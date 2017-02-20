//
//  RRFFreeBuyOrderViewController.m
//  Puzzle
//
//  Created by huipay on 2016/12/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFFreeBuyOrderViewController.h"
#import "RRFFreeBuyOrderCell.h"
#import "MJRefresh.h"
#import "RRFParticipateInfoController.h"
#import "RRFRemarkViewController.h"
#import "RRFReceiveController.h"
#import "RRFFreeBuyOrderTool.h"
#import "RRFFreeBuyOrderModel.h"
#import "RRFFreeBuyOrderDetailController.h"
#import "JNQFBComContentPageController.h"
#import "RRFFreeBuyOrderHeaderView.h"
#import "RRFWillCommentPanel.h"
#import "JNQFailFooterView.h"
#import "RRFShareOrderDetailInfoController.h"
@interface RRFFreeBuyOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)JNQFailFooterView *failFootView;

@property(nonatomic,assign)int pageNo;
//是否已经晒单
@property(nonatomic,strong)NSString *isEvaluate;
@property(nonatomic,strong)NSMutableArray *allData;
@property(nonatomic,weak)RRFFreeBuyOrderHeaderView *headerView;
@end

@implementation RRFFreeBuyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 0;
    self.isEvaluate = @"";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[RRFFreeBuyOrderCell class] forCellReuseIdentifier:@"RRFFreeBuyOrderViewController"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200.0;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MJRefreshNormalHeader *tabheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestDataList:)];
    tabheader.lastUpdatedTimeLabel.hidden = YES;
    tabheader.stateLabel.textColor = HBColor(135, 135, 135);
    tabheader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.tableView.mj_header = tabheader;
    
    MJRefreshAutoNormalFooter *tabfooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestDataList:)];
    tabfooter.triggerAutomaticallyRefreshPercent = 1;
    tabfooter.automaticallyRefresh = YES;
    tabfooter.stateLabel.textColor = HBColor(135, 135, 135);
    self.tableView.mj_footer = tabfooter;
    
    if (self.showCancel) {
        UIBarButtonItem* cancelItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelController)];
        self.navigationItem.rightBarButtonItem = cancelItem ;
    }
    
    if (self.comminType == RRFFreeBuyOrderTypeFreeBuy) {
        RRFFreeBuyOrderHeaderView *headerView = [[RRFFreeBuyOrderHeaderView alloc]init];
        self.status = @"";
        headerView.frame = CGRectMake(0, 0, SCREENWidth, 56);
        self.tableView.tableHeaderView = headerView;
        headerView.buyOrderHeaderBlock = ^(NSNumber *typeNum){
            int typeInt = [typeNum intValue];
            if (typeInt == 0) {
               self.status = @"";
                self.isEvaluate = @"";
                [self.tableView.mj_header beginRefreshing];
            }else if (typeInt == 1){
                self.status = @"waiting";
                self.isEvaluate = @"";
                [self.tableView.mj_header beginRefreshing];
            }else if (typeInt == 2){
                self.status = @"win";
                self.isEvaluate = @"";
                [self.tableView.mj_header beginRefreshing];
            }else {
                self.status = @"evaluate";
                self.isEvaluate = @"false";
                [self.tableView.mj_header beginRefreshing];
            }
        };
    }
    
    if (self.showSwitchPanel) {
        self.isEvaluate = @"false";
        RRFWillCommentPanel *headerPanel = [[RRFWillCommentPanel alloc]init];
        headerPanel.frame = CGRectMake(0, 0, SCREENWidth, 44);
        self.tableView.tableHeaderView = headerPanel;
        headerPanel.commentPanelBlock = ^(NSNumber *typeNum){
            int typeInt = [typeNum intValue];
            self.isEvaluate = typeInt==0?@"false":@"true";
            [self.tableView.mj_header beginRefreshing];
        };
    }
    [self.tableView.mj_footer beginRefreshing];
}

