//
//  RRFInviteViewController.m
//  Puzzle
//
//  Created by huibei on 16/10/24.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFInviteViewController.h"
#import "RRFInviteView.h"
#import "PZTextView.h"
#import "HomeTool.h"
#import "HBShareTool.h"
#import <UMSocialSnsPlatformManager.h>
#import "JNQInviteAwardView.h"
#import "HBVerticalBtn.h"
#import "WXApi.h"
#import "PZParamTool.h"
#import "LoginModel.h"
#import "HMScanner.h"
#import "UIImageView+WebCache.h"
#import "UIButton+EdgeInsets.h"
#import "HBLoadingView.h"
#import <WebKit/WebKit.h>
@interface RRFInviteViewController ()<WKNavigationDelegate>

@property(nonatomic,weak)RRFInviteView *inviteView;
@property(nonatomic,strong)NSString *QRcodeUrl;
@property(nonatomic,weak)JNQShareView *shareView;
@property(nonatomic,weak)UIButton *cencelBtn;

@property(assign,nonatomic)BOOL dynamicBg ;

@property(weak,nonatomic)UIView* bgView ;


@property(weak,nonatomic)WKWebView* hiddenWebView;
@end

@implementation RRFInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dynamicBg = arc4random()%2 ;
    UIColor* bgColor = self.dynamicBg? [UIColor colorWithHexString:@"2d3132"]:[UIColor whiteColor];
    self.view.backgroundColor = bgColor ;
    LoginModel *user = [PZParamTool currentUser];
    NSString *iconStr = user.icon;

    NSString *nameStr = user.cnName;
    if (nameStr==nil ||nameStr.length == 0) {
        nameStr = @"--" ;
    }
    if (iconStr.length == 0) {
        iconStr = user.headimgurl;
    }
    
    UIView* bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.bgView = bgView ;

    UIImageView* logoView = [[UIImageView alloc]init];
    logoView.layer.masksToBounds = YES ;
    logoView.layer.cornerRadius = 2 ;
    logoView.contentMode = UIViewContentModeScaleAspectFill ;
    [logoView sd_setImageWithURL:[NSURL URLWithString:iconStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            logoView.image = [self coreBlurImage:image withBlurNumber:4.0];
            [HBLoadingView dismiss];
        });
    }];
    [bgView addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(logoView.mas_width);
    }];
    
    UIImageView* smallLogo = [[UIImageView alloc]init];
    smallLogo.layer.masksToBounds = YES ;
    smallLogo.layer.cornerRadius = 2 ;
    smallLogo.contentMode = UIViewContentModeScaleAspectFill ;
    [smallLogo sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:DefaultImage];
    [logoView addSubview:smallLogo];
    CGFloat smallSize = SCREENWidth/4 ;
    [smallLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(smallSize, smallSize));
        make.left.mas_equalTo(40);
        make.bottom.mas_equalTo(-40);
    }];
    
    UILabel* nameLabel = [[UILabel alloc]init];
    nameLabel.text = nameStr;
    nameLabel.textAlignment = NSTextAlignmentCenter ;
    nameLabel.font = PZFont(17.0f);
    [nameLabel sizeToFit];
    [bgView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(logoView.mas_bottom).offset(15);
        make.centerX.mas_equalTo(bgView.mas_centerX);
    }];
    
    UIImageView* botImageView = [[UIImageView alloc]init];
    botImageView.contentMode = UIViewContentModeScaleAspectFit ;
    [bgView addSubview:botImageView];
    [botImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo((SCREENWidth-15*2)*2/3);
    }];
    
    UIImageView* qrView = [[UIImageView alloc]init];
    [bgView addSubview:qrView];
    [qrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-17);
        make.bottom.mas_equalTo(-17);
        make.width.mas_equalTo((SCREENWidth-17)/3);
        make.height.mas_equalTo((SCREENWidth-17)/3);
    }];
    

    UILabel* botRight = [[UILabel alloc]init];
    botRight.text = @"100红包" ;
    botRight.font = PZFont(15.0f);
    botRight.textColor = [UIColor colorWithHexString:@"fa331e"];
    [bgView addSubview:botRight];
    [botRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-17);
        make.right.mas_equalTo(qrView.mas_left).offset(-16);
    }];
    
    UIButton* botLabel = [UIButton new];
    [botLabel setTitle:@"领取" forState:UIControlStateNormal];
    botLabel.titleLabel.font = PZFont(15.0f);
    [botLabel setImage:[UIImage imageNamed:@"icon_big"] forState:UIControlStateNormal];
    [bgView addSubview:botLabel];
    [botLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-17);
        make.right.mas_equalTo(botRight.mas_left).offset(-6);
    }];
    [botLabel layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageRight imageTitlespace:2 imageWidth:5];
    
    
    UILabel* qrLabelStr = [[UILabel alloc]init];
    qrLabelStr.text = @"扫一扫或者长按我的二维码";
    [qrLabelStr sizeToFit];
    qrLabelStr.font = PZFont(15.0f);
    [bgView addSubview:qrLabelStr];
    [qrLabelStr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(botLabel.mas_top).offset(-2);
        make.right.mas_equalTo(qrView.mas_left).offset(-16);
    }];
    
    if (self.dynamicBg) {
        UIImageView* botBgView = [[UIImageView alloc]init];
        botBgView.image = [UIImage imageNamed:@"me_share_bot"];
        [bgView insertSubview:botBgView aboveSubview:nameLabel];
        [botBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(logoView.mas_bottom);
            make.left.right.bottom.mas_equalTo(0);
        }];
        botImageView.image = [UIImage imageNamed:@"xitenggengxingfu-"];
        nameLabel.textColor = [UIColor whiteColor];
        qrLabelStr.textColor = [UIColor whiteColor];
        [botLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        bgView.backgroundColor= [UIColor blackColor];
    }
    else{
        nameLabel.textColor = [UIColor colorWithHexString:@"000000"];
        nameLabel.textColor = [UIColor colorWithHexString:@"000000"];
        botImageView.image = [UIImage imageNamed:@"xitenggengxingfu"];
        [botLabel setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        bgView.backgroundColor= [UIColor whiteColor];
    }
    [HBLoadingView showCircleView:self.view];
    
    WKWebView* hiddenWebView = [[WKWebView alloc]init];
    hiddenWebView.navigationDelegate = self ;
    [self.view insertSubview:hiddenWebView belowSubview:self.bgView];
    [hiddenWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.hiddenWebView = hiddenWebView ;
    NSString* content = @"亲，我送你100喜腾币，免费参加股市猜涨跌游戏，祝你好运！";
    [HomeTool inviteWithContent:content successBlock:^(id json) {
        NSString *fullUrlStr = [NSString stringWithFormat:@"%@%@",Base_url,json[@"url"]];
        self.QRcodeUrl =  fullUrlStr;
        [HMScanner qrImageWithString:fullUrlStr avatar:nil completion:^(UIImage *image) {
            qrView.image = image;
        }];
    } fail:^(id json) {
        
    }];
    
    //请求分享URL  获取分享图片
    NSString* urlString = [NSString stringWithFormat:@"%@xitenggame/singleWrap/shareMyQRCode.html?otherUserId=%d",Base_url,[user.userId intValue]] ;
    // 2.创建请求
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    // 3.加载网页
    [self.hiddenWebView loadRequest:request];
    [self setNavItem];
}
-(void)setNavItem
{
    UIButton *right = [[UIButton alloc]init];
    right.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [right setImage:[UIImage imageNamed:@"home_btn_share"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    right.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = item;
    
}
#pragma mark - 分享
-(void)share:(UIButton*)sender
{
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
        NSArray* platForms = @[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ];
        NSString* platForm = platForms[shareBtn.tag];
        UIImage* QRImage = [self captureScrollView:weakSelf.hiddenWebView.scrollView] ;
        [[HBShareTool sharedInstance] shareImage:QRImage imageUrl:self.QRcodeUrl platForm:platForm];
        [weakSelf hiddenShareView:weakSelf.cencelBtn];
    };

    [[shareView.quitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self hiddenShareView:cencelBtn];
    }];
    [[cencelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self hiddenShareView:cencelBtn];
    }];
}

-(void)requestShareImage:(ItemClickParamBlock)complete{
    
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


- (UIImage *)captureScrollView:(UIScrollView*)scrollView{
    UIImage* viewImage = nil;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, scrollView.opaque, 0.0);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        viewImage = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (viewImage != nil) {
        return viewImage;
    }
    return nil;
}



- (void)hiddenShareView:(UIButton *)button {
    [UIView animateWithDuration:0.2 animations:^{
    } completion:^(BOOL finished) {
        [_shareView removeFromSuperview];
        [button removeFromSuperview];
    }];
}

-(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage= [CIImage imageWithCGImage:image.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey]; [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}


@end
