//
//  RRFXTNextDelegateController.m
//  Puzzle
//
//  Created by huipay on 2016/12/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFXTNextDelegateController.h"
#import "RRFXTDelegateCell.h"
#import "RRFMeTool.h"
#import "MJRefresh.h"
#import "RRFXTDelegateCellModel.h"
#import "RRFXTDelegateView.h"
#import "RRFCDelegateController.h"

@interface RRFXTNextDelegateController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *datas;
@property(nonatomic,assign)int pageNo;
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)RRFXTDelegateFootBarView *footBarView;
@end

@implementation RRFXTNextDelegateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 0;
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 120.0f;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    [tableView registerClass:[RRFXTDelegateCell class] forCellReuseIdentifier:@"RRFXTNextDelegateController"];
    tableView.tableFooterView = [UIView new];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-44);
    }];
    
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
    
    RRFXTDelegateFootBarView *footBarView = [[RRFXTDelegateFootBarView alloc]init];
    [footBarView setNumber:[NSString stringWithFormat:@"%ld",self.diamondAmount]];
    self.footBarView = footBarView;
    [self.view addSubview:footBarView];
    [footBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];

    [self requestListWith:nil];
}
-(void)requestListWith:(UIView *)sender
{
    BOOL allRefre = NO;
    NSMutableArray *temp;
    if ([sender isKindOfClass:[MJRefreshHeader class]]) {
        allRefre = YES;
        self.pageNo = 0;

    }
    if (allRefre) {
        temp = [[NSMutableArray alloc]init];
    }else{
        temp = [[NSMutableArray alloc]initWithArray:self.datas];
    }
    [RRFMeTool requestLevelUserInfoMsgWithUserId:self.userId Level:@"A" PageNo:self.pageNo Size:10 Success:^(id json) {
        NSArray *dacArray = json[@"content"];
        for (NSDictionary *dic in dacArray) {
            RRFXTDelegateCellModel *model = [RRFXTDelegateCellModel yy_modelWithJSON:dic];
            [temp addObject:model];
        }
        self.datas = temp;
        if (self.datas.count == 0) {
            [self settingNoDataView];
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
            self.footBarView.hidden = YES;
            [self.footBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.right.left.mas_equalTo(0);
                make.height.mas_equalTo(0);
            }];
        }else{
            self.tableView.tableFooterView = [UIView new];
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.mas_equalTo(0);
                make.bottom.mas_equalTo(-44);
            }];
            self.footBarView.hidden = NO;
            [self.footBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.right.left.mas_equalTo(0);
                make.height.mas_equalTo(44);
            }];
        }
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];

        BOOL last = [json[@"last"] boolValue];
        if (last) {
            [self.tableView.mj_footer setHidden:YES];
        }else{
            [self.tableView.mj_footer setHidden:NO];
        }
        self.pageNo ++;
    } failBlock:^(id json) {
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RRFXTDelegateCellModel *model = self.datas[indexPath.row];
    RRFXTDelegateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRFXTNextDelegateController"];
    if (cell == nil) {
        cell = [[RRFXTDelegateCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RRFXTNextDelegateController"];
    }
    cell.model = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.leverStr isEqualToString:@"B"]) {
        return;
    }
    RRFXTDelegateCellModel *model = self.datas[indexPath.row];
    RRFCDelegateController *desc = [[RRFCDelegateController alloc]init];
    desc.title = model.userName;
    desc.userId = [NSString stringWithFormat:@"%ld",model.userId];
    [self.navigationController pushViewController:desc animated:YES];
}
-(void)settingNoDataView
{
    NSString *titleStr = @"没有邀请客户!";
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
@end