-(void)cancelController{
    [self dismissViewControllerAnimated:YES completion:nil];
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
-(void)requestDataList:(UIView *)sender
{
    NSMutableArray *temp;
    BOOL allRefre = NO;
    if ([sender isKindOfClass:[MJRefreshHeader class]]) {
        allRefre = YES;
        self.pageNo = 0;
    }
    if (allRefre) {
        temp = [[NSMutableArray alloc]init];
    }else{
        temp = [NSMutableArray arrayWithArray:self.allData];
    }
    WEAKSELF
    [RRFFreeBuyOrderTool requestFreeBuyOrderListWithStatus:self.status isEvaluate:self.isEvaluate pageNo:self.pageNo Success:^(id json) {
        BOOL last = [json[@"last"] boolValue];
        NSArray *dicArray = json[@"content"];
        for (NSDictionary *dic in dicArray) {
            RRFFreeBuyOrderModel *model = [RRFFreeBuyOrderModel yy_modelWithJSON:dic];
            [temp addObject:model];
        }
        weakSelf.allData = temp;
        if (weakSelf.allData.count == 0) {
            [weakSelf settingNoDataView];
        }else{
            [weakSelf.tableView setTableFooterView:[UIView new]];
        }
        [weakSelf.tableView reloadData];
        weakSelf.pageNo ++;
        [weakSelf.tableView.mj_footer setHidden:last];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    } failBlock:^(id json) {
        weakSelf.allData = nil;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer setHidden:YES];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView setTableFooterView:self.failFootView];

    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.allData.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    RRFFreeBuyOrderModel *model = self.allData[indexPath.section];
    RRFFreeBuyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRFFreeBuyOrderViewController"];;
    if(cell == nil){
        cell = [[RRFFreeBuyOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RRFFreeBuyOrderViewController"];
    };
    cell.model = model;
    cell.FreeBuyOrderCellBlock =^(NSNumber *typeNum){
        int type = [typeNum intValue];
        if (type == 0) {
            // 查看全部
            [weakSelf setAllWithRecordList:model.bidRecords];
        }else{
            // 操作
            [weakSelf operationWithModel:model ];
        };
    };
    cell.productBtnBlock = ^(){
        JNQFBComContentPageController *desc =[[JNQFBComContentPageController alloc]init];
        desc.fbPurchaseGameId = model.purchaseGameId;
        [self.navigationController pushViewController:desc animated:YES];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    RRFFreeBuyOrderModel *model = self.allData[indexPath.section];
    RRFFreeBuyOrderDetailController *desc = [[RRFFreeBuyOrderDetailController alloc]init];
    desc.model = model;
    desc.title = @"订单详情";
    desc.isRefre = ^(BOOL isRefre){
        if (isRefre == YES) {
            [weakSelf.tableView.mj_header beginRefreshing];
        }
    };
    [self.navigationController pushViewController:desc animated:YES];
}
-(void)setAllWithRecordList:(NSArray *)bidRecords{
    
    RRFParticipateInfoController *desc = [[RRFParticipateInfoController alloc]init];
    desc.title = @"夺宝号码";
    desc.recordList = bidRecords;
    [self.navigationController pushViewController:desc animated:YES];
}

-(void)operationWithModel:(RRFFreeBuyOrderModel *)model{
    WEAKSELF
    NSString *str = [model.bidOrderStatus bidOrderStatusOperationBtnStr];
    if ([str isEqualToString:@"去领奖"]) {
        RRFReceiveController *desc = [[RRFReceiveController alloc]init];
        desc.title = @"领奖";
        desc.model = model;
        [self.navigationController pushViewController:desc animated:YES];
        desc.isRefre = ^(BOOL isRefre){
            if (isRefre == YES) {
                [weakSelf.tableView.mj_header beginRefreshing];
            }
        };
    }else if ([str isEqualToString:@"去晒单"]){
        RRFRemarkViewController *desc = [[RRFRemarkViewController alloc]init];
        desc.title = @"晒单";
        desc.showOrderType = RRFShowOrderTypeFreeBuy;
        desc.model = model;
        [self.navigationController pushViewController:desc animated:YES];
        desc.isRefre = ^(BOOL isRefre){
            if(isRefre == YES){
                [self.tableView.mj_header beginRefreshing];
            }
        };
    }else if ([str isEqualToString:@"查看晒单"]){
        RRFShareOrderDetailInfoController *desc = [[RRFShareOrderDetailInfoController alloc]init];
        desc.title = @"晒单详情";
        desc.showOrderType =  RRFShowOrderTypeFreeBuy;
        desc.purchaseGameShowId = model.purchaseGameShowId;
        [self.navigationController pushViewController:desc animated:YES];
    }
    else if ([str isEqualToString:@"再次参与"]){
        
        JNQFBComContentPageController *vc = [[JNQFBComContentPageController alloc] init];
        vc.fbPurchaseGameId = model.purchaseGameId;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
