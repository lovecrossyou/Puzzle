//
//  JNQFriendGuessViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/9/21.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQFriendGuessViewController.h"
#import "JNQFriendCircleModel.h"
#import "JNQFriendsCircleCell.h"
#import "InviteFriendController.h"
#import "JNQHttpTool.h"
#import "MJRefresh.h"
#import "JNQFailFooterView.h"

@interface JNQFriendGuessViewController () {
    int _pageNo;
    NSMutableArray *_dataArray;
}


@property (nonatomic, strong) JNQFailFooterView *failFooterView;
@end

@implementation JNQFriendGuessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = HBColor(245, 245, 245);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    WEAKSELF
    _failFooterView = [[JNQFailFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
    _failFooterView.reloadBlock = ^() {
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    
    _dataArray = [NSMutableArray array];
    [self buildUI];
//    [self loadFriendCircleData:nil];
}

- (void)buildUI {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFriendCircleData:)];
    header.tag = 10010;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.textColor = HBColor(135, 135, 135);
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFriendCircleData:)];
    footer.triggerAutomaticallyRefreshPercent = 1;
    footer.automaticallyHidden = YES;
    footer.automaticallyRefresh = YES;
    footer.stateLabel.textColor = HBColor(135, 135, 135);
    self.tableView.mj_footer = footer;
}

- (void)refreshTableviewState {
    if (_dataArray.count) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 20)];
        view.backgroundColor = HBColor(245, 245, 245);
        [self.tableView setTableHeaderView:view];
    } else {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
        
        UILabel *atten = [[UILabel alloc] init];
        [headerView addSubview:atten];
        [atten mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(headerView);
            make.centerY.mas_equalTo(headerView).offset(-40);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth-24, 50));
        }];
        atten.font = PZFont(14);
        atten.textColor = HBColor(153, 153, 153);
        atten.textAlignment = NSTextAlignmentCenter;
        atten.numberOfLines = 0;
        atten.text = @"邀请好友更多互动！";
        
        UIButton *button = [[UIButton alloc] init];
        [headerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(atten.mas_bottom).offset(8);
            make.centerX.mas_equalTo(headerView);
            make.height.mas_equalTo(30);
        }];
        button.backgroundColor = BasicBlueColor;
        [button setTitle:@"  立即邀请  " forState:UIControlStateNormal];
        button.titleLabel.font = PZFont(15);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            InviteFriendController* invite = [[InviteFriendController alloc]init];
            invite.title = @"邀请朋友" ;
            [self.navigationController pushViewController:invite animated:YES];
        }];

        
        [self.tableView setTableHeaderView:headerView];
    }
}

- (void)loadFriendCircleData:(UIView *)sender {
    if (sender.tag == 10010) {
        _pageNo = 0;
    }
    NSDictionary *params = @{
                             @"size"    : @(5),
                             @"pageNo"  : @(_pageNo),
                             @"sortProperties"  : @[@"time"],
                             @"direction"  : @"DESC"
                             };
    [JNQHttpTool JNQHttpRequestWithURL:@"getFriendWithStockList" requestType:@"post" showSVProgressHUD:NO parameters:params successBlock:^(id json) {
        NSArray *data = json[@"content"];
        [self.tableView setTableFooterView:nil];
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in data) {
            JNQFriendCircleModel *model = [JNQFriendCircleModel yy_modelWithJSON:dict];
            [array addObject:model];
        }
        if (_pageNo) {
            [_dataArray addObjectsFromArray:array];
            [self.tableView.mj_footer endRefreshing];
        } else {
            _dataArray = array;
            [self.tableView.mj_header endRefreshing];
        }
        [self.tableView reloadData];
        [self refreshTableviewState];
        BOOL last = [json[@"last"] boolValue];
        if (last) {
            self.tableView.mj_footer.hidden = YES;
        }
        _pageNo++;
    } failureBlock:^(id json) {
        if (!_pageNo) {
            [self.tableView setTableHeaderView:nil];
            [self.tableView.mj_header endRefreshing];
            [self.tableView setTableFooterView:_failFooterView];
        }
    }];
}

- (void)savePraiseOperation:(JNQFriendsCircleCell *)cell indexPath:(NSIndexPath *)indexPath {
    [JNQHttpTool JNQHttpRequestWithURL:@"addGuessPraise" requestType:@"post" showSVProgressHUD:NO parameters:@{@"guessWithStockId" : @(cell.friendCircleModel.guessWithStockId)} successBlock:^(id json) {
        cell.praiseBtn.userInteractionEnabled = YES;
        if ([cell.friendCircleModel.isPraise isEqualToString:@"noPraise"]) {
            cell.friendCircleModel.praiseAmount = cell.friendCircleModel.praiseAmount+1;
            cell.friendCircleModel.isPraise = @"alreadyPraise";
        } else {
            cell.friendCircleModel.praiseAmount = cell.friendCircleModel.praiseAmount-1;
            cell.friendCircleModel.isPraise = @"noPraise";
        }
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]  withRowAnimation:UITableViewRowAnimationNone];
    } failureBlock:^(id json) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 114;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        JNQFriendsCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JNQFriendsCircleCell"];
        if (!cell) {
            cell = [[JNQFriendsCircleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JNQFriendsCircleCell"];
        }
        JNQFriendCircleModel *friendCircleModel = _dataArray[indexPath.row];
        cell.friendCircleModel = friendCircleModel;
        cell.cellBlock = ^(JNQFriendsCircleCell *cell) {
            [self savePraiseOperation:cell indexPath:indexPath];
        };
        return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

@end
