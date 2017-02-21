 //
//  RRFShareOrderDetailInfoController.m
//  Puzzle
//
//  Created by huipay on 2016/12/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFShareOrderDetailInfoController.h"
#import "FBShareOrderListModel.h"
#import <UMSocialSnsPlatformManager.h>
#import "WXApi.h"
#import "JNQInviteAwardView.h"
#import "HBShareTool.h"
#import "HBVerticalBtn.h"
#import "HomeTool.h"
#import "HMScanner.h"
#import "RRFWiningOrderDetailModel.h"
#import <React/RCTRootView.h>
#import <CodePush/CodePush.h>
#import "PZReactUIManager.h"

@interface RRFShareOrderDetailInfoController ()
@property(nonatomic,weak)JNQShareView *shareView;
@property(nonatomic,weak)UIButton *cancelBtn;
@property(nonatomic,strong)NSString *QRcodeUrl;

@property(nonatomic,assign)NSInteger showOrderId;
@property(nonatomic,strong)NSString *shareTitle;
@property(nonatomic,strong)NSString *shareMassage;


@end

@implementation RRFShareOrderDetailInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavItem];
    
    [self setupView];
}

-(void)setupView{
    NSURL *jsCodeLocation;
#ifdef DEBUG
    jsCodeLocation = [NSURL
                      URLWithString:@"http://localhost:8081/index.ios.bundle?platform=ios"];
#else
    jsCodeLocation = [CodePush bundleURL];
#endif
    
    
    NSString* orderId = @"";
    NSString* shareType = @"";
    NSString* url = @"";

    if(self.showOrderType ==  RRFShowOrderTypeGift){
        orderId = [NSString stringWithFormat:@"%ld",(long)self.giftOrderShowId];
        url = @"product/comment/detail" ;
        shareType = @"exchangeOrderId" ;
        self.showOrderId = self.giftOrderShowId;
        self.shareMassage = @"我在喜腾兑换商城兑换了商品，赶快来参与吧！";
        
    }else if (self.showOrderType ==  RRFShowOrderTypeFreeBuy){
        orderId = [NSString stringWithFormat:@"%ld",(long)self.purchaseGameShowId];
        url = @"purchaseGame/show/detail";
        shareType = @"purchaseGameShowId" ;
        self.showOrderId = self.purchaseGameShowId;
        self.shareMassage = @"我是0元夺宝的幸运儿，以后请叫我幸运帝!";
    }else if (self.showOrderType ==  RRFShowOrderTypeWining){
        orderId = [NSString stringWithFormat:@"%ld",(long)self.winingOrderShowId];
        url = @"stockWinOrderShowDetail";
        shareType = @"stockWinOrderShowId" ;
        self.showOrderId = self.winingOrderShowId;
        self.shareMassage = @"我参与喜腾猜涨跌获得了奖品，赶快来参与！";
    }
    
    
    UIView* rootView = [PZReactUIManager createWithPage:@"share_order" params:@{
                                                                          @"orderId":@(self.showOrderId),
                                                                          @"url":url,
                                                                          @"shareType":shareType} size:CGSizeZero];
    self.view = rootView ;
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
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
    self.cancelBtn = cancelBtn ;
    [self.view.window addSubview:cancelBtn];
    cancelBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    JNQShareView *shareView = [[JNQShareView alloc] init];
    shareView.atten.text = @"分享给朋友";
    self.shareView = shareView;
    [self.view.window addSubview:shareView];
    shareView.frame = CGRectMake(0, SCREENHeight, SCREENWidth, 140);
    [UIView animateWithDuration:0.15 animations:^{
        weakSelf.shareView.frame = CGRectMake(0, SCREENHeight-140, SCREENWidth, 140);
    }];
    
    shareView.shareBlock = ^(HBVerticalBtn *shareBtn) {
        [MBProgressHUD show];
        NSString* content = @"亲，我送你100喜腾币，免费参加股市猜涨跌游戏，祝你好运！";
        [HomeTool inviteWithContent:content successBlock:^(id json) {
            NSString *baseStr = Base_url;
            baseStr = [baseStr substringToIndex:Base_url.length-1];
            self.QRcodeUrl =  [NSString stringWithFormat:@"%@%@",baseStr,json[@"url"]];
            NSString *url;
            if(self.showOrderType == RRFShowOrderTypeFreeBuy){
                url = [NSString stringWithFormat:@"%@xitenggame/singleWrap/shareOnePieceOrder.html?purchaseGameShowId=%ld&QRCodeUrl=%@",Base_url,self.showOrderId,self.QRcodeUrl];
            }else if (self.showOrderType == RRFShowOrderTypeWining){
                url = [NSString stringWithFormat:@"%@xitenggame/singleWrap/shareWinning.html?stockWinOrderShowId=%ld&QRCodeUrl=%@",Base_url,self.showOrderId,self.QRcodeUrl];
            }else if (self.showOrderType == RRFShowOrderTypeGift){
                url = [NSString stringWithFormat:@"%@xitenggame/singleWrap/shareProduct.html?exchangeOrderId=%ld&QRCodeUrl=%@",Base_url,self.showOrderId,self.QRcodeUrl];
            }
            NSArray* platForms = @[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ];
            NSString* platForm = platForms[shareBtn.tag];
            [[HBShareTool sharedInstance] shareSingleSNSWithType:platForm title:self.shareTitle image:[UIImage imageNamed:@"share_logo"]  url:url msg:self.shareMassage presentedController:weakSelf];
            [weakSelf hiddenShareView:weakSelf.cancelBtn];
            [MBProgressHUD dismiss];
        } fail:^(id json) {
            
        }];
    };
    
    [[shareView.quitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self hiddenShareView:cancelBtn];
    }];
    [[cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self hiddenShareView:cancelBtn];
    }];
    
    
}
- (void)hiddenShareView:(UIButton *)button {
    [UIView animateWithDuration:0.2 animations:^{
    } completion:^(BOOL finished) {
        [_shareView removeFromSuperview];
        [button removeFromSuperview];
    }];
}


@end
