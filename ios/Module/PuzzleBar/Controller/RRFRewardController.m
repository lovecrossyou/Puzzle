//
//  RRFRewardController.m
//  Puzzle
//
//  Created by huibei on 16/8/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//  打赏页

#import "RRFRewardController.h"
#import "RRFRewardView.h"
#import "ZFModalTransitionAnimator.h"
#import "RRFPuzzleBarTool.h"
#import "PZParamTool.h"
#import "LoginModel.h"
#import "PZParamTool.h"
#import "TPKeyboardAvoidingTableView.h"
#import "UIViewController+ResignFirstResponser.h"
#import "BetCompletePopController.h"
#import "SCLAlertView.h"
#import <STPopup/STPopup.h>
#import "PZHttpTool.h"
#import "PZCache.h"
#import "JNQDiamondViewController.h"
#import "InviteFriendController.h"
#import "HBLoadingView.h"
typedef void(^AlertAction)();
@interface RRFRewardController ()<UIAlertViewDelegate>
{
    TPKeyboardAvoidingTableView *_rewardTableView;
    
}
@property(nonatomic,weak)RRFRewardView *rewardView;
@end

@implementation RRFRewardController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    self.view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    _rewardTableView = [[TPKeyboardAvoidingTableView alloc]init];
    _rewardTableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    [self.view addSubview:_rewardTableView];
    [_rewardTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    [HBLoadingView showCircleView:self.view];
    [RRFPuzzleBarTool getPresentDiamondsListWithSuccess:^(id json) {
        [HBLoadingView dismiss];
        RRFRewardView *rewardView =  [[RRFRewardView alloc]initWithJSONData:json];
        rewardView.frame = CGRectMake(0, 0, SCREENWidth, SCREENHeight);
        self.rewardView  = rewardView;
        _rewardTableView.tableFooterView = rewardView;
        rewardView.rewardBlock = ^(int selNum){
            if (selNum == 0) {
                selNum = 1;
                [weakSelf.rewardView setInputNum:@"1"];
            }
            [weakSelf resignAll];
            [weakSelf goPayWithStr:selNum];
        };
    } failBlock:^(id json) {
        [HBLoadingView dismiss];
    }];
}

-(void)goPayWithStr:(int )selInt
{
    WEAKSELF
    NSString *message = [NSString stringWithFormat:@"赞赏需要支付%d喜腾币,请确认赞赏",selInt];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认赞赏" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [MBProgressHUD show ];
        [PZParamTool rewardWithUserId:self.userId amount:selInt entityId:self.entityId entityType:self.entityType Success:^(id json) {
            
            [weakSelf showBetSuccessWithNumber:selInt];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshCommentTableView object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshPersonalAskBarTableView object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:RRFDynamicRefre object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:RRFFriendCircleRefre object:nil];
            [MBProgressHUD dismiss];
        } failBlock:^(NSError* error) {
            [MBProgressHUD dismiss];
            NSData* data = error.userInfo[@"com.alamofire.serialization.response.error.data"] ;
            if (data != nil) {
                NSDictionary* d = [self toArrayOrNSDictionary:data];
                NSString* message = d[@"message"];
                if (message!= nil) {
                    if ([message containsString:@"不足"]) {
                        [weakSelf goExchangeXT:nil];
                    }
                    else{
                        [MBProgressHUD showInfoWithStatus:message];
                    }
                }
            }
        }];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (id)toArrayOrNSDictionary:(NSData *)jsonData{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}


-(void)goExchangeXT:(NSNotification*)notificate{
    BOOL appOpen = [PZCache sharedInstance].versionRelease ;
    NSString* message = appOpen?@"您的喜腾币余额不足，需购买钻石兑换喜腾币" : @"分享获取喜腾币" ;
    NSString* titleVC = appOpen?@"购买钻石" : @"邀请朋友获取喜腾币" ;
    NSString* confirmTitle = appOpen?@"立即购买" : @"立即邀请" ;
    WEAKSELF
    [self showActionWithTitle:nil message:message cancelAction:nil confirmAction:^{
        if (appOpen) {
            JNQDiamondViewController* exchangeVC = [[JNQDiamondViewController alloc]init];
            exchangeVC.title = titleVC ;
            [self.navigationController pushViewController:exchangeVC animated:YES];
        }
        else{
            [weakSelf shareFriend];
        }
        
    } confirmTitle:confirmTitle];
}
#pragma mark - 分享
-(void)shareFriend{
    InviteFriendController* invite = [[InviteFriendController alloc]init];
    invite.title = @"邀请朋友" ;
    invite.showCancel = YES ;
    [self presentViewController:invite animated:YES completion:nil];
}
-(void)showActionWithTitle:(NSString*)title message:(NSString*)msg cancelAction:(AlertAction)cancelAct confirmAction:(AlertAction)confirm confirmTitle:(NSString*)confirmTitle{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:cancelAct];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:confirm];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self.navigationController presentViewController:alertController animated:YES completion:^{
    }];
}

-(void)showBetSuccessWithNumber:(int)number{
    WEAKSELF
    BetCompletePopController* popDetail = [[BetCompletePopController alloc]init];
    popDetail.praise = YES ;
    popDetail.amount = [NSString stringWithFormat:@"%d",number];
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

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RefreshCommentTableView object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RefreshPersonalAskBarTableView object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RRFDynamicRefre object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RRFFriendCircleRefre object:nil];
}

@end
