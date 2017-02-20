//
//  PZNewsWebController.m
//  Puzzle
//
//  Created by huibei on 16/12/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZNewsWebController.h"
#import "PZParamTool.h"
#import "AFNetworking.h"
#import "HBLoadingView.h"
#import <UMSocialSnsPlatformManager.h>
#import "HBShareTool.h"
#import "JNQInviteAwardView.h"
#import "WXApi.h"
#import "HomeTool.h"
#import "HMScanner.h"
#import "HBVerticalBtn.h"
#import <HUPhotoBrowser/HUPhotoBrowser.h>
#import "UIImageView+WebCache.h"
#import "NewsCommentController.h"
#import "PZCommentPanel.h"
#import "STInputBar.h"
#import "PZNewsCellModel.h"
#import "NewsHttpTool.h"
#import "NewsCommentModel.h"
#import "PZNewsWebCommentView.h"
#import "LoginModel.h"
#import "PZParamTool.h"
#import "RRFMeTool.h"
@interface PZNewsFooterView :UIView
@property(nonatomic,weak)PZNewsShareView *shareView;
@property(nonatomic,weak)PZNewsWebCommentView *commentView;
@property(nonatomic,copy)ItemClickParamBlock shareBlock;
@property(nonatomic,copy)ItemClickBlock moreBlock;

-(CGFloat)getCommentListHeightWithArray:(NSArray *)commentList;
@end

@implementation PZNewsFooterView
-(instancetype)init
{
    if (self = [super init]) {
        PZNewsShareView *shareView = [[PZNewsShareView alloc]init];
        self.shareView = shareView;
        [self addSubview:shareView];
        [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(100);
        }];
        shareView.shareBlock = ^(NSNumber *type){
            if (self.shareBlock) {
                self.shareBlock(type);
            }
        };
   
        PZNewsWebCommentView *commentView = [[PZNewsWebCommentView alloc]init];
        self.commentView = commentView;
        [self addSubview:commentView];
        [commentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(shareView.mas_bottom);
            make.bottom.mas_equalTo(0);
        }];
        commentView.moreBlock = ^(){
            if (self.moreBlock ) {
                self.moreBlock();
            }
        };
    }
    return self;
}
-(CGFloat)getCommentListHeightWithArray:(NSArray *)commentList
{
    if (commentList.count == 0){
        self.commentView.hidden = YES;
        return 120;
        
    }else{
        self.commentView.hidden = NO;
        CGFloat height = [self.commentView getHeightWtihCommentList:commentList];
        return height + 120;
    }
    
}
@end
@interface PZNewsWebController ()<UIWebViewDelegate,UIScrollViewDelegate>
@property(nonatomic,weak)UIWebView *webView;
@property(nonatomic,weak)JNQShareView *shareView ;
@property(nonatomic,weak)UIButton *cencelBtn;
@property(nonatomic,strong)NSString *QRcodeUrl;

@property(strong,nonatomic)NSMutableArray* mUrlArray;
@property(weak,nonatomic)STInputBar* inputBar  ;
@property(nonatomic,weak)PZNewsFooterView *commentView ;
@end

@implementation PZNewsWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    self.view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"] ;
    
    UIWebView* webView = [[UIWebView alloc]init];
    webView.backgroundColor = [UIColor clearColor] ;
    webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    webView.opaque = NO;
    webView.delegate = self ;
    NSString* pathUrl = self.model.url;
    webView.scrollView.delegate = self ;
    NSMutableURLRequest* request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:pathUrl parameters:self.param error:nil];
    if (pathUrl != nil && pathUrl.length != 0) {
        [webView loadRequest:request]; // 利用浏览器访问地址
    }
    self.webView = webView;
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 44, 0));
    }];
    
    STInputBar *inputBar = [STInputBar inputBar];
    [inputBar setFitWhenKeyboardShowOrHide:YES];
    inputBar.floatBottom = YES ;
    inputBar.commonMode = NO ;
    [inputBar setDidSendClicked:^(NSString *text) {
        if (text.length) {
            [MBProgressHUD show];
            [NewsHttpTool postCommentWithId:self.model.newMessageId content:text successBlock:^(id json) {
                [MBProgressHUD dismiss];
                [weakSelf.inputBar resignFirstResponder];
            } fail:^(id json) {
                [MBProgressHUD dismiss];
            }];
        }
    }];
    inputBar.placeHolder =[NSString stringWithFormat:@"说点什么吧"];
    [inputBar hiddenPhoto];
    self.inputBar = inputBar;
    [self.view addSubview:inputBar];
    [inputBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    [HBLoadingView showCircleView:self.view Interactive:YES];
    [self setNav];
}

-(void)setNav{
    WEAKSELF
    UIButton* shareBtn = [UIButton new];
    [[shareBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:weakSelf.webView.request.URL.absoluteString]];
    }];
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, -20);
    shareBtn.bounds = CGRectMake(0, 0, 84, 44);
    shareBtn.titleLabel.font = PZFont(12.0f);
//    [shareBtn setImage:[UIImage imageNamed:@"home_btn_share"] forState:UIControlStateNormal];
    [shareBtn setTitle:@"浏览器打开" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
}

