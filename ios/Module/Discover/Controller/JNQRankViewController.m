//
//  JNQRankViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/9/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQRankViewController.h"
#import "JNQAwardListViewController.h"
#import "JNQPersonalHomepageViewController.h"

#import "JNQAwardModel.h"
#import "JNQSelfRankModel.h"

#import "JNQRankView.h"
#import "JNQFailFooterView.h"
#import "JNQOperateSelectView.h"
#import "JNQFreCircleRankCell.h"

#import "JNQHttpTool.h"

#import "MJRefresh.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

static NSString *typeArr[8] = {
    @"prePeriod",     //上期
    @"preWeek",       //上周
    @"preMonth",      //上月
    @"currentPeriod", //本期
    @"currentWeek",   //本周
    @"currentMonth",  //本月
    @"currentYear",   //本年
    @"preYear"        //上年
};



@interface JNQRankViewController () <UITableViewDelegate, UITableViewDataSource> {
    JNQRankHeaderView *_headerView;

    int _identityType;
    BOOL _acctFinish;
    BOOL _dataFinish;
    BOOL _enable;
    NSArray *_tagArray;
    int _pageNo;
}

@property (nonatomic, strong) JNQRankSelectView *selectView;
@property (nonatomic, strong) NSString *typeStr;

@property (nonatomic, strong) UITableView *rankTv;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) JNQRankHeaderView *rankHead;
@property (nonatomic, strong) JNQFailFooterView *failFooterView;

@end

@implementation JNQRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HBColor(245, 245, 245);
    _typeStr = typeArr[_rankType];
    _dataArray = [NSMutableArray array];
    
    [self buildUI];
    [self loadIdentityData];
    [self loadAwardData];
    [self loadAcctData];
    [_rankTv.mj_footer beginRefreshing];
}

- (void)buildUI {
    WEAKSELF
    UIImageView *backImgView = [[UIImageView alloc] init];
    [self.view addSubview:backImgView];
    [backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [backImgView setImage:[UIImage imageNamed:@"ranking_lg"]];
    
    _rankTv = [[UITableView alloc] init];
    [self.view addSubview:_rankTv];
    [_rankTv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).offset(12);
        make.right.mas_equalTo(self.view).offset(-12);
    }];
    _rankTv.backgroundColor = [UIColor clearColor];
    _rankTv.separatorStyle = UITableViewCellSeparatorStyleNone;
    _rankTv.delegate = self;
    _rankTv.dataSource = self;
    
    _rankHead = [[JNQRankHeaderView alloc] init];
    _rankHead.frame = CGRectMake(0, 0, SCREENWidth-24, RankBannerHeight+25);
    _rankHead.rankType = _rankType;
    [_rankHead addTarget:self action:@selector(turnToAwardList) forControlEvents:UIControlEventTouchUpInside];
    [_rankHead.moreBtn addTarget:self action:@selector(turnToAwardList) forControlEvents:UIControlEventTouchUpInside];
    [_rankTv setTableHeaderView:_rankHead];
    
    MJRefreshAutoNormalFooter *tabfooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    tabfooter.triggerAutomaticallyRefreshPercent = 1;
    tabfooter.automaticallyRefresh = YES;
    tabfooter.stateLabel.textColor = HBColor(135, 135, 135);
    _rankTv.mj_footer = tabfooter;
    
    _failFooterView = [[JNQFailFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
    [self.view addSubview:_failFooterView];
    _failFooterView.reloadBlock = ^() {
        [weakSelf loadData];
        [weakSelf loadAcctData];
    };
    _failFooterView.hidden = YES;
}

- (void)turnToAwardList {
    JNQAwardListViewController *awardVC = [[JNQAwardListViewController alloc] init];
    NSArray *titleArray = @[@"上期获奖名单", @"上周获奖名单", @"上月获奖名单", @"本期奖品", @"本周奖品", @"本月奖品", @"年度奖品", @"上年获奖名单"];
    awardVC.navigationItem.title = titleArray[_rankType];
    awardVC.rankType = _rankType;
    [self.navigationController pushViewController:awardVC animated:YES];
}

- (void)loadAcctData {
    _acctFinish = NO;
    [JNQHttpTool JNQHttpRequestWithURL:@"selfProfit" requestType:@"post" showSVProgressHUD:NO parameters:@{@"type" : _typeStr} successBlock:^(id json) {
        JNQSelfRankModel *selfRankModel = [JNQSelfRankModel yy_modelWithJSON:json];
        _acctFinish = YES;
        _failFooterView.hidden = YES;
        [_dataArray insertObject:selfRankModel atIndex:0];
        if (_dataFinish) {
            [_rankTv reloadData];
            [_rankTv.mj_footer endRefreshing];
            _pageNo++;
//            _rankTv.mj_footer.hidden = [json[@"last"] boolValue];
        }
    } failureBlock:^(id json) {
        _failFooterView.hidden = NO;
    }];
}


- (void)loadData {
    _dataFinish = NO;
    NSString *urlStr;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(_pageNo) forKey:@"pageNo"];
    if (_rankViewType == RankViewTypeCurrent) {
        urlStr = @"rakingList";
        [param setObject:_typeStr forKey:@"type"];
    } else {
        urlStr = @"ranking/list/info";
        [param setObject:@(_rankType+1) forKey:@"type"];
    }
    [JNQHttpTool JNQHttpRequestWithURL:urlStr requestType:@"post" showSVProgressHUD:NO parameters:param successBlock:^(id json) {
        NSArray *data = json[@"content"];
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in data) {
            JNQSelfRankModel *model = [JNQSelfRankModel yy_modelWithJSON:dict];
            [array addObject:model];
        }
        [_dataArray addObjectsFromArray:array];
        _dataFinish = YES;
        if (_acctFinish) {
            [_rankTv reloadData];
            [_rankTv.mj_footer endRefreshing];
            _pageNo++;
            _rankTv.mj_footer.hidden = !array.count ? YES : NO;
//            _rankTv.mj_footer.hidden = [json[@"last"] boolValue];
        }
    } failureBlock:^(id json) {
        
    }];
}

