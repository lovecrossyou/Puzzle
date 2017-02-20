//
//  FBShareOrderController.m
//  Puzzle
//
//  Created by huibei on 16/12/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "FBShareOrderController.h"
#import "FBShareOrderCell.h"
#import "FBSharePanel.h"
#import <LGAlertView/LGAlertView.h>
#import "FBTool.h"
#import "FBShareOrderListModel.h"
#import "HBLoadingView.h"
#import "MJRefresh.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "RRFDetailInfoController.h"
#import "PZParamTool.h"
#import "RRFShareOrderDetailInfoController.h"

@interface FBShareOrderController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property(strong,nonatomic) NSArray* dataList;
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,assign)int pageNo;

@end

@implementation FBShareOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 0 ;
    self.dataList = [NSArray array];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 68.0;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[FBShareOrderCell class] forCellReuseIdentifier:@"FBShareOrderCell"];
    tableView.delegate = self ;
    tableView.dataSource = self ;
    tableView.frame = CGRectMake(0, 0, SCREENWidth, SCREENHeight-64);
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    MJRefreshAutoNormalFooter *tabfooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    tabfooter.triggerAutomaticallyRefreshPercent = 1;
    tabfooter.automaticallyRefresh = YES;
    tabfooter.stateLabel.textColor = HBColor(135, 135, 135);
    self.tableView.mj_footer = tabfooter;
    [tabfooter beginRefreshing];
}
-(void)requestData
{
    NSMutableArray* temp = [NSMutableArray arrayWithArray:self.dataList];
    WEAKSELF
    [FBTool getShareOrderListWithPageNo:self.pageNo pageSize:10 PurchaseGameId:0 Stage:@"" ProductId:self.productId isAll:@"yes" SuccessBlock:^(id json) {
        FBShareOrderListModel* listM = [FBShareOrderListModel yy_modelWithJSON:json];
        [temp addObjectsFromArray:listM.content];
        weakSelf.dataList = temp ;
        [weakSelf.tableView.mj_footer endRefreshing];
        if (listM.last) {
            [weakSelf.tableView.mj_footer setHidden:YES];
        }
        weakSelf.pageNo++;
        weakSelf.tableView.emptyDataSetSource = self ;
        weakSelf.tableView.emptyDataSetDelegate = self ;
        [weakSelf.tableView reloadData];
    } fail:^(id json) {
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count>0?1:0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF
    FBShareOrderModel* model = self.dataList[indexPath.section];
    FBShareOrderCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FBShareOrderCell"];
    cell.model = model;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.goInfoBlock = ^(){
        if (![PZParamTool hasLogin]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin" object:nil];
            return;
        }
        RRFDetailInfoController *desc = [[RRFDetailInfoController alloc]init];
        desc.title = @"详细资料";
        desc.userId = model.userId;
        desc.verityInfo = NO;
        desc.detailInfoComeInType =  RRFDetailInfoComeInTypeOther;
        [weakSelf.navigationController pushViewController:desc animated:YES];
    };
    return cell ;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FBShareOrderModel* model = self.dataList[indexPath.section];
    RRFShareOrderDetailInfoController *desc = [[RRFShareOrderDetailInfoController alloc]init];
    desc.showOrderType = RRFShowOrderTypeFreeBuy;
    desc.purchaseGameShowId = model.ID;
    desc.title = @"晒单详情";
    [self.navigationController pushViewController:desc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"抢占沙发，成为第一个晒单？";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
@end
