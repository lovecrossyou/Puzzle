
//
//  RRFFocusController.m
//  Puzzle
//  关注
//  Created by huipay on 2016/9/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFFocusController.h"
#import "RRFPuzzleBarTool.h"
#import "MJRefresh.h"
#import "QuestionBarListModel.h"
#import "HomeWenBarCell.h"
#import "RRFPersonalAskBarController.h"
#import "JNQFailFooterView.h"
#import "HBLoadingView.h"

@interface RRFFocusController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_focusDatas;
    NSMutableArray *_focusNames;


}
@property(assign,nonatomic) int pageNo ;
@property(nonatomic,strong)JNQFailFooterView *failFootView;

@end

@implementation RRFFocusController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    _focusDatas = [NSMutableArray array];
    _focusNames = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 120.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerClass:[HomeWenBarCell class] forCellReuseIdentifier:@"RRFFocusController"];
    MJRefreshNormalHeader *tabheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData:)];
    tabheader.lastUpdatedTimeLabel.hidden = YES;
    tabheader.stateLabel.textColor = HBColor(135, 135, 135);
    tabheader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.tableView.mj_header = tabheader;
    
    MJRefreshAutoNormalFooter *tabfooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestData:)];
    tabfooter.triggerAutomaticallyRefreshPercent = 1;
    tabfooter.automaticallyRefresh = YES;
    tabfooter.stateLabel.textColor = HBColor(135, 135, 135);
    self.tableView.mj_footer = tabfooter;
    
    if (self.failFootView == nil) {
        self.failFootView = [[JNQFailFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
        self.failFootView.reloadBlock = ^(){
            [weakSelf.tableView.mj_header beginRefreshing];
        };
    }
    
}
-(void)requestData:(UIView *)sender
{
    if ([sender isKindOfClass:[MJRefreshHeader class]]) {
        self.pageNo = 0;
        [self.tableView reloadData];
    }
    WEAKSELF
    [RRFPuzzleBarTool requestFollowerListWithPageNo:self.pageNo Success:^(id json) {
        QuestionBarListModel* modelList = [QuestionBarListModel yy_modelWithJSON:json];
        NSMutableArray* allDatas ;
        if (self.pageNo == 0) {
            allDatas = [NSMutableArray array];
        }
        else{
            allDatas = [NSMutableArray arrayWithArray:_focusDatas];
        }
       
        if (modelList.content.count) {
            [allDatas addObjectsFromArray:modelList.content];
            self.tableView.tableFooterView = [[UIView alloc]init];
        }else{
            [self settingNoDataView];
        }
        _focusDatas = allDatas ;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
        weakSelf.pageNo ++;
        if (modelList.last) {
            //隐藏加载更多
            weakSelf.tableView.mj_footer.hidden = YES;
        }
    } failBlock:^(id json) {
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.tableView.mj_footer.hidden = YES;
        [weakSelf.tableView setTableFooterView:self.failFootView];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _focusDatas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionBarModel *model = _focusDatas[indexPath.row];
    HomeWenBarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRFFocusController"];
    if (cell == nil) {
        cell = [[HomeWenBarCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RRFFocusOnController"];
    }
    cell.model = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionBarModel *model = _focusDatas[indexPath.row];
    RRFPersonalAskBarController *desc = [[RRFPersonalAskBarController alloc]init];
    desc.title = @"沙龙评论";
    desc.userId = model.userId;
    [self.navigationController pushViewController:desc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}
-(void)settingNoDataView
{
    NSString *titleStr = @"您还没有关注别人哦!";
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64-50)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, (SCREENHeight-64-50)/2, SCREENWidth-30, 50)];
    titleLabel.text = titleStr;
    titleLabel.numberOfLines=2;
    titleLabel.textColor = [UIColor colorWithHexString:@"777777"];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:titleLabel];
    self.tableView.tableFooterView = footerView;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView.mj_footer beginRefreshing];
}


@end
