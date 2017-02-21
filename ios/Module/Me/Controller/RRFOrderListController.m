//
//  RRFOrderListController.m
//  Puzzle
//
//  Created by huibei on 16/8/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFOrderListController.h"
#import "RRFOrderListView.h"
#import "RRFOrderListCell.h"
#import "RRFOrderDetailController.h"
#import "RRFMeTool.h"
#import "MJRefresh.h"
#import "RRFOrderListModel.h"
#import "RRFProductModel.h"
#import "NSString+TimeConvert.h"
#import "JNQFailFooterView.h"
#import "HBLoadingView.h"
#import "RRFWillCommentPanel.h"
#import "RRFShareOrderDetailInfoController.h"
#import "RRFRemarkViewController.h"
#import "PZReactUIManager.h"
@interface RRFOrderListController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)JNQFailFooterView *failFootView;
@property(nonatomic,strong)NSMutableArray *allData;
@property(nonatomic,assign)int pageNo;
@property(nonatomic,weak)UITableView *tableView;

@end

@implementation RRFOrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUIView];
    
//    [self settingTableView];
}
-(void)settingTableView
{
    self.pageNo = 0;
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 200.0;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    MJRefreshNormalHeader *tabheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestOrderList:)];
    tabheader.lastUpdatedTimeLabel.hidden = YES;
    tabheader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.tableView.mj_header = tabheader;
    
    MJRefreshAutoNormalFooter *tabfooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestOrderList:)];
    tabfooter.automaticallyRefresh = YES;
    self.tableView.mj_footer = tabfooter;
    
    [self.tableView registerClass:[RRFOrderListCell class] forCellReuseIdentifier:@"RRFOrderListController"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 68.0;
    
    if (self.showSwitchPanel) {
        RRFWillCommentPanel *headerPanel = [[RRFWillCommentPanel alloc]init];
        headerPanel.frame = CGRectMake(0, 0, SCREENWidth, 45);
        self.tableView.tableHeaderView = headerPanel;
        headerPanel.commentPanelBlock = ^(NSNumber *typeNum){
            int typeInt = [typeNum intValue];
            if (typeInt == 0) {
                self.status = 2;
            }else{
                self.status = 3;
            }
            [self.tableView.mj_header beginRefreshing];
        };
    }
    
    [self.tableView.mj_footer beginRefreshing];
}
-(void)setUIView
{
   NSString *isSwitch = self.showSwitchPanel == YES?@"true":@"false";
    UIView* rootView = [PZReactUIManager createWithPage:@"giftOrder" params:@{
                                                                          @"status":@(self.status),
                                                                          @"url":@"exchange/list",
                                                                          @"isSwitch":isSwitch
                                                                          } size:CGSizeZero];
    rootView.frame = self.view.bounds ;
    [self.view addSubview:rootView];
    
}
-(NSMutableArray *)allData
{
    if (_allData == nil) {
        _allData = [[NSMutableArray alloc]init];
    }
    return _allData;
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
-(void)requestOrderList:(UIView *)sender
{
    WEAKSELF
    if ([sender isKindOfClass:[MJRefreshHeader class]]) {
        self.pageNo = 0;
    }
    [RRFMeTool requestOrderListWithStatus:self.status pageNo:self.pageNo Success:^(id json) {
        BOOL last = [[json objectForKey:@"last"] boolValue];
        NSArray *dataArray = [json objectForKey:@"content"];
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        if (dataArray.count > 0) {
            for (NSDictionary *dic in dataArray) {
                RRFOrderListModel *listM = [RRFOrderListModel yy_modelWithJSON:dic];
                [temp addObject:listM];
            }
        }
        if (self.pageNo == 0) {
            self.allData = temp;
        }else{
            [self.allData addObjectsFromArray:temp];
        }
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        if(self.allData.count == 0){
            [weakSelf settingNoDataView];
        }else{
            [weakSelf.tableView setTableFooterView:[UIView new]];
        }
        [weakSelf.tableView reloadData];
        self.pageNo ++;
        if (last) {
            [weakSelf.tableView.mj_footer setHidden:YES];
        }else{
            [weakSelf.tableView.mj_footer setHidden:NO];
        }
    } failBlock:^(id json) {
        [weakSelf.tableView.mj_footer setHidden:YES];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView setTableFooterView:self.failFootView];
        [weakSelf.tableView reloadData];

    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.allData.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.allData.count) {
        RRFOrderListModel *listM = self.allData[section];
        return listM.products.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RRFOrderListModel *listM = self.allData[indexPath.section];
    RRFProductModel *model = listM.products[indexPath.row];
    RRFOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRFOrderListController"];
    if (cell == nil) {
        cell = [[RRFOrderListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RRFOrderListController"];
    }
    model.tradeWay = listM.tradeWay;
    cell.model = model;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RRFOrderListSectionHeaderView *secHead = [[RRFOrderListSectionHeaderView alloc]init];
    RRFOrderListModel *listM = self.allData[section];
    secHead.model = listM;
    return secHead;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 56;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    WEAKSELF
    RRFOrderListSectionFooterView *footerView = [[RRFOrderListSectionFooterView alloc]init];
    RRFOrderListModel *listM = self.allData[section];
    [footerView.totalBtn setTitle:[NSString stringWithFormat:@"%.0f",listM.xtbPrice] forState:UIControlStateNormal];
    [footerView.clickBtn setTitle:[listM.statusVal orderState] forState:UIControlStateNormal];
    [[footerView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([listM.statusVal isEqualToString:@"1"]) {
            // 1:签收
            [weakSelf dealWithOrderId:listM.orderId];
        }else if([listM.statusVal isEqualToString:@"2"]){
            // 2:评价
            [weakSelf goCommentControllerWithlistM:listM];
        }else if([listM.statusVal isEqualToString:@"0"]){
            //0:提醒发货
            [weakSelf  remindWithTradeOrderId:listM.orderId];
        }else if([listM.statusVal isEqualToString:@"3"]){
            // 3:查看晒单
            RRFShareOrderDetailInfoController *desc = [[RRFShareOrderDetailInfoController alloc]init];
            desc.title = @"晒单详情";
            desc.showOrderType =  RRFShowOrderTypeGift;
            desc.giftOrderShowId = listM.ID;
            [self.navigationController pushViewController:desc animated:YES];
        }
    }];
    return footerView;
    
}
-(void)remindWithTradeOrderId:(NSNumber *)tradeOrderId
{
    [RRFMeTool stockWinOrderShowWithTradeOrderId:[tradeOrderId integerValue] Success:^(id json) {
        [MBProgressHUD showInfoWithStatus:@"提醒成功!"];
    } failBlock:^(id json) {
        
    }];
}

//响应信息：
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    RRFOrderListModel *listM = self.allData[indexPath.section];
    RRFOrderDetailController *descVc = [[RRFOrderDetailController alloc]init];
    descVc.orderId = listM.ID;
    descVc.title = @"订单详情";
    descVc.refreBlock = ^(BOOL shouldReload){
        if (shouldReload == YES) {
            [weakSelf.tableView.mj_header beginRefreshing];
        }
    };
    [self.navigationController pushViewController:descVc animated:YES];
}
-(void)goCommentControllerWithlistM:(RRFOrderListModel *)listM
{
    WEAKSELF
    // 去评价
    RRFRemarkViewController *desc = [[RRFRemarkViewController alloc]init];
    desc.title = @"晒单";
    desc.listModel = listM;
    desc.showOrderType = RRFShowOrderTypeGift;
    [self.navigationController pushViewController:desc animated:YES];
    desc.isRefre = ^(BOOL isRefre){
        if(isRefre == YES){
          [weakSelf.tableView.mj_header beginRefreshing];
        }
    };
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
-(void)dealWithOrderId:(NSNumber *)orderId
{
    [RRFMeTool dealWithOrderId:orderId Success:^(id json) {
        [MBProgressHUD showInfoWithStatus:@"签收成功!"];
        [self.tableView.mj_header beginRefreshing];
    } failBlock:^(id json) {
        [MBProgressHUD showInfoWithStatus:@"签收失败,请稍候重试!"];
    }];
}

@end
