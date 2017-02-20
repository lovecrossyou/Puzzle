//
//  HBWebController.m
//  HuiBeiWaterMerchant
//
//  Created by 朱理哲 on 16/5/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZWebController.h"
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

@interface PZWebController()<UIWebViewDelegate>
@property(nonatomic,weak)UIWebView *webView;
@property(nonatomic,weak)JNQShareView *shareView ;
@property(nonatomic,weak)UIButton *cencelBtn;
@property(nonatomic,strong)NSString *QRcodeUrl;

@property(strong,nonatomic)NSMutableArray* mUrlArray;

@end

@implementation PZWebController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"] ;
    UIWebView* webView = [[UIWebView alloc]init];
    webView.backgroundColor = [UIColor clearColor] ;
    webView.opaque = NO;
    webView.delegate = self ;
    NSString* pathUrl = self.pathUrl;
    
    if (self.fileName != nil) {
        NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
        NSString *path = [[NSBundle mainBundle] pathForResource:self.fileName ofType:@"html"];
        NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [webView loadHTMLString:html baseURL:baseURL];
    }
    else{        
        NSMutableURLRequest* request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:self.pathUrl parameters:self.param error:nil];
        if (pathUrl != nil && pathUrl.length != 0) {
            [webView loadRequest:request]; // 利用浏览器访问地址
        }
    }
    self.webView = webView;
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    if (self.share) {
        [self settingNavItem];
    }
    [HBLoadingView showCircleView:self.view Interactive:YES];
}


-(void)settingNavItem
{
    UIButton *right = [[UIButton alloc]init];
    right.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [right setImage:[UIImage imageNamed:@"home_btn_share"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    right.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = item;
    
}

-(void)share:(UIButton*)sender{
    WEAKSELF
    if (![WXApi isWXAppInstalled]) {
        [MBProgressHUD showInfoWithStatus:@"您没有安装微信应用"];
        return ;
    }
    UIButton *cencelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
    self.cencelBtn = cencelBtn ;
    [self.view.window addSubview:cencelBtn];
    cencelBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    
    JNQShareView *shareView = [[JNQShareView alloc] init];
    shareView.atten.text = @"分享朋友,发喜腾红包";
    self.shareView = shareView;
    [self.view.window addSubview:shareView];
    shareView.frame = CGRectMake(0, SCREENHeight, SCREENWidth, 140);
    [UIView animateWithDuration:0.15 animations:^{
        weakSelf.shareView.frame = CGRectMake(0, SCREENHeight-140, SCREENWidth, 140);
    }];

    
    shareView.shareBlock = ^(HBVerticalBtn *shareBtn) {
        [MBProgressHUD show];
        [weakSelf requestQRCodeUrlCompeleteBlock:^(UIImage* qrImage) {
            [MBProgressHUD dismiss];
            NSArray* platForms = @[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ];
            NSString* platForm = platForms[shareBtn.tag];
            UIImage* fullImage = [weakSelf makeImageWithView:weakSelf.webView] ;
            CGSize reSize = fullImage.size ;
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(reSize.width, reSize.height+12+80+12), NO, 0.0);
            [fullImage drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
            [qrImage drawInRect:CGRectMake(12, reSize.height+12, 76, 76)];
            //            文字 1
            NSString* infoString = @"长按二维码识别 获取100喜腾币";
            CGRect infoRect = CGRectMake(12+76+12, reSize.height+12+6+20, 220, 24);
            [infoString drawInRect:infoRect withAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f]}];
            
            
            //            logo alerthead_icon
            UIImage* appLogo = [UIImage imageNamed:@"alerthead_icon"];
            CGRect logoRect = CGRectMake(12+76+12, reSize.height+12+24+12+16, 16, 16);
            [appLogo drawInRect:logoRect];
            
            //            文字2
            NSString* info = @"由 喜腾 发送 via www.xiteng.com";
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:info];
            [attributedStr addAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"F75000"],NSFontAttributeName:PZFont(12.0f)} range:NSMakeRange(0, info.length)];
            [attributedStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"F75000"],NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0f]} range:NSMakeRange(2, 2)];
            //F75000
            infoRect = CGRectMake(12+76+12 + 16+6, reSize.height+12+24+12+16, 220, 24);
            [attributedStr drawInRect:infoRect];
            UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [[HBShareTool sharedInstance] shareImage:reSizeImage imageUrl:self.QRcodeUrl platForm:platForm];
            [weakSelf hiddenShareView:weakSelf.cencelBtn];
        }];
    };
    
    [[shareView.quitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self hiddenShareView:cencelBtn];
    }];
    [[cencelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self hiddenShareView:cencelBtn];
    }];
}

#pragma mark - 获取分享二维码
-(void)requestQRCodeUrlCompeleteBlock:(ItemClickParamBlock)complete{
    NSString* content = @"亲，我送你100喜腾币，免费参加股市猜涨跌游戏，祝你好运！";
    [HomeTool inviteWithContent:content successBlock:^(id json) {
        NSString *fullUrlStr = [NSString stringWithFormat:@"%@%@",Base_url,json[@"url"]];
        self.QRcodeUrl =  fullUrlStr;
        [HMScanner qrImageWithString:fullUrlStr avatar:nil completion:^(UIImage *image) {
            complete(image);
        }];
    } fail:^(id json) {
        
    }];
}


- (UIImage *)makeImageWithView:(UIView *)view
{
    CGSize s = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数。
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


-(void)webViewDidStartLoad:(UIWebView *)webView{
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    if (!self.hiddenTitle) {        
        NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        self.title = theTitle ;
    }
    
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
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if ([self picTypeForString:self.pathUrl]) {
        return YES ;
    }
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if ([components count] > 1){
        NSString* imgUrl = [components lastObject];
        if ([self picTypeForString:imgUrl]) {
            [self tapHandle];
            return NO;
        }
        return YES;
    }
    return YES;
}

-(BOOL)picTypeForString:(NSString*)url{
    return  [url hasSuffix:@"png"]||[url hasSuffix:@"jpeg"]||[url hasSuffix:@"gif"];
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [HBLoadingView dismiss];
}

- (void)hiddenShareView:(UIButton *)button {
    [UIView animateWithDuration:0.2 animations:^{
    } completion:^(BOOL finished) {
        [_shareView removeFromSuperview];
        [button removeFromSuperview];
    }];
}


- (void)tapHandle{
    
    NSString* firstUrl = [self.mUrlArray firstObject];
    UIImageView* logo =  [[UIImageView alloc] init];
    [logo sd_setImageWithURL:[NSURL URLWithString:firstUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        UIImageView* imgView = [[UIImageView alloc]initWithImage:image];
        [HUPhotoBrowser showFromImageView:imgView withURLStrings:self.mUrlArray placeholderImage:DefaultImage atIndex:0 dismiss:nil];
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.hiddenNav == YES) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        [self setNeedsStatusBarAppearanceUpdate];
        UINavigationBar *navBar = self.navigationController.navigationBar;
        navBar.shadowImage = [UIImage createImageWithColor:[UIColor whiteColor]];
        [navBar setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
        navBar.barStyle = UIStatusBarStyleDefault;
        [navBar setTintColor:[UIColor colorWithHexString:@"4964ef"]];
    }
}


@end
