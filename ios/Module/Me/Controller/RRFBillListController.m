//
//  RRFBillListController.m
//  Puzzle
//
//  Created by huibei on 16/8/24.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFBillListController.h"
#import "RRFBillListCell.h"
#import "RRFBillListView.h"
#import "RRFMeTool.h"
#import "MJRefresh.h"
#import "RRFBillListSectionModel.h"
#import "RRFBillCellModel.h"
#import "LoginModel.h"
#import "JNQFailFooterView.h"
#import "HBLoadingView.h"

@interface RRFBillListController ()<UITableViewDelegate,UITableViewDataSource>
{
    RRFBillListView *_headerView;
    NSMutableArray *_xtAllData;

}
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)JNQFailFooterView *failFootView;
@end

@implementation RRFBillListController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    if (self.failFootView == nil) {
        self.failFootView = [[JNQFailFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
        self.failFootView.reloadBlock = ^(){
            [weakSelf.tableView.mj_header beginRefreshing];
        };
    }
    [self settingHeaderView];
    [self.tableView.mj_header beginRefreshing];
}
-(void)requestBillList:(UIView *)sender
{
    WEAKSELF
    if ([sender isKindOfClass:[MJRefreshHeader class]]) {
        _xtAllData = nil;
    }
    [RRFMeTool requestBillListWithType:1 Success:^(id json) {
        NSArray *dataArray = [json objectForKey:@"monthBills"];
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        if (dataArray.count > 0) {
            for (NSDictionary *dic in dataArray) {
                RRFBillListSectionModel *model = [RRFBillListSectionModel yy_modelWithJSON:dic];
                [temp addObject:model];
            }
            if (temp.count == 0) {
                [weakSelf settingNoDataView];
            }else{
                [weakSelf.tableView setTableFooterView:[UIView new]];
            }
            _xtAllData = temp;
           
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } failBlock:^(id json) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView setTableFooterView:weakSelf.failFootView];
    }];
    
}
- (void)settingHeaderView {
    _headerView = [[RRFBillListView alloc]init];
    _headerView.userM = self.userM;
    [self.view addSubview:_headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc]init];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(_headerView.mas_bottom).offset(0);
    }];
    MJRefreshNormalHeader *tabheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestBillList:)];
    tabheader.lastUpdatedTimeLabel.hidden = YES;
    tabheader.stateLabel.textColor = HBColor(135, 135, 135);
    tabheader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.tableView.mj_header = tabheader;

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _xtAllData.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    RRFBillListSectionModel *secM = _xtAllData[section];
    return secM.dayBills.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RRFBillListSectionModel *secM = _xtAllData[indexPath.section];
    RRFBillCellModel *model = secM.dayBills[indexPath.row];
    RRFBillListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRFBillListController"];
    if (cell == nil) {
        cell = [[RRFBillListCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RRFBillListController"];
    }
    cell.model = model;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RRFBillListSectionModel *secM = _xtAllData[section];
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = [NSString stringWithFormat:@"%ld月",secM.monthTime];
    titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    titleLabel.font = [UIFont systemFontOfSize:13];
    [headView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(headView.mas_centerY);
    }];
    
    UIButton *subTitleLabel = [[UIButton alloc]init];
    NSString *subTitleStr = [NSString stringWithFormat:@"%ld",secM.totalAmount];
    [subTitleLabel setImage:[UIImage imageNamed:@"icon_maddle_red"] forState:UIControlStateNormal];
    [subTitleLabel setTitle:subTitleStr forState:UIControlStateNormal];
    [subTitleLabel setTitleColor:StockRed forState:UIControlStateNormal];
    subTitleLabel.titleLabel.font = [UIFont systemFontOfSize:13];
    [headView addSubview:subTitleLabel];
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(headView.mas_centerY);
    }];
    return  headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
-(void)settingNoDataView
{
    NSString *titleStr = @"您还没有消费记录!";
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64-60)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 50, SCREENWidth-30, 40)];
    titleLabel.text = titleStr;
    titleLabel.numberOfLines=2;
    titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:titleLabel];
    self.tableView.tableFooterView = footerView;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
@end
