//
//  RRFMyFriendController.m
//  Puzzle
//
//  Created by huibei on 16/11/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFMyFriendController.h"
#import "RRFMyFriendCell.h"
#import "RRFMyFriendHeadView.h"
#import "RRFBFriendController.h"
#import "InviteFriendController.h"
#import "MJRefresh.h"
#import "JNQHttpTool.h"
#import "InviteBonusesModel.h"
#import "JNQFailFooterView.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "RRFDetailInfoController.h"
@interface RRFMyFriendController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate> {
    int _pageNo;
}
@property(nonatomic,strong)NSMutableArray *allData;
@property (nonatomic, strong) JNQFailFooterView *failFooterView;
@property (nonatomic, strong) InviteBonusesModel* inviteBonuses;

@end

@implementation RRFMyFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    self.allData = [[NSMutableArray alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.estimatedRowHeight = 120.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    MJRefreshNormalHeader *tabheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMyFriendData:)];
    tabheader.tag = 10010;
    tabheader.lastUpdatedTimeLabel.hidden = YES;
    tabheader.stateLabel.textColor = HBColor(135, 135, 135);
    tabheader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.tableView.mj_header = tabheader;
    
    MJRefreshAutoNormalFooter *tabfooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMyFriendData:)];
    tabfooter.triggerAutomaticallyRefreshPercent = 1;
    tabfooter.automaticallyRefresh = YES;
    tabfooter.stateLabel.textColor = HBColor(135, 135, 135);
    self.tableView.mj_footer = tabfooter;
    
    [self setNav];
    
//    _failFooterView = [[JNQFailFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
//    [self.view addSubview:_failFooterView];
//    _failFooterView.reloadBlock = ^() {
//        [weakSelf.tableView.mj_header beginRefreshing];
//    };
//    _failFooterView.hidden = YES;
    
    [self.tableView.mj_footer beginRefreshing];
}

-(void)setNav {
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    navTitle.font = PZFont(11);
    navTitle.textColor = [UIColor whiteColor];
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.numberOfLines = 2;
    navTitle.text = [NSString stringWithFormat:@"邀请的朋友 (%d)", _inviteBonuses.selfInviteAmount];
    NSMutableAttributedString *navTitleString = [[NSMutableAttributedString alloc] initWithString:navTitle.text];
    [navTitleString addAttribute:NSFontAttributeName value:PZFont(17) range:[navTitle.text rangeOfString:@"邀请的朋友"]];
    navTitle.attributedText = navTitleString;
    self.navigationItem.titleView = navTitle;
    
    UIButton *right = [[UIButton alloc]init];
    right.titleLabel.textAlignment = NSTextAlignmentRight;
    [right setTitle:@"+邀请" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize:14];
    [right addTarget:self action:@selector(pushController) forControlEvents:UIControlEventTouchUpInside];
    right.frame = CGRectMake(0, 0, 44, 44);
    right.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = item;
}


#pragma mark - 二级邀请
-(UIView*)createHeader{
    if (_allData.count) {
        RRFMyFriendHeadView *headView = [[RRFMyFriendHeadView alloc]initWithTitle:@"二级朋友" isShowDesc:YES];
        headView.frame = CGRectMake(0, 0, SCREENWidth, 120);
        self.tableView.tableHeaderView = headView;
        [[headView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            RRFBFriendController *bVC = [[RRFBFriendController alloc] init];
            bVC.viewType = BFriendViewTypeSelf;
            [self.navigationController pushViewController:bVC animated:YES];
        }];
        return headView ;
    }
    return nil ;
}

- (void)loadMyFriendData:(UIView *)sender {
    WEAKSELF
    _pageNo = sender.tag == 10010 ? 0 : _pageNo;
    NSMutableArray* tempData ;
    if (_pageNo == 0) {
        tempData = [NSMutableArray array];
    }
    else{
        tempData = [NSMutableArray arrayWithArray:_allData];
    }
    NSDictionary *param = @{
                            @"size" : @(20),
                            @"pageNo" : @(_pageNo)
                            };
    [JNQHttpTool JNQHttpRequestWithURL:@"inviteBonuses" requestType:@"post" showSVProgressHUD:NO parameters:param successBlock:^(id json) {
        _inviteBonuses = [InviteBonusesModel yy_modelWithJSON:json];
        [tempData addObjectsFromArray:_inviteBonuses.content];
        _allData = tempData ;
        if (!_pageNo) {
            [weakSelf setNav];
            [weakSelf createHeader];
        }
        weakSelf.tableView.emptyDataSetSource = weakSelf;
        weakSelf.tableView.emptyDataSetDelegate = weakSelf;

        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView reloadData];
        _pageNo++;
        BOOL isLast = [json[@"last"] boolValue];
        weakSelf.tableView.mj_footer.hidden = isLast;
    } failureBlock:^(id json) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"想要更多奖励？快点击右上角邀请好友吧！";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
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

-(void)pushController {
    InviteFriendController* invite = [[InviteFriendController alloc]init];
    invite.title = @"邀请朋友" ;
    [self.navigationController pushViewController:invite animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _allData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF
    RRFMyFriendCell *cell = [[RRFMyFriendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RRFMyFriendController"];
    InviteBonuses *model = _allData[indexPath.row];
    cell.model = model;
    cell.isTop = !indexPath.row ? YES : NO;
    cell.isBot = indexPath.row == _allData.count-1 ? YES : NO;
    cell.clickBlock = ^() {
        [self inviteBet:model.model.acceptUserId];
    };
    cell.headerBlock = ^(){
        RRFDetailInfoController *desc = [[RRFDetailInfoController alloc]init];
        desc.title = @"详细资料";
        desc.userId = model.model.acceptUserId;
        desc.verityInfo = NO;
        desc.detailInfoComeInType =  RRFDetailInfoComeInTypeOther;
        [weakSelf.navigationController pushViewController:desc animated:YES];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RRFBFriendController *desc = [[RRFBFriendController alloc]init];
    desc.viewType = BFriendViewTypeOther;
    desc.model = _allData[indexPath.row];
    [self.navigationController pushViewController:desc animated:YES];
}
@end
