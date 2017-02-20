//
//  GuessPageController.m
//  Puzzle
//
//  Created by huipay on 2016/8/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "GuessPageController.h"
#import "GuessPageHeadView.h"
#import "GameModel.h"
#import "HomeTool.h"
#import "PZParamTool.h"
#import "SCLAlertView.h"
#import "BetResultView.h"
#import "RRFBettingRecordController.h"
#import "UIViewController+ResignFirstResponser.h"
#import <STPopup/STPopup.h>
#import "BetCompletePopController.h"
#import "PZCache.h"
#import "InviteFriendController.h"
#import "JNQDiamondViewController.h"
#import "PZAccessInfo.h"
@interface GuessPageController ()
@property(weak,nonatomic)GuessPageHeadView* headView ;
@end

@implementation GuessPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    UIImage *image = [UIImage imageNamed:@"cai3-bg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive ;
    GuessPageHeadView* headView = [[GuessPageHeadView alloc]initWithIndexM:self.indexM stockDetailM:nil type:self.guessType];
    headView.guessGameBlock = ^(NSString* amount){
        if ([amount intValue] < 10) {
            [MBProgressHUD showInfoWithStatus:@"至少投注10喜腾币！"];
            return  ;
        }
        [weakSelf checkBindPhone];
        [weakSelf resignAll];
        [MBProgressHUD show];
        [HomeTool guessGameWithAmount:amount guessType:weakSelf.guessType stockId:weakSelf.indexM.stockGameId successBlock:^(id json) {
            [MBProgressHUD dismiss];
            [weakSelf showBetSuccessViewWithString:amount];
        } fail:^(id json) {
            [MBProgressHUD dismiss];
        }];
    };
    //    释放键盘
    [[headView rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(id x) {
        [weakSelf resignAll];
    }];
    
    //    兑换喜腾币
    headView.bugXTBlock = ^{
        [weakSelf resignAll];
        BOOL appOpen = [PZCache sharedInstance].versionRelease ;
        if (appOpen) {
            JNQDiamondViewController* exchangeVC = [[JNQDiamondViewController alloc]init];
            exchangeVC.title = @"购买钻石" ;
            [weakSelf.navigationController pushViewController:exchangeVC animated:YES];
        }
        else{
            [weakSelf share:nil];
        }
    };
    
    self.headView = headView ;
    
    headView.frame = CGRectMake(0, 0, SCREENWidth, SCREENHeight - 64);
    self.tableView.tableHeaderView = headView ;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag ;
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithTitle:@"投注记录" style:UIBarButtonItemStylePlain target:self action:@selector(betHistory)];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:PZFont(16.0)} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = rightItem ;
}


-(void)checkBindPhone{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfo];
    NSString* phone_num = accessInfo.phone_num ;
    if (phone_num == nil || phone_num.length == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin" object:nil];
    }
}

#pragma mark - 分享
-(void)share:(UIButton*)sender
{
    InviteFriendController* invite = [[InviteFriendController alloc]init];
    invite.title = @"邀请朋友" ;
    [self.navigationController pushViewController:invite animated:YES];
}


#pragma mark - 投注记录
-(void)betHistory{
    [self resignAll];
    RRFBettingRecordController* betRecord = [[RRFBettingRecordController alloc]init];
    betRecord.title = @"我的投注" ;
    [self.navigationController pushViewController:betRecord animated:YES];
}

-(void)showBetSuccessViewWithString:(NSString *)amount{
    WEAKSELF
    BetCompletePopController* popDetail = [[BetCompletePopController alloc]init];
    popDetail.stockDetailModel = self.indexM ;
    popDetail.amount = amount ;
    popDetail.guessType = self.guessType ;
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:popDetail];
    popupController.navigationBarHidden = YES ;
    popupController.style = STPopupStyleFormSheet;
    popupController.containerView.layer.cornerRadius = 6 ;
    [popupController presentInViewController:weakSelf];
    popDetail.popViewBlock = ^(){
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [popupController dismiss];
    };
}

@end
