//
//  JNQPersonalHomepageViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/9/13.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQPersonalHomepageViewController.h"
#import "JNQPageViewController.h"
#import "RRFDetailInfoController.h"
#import "JNQVIPUpdateViewController.h"
#import "RRFPersonalAskBarController.h"

#import "JNQSelfRankModel.h"

#import "HBLoadingView.h"
#import "JNQPersonHomepageView.h"
#import "JNQPerHomepageCell.h"

#import "JNQHttpTool.h"

#import "MJRefresh.h"

static NSString *vipArr[3] = {
    @"黄金会员",
    @"珀金会员",
    @"钻石会员"
};

@interface JNQPersonalHomepageViewController () {
    JNQPersonHomepageHeaderView *_headerView;
    NSMutableArray *_dataArray;
    int _pageNo;
    int _identityValue;
    NSString *_identityName;
    int _identityType;
}

@end

@implementation JNQPersonalHomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = HBColor(245, 245, 245);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dataArray = [NSMutableArray array];
    [self buildUI];
    [self loadPersonalData];
    [self loadIdentityData];
    [HBLoadingView showCircleView:self.tableView];
}


- (void)buildUI {
    self.tableView.tableHeaderView = [[UIView alloc] init];
    _headerView = [[JNQPersonHomepageHeaderView alloc] init];
    _headerView.backgroundColor = [UIColor whiteColor];
    [[_headerView.allInfoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        _headerView.allInfoBtn.selected = !_headerView.allInfoBtn.selected;
        if (_headerView.allInfoBtn.selected) {
            _headerView.infoLabel.numberOfLines = 0;
            [self updateUserInfo:_headerView.selfRankModel.userIntroduce numberOfLines:0];
        } else {
            _headerView.infoLabel.numberOfLines = 2;
            [self updateUserInfo:_headerView.selfRankModel.userIntroduce numberOfLines:2];
        }
    }];
    [[_headerView.headImgBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        RRFDetailInfoController *desc = [[RRFDetailInfoController alloc]init];
        desc.userId = self.otherUserId;
        desc.title = @"详细资料";
        desc.detailInfoComeInType = RRFDetailInfoComeInTypeBet;
        [self.navigationController pushViewController:desc animated:YES];
    }];
    [[_headerView.rankInput rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        BOOL haveRank = [[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2] isKindOfClass:[JNQPageViewController class]] ? YES : NO;
        if (haveRank) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2] animated:YES];
        } else {
            JNQPageViewController *pageVC = [[JNQPageViewController alloc] init];
            pageVC.rankViewType = RankViewTypeCurrent;
            pageVC.title = @"股神争霸";
            [self.navigationController pushViewController:pageVC animated:YES];
        }
    }];
    
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData:)];
    header.tag = 10010;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.textColor = HBColor(135, 135, 135);
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData:)];
    footer.triggerAutomaticallyRefreshPercent = 1;
    footer.automaticallyHidden = YES;
    footer.automaticallyRefresh = YES;
    footer.stateLabel.textColor = HBColor(135, 135, 135);
    self.tableView.mj_footer = footer;
}

- (void)loadData:(UIView *)sender {
    _pageNo = sender.tag == 10010 ? 0 : _pageNo;
    NSDictionary *param = @{
                            @"size"         : @(5),
                            @"pageNo"       : @(_pageNo),
                            @"otherUserId"  : @(_otherUserId),
                            @"identityType" : @(_identityType),
                            @"rankingType"  : _rankingType
                            };
    BOOL showSVP = _pageNo ? NO : YES;
    [JNQHttpTool JNQHttpRequestWithURL:@"peekGuessStockList" requestType:@"post" showSVProgressHUD:showSVP parameters:param successBlock:^(id json) {
        NSArray *data = json[@"content"];
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in data) {
            JNQFriendCircleModel *circleModel = [JNQFriendCircleModel yy_modelWithJSON:dict];
            [array addObject:circleModel];
        }
        if (_pageNo) {
            [_dataArray addObjectsFromArray:array];
            [self.tableView.mj_footer endRefreshing];
        } else {
            _dataArray = array;
            [self.tableView.mj_header endRefreshing];
        }
        [self.tableView reloadData];
        _pageNo++;
        self.tableView.mj_footer.hidden = [json[@"last"] boolValue];
    } failureBlock:^(id json) {
        
    }];
}

- (void)loadPersonalData {
    NSDictionary *param = @{
                            @"rankType"   : _rankingType,
                            @"otherUserId": @(_otherUserId)
                            };
    [JNQHttpTool JNQHttpRequestWithURL:@"otherProfit" requestType:@"post" showSVProgressHUD:NO parameters:param successBlock:^(id json) {
        JNQSelfRankModel *model = [JNQSelfRankModel yy_modelWithJSON:json];
        _headerView.selfRankModel = model;
        [self updateUserInfo:model.userIntroduce numberOfLines:2];
        [HBLoadingView hide];
    } failureBlock:^(id json) {
        [HBLoadingView hide];
    }];
}

- (void)loadIdentityData {
    [JNQHttpTool JNQHttpRequestWithURL:@"identity/info" requestType:@"post" showSVProgressHUD:NO parameters:@{} successBlock:^(id json) {
        _identityType = [json[@"identityValue"] intValue];
        [self.tableView.mj_header beginRefreshing];
    } failureBlock:^(id json) {
    }];
}

- (void)updateUserInfo:(NSString *)userInfo numberOfLines:(NSInteger)lines {
    if ([userInfo isEqualToString:@""] || !userInfo) {
        _headerView.frame = CGRectMake(0, 0, SCREENWidth, 275);
        [_headerView.infoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [_headerView.allInfoBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0); 
        }];
        [_headerView.rankView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headerView.allInfoBtn.mas_bottom).mas_offset(-5);
        }];
    } else {
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGRect rect = [userInfo boundingRectWithSize:CGSizeMake(SCREENWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
        NSInteger height = CGRectGetHeight(rect)+5 >= 36 ? 36 : CGRectGetHeight(rect)+5;
        if (!lines) {
            height = CGRectGetHeight(rect)+5;
        }
        [_headerView.infoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
        _headerView.allInfoBtn.hidden = CGRectGetHeight(rect)+5 >= 36 ? NO : YES;
        _headerView.frame = CGRectMake(0, 0, SCREENWidth, 295+height);
    }
    [self.tableView setTableHeaderView:_headerView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 142;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF
    JNQPerHomepageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JNQPerHomepageCell"];
    if (!cell) {
        cell = [[JNQPerHomepageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JNQPerHomepageCell"];
    }
    cell.circleModel = _dataArray[indexPath.row];
    cell.btnBlock = ^(UIButton *button) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您现在还不是会员，升级会员立即查看！" message:@"" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        }];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"立即升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            JNQVIPUpdateViewController *vipUpdateVC = [[JNQVIPUpdateViewController alloc] init];
            vipUpdateVC.navigationItem.title = @"升级会员";
            [weakSelf.navigationController pushViewController:vipUpdateVC animated:YES];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:deleteAction];
        [weakSelf presentViewController:alertController animated:YES completion:^{
        }];

    };
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
