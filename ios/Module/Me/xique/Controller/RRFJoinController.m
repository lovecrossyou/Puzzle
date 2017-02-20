//
//  RRFJoinController.m
//  Puzzle
//
//  Created by huibei on 16/9/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFJoinController.h"
#import "RRFJoinView.h"
#import "UIViewController+ResignFirstResponser.h"
#import "JNQSelectedDistrictController.h"
#import "ZFModalTransitionAnimator.h"
#import "PZTitleInputView.h"
#import "TPKeyboardAvoidingTableView.h"
#import "RRFPlanTool.h"
#import "RRFApplyDelegaterModel.h"
#import "JNQPayViewContoller.h"
#import "JNQConfirmOrderModel.h"
#import "RRFPhoneListModel.h"
#import "Singleton.h"
#import "HBLoadingView.h"
#import "PZWebController.h"
#import "PZAccessInfo.h"
#import "PZHttpTool.h"
#import "PZParamTool.h"
@interface RRFJoinController ()
@property(nonatomic,weak)RRFJoinView *headView;
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;
@property(nonatomic,weak)TPKeyboardAvoidingTableView *tableView;
@property(nonatomic,weak)RRFApplyDelegaterModel *model;
@end

@implementation RRFJoinController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    RRFPhoneListModel *model = [Singleton sharedInstance].phoneListM;

    TPKeyboardAvoidingTableView *tableView = [[TPKeyboardAvoidingTableView alloc]init];
    self.tableView = tableView;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag ;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    RRFJoinView *headView = [[RRFJoinView alloc]init];
    headView.frame = CGRectMake(0, 0, SCREENWidth, SCREENHeight-64);
    self.headView = headView;
    self.tableView.tableHeaderView = headView;
    headView.applyForBlock = ^(NSNumber *tag){
        int type = [tag intValue];
        if (type == 0) {
            [weakSelf resignAll];
            // 立即申请
            [self joinDelegate];
        }else if (type == 1){
            // 选择地区
            [weakSelf selectedCity];
        }else if (type == 2){
            // 代理协议
            [weakSelf protocol];
            NSLog(@"代理协议");
        }else{
            // 南区
            [self callWithPhone:model.tel];
        }
    };
}
-(void)protocol
{
    PZWebController *desc = [[PZWebController alloc]init];
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfoNotLogin];
    NSDictionary* param = @{@"accessInfo":[accessInfo yy_modelToJSONObject]};
    [MBProgressHUD show];
    [PZHttpTool postHttpRequestUrl:@"baseInfo/protocolUrl" parameters:param successBlock:^(id json) {
        [MBProgressHUD dismiss];
        desc.pathUrl = json ;
        [self.navigationController pushViewController:desc animated:YES];
    } fail:^(id json) {
    }];

}
-(void)callWithPhone:(NSString *)phone
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
-(void)joinDelegate
{
    RRFApplyDelegaterModel* m = self.headView.delegaterModel ;
    m.phoneNumber = [m.phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (m.phoneNumber.length!=11) {
        [MBProgressHUD showInfoWithStatus:@"请填写正确的手机号"];
        return;
    }
    if(m.realName.length == 0){
        [MBProgressHUD showInfoWithStatus:@"请填写名字"];
        return;
    }
    if(m.cityId == 0){
        [MBProgressHUD showInfoWithStatus:@"请选择地址"];
        return;
    }
    [HBLoadingView showCircleView:self.view];
    [RRFPlanTool requestApplyDelegaterWithModel:m Success:^(id json) {
        JNQConfirmOrderModel *model = [JNQConfirmOrderModel yy_modelWithJSON:json];
        JNQPayViewContoller *desc = [[JNQPayViewContoller alloc]init];
        desc.title = @"确认加盟";
        desc.confirmOrderModel = model;
        desc.viewType = PayViewTypeDelegate;
        [self.navigationController pushViewController:desc animated:YES];
        [HBLoadingView hide];
    } failBlock:^(id json) {
        [HBLoadingView hide];
    }];
}
#pragma mark - 选择区域
-(void)selectedCity {
    [self resignAll];
    WEAKSELF
    JNQSelectedDistrictController *selectController = [[JNQSelectedDistrictController alloc]init];
    selectController.modalPresentationStyle = UIModalPresentationCustom;
    weakSelf.animator = [[ZFModalTransitionAnimator alloc]initWithModalViewController:selectController];
    weakSelf.animator.dragable = NO;
    weakSelf.animator.bounces = NO;
    weakSelf.animator.behindViewAlpha = 1.0f;
    weakSelf.animator.behindViewScale = 0.9f;
    weakSelf.animator.direction = ZFModalTransitonDirectionBottom;
    selectController.transitioningDelegate = weakSelf.animator;
    [weakSelf presentViewController:selectController animated:YES completion:^{
    }];
    selectController.districtNameBlock = ^(NSString *districtName, NSInteger provinceId, NSInteger cityId){
        weakSelf.headView.areaLabel.textValue = districtName;
        weakSelf.headView.delegaterModel.provinceId = provinceId;
        weakSelf.headView.delegaterModel.cityId = cityId;
        weakSelf.headView.delegaterModel.districtId = provinceId;
    };
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self resignAll];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.headView keyboardUp];
}
@end
