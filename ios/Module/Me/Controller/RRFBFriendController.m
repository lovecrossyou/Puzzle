//
//  RRFBFriendController.m
//  Puzzle
//
//  Created by huibei on 16/11/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFBFriendController.h"
#import "RRFMyFriendCell.h"
#import "MJRefresh.h"
#import "JNQHttpTool.h"
#import "JNQFailFooterView.h"
#import "RRFDetailInfoController.h"
@interface RRFBFriendController ()<UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *_dataArray;
    int _pageNo;
}

@property (nonatomic, strong) JNQFailFooterView *failFooterView;
@property (nonatomic, strong) InviteBonusesModel* inviteBonuses;

@end

@implementation RRFBFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    self.tableView.backgroundColor = HBColor(245, 245, 245);
    _dataArray = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 120.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    MJRefreshAutoNormalFooter *tabfooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData:)];
    tabfooter.triggerAutomaticallyRefreshPercent = 1;
    tabfooter.automaticallyRefresh = YES;
    tabfooter.stateLabel.textColor = HBColor(135, 135, 135);
    self.tableView.mj_footer = tabfooter;
    
    _failFooterView = [[JNQFailFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
    [self.view addSubview:_failFooterView];
    _failFooterView.reloadBlock = ^() {
        [weakSelf loadData:nil];
    };
    _failFooterView.hidden = YES;
    [self.tableView.mj_footer beginRefreshing];
}

- (void)setNav {
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    navTitle.font = PZFont(11);
    navTitle.textColor = [UIColor whiteColor];
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.numberOfLines = 2;
    NSString *titleStr = _viewType == BFriendViewTypeSelf ? @"二级朋友" : self.model.model.acceptUserName;
    NSInteger count = _viewType == BFriendViewTypeSelf ? _inviteBonuses.twoLevelPersonAmount : self.model.model.acceptUserInviteAmout;
    navTitle.text = [NSString stringWithFormat:@"%@ (%ld)", titleStr, count];
    NSMutableAttributedString *navTitleString = [[NSMutableAttributedString alloc] initWithString:navTitle.text];
    [navTitleString addAttribute:NSFontAttributeName value:PZFont(17) range:[navTitle.text rangeOfString:titleStr]];
    navTitle.attributedText = navTitleString;
    self.navigationItem.titleView = navTitle;
}

- (void)buildHeaderView {
    if (_dataArray.count) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 18)];
        headerView.backgroundColor = HBColor(245, 245, 245);
        [self.tableView setTableHeaderView:headerView];
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
        atten.text = _viewType == BFriendViewTypeSelf ? @"您还没有二级朋友" : @"该用户还没有邀请好友";
        [self.tableView setTableHeaderView:headerView];
    }
}


-(void)loadData:(UIView *)sender {
    NSString *url;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"size" : @(10), @"pageNo" : @(_pageNo)}];
    if (_viewType == BFriendViewTypeSelf) {
        url = @"inviteSelfTwoPersonList";
    } else {
        url = @"inviteTwoPersonList";
        [param setObject:@(self.model.model.acceptUserId) forKey:@"otherUserId"];
    }
    [JNQHttpTool JNQHttpRequestWithURL:url requestType:@"post" showSVProgressHUD:NO parameters:param successBlock:^(id json) {
        _failFooterView.hidden = YES;
        _inviteBonuses = [InviteBonusesModel yy_modelWithJSON:json];
        NSArray *array = json[@"content"];
        for (NSDictionary *dict in array) {
            InviteBaseModel *m = [InviteBaseModel yy_modelWithJSON:dict];
            [_dataArray addObject:m];
        }

        if (!_pageNo) {
            [self setNav];
            [self buildHeaderView];
        }
        [self.tableView reloadData];
        _pageNo++;
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer.hidden = [json[@"last"] boolValue];
        [self.tableView.mj_footer endRefreshing];
    } failureBlock:^(id json) {
        _failFooterView.hidden = NO;
    }];

}

- (void)inviteBet:(NSInteger)otherUserId {
    [MBProgressHUD show];
    [JNQHttpTool JNQHttpRequestWithURL:@"warnOtherGuess" requestType:@"post" showSVProgressHUD:NO parameters:@{@"otherUserId" : @(otherUserId)} successBlock:^(id json) {
        [MBProgressHUD dismiss];
        [MBProgressHUD showInfoWithStatus:@"提醒成功"];
    } failureBlock:^(id json) {
        [MBProgressHUD dismiss];
        [MBProgressHUD showInfoWithStatus:@"提醒失败，请再试一次"];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF
    RRFMyFriendCell *cell = [[RRFMyFriendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RRFMyFriendController"];
    InviteBaseModel *baseM = _dataArray[indexPath.row];
    cell.baseModel = baseM;
    cell.isTop = !indexPath.row ? YES : NO;
    cell.isBot = indexPath.row == _dataArray.count-1 ? YES : NO;
    cell.clickBlock = ^() {
        [self inviteBet:baseM.acceptUserId];
    };
    cell.headerBlock = ^(){
        RRFDetailInfoController *desc = [[RRFDetailInfoController alloc]init];
        desc.title = @"详细资料";
        desc.userId = baseM.acceptUserId;
        desc.verityInfo = NO;
        desc.detailInfoComeInType =  RRFDetailInfoComeInTypeOther;
        [weakSelf.navigationController pushViewController:desc animated:YES];
    };
    return cell;
}

@end
