//
//  RRFExceptionalListController.m
//  Puzzle
//
//  Created by huibei on 16/8/25.
//  Copyright © 2016年 HuiBei. All rights reserved.
//  打赏&点赞列表

#import "RRFExceptionalListController.h"
#import "RRFExceptionalListCell.h"
#import "RRFMeTool.h"
#import "RRFPraiseListModel.h"
#import "MJRefresh.h"
#import "JNQFailFooterView.h"
#import "HBLoadingView.h"

@interface RRFExceptionalListController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,assign)int pageNo;
@property(nonatomic,strong)NSMutableArray *allData;
@property(nonatomic,strong)JNQFailFooterView *failFootView;
@end

@implementation RRFExceptionalListController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    self.tableView.delegate = self ;
    self.tableView.dataSource = self ;
    self.pageNo = 0;
    
    [self.tableView registerClass:[RRFExceptionalListCell class] forCellReuseIdentifier:@"RRFExceptionalListController"];
    MJRefreshNormalHeader *tabheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestListWith:)];
    tabheader.lastUpdatedTimeLabel.hidden = YES;
    tabheader.stateLabel.textColor = HBColor(135, 135, 135);
    tabheader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.tableView.mj_header = tabheader;
    
    MJRefreshAutoNormalFooter *tabfooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestListWith:)];
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
    [self.tableView.mj_footer beginRefreshing];
    if (self.showCancel) {
        UIBarButtonItem* cancelItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelController)];
        self.navigationItem.rightBarButtonItem = cancelItem ;
    }
}

-(void)cancelController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSMutableArray *)allData
{
    if (_allData == nil) {
        _allData = [NSMutableArray array];
    }
    return _allData;
}
-(void)requestListWith:(UIView *)sender
{
    WEAKSELF
    if ([sender isKindOfClass:[MJRefreshHeader class]]) {
        weakSelf.pageNo = 0;
    }
    NSString *url;
    if (self.comeInType == PraiseListTypeComment) {
        if (self.type == CommentCellClickTypePraise) {
            url = @"praiseList";
        }else{
            url = @"presentDiamondsRecord";
        }
    }else{
        if (self.type == CommentCellClickTypePraise) {
            url = @"client/friendCircle/praiseList";
        }else{
            url = @"presentDiamondsRecord";
        }
    }
    [HBLoadingView showCircleView:self.view];
    [RRFMeTool requestPraiseListWithUrl:url PageNo:self.pageNo size:100 entityType:self.entityType entityId:self.ID Success:^(id json) {
        NSArray *data = json[@"content"];
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in data) {
            RRFPraiseListModel *mode = [RRFPraiseListModel yy_modelWithJSON:dic];
            [temp addObject:mode];
        }
        if (_pageNo == 0) {
            weakSelf.allData = temp;
            if (temp.count == 0) {
                [self settingNoDataView];
            }else{
                self.tableView.tableFooterView = [UIView new];
            }
        }else{
            [weakSelf.allData addObjectsFromArray:temp];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView reloadData];
        weakSelf.pageNo ++;
        weakSelf.tableView.mj_footer.hidden = YES;
        [HBLoadingView hide];
    } failBlock:^(id json) {
        [HBLoadingView hide];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.tableView.mj_footer.hidden = YES;
        [weakSelf.tableView setTableFooterView:self.failFootView];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RRFPraiseListModel *model = self.allData[indexPath.row];
    RRFExceptionalListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRFExceptionalListController"];
    if (cell == nil) {
        cell = [[RRFExceptionalListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RRFExceptionalListController"];
    }
    cell.type = self.type;
    cell.model = model;
    return cell;
}
-(void)settingNoDataView
{
    NSString *titleStr = @"暂时没有人给您赞赏";
    if(self.type == CommentCellClickTypePraise){
        titleStr = @"暂时没有人给您点赞";
    }
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, (SCREENHeight-64)/2, SCREENWidth-30, 40)];
    titleLabel.text = titleStr;
    titleLabel.numberOfLines=2;
    titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:titleLabel];
    self.tableView.tableFooterView = footerView;
}

@end
