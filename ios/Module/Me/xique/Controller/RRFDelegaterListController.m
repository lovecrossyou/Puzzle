//
//  RRFDelegaterListController.m
//  Puzzle
//
//  Created by huibei on 16/9/27.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFDelegaterListController.h"
#import "RRFDelegaterListCell.h"
#import "RRFPlanTool.h"
#import "RRFDelegaterView.h"
#import "RRFMyDelegateDetailInfoModel.h"
#import "RRFDelegateListModel.h"
#import "MJRefresh.h"
#import "RRFNextDelegateListController.h"
#import "RRFRecruitController.h"
#import "RRFDelegaterListFootView.h"
#import "JNQFailFooterView.h"
#import "InviteFriendController.h"
#import "HBLoadingView.h"

@interface RRFDelegaterListController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)RRFDelegaterView *headView;
@property(nonatomic,strong)NSMutableArray *delegateList;
@property(nonatomic,strong)NSMutableArray *userList;
@property(nonatomic,assign)int pageNo;
@property(nonatomic,assign)DelegaterListSwitchType switchType;
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)RRFDelegaterListFootView *footView;
@property(nonatomic,strong)JNQFailFooterView *failFootView;

@end

@implementation RRFDelegaterListController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    self.pageNo = 0;
    self.switchType = DelegaterListSwitchTypeA;
    if (self.delegateList == nil) {
        self.delegateList = [[NSMutableArray alloc]init];
    }
    if (self.userList == nil) {
        self.userList = [[NSMutableArray alloc]init];
    }
    if (self.failFootView == nil) {
        self.failFootView = [[JNQFailFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
        self.failFootView.reloadBlock = ^(){
            [weakSelf.tableView.mj_header beginRefreshing];
        };
    }
    
    [self getMyUserInfo];
    [self setNavItem];
}
-(void)setNavItem
{
    NSString *rightStr = @"邀请";
    if (self.viewType == DelegaterListControllerViewTypeDelegate) {
        rightStr = @"+招募";
    }
    UIButton *right = [[UIButton alloc]init];
    right.titleLabel.textAlignment = NSTextAlignmentRight;
    [right setTitle:rightStr forState:UIControlStateNormal];
    [right setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize:16];
    [right addTarget:self action:@selector(pushController) forControlEvents:UIControlEventTouchUpInside];
    right.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = item;
}
-(void)pushController
{
    if(self.viewType == DelegaterListControllerViewTypeUser){
        InviteFriendController* invite = [[InviteFriendController alloc]init];
        invite.title = @"邀请朋友" ;
        [self.navigationController pushViewController:invite animated:YES];
    }else{
        RRFRecruitController* test = [[RRFRecruitController alloc]init];
        test.title = @"招募喜鹊";
        [self.navigationController pushViewController:test animated:YES];
    }
    
}
-(void)getMyUserInfo
{
    NSString *url = self.viewType == DelegaterListControllerViewTypeUser?@"delegater/MyUserInfo":@"delegater/MyDelegaterInfo";
    [RRFPlanTool requestDelegaterMyDelegaterInfoWithUrl:url Success:^(id json) {
        RRFMyDelegateDetailInfoModel *model = [RRFMyDelegateDetailInfoModel yy_modelWithJSON:json];
        [self settingHeadViewWithModel:model];
    } failBlock:^(id json) {
        
    }];
}
-(void)settingHeadViewWithModel:(RRFMyDelegateDetailInfoModel *)model{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView = tableView;
    tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bettingrecord_bg"]];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 120.0f;
    tableView.rowHeight = UITableViewAutomaticDimension;
    [tableView registerClass:[RRFDelegaterListCell class] forCellReuseIdentifier:@"RRFDelegaterListController"];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(49);
        make.bottom.mas_equalTo(-49);

    }];
    
    MJRefreshNormalHeader *tabheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestDtataList:)];
    tabheader.lastUpdatedTimeLabel.hidden = YES;
    tabheader.stateLabel.textColor = HBColor(135, 135, 135);
    tabheader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.tableView.mj_header = tabheader;
    
    MJRefreshAutoNormalFooter *tabfooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestDtataList:)];
    tabfooter.triggerAutomaticallyRefreshPercent = 1;
    tabfooter.automaticallyRefresh = YES;
    tabfooter.stateLabel.textColor = HBColor(135, 135, 135);
    self.tableView.mj_footer = tabfooter;

    
    RRFDelegaterView *headView = [[RRFDelegaterView alloc]initWithModel:model ViewType:self.viewType];
    self.headView = headView;
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(49);
    }];
    RRFDelegaterListFootView *footView = [[RRFDelegaterListFootView alloc]init];
    [footView settingFootStr:model.sellADiamondAmount];
    self.footView = footView;
    [self.view addSubview:footView];
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(49);
    }];
   WEAKSELF
    headView.delegaterBlock = ^(NSNumber *type){
        if ([type intValue] == 0) {
            weakSelf.switchType = DelegaterListSwitchTypeA;
            [weakSelf.footView settingFootStr:model.sellADiamondAmount];
            [weakSelf.tableView.mj_header beginRefreshing];
        }else if ([type intValue] == 1){
            weakSelf.switchType = DelegaterListSwitchTypeB;
            [weakSelf.footView settingFootStr:model.sellBDiamondAmount];
            [weakSelf.tableView.mj_header beginRefreshing];
        }else{
            weakSelf.switchType = DelegaterListSwitchTypeC;
            [weakSelf.footView settingFootStr:model.sellCDiamondAmount];
            [weakSelf.tableView.mj_header beginRefreshing];
        }
    };

    [self.tableView.mj_footer beginRefreshing];

}

