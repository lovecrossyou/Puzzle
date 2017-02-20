//
//  RRFWiningOrderListController.m
//  Puzzle
//
//  Created by huipay on 2017/1/17.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "RRFWiningOrderListController.h"
#import "RRFWiningOrderListCell.h"
#import "MJRefresh.h"
#import "RRFMeTool.h"
#import "RRFWiningOrderModel.h"
#import "RRFReceiveController.h"
#import "RRFFreeBuyOrderModel.h"
#import "RRFWillCommentPanel.h"
#import "RRFRemarkViewController.h"
#import "RRFShareOrderDetailInfoController.h"
#import "JNQFailFooterView.h"
#import "RRFWiningOrderDetailController.h"

@interface RRFWiningOrderListController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)JNQFailFooterView *failFootView;
@property(nonatomic,strong)NSArray *allData;
@property(nonatomic,assign)int pageNo;

@end

@implementation RRFWiningOrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200.0;
    [self.tableView registerClass:[RRFWiningOrderListCell class] forCellReuseIdentifier:@"RRFWiningOrderListController"];
    
    MJRefreshNormalHeader *tabheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestList:)];
    tabheader.lastUpdatedTimeLabel.hidden = YES;
    tabheader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.tableView.mj_header = tabheader;
    
    MJRefreshAutoNormalFooter *tabfooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestList:)];
    tabfooter.automaticallyRefresh = YES;
    self.tableView.mj_footer = tabfooter;
    
    if (self.showSwitchPanel) {
        RRFWillCommentPanel *headerPanel = [[RRFWillCommentPanel alloc]init];
        headerPanel.frame = CGRectMake(0, 0, SCREENWidth, 45);
        self.tableView.tableHeaderView = headerPanel;
        headerPanel.commentPanelBlock = ^(NSNumber *typeNum){
            int typeInt = [typeNum intValue];
            if (typeInt == 0) {
                self.status = @"finish";
            }else{
                self.status = @"evaluate";
            }
            [self.tableView.mj_header beginRefreshing];
        };
    }

    
    [self.tableView.mj_footer beginRefreshing];
    
}
-(JNQFailFooterView *)failFootView
{
    WEAKSELF
    if (_failFootView == nil) {
        _failFootView = [[JNQFailFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
        _failFootView.reloadBlock = ^(){
            [weakSelf.tableView.mj_header beginRefreshing];
        };
    }
    return _failFootView;
}
-(void)requestList:(UIView *)sender
{
    BOOL isRefre = NO;
    NSMutableArray *temp;
    if ([sender isKindOfClass:[MJRefreshHeader class]]) {
        isRefre = YES;
    }
    if (isRefre) {
        self.pageNo = 0;
        temp = [[NSMutableArray alloc]init];
    }else{
        temp = [[NSMutableArray alloc]initWithArray:self.allData];
    }
    WEAKSELF
    [RRFMeTool requestWiningOrderListWithPageNo:self.pageNo Size:10 Status:self.status Success:^(id json) {
        RRFWiningOrderListModel *model = [RRFWiningOrderListModel yy_modelWithJSON:json];
        weakSelf.allData = model.content;
        if(weakSelf.allData.count == 0){
            [weakSelf settingNoDataView];
        }else{
            weakSelf.tableView.tableFooterView = [UIView new];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.tableView.mj_footer.hidden = model.last;
        [weakSelf.tableView reloadData];
        weakSelf.pageNo ++;
    }failBlock:^(id json) {
        self.allData = nil;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer setHidden:YES];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView setTableFooterView:self.failFootView];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.allData.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RRFWiningOrderModel *model = self.allData[indexPath.section];
    RRFWiningOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRFWiningOrderListController"];
    if (cell == nil) {
        cell = [[RRFWiningOrderListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RRFWiningOrderListController"];
    }
    cell.winingOrderListCellBlock = ^(){
        [self cellClcikWithModel:model];
    };
    cell.model = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    RRFWiningOrderModel *model = self.allData[indexPath.section];
    if ([self.status isEqualToString:@"evaluate"]) {
        RRFShareOrderDetailInfoController *desc = [[RRFShareOrderDetailInfoController alloc]init];
        desc.title = @"晒单详情";
        desc.showOrderType = RRFShowOrderTypeWining;
        desc.winingOrderShowId = model.stockWinOrderShowId;
        [self.navigationController pushViewController:desc animated:YES];

    }else if ([self.status isEqualToString:@"create"]){
        
        return;
    }else{
        RRFWiningOrderModel *model = self.allData[indexPath.section];
        RRFWiningOrderDetailController *desc = [[RRFWiningOrderDetailController alloc]init];
        desc.model = model;
        desc.title = @"订单详情";
        desc.refreBlock = ^(BOOL shouldReload){
            if (shouldReload == YES) {
                [weakSelf.tableView.mj_header beginRefreshing];
            }
        };
        [self.navigationController pushViewController:desc animated:YES];
    }
}
-(void)cellClcikWithModel:(RRFWiningOrderModel *)model
{
    WEAKSELF
    if ([model.orderStatus isEqualToString:@"create"]) {
        RRFReceiveController *desc = [[RRFReceiveController alloc]init];
        desc.title = @"领奖";
        desc.winingM = model;
        [self.navigationController pushViewController:desc animated:YES];
        desc.isRefre = ^(BOOL isRefre){
            if (isRefre == YES) {
                [weakSelf.tableView.mj_header beginRefreshing];
            }
        };
    }else if ([model.orderStatus isEqualToString:@"send"] || [model.orderStatus isEqualToString:@"acceptPrize"] ){
        // 签收
        [self dealWithOrderId:model.orderId];
    }else if ([model.orderStatus isEqualToString:@"finish"] ){
        // 去评价
        RRFRemarkViewController *desc = [[RRFRemarkViewController alloc]init];
        desc.title = @"晒单";
        desc.showOrderType = RRFShowOrderTypeWining;
        desc.winingModel = model;
        [self.navigationController pushViewController:desc animated:YES];
        desc.isRefre = ^(BOOL isRefre){
            if(isRefre == YES){
                [weakSelf.tableView.mj_header beginRefreshing];
            }
        };
    }else{
        // 查看晒单
        RRFShareOrderDetailInfoController *desc = [[RRFShareOrderDetailInfoController alloc]init];
        desc.title = @"晒单详情";
        desc.showOrderType =  RRFShowOrderTypeWining;
        desc.winingOrderShowId = model.stockWinOrderShowId;
        [self.navigationController pushViewController:desc animated:YES];
    }
}
-(void)dealWithOrderId:(NSNumber *)orderId
{
    [RRFMeTool dealWithOrderId:orderId Success:^(id json) {
        [MBProgressHUD showInfoWithStatus:@"签收成功!"];
        [self.tableView.mj_header beginRefreshing];
    } failBlock:^(id json) {
        [MBProgressHUD showInfoWithStatus:@"签收失败,请稍候重试!"];
    }];
}
-(void)remindWithTradeOrderId:(NSInteger)tradeOrderId
{
    [RRFMeTool stockWinOrderShowWithTradeOrderId:tradeOrderId  Success:^(id json) {
        [MBProgressHUD showInfoWithStatus:@"提醒成功!"];
    } failBlock:^(id json) {
        
    }];
}
-(void)settingNoDataView
{
    NSString *titleStr = @"暂时没有订单!";
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, 100)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 50, SCREENWidth-30, 50)];
    titleLabel.text = titleStr;
    titleLabel.numberOfLines=2;
    titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:titleLabel];
    self.tableView.tableFooterView = footerView;
}
@end