#pragma mark - 底部视图
-(void)addFooter{
    WEAKSELF
    PZNewsFooterView *commentView =[[PZNewsFooterView alloc]init];
    commentView.backgroundColor = [UIColor whiteColor];
    commentView.hidden = YES ;
    self.commentView = commentView;
    [self.webView.scrollView addSubview:commentView];
    commentView.shareBlock = ^(NSNumber *type){
        [weakSelf shareWithType:type];
    };
    commentView.moreBlock = ^(){
        [weakSelf goNewsCommentList];
    };
}


-(void)getCommentCountWithWebHeight:(CGFloat)heigth{
    WEAKSELF
    [NewsHttpTool getNewsCommentListListWithPageNo:0 pageSize:10 commentId:self.model.newMessageId successBlock:^(id json) {
        NewsCommentListModel* listM = [NewsCommentListModel yy_modelWithJSON:json];
        NSInteger totalCount = 0;
        for (NewsCommentModel* model in listM.content) {
            totalCount += model.responseModels.count +1;
        }
        [weakSelf setCommnetView:listM.content WebHeight:heigth];
        [weakSelf setCommnetNav:totalCount];
    } fail:^(id json) {
        
    }];
}
-(void)setCommnetView:(NSArray *)comments WebHeight:(CGFloat)webHeight
{
    if (webHeight > 0) {
        self.commentView.hidden = NO ;
    }
    CGFloat height = [self.commentView getCommentListHeightWithArray:comments];
    self.commentView.frame = CGRectMake(0, webHeight+30, SCREENWidth, height);
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, height+30, 0);

}

-(void)setCommnetNav:(NSInteger)count{
    UIButton *right = [[UIButton alloc]init];
    right.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //[right setImage:[UIImage imageNamed:@"home_btn_share"] forState:UIControlStateNormal];
    right.titleLabel.font = PZFont(13.0f);
    NSString* titleStr = [NSString stringWithFormat:@"跟帖"];
    [right setTitle:titleStr forState:UIControlStateNormal];
    [right addTarget:self action:@selector(goNewsCommentList) forControlEvents:UIControlEventTouchUpInside];
    right.frame = CGRectMake(0, 0, 90, 44);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)goNewsCommentList{
    NewsCommentController* comment = [[NewsCommentController alloc]init];
    comment.commentId = self.model.newMessageId ;
    [self.navigationController pushViewController:comment animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.inputBar resignFirstResponder];
}

-(void)shareWithType:(NSNumber *)type
{
    WEAKSELF
    if (![WXApi isWXAppInstalled]) {
        [MBProgressHUD showInfoWithStatus:@"您没有安装微信应用"];
        return ;
    }
    int typeInt = [type intValue];
    
    [RRFMeTool requestUserInfoWithSuccess:^(id json) {
        if(json != nil){
            NSArray* platForms = @[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ];
            NSString* platForm = platForms[typeInt];
            NSDictionary *dic = json[@"userInfo"];
            NSNumber *xitengCode = dic[@"xtNumber"];
            NSString *url = [NSString stringWithFormat:@"%@xitenggame/singleWrap/weiShareNews.html?commentId=%d&xitengCode=%@",Base_url,self.model.newMessageId,xitengCode];
            [[HBShareTool sharedInstance] shareSingleSNSWithType:platForm title:@"喜腾" image:[UIImage imageNamed:@"share_logo"] url:url msg:@"喜腾新闻" presentedController:weakSelf];
        }
    } failBlock:^(id json) {
    }];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self performSelector:@selector(addFooter) withObject:nil afterDelay:0.5];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
//    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    self.title = theTitle ;
    //这里是js，主要目的实现对url的获取
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(var i=0;i<objs.length;i++){\
    imgScr = imgScr + objs[i].src + '+';\
    };\
    return imgScr;\
    };";
    
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    
    NSString *urlResurlt = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    
    self.mUrlArray = [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"+"]];
    [self.mUrlArray removeLastObject];
    //urlResurlt 就是获取到得所有图片的url的拼接；mUrlArray就是所有Url的数组
    [HBLoadingView dismiss];
    
//     CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
//    [self getCommentCountWithWebHeight:height];
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if ([components count] > 1){
        NSString* imgUrl = [components lastObject];
        if ([imgUrl hasSuffix:@"png"]||[imgUrl hasSuffix:@"jpeg"]||[imgUrl hasSuffix:@"gif"]) {
            [self tapHandle];
            return NO;
        }
        return YES;
    }
    return YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [HBLoadingView dismiss];
}

- (void)tapHandle{
    WEAKSELF
    NSString* firstUrl = [self.mUrlArray firstObject];
    UIImageView* logo =  [[UIImageView alloc] init];
    [logo sd_setImageWithURL:[NSURL URLWithString:firstUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        UIImageView* imgView = [[UIImageView alloc]initWithImage:image];
        [HUPhotoBrowser showFromImageView:imgView withURLStrings:weakSelf.mUrlArray placeholderImage:DefaultImage atIndex:0 dismiss:nil];
    }];
}


-(void)dealloc{
    NSLog(@"xxxx");
}

@end
