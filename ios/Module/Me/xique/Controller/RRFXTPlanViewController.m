//
//  RRFPlanViewController.m
//  Puzzle
//
//  Created by huipay on 2016/12/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFXTPlanViewController.h"
#import "RRFXQPlanView.h"
#import "PZCommonCellModel.h"
#import "CommonTableViewCell.h"
#import "RRFRebateController.h"
#import "RRFRecruitController.h"
#import "RRFMeTool.h"
#import "RRFXTPlanModel.h"
#import "RRFXTDelegateController.h"
#import "InviteFriendController.h"
#import "PZWebController.h"
#import "PZAccessInfo.h"
#import "PZParamTool.h"
#import "PZHttpTool.h"
@interface RRFXTPlanViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *allData;
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)RRFPlanHeaderView *headerView;
@end

@implementation RRFXTPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    RRFPlanHeaderView *headerView = [[RRFPlanHeaderView alloc]initWithBackgroundColor:[UIColor colorWithHexString:@"7c7d82"] TextColor:[UIColor whiteColor] ];
    headerView.frame = CGRectMake(0, 0, SCREENWidth, 146);
    self.headerView = headerView;
    [self.tableView setTableHeaderView:headerView];
    headerView.planHeaderBlock = ^(NSNumber *typeNum){
        int typeInt = [typeNum intValue];
        if (typeInt == 1) {
            RRFRebateController *desc = [[RRFRebateController alloc]init];
            desc.title = @"我的返利";
            [self.navigationController pushViewController:desc animated:YES];
        }else{
            RRFXTDelegateController *desc = [[RRFXTDelegateController alloc]init];
            desc.title = @"我的客户";
            [self.navigationController pushViewController:desc animated:YES];
        }
        
    };
    
    RRFPlanFooterBarView *footBar = [[RRFPlanFooterBarView alloc]init];
    footBar.frame = CGRectMake(0, 0, SCREENWidth, 44);
    [self.view addSubview:footBar];
    [footBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(-20);
    }];
    [[footBar rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
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
    }];
    
   
    [self settingTableView];
    [self requestData];
}
-(void)requestData
{
    WEAKSELF
    [RRFMeTool requestDelegateRebateWithSuccess:^(id json) {
        RRFXTPlanModel *model = [RRFXTPlanModel yy_modelWithJSON:json];
        weakSelf.headerView.model = model;
    } failBlock:^(id json) {
        
    }];
}
-(void)settingTableView
{
    
    PZCommonCellModel *mode1 = [PZCommonCellModel cellModelWithIcon:@"xique_icon_invitation" title:@"邀请朋友" subTitle:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:nil];
    self.allData = @[mode1];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.allData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PZCommonCellModel *model = self.allData[indexPath.row];
    CommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRFMeController"];
    if (!cell) {
        cell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"RRFMeController"];
        cell.textLabel.font = PZFont(16);
        cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    cell.accessoryType = model.accessoryType;
    cell.imageView.image = [UIImage imageNamed:model.icon];
    cell.textLabel.text = model.title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView =[[UIView alloc]init];
    headerView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PZCommonCellModel *model = self.allData[indexPath.row];
    InviteFriendController* invite = [[InviteFriendController alloc]init];
    invite.title = model.title ;
    [self.navigationController pushViewController:invite animated:YES];

}


@end
