//
//  JNQFBComContentPageController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/12/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQFBComContentPageController.h"
#import "PZWebController.h"
#import "JNQFBComViewController.h"
#import "JNQBookFBOrderViewController.h"

#import "JNQComView.h"
#import "FBSharePanel.h"
#import "HBLoadingView.h"
#import "HBVerticalBtn.h"
#import "JNQInviteAwardView.h"

#import "HomeTool.h"
#import "JNQHttpTool.h"
#import "HBShareTool.h"
#import "WXApi.h"
#import "UIImageView+WebCache.h"
#import <LGAlertView/LGAlertView.h>
#import <UMSocialSnsPlatformManager.h>
@interface JNQFBComContentPageController () {
}
@property (nonatomic, strong) FBProductModel *fbProductM;
@property(weak,nonatomic)    JNQComBottomView *fbBottomV;
@property (nonatomic, strong) JNQShareView *shareView;
@property (nonatomic, strong) UIButton *backBtn;
@end

@implementation JNQFBComContentPageController

- (instancetype)init {
    self = [super init];
    NSArray *viewControllers = @[[JNQFBComViewController class], [PZWebController class]];
    NSArray *titles = @[@"商品", @"详情"];
    JNQFBComContentPageController *pageVC = [[JNQFBComContentPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    pageVC.pageAnimatable = YES;
    pageVC.progressWidth = 30;
    pageVC.progressHeight = 2;
    pageVC.titleColorSelected = [UIColor whiteColor];
    pageVC.titleColorNormal = HBColor(243, 243, 243);
    pageVC.progressColor = [UIColor whiteColor];
    pageVC.menuHeight = 44;
    pageVC.menuViewStyle = WMMenuViewStyleLine;
    pageVC.titleSizeSelected = 16;
    pageVC.titleSizeNormal = 16;
    pageVC.showOnNavigationBar = YES;
    pageVC.menuBGColor = [UIColor clearColor];
    pageVC.itemsWidths = @[@(40),@(40)];
    pageVC.itemMargin = 15;
    pageVC.postNotification = YES;
    pageVC.bounces = YES;
    return pageVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuView.delegate = self ;
    self.delegate = self;
    self.dataSource = self;
    [self settingNavItem];
    [self buildFBComPageUI];
    [self loadComData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadComData) name:@"updateComData" object:nil];
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
#pragma mark - 分享
-(void)share:(UIButton*)sender
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.backBtn];
    [window addSubview:self.shareView];
    [UIView animateWithDuration:0.3 animations:^{
        _shareView.frame = CGRectMake(0, SCREENHeight-140, SCREENWidth, 140);
    }];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buildFBComPageUI {
    WEAKSELF
    JNQComBottomView* fbBottomV = [[JNQComBottomView alloc] init];
    self.fbBottomV = fbBottomV ;
    [self.view addSubview:fbBottomV];
    [fbBottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    
    [[fbBottomV.nowInBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([_fbProductM.purchaseGameStatus isEqualToString:@"bidding"]) {
            JNQBookFBOrderViewController *bookFBOrderVC = [[JNQBookFBOrderViewController alloc] init];
            bookFBOrderVC.navigationItem.title = @"夺宝订单";
            bookFBOrderVC.productM = weakSelf.fbProductM;
            [weakSelf.navigationController pushViewController:bookFBOrderVC animated:YES];
        } else {
            JNQFBComContentPageController *comContentPageVC = [[JNQFBComContentPageController alloc] init];
            comContentPageVC.fbPurchaseGameId = _fbProductM.nextPurchaseGameId;
            [self.navigationController pushViewController:comContentPageVC animated:YES];
        }
    }];
}

- (void)loadComData {
    WEAKSELF
    [HBLoadingView showCircleView:self.view];
    [JNQHttpTool JNQHttpRequestWithURL:@"purchaseGame/detail" requestType:@"post" showSVProgressHUD:NO parameters:@{@"purchaseGameId" : @(self.fbPurchaseGameId)} successBlock:^(id json) {
        weakSelf.fbProductM = [FBProductModel yy_modelWithJSON:json[@"content"]];
        NSString *title = [_fbProductM.purchaseGameStatus isEqualToString:@"bidding"] ? @"立即参与" : @"再次参与";
        [weakSelf.fbBottomV.nowInBtn setTitle:title forState:UIControlStateNormal];
        [HBLoadingView dismiss];
    } failureBlock:^(id json) {
        [HBLoadingView dismiss];
    }];
}

-(void)requestUserAvatar:(ItemClickParamBlock)completeBlock{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage* defaultIcon = [UIImage imageNamed:@"share_logo"] ;
        if (_fbProductM.picUrl != nil && ![_fbProductM.picUrl isEqualToString:@""]) {
            NSString* avatarUrl = _fbProductM.picUrl ;
            if (avatarUrl!=nil) {
                UIImageView* imageView = [[UIImageView alloc]init];
                [imageView sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:defaultIcon options:SDWebImageContinueInBackground completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (error != nil) {
                        completeBlock(defaultIcon);
                    }
                    else{
                        completeBlock(image);
                    }
                }];
            } else {
                completeBlock(defaultIcon);
            }
        } else {
            completeBlock(defaultIcon);
        }
    });
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 2;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    if (index) {
        PZWebController *fbContentVC = [[PZWebController alloc] init];
        fbContentVC.navigationItem.title = @"详情";
        NSString* pathUrl = [NSString stringWithFormat:@"%@xitenggame/singleWrap/purchaseGameProductDetail.html",Base_url];
        fbContentVC.pathUrl = pathUrl ;
        fbContentVC.param = @{
                         @"purchaseGameId":@(_fbPurchaseGameId)
        };
        return fbContentVC;
    } else {
        JNQFBComViewController *fbComVC = [[JNQFBComViewController alloc] init];
        fbComVC.navigationItem.title = @"商品";
        fbComVC.fbPurchaseGameId = _fbPurchaseGameId;
        return fbComVC;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)forBarMetrics:UIBarMetricsDefault];
}

