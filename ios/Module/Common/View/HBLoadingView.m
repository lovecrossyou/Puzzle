//
//  HBLoadingView.m
//  LodingScreen
//
//  Created by huipay on 2016/10/31.
//  Copyright © 2016年 huipay. All rights reserved.
//

#import "HBLoadingView.h"

typedef enum : NSUInteger {
    LoadingViewCircle,
    LoadingViewLogo,
} LoadingViewType;


#define KLogoWidth 12
#define KLogoHeight 12

#define KIndicatorSize 32


static HBLoadingView* loadingView ;
static UIView* centerView ;

@implementation HBLoadingView

- (instancetype)initWithFrame:(CGRect)frame type:(LoadingViewType)type {
    if (self = [super initWithFrame:frame]) {
        switch (type) {
            case LoadingViewCircle:
                [self creatCircleJoinAnimation];
                break;
            case LoadingViewLogo:
                break;
            default:
                break;
        }
    }
    return self ;
}

- (void)creatCircleJoinAnimation

{
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.bounds          = CGRectMake(0, 0, 25, 25);
    replicatorLayer.cornerRadius    = 10.0;
    replicatorLayer.position        =  self.center;
    [self.layer addSublayer:replicatorLayer];
    
    CALayer *logoLayer = [CALayer layer];
    logoLayer.bounds          = CGRectMake(0, 0, KLogoWidth, KLogoHeight);
    logoLayer.position        =  self.center;
    logoLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"xiteng_logo"].CGImage);
    [self.layer addSublayer:logoLayer];
    
    CALayer *dot        = [CALayer layer];
    dot.bounds          = CGRectMake(0, 0, 2, 2);
    dot.position        = CGPointMake(0, 10);
    dot.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor;
    dot.cornerRadius    = 1;
    dot.masksToBounds   = YES;
    
    [replicatorLayer addSublayer:dot];
    
    
    CGFloat count                     = 100.0;
    replicatorLayer.instanceCount     = count;
    CGFloat angel                     = 2* M_PI/count;
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(angel, 0, 0, 1);
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration    = 1.0;
    animation.fromValue   = @1;
    animation.toValue     = @0.1;
    animation.repeatCount = MAXFLOAT;
    [dot addAnimation:animation forKey:nil];

    replicatorLayer.instanceDelay = 1.0/ count;
    
    dot.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
}
+(void)dismiss{
    [self hide];
}
+ (void)showCircleView:(UIView *)view Interactive:(BOOL)nteractive{
    
    [self showCircleView:view];
    if (nteractive) {
        loadingView.backgroundColor = [UIColor clearColor];
        loadingView.userInteractionEnabled = NO ;
    }
}

+ (void)showCircleView:(UIView *)view
{
    loadingView = [[HBLoadingView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight) type:LoadingViewCircle];
    loadingView.backgroundColor = [UIColor whiteColor];
    loadingView.center = view.center;
    [view addSubview:loadingView];
}


+(void)showLoading:(UIView *)view{
    CGFloat LogoHeight = 36 ;
    CGFloat LogoWidth = 36 ;
    loadingView = [[HBLoadingView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) type:LoadingViewLogo];
    loadingView.backgroundColor = [UIColor clearColor];
    loadingView.userInteractionEnabled = YES ;
    loadingView.center = view.center;
    [view addSubview:loadingView];
    
    centerView = [[UIView alloc]init];
    centerView.center = loadingView.center ;
    loadingView.bounds  = CGRectMake(0, 0,KIndicatorSize + LogoWidth, LogoHeight);
    [loadingView addSubview:centerView];
    
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0, 0, KIndicatorSize, KIndicatorSize);
    [loadingView addSubview:indicator];
    [indicator startAnimating];
    
    //logo
    UIImageView* logo = [[UIImageView alloc]init];
    logo.image = [UIImage imageNamed:@"xiteng_logo"];
    logo.frame = CGRectMake(KIndicatorSize, (LogoHeight - LogoHeight)/2, LogoWidth, LogoHeight);
    [loadingView addSubview:logo];
    
}

+(void)showMsg:(NSString *)content{
    
    
}


+ (void)hide{
    if (loadingView) {
        [loadingView removeFromSuperview];
    }
}






@end
