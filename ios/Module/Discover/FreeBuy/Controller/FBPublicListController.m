//
//  FBPublicListController.m
//  Puzzle
//
//  Created by huibei on 16/12/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "FBPublicListController.h"
#import "FBPublicListCell.h"
#import "FBPublicListModel.h"
#import "FBTool.h"
#import "FBProductListModel.h"
#import "JNQFBComContentPageController.h"
#import "MJRefresh.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "PZWeakTimer.h"
@interface FBPublicListController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) PZWeakTimer *m_timer;
@property(nonatomic,assign)int pageNo;

@end

@implementation FBPublicListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 0;
    self.dataArray = [NSArray array];
    // Do any additional setup after loading the view.
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 68.0;
    [self.tableView registerClass:[FBPublicListCell class] forCellReuseIdentifier:@"FBPublicListCell"];
    self.tableView.delegate = self ;
    self.tableView.dataSource = self ;
    MJRefreshAutoNormalFooter *tabfooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    tabfooter.triggerAutomaticallyRefreshPercent = 1;
    tabfooter.automaticallyRefresh = YES;
    tabfooter.stateLabel.textColor = HBColor(135, 135, 135);
    self.tableView.mj_footer = tabfooter;
    [tabfooter beginRefreshing];
    [self createTimer];
}

-(void)requestData{
    WEAKSELF
    NSMutableArray* temp = [NSMutableArray arrayWithArray:self.dataArray];
    [FBTool getPurchaseGameOpenListWithPageNo:self.pageNo pageSize:10 ProductId:self.productId Status:@"finish_bid" SuccessBlock:^(id json) {
        FBPublicListModel* list = [FBPublicListModel yy_modelWithJSON:json];
        [temp addObjectsFromArray:list.content];
        weakSelf.dataArray = temp ;
        [weakSelf.tableView.mj_footer endRefreshing];
        if (list.last) {
            [weakSelf.tableView.mj_footer setHidden:YES];
        }
        weakSelf.tableView.emptyDataSetSource = weakSelf ;
        weakSelf.tableView.emptyDataSetDelegate = weakSelf ;
        [weakSelf.tableView reloadData];
        weakSelf.pageNo ++;
    } fail:^(id json) {
    }];
}

- (void)createTimer {
    self.m_timer = [PZWeakTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
}

- (void)timerEvent {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIME_CELL object:nil];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count ;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FBPublicListCell* cell = [[FBPublicListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FBPublicListCell"];
    FBPublicModel * model = self.dataArray[indexPath.row];
    [cell loadData:model indexPath:indexPath];
    return cell ;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    FBPublicListCell *tmpCell = (FBPublicListCell *)cell;
    tmpCell.m_isDisplayed            = YES;
    [tmpCell loadData:self.dataArray[indexPath.row] indexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    FBPublicListCell *tmpCell = (FBPublicListCell *)cell;
    tmpCell.m_isDisplayed = NO;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FBPublicModel * model = self.dataArray[indexPath.row];
    JNQFBComContentPageController *vc = [[JNQFBComContentPageController alloc] init];
    vc.fbPurchaseGameId = model.purchaseGameId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"未查询到揭晓数据";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


@end