-(void)requestDtataList:(UIView*)sender
{
    WEAKSELF
    BOOL refreAllData = NO;
    NSMutableArray *temp ;
    if ([sender isKindOfClass:[MJRefreshHeader class]]) {
        refreAllData = YES;
        self.pageNo = 0;
    }
    if (refreAllData) {
        temp = [[NSMutableArray alloc]init];
    }else{
        temp = [NSMutableArray arrayWithArray:self.userList];
    }
    NSString *levelStr;
    if (self.switchType == DelegaterListSwitchTypeA) {
        levelStr = @"A";
    }else if (self.switchType == DelegaterListSwitchTypeB){
        levelStr = @"B";
    }else{
        levelStr = @"C";
    }
    NSString *url = self.viewType == DelegaterListControllerViewTypeUser?@"delegater/userLowerLevelList":@"delegater/delegaterLowerLevelList";
    [RRFPlanTool requestDelegaterLowerLevelListWithUrl:url PageNo:self.pageNo size:20 level:levelStr Success:^(id json) {
        BOOL last = [json[@"last"] boolValue];
        NSArray *dataList = json[@"content"];
        for (NSDictionary *dic in dataList) {
            RRFDelegateListModel *model = [RRFDelegateListModel yy_modelWithJSON:dic];
            [temp addObject:model];
        }
        weakSelf.userList = temp;
        [weakSelf.tableView reloadData];
        weakSelf.pageNo ++;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (weakSelf.userList.count==0) {
            [weakSelf settingNoDataView];
            weakSelf.footView.footLabelView.hidden = YES;
            weakSelf.footView.footLabel.hidden = YES;

        }else{
            weakSelf.footView.footLabelView.hidden = NO;
            weakSelf.footView.footLabel.hidden = NO;
            [weakSelf.tableView setTableFooterView:[[UIView alloc]init]];
        }
        if (last) {
            [weakSelf.tableView.mj_footer setHidden:YES];
        }else{
            [weakSelf.tableView.mj_footer setHidden:NO];
        }
        
    } failBlock:^(id json) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_footer setHidden:YES];
        [weakSelf.tableView setTableFooterView:weakSelf.failFootView];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RRFDelegateListModel *model = self.userList[indexPath.row];
    RRFDelegaterListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRFDelegaterListController"];
    if (cell == nil) {
        cell = [[RRFDelegaterListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RRFDelegaterListController"];
    }
    cell.model = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.switchType == DelegaterListSwitchTypeC) return;
    RRFDelegateListModel *model = self.userList[indexPath.row];
    RRFNextDelegateListController *desc = [[RRFNextDelegateListController alloc]init];
    desc.model = model;
    desc.viewType = self.viewType;
    desc.switchType = self.switchType;
    [self.navigationController pushViewController:desc animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]init];
    headView.frame = CGRectMake(0, 0, SCREENWidth, 12);
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}
-(void)settingNoDataView
{
    NSString *titleStr = @"您暂时还没有客户,赶快去邀请吧!";
    NSString *subTitleStr = @"要邀请的客户越多，购买的钻石就越多，利润越多!";
    NSString *rightStr = @"邀请";
    if (self.viewType == DelegaterListControllerViewTypeDelegate) {
        titleStr = @"您暂时还没有下级代理,赶快去招募吧!";
        subTitleStr = @"招募的代理越多，进货钻石越多，你的返利越多!心动不如行动";
        rightStr = @"+招募";
    }
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64-49)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 60, SCREENWidth-30, 40)];
    titleLabel.text = titleStr;
    titleLabel.numberOfLines=2;
    titleLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:titleLabel];
    
    UILabel *subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 90, SCREENWidth-30, 40)];
    subTitleLabel.text = subTitleStr;
    subTitleLabel.numberOfLines=2;
    subTitleLabel.textColor = [UIColor colorWithHexString:@"bbbbbb"];
    subTitleLabel.font = [UIFont systemFontOfSize:15];
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:subTitleLabel];

    self.tableView.tableFooterView = footerView;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
@end