- (JNQShareView *)shareView {
    WEAKSELF
    if (!_shareView) {
        _shareView = [[JNQShareView alloc] init];
        [[_shareView.quitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [weakSelf removeShareView];
        }];
        _shareView.shareBlock = ^(HBVerticalBtn *shareBtn) {
            if (![WXApi isWXAppInstalled]) {
                [MBProgressHUD showInfoWithStatus:@"您没有安装微信应用"];
                return ;
            }
            NSString* title =  weakSelf.fbProductM.productName;
            __block NSString* desc = @"我在0元夺宝发现一个不错的商品，赶快来看看吧~" ;
                NSString *fullUrlStr = [NSString stringWithFormat:@"%@xitengWapApp/index.html#/OnePieceProductDetails?purchaseGameId=%ld",Base_url,weakSelf.fbPurchaseGameId];
                NSArray* platForms = @[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ];
                if (shareBtn.tag==1 || shareBtn.tag==2) {
                    desc = [NSString stringWithFormat:@"我在0元夺宝发现一个不错的商品，赶快来看看吧~ %@", fullUrlStr];
                }
                [weakSelf requestUserAvatar:^(UIImage* image) {
                    [weakSelf removeShareView];
                    [[HBShareTool sharedInstance] shareSingleSNSWithType:platForms[shareBtn.tag] title:title image:image url:fullUrlStr msg:desc presentedController:weakSelf];
                }];
        };
    }
    _shareView.frame = CGRectMake(0, SCREENHeight, SCREENWidth, 140);
    return _shareView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        _backBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [_backBtn addTarget:self action:@selector(removeShareView) forControlEvents:UIControlEventTouchUpInside];
    }
    _backBtn.frame = CGRectMake(0, 0, SCREENWidth, SCREENHeight);
    return _backBtn;
}

- (void)removeShareView {
    [UIView animateWithDuration:0.3 animations:^{
        _shareView.frame = CGRectMake(0, SCREENHeight, SCREENWidth, 140);
    } completion:^(BOOL finished) {
        [_shareView removeFromSuperview];
        [_backBtn removeFromSuperview];
    }];
}

@end
