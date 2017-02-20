//
//  RRFApplyForController.m
//  Puzzle
//
//  Created by huibei on 16/9/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFApplyForController.h"
#import "RRFApplyForView.h"
#import "RRFJoinController.h"
#import "RRFRecruitController.h"
#import "RRFAboutController.h"
#import "RRFPhoneListModel.h"
#import "Singleton.h"
#import "PZWebController.h"
#import "PZParamTool.h"
#import "PZAccessInfo.h"
#import "PZHttpTool.h"
#import "RRFXQPlanView.h"
#import "RRFMeTool.h"
#import "RRFXTPlanModel.h"
@interface RRFApplyForController ()
@property(nonatomic,weak)RRFApplyForView *planView;
@property(nonatomic,weak)RRFPlanHeaderView *porfitView ;
@end

@implementation RRFApplyForController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    
    RRFPlanHeaderView *porfitView = [[RRFPlanHeaderView alloc]initWithBackgroundColor:[UIColor whiteColor] TextColor:[UIColor colorWithHexString:@"333333"] ];
    self.porfitView = porfitView;
    [self.view addSubview:porfitView];
    [porfitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(146);
    }];
    
    RRFApplyForView *planView = [[RRFApplyForView alloc]init];
    self.planView = planView;
    [self.view addSubview:planView];
    [planView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(porfitView.mas_bottom);
    }];
    planView.applyForBlock = ^(NSNumber *tag){
        int type = [tag intValue];
        if (type == 0) {
            // 立即申请
            RRFJoinController *desc = [[RRFJoinController alloc]init];
            desc.title = @"加入喜鹊";
            [weakSelf.navigationController pushViewController:desc animated:YES];
        }else{
            //什么是喜鹊计划
          [self requirePlan];
        }
    };
    [self requestData];
}
-(void)requirePlan
{
    PZWebController *desc = [[PZWebController alloc]init];
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfoNotLogin];
    NSDictionary* param = @{@"accessInfo":[accessInfo yy_modelToJSONObject]};
    [MBProgressHUD show];
    [PZHttpTool postHttpRequestUrl:@"baseInfo/aboutUrl" parameters:param successBlock:^(id json) {
        [MBProgressHUD dismiss];
        desc.pathUrl = json ;
        [self.navigationController pushViewController:desc animated:YES];
    } fail:^(id json) {
    }];
}
-(void)requestData
{
    WEAKSELF
    [RRFMeTool requestDelegateRebateWithSuccess:^(id json) {
        RRFXTPlanModel *model = [RRFXTPlanModel yy_modelWithJSON:json];
        weakSelf.porfitView.model = model;
    } failBlock:^(id json) {
        
    }];
}


@end