- (void)loadIdentityData {
    [JNQHttpTool JNQHttpRequestWithURL:@"identity/info" requestType:@"post" showSVProgressHUD:NO parameters:@{} successBlock:^(id json) {
        _identityType = [json[@"identityValue"] intValue];
    } failureBlock:^(id json) {
    }];
}


- (void)loadAwardData {
    NSString *urlStr;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    urlStr = @"award/list";
    if (_rankType <=3 || _rankType == 7) {
        NSInteger rankType = _rankType == 7 ? 3 : _rankType;
        [param setObject:@(rankType) forKey:@"awardType"];
    } else {
        [param setObject:@(_rankType-3) forKey:@"awardType"];
    }
    [JNQHttpTool JNQHttpRequestWithURL:urlStr requestType:@"post" showSVProgressHUD:NO parameters:param successBlock:^(id json) {
        NSArray *data = json[@"awards"];
        NSDictionary *dict = [data firstObject];
        JNQAwardModel *model = [JNQAwardModel yy_modelWithJSON:dict];
        NSString *picStr = model.presentModel.picUrl;
        [_rankHead.backImgView sd_setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:[UIImage imageNamed:@"prize_default-diagram"]];
    } failureBlock:^(id json) {
        
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
    cell.rankType = FriendRankTypeIncome;
    JNQSelfRankModel *model = _dataArray[indexPath.row];
    BOOL isLast = indexPath.row == _dataArray.count-1 ? YES : NO;
    
    UIImage *img = model.ranking<=3 && indexPath.row ? [UIImage imageNamed:rankImgArr[model.ranking-1]] : nil;
    
    NSString* rankStr = model.ranking >= 1000 ? @"999+" : [NSString stringWithFormat:@"%ld", model.ranking] ;
    NSString *str = model.ranking<=3 && indexPath.row ? @"" : rankStr;
    [cell.rankLabel setTitle:str forState:UIControlStateNormal];
    [cell.rankLabel setImage:img forState:UIControlStateNormal];
    cell.topBackView.hidden = indexPath.row == 0 ? YES : NO;
    cell.botBackView.hidden = isLast;
    cell.selfRankModel = model;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JNQSelfRankModel *model = _dataArray[indexPath.row];
    JNQPersonalHomepageViewController *perHomepageVC = [[JNQPersonalHomepageViewController alloc] init];
    perHomepageVC.title = @"个人投注";
    perHomepageVC.rankingType = typeArr[_rankType];
    perHomepageVC.otherUserId = model.userId;
    [self.navigationController pushViewController:perHomepageVC animated:YES];
}

@end
