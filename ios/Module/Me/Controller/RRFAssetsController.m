//
//  RRFAssetsController.m
//  Puzzle
//
//  Created by huibei on 16/8/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFAssetsController.h"
#import "PZCommonCellModel.h"
#import "RRFAssetsView.h"
#import "RRFMeTool.h"
#import "LoginModel.h"
#import "PZParamTool.h"
#import "RRFBillListController.h"
#import "JNQDiamondViewController.h"
#import "HBLoadingView.h"
#import "JNQPresentAwardViewController.h"
#import "PZCache.h"
@interface RRFAssetsController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_allData;
}
@property(nonatomic,strong)LoginModel *userM;
@property(nonatomic,weak)RRFAssetsHeaderView *headerView;

@end

@implementation RRFAssetsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self requestAccountInfo];
    [self settingTableView];
    [self settingNavItem];
}
//喜腾币账户
-(void)requestAccountInfo
{
    [HBLoadingView showCircleView:self.view];
    [RRFMeTool requestAccountXTBWithSuccess:^(id json) {
        if(json != nil){
            RLMRealm *defaultRealm = [RLMRealm defaultRealm];
            [defaultRealm beginWriteTransaction];
            LoginModel* userM = [LoginModel yy_modelWithJSON:json];
            LoginModel *userInfo = [PZParamTool currentUser];
            userInfo.xtbCapitalAmount = userM.xtbCapitalAmount;
            userInfo.xtbTotalAmount = userM.xtbTotalAmount;
            userInfo.diamondAmount =userM.diamondAmount;
            userInfo.xtbProfitAmount = userM.xtbProfitAmount;
            [defaultRealm commitWriteTransaction];
            [self settingDataWithLoginModel:userInfo];
            self.userM = userInfo;
            [HBLoadingView hide];
        }
    } failBlock:^(id json) {
        [HBLoadingView hide];

    }];
}
-(void)settingDataWithLoginModel:(LoginModel *)loginModel;
{
    BOOL appOpen = [PZCache sharedInstance].versionRelease ;
    CGFloat headerHeight = appOpen?200 : 125;
    RRFAssetsHeaderView *headerView = [[RRFAssetsHeaderView alloc]initWithModel:loginModel];
    headerView.frame = CGRectMake(0, 0, SCREENWidth, headerHeight);
    self.headerView = headerView;
    self.tableView.tableHeaderView = headerView;
}
- (void)settingTableView {
    PZCommonCellModel *mode1 = [PZCommonCellModel cellModelWithIcon:@"assets_icon_buy-diamonds" title:@"购买钻石" subTitle:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:[JNQDiamondViewController class ]];
    PZCommonCellModel *mode2 = [PZCommonCellModel cellModelWithIcon:@"assets_icon_mall" title:@"礼品商城" subTitle:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:[JNQPresentAwardViewController class]];
    BOOL appOpen = [PZCache sharedInstance].versionRelease ;
    if (appOpen) {
        _allData = @[mode1,mode2];
    }
    else{
        _allData = @[mode2];
    }
}
-(void)settingNavItem
{
    UIButton *right = [[UIButton alloc]init];
    [right setTitle:@"账单" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize:16];
    [right addTarget:self action:@selector(billList) forControlEvents:UIControlEventTouchUpInside];
    right.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = item;
}
#pragma mark - 账单列表
-(void)billList
{
    RRFBillListController *desc = [[RRFBillListController alloc]init];
    desc.title = @"账单";
    desc.userM = self.userM;
    [self.navigationController pushViewController:desc animated:YES];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _allData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PZCommonCellModel *model = _allData[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRFAssetsController"];
    if (cell== nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RRFAssetsController"];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    cell.textLabel.text = model.title;
    cell.imageView.image = [UIImage imageNamed:model.icon];
    cell.accessoryType = model.accessoryType;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PZCommonCellModel *model = _allData[indexPath.row];
    UIViewController *desc = [[model.descVc alloc]init];
    desc.title = model.title;
    [self.navigationController pushViewController:desc animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MBProgressHUD dismiss];
}
@end
