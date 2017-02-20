//
//  JNQFriendRankViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/9/21.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQFriendRankViewController.h"
#import "JNQPersonalHomepageViewController.h"

#import "JNQSelfRankModel.h"

#import "JNQFailFooterView.h"
#import "JNQFriendsCircleView.h"
#import "JNQFreCircleRankCell.h"

#import "JNQHttpTool.h"

#import "MJRefresh.h"

@interface JNQFriendRankViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *_dataArray;
}
@property (nonatomic, assign) int pageNo;
@property (nonatomic, strong) UITableView *rankTv;
@property (nonatomic, strong) JNQFriendsCircleRankHeaderView *headerView;
@property (nonatomic, strong) JNQFailFooterView *failFooterView;

@end

@implementation JNQFriendRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HBColor(245, 245, 245);
    _dataArray = [NSMutableArray array];
    
    [self buildUI];
    [self loadAcctData];
    [self loadData:nil];
    WEAKSELF
    _failFooterView = [[JNQFailFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
    [self.view addSubview:_failFooterView];
    _failFooterView.hidden = YES;
    _failFooterView.reloadBlock = ^() {
        [weakSelf loadData:nil];
        [weakSelf loadAcctData];
    };
}


- (void)buildUI {
    _rankTv = [[UITableView alloc] init];
    [self.view addSubview:_rankTv];
    [_rankTv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _rankTv.backgroundColor = HBColor(245, 245, 245);
    _rankTv.delegate = self;
    _rankTv.dataSource = self;
    _rankTv.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _headerView = [[JNQFriendsCircleRankHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 80)];
    _headerView.rankType = _rankType;
    [_rankTv setTableHeaderView:_headerView];
    
    MJRefreshNormalHeader *incomeheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData:)];
    incomeheader.tag = 10010;
    incomeheader.lastUpdatedTimeLabel.hidden = YES;
    incomeheader.stateLabel.textColor = HBColor(135, 135, 135);
    incomeheader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _rankTv.mj_header = incomeheader;
    
    MJRefreshAutoNormalFooter *incomefooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData:)];
    incomefooter.triggerAutomaticallyRefreshPercent = 1;
    incomefooter.automaticallyHidden = YES;
    incomefooter.automaticallyRefresh = YES;
    incomefooter.stateLabel.textColor = HBColor(135, 135, 135);
    _rankTv.mj_footer = incomefooter;
}

- (void)loadAcctData {
//    [MBProgressHUD show];
    NSString *type = _rankType == FriendRankTypeIncome ? @"bounsXtbAmount" : @"hitAmount";
    [JNQHttpTool JNQHttpRequestWithURL:@"friendSelfProfit" requestType:@"post" showSVProgressHUD:NO parameters:@{@"type" : type} successBlock:^(id json) {
        [MBProgressHUD dismiss];
        _headerView.selfRankModel = [JNQSelfRankModel yy_modelWithJSON:json];
        _headerView.rankType = _rankType;
    } failureBlock:^(id json) {
        
    }];
}

- (void)loadData:(UIView *)sender {
    _pageNo = sender.tag == 10010 ? 0 : _pageNo;
    NSDictionary *params = @{
                             @"size"    : @(10),
                             @"pageNo"  : @(_pageNo)
                             };
    NSString *urlStr = _rankType == FriendRankTypeIncome ? @"friendRakingList" : @"hitRateRankingList";
//    [MBProgressHUD show];
    [JNQHttpTool JNQHttpRequestWithURL:urlStr requestType:@"post" showSVProgressHUD:NO parameters:params successBlock:^(id json) {
        _failFooterView.hidden = YES;
//        [MBProgressHUD dismiss];
        NSArray *data = json[@"content"];
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in data) {
            JNQSelfRankModel *model = [JNQSelfRankModel yy_modelWithJSON:dict];
            [array addObject:model];
        }
        if (_pageNo) {
            [_dataArray addObjectsFromArray:array];
        } else {
            _dataArray = array;
        }
        [_rankTv reloadData];
        _pageNo++;
        [_rankTv.mj_footer endRefreshing];
        [_rankTv.mj_header endRefreshing];
        _rankTv.mj_footer.hidden = !array.count ? YES : NO;
    } failureBlock:^(id json) {
//        [MBProgressHUD dismiss];
        [_rankTv.mj_footer endRefreshing];
        [_rankTv.mj_header endRefreshing];
        _failFooterView.hidden = NO;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JNQFreCircleRankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JNQFreCircleRankCell"];
    if (!cell) {
        cell = [[JNQFreCircleRankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JNQFreCircleRankCell"];
    }
    JNQSelfRankModel *model = _dataArray[indexPath.row];
    cell.topBackView.hidden = YES;
    cell.botBackView.hidden = YES;
    cell.rankType = _rankType;
    cell.selfRankModel = model;
    UIImage *img = indexPath.row < 3 ? [UIImage imageNamed:rankImgArr[indexPath.row]] : nil;
    NSString *str = indexPath.row < 3 ? @"" : [NSString stringWithFormat:@"%ld", indexPath.row+1];
    [cell.rankLabel setImage:img forState:UIControlStateNormal];
    [cell.rankLabel setTitle:str forState:UIControlStateNormal];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JNQSelfRankModel *model = _dataArray[indexPath.row];
    if (model.userId == 0) return;
    JNQPersonalHomepageViewController *perHomepageVC = [[JNQPersonalHomepageViewController alloc] init];
    perHomepageVC.title = @"个人投注";
    perHomepageVC.rankingType = @"currentWeek";
    perHomepageVC.otherUserId = model.userId;
    [self.navigationController pushViewController:perHomepageVC animated:YES];
}



@end
