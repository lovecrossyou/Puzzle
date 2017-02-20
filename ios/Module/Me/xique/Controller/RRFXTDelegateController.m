//
//  RRFXTDelegateController.m
//  Puzzle
//
//  Created by huipay on 2016/12/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFXTDelegateController.h"
#import "RRFXTDelegateCell.h"
#import "RRFXTDelegateView.h"
#import "RRFMeTool.h"
#import "RRFXTDelegateInfoModel.h"
#import "MJRefresh.h"
#import "RRFXTDelegateCellModel.h"
#import "RRFXTNextDelegateController.h"

@interface RRFXTDelegateController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)RRFXTDelegateFootBarView *footBarView;
@property(nonatomic,weak) RRFXTDelegateHeaderView *headerView ;
@property(nonatomic,strong)NSMutableArray *allData;
@property(nonatomic,strong)NSString *leverStr;
@property(nonatomic,assign)int pageNo;
@property(nonatomic,strong)RRFXTDelegateInfoModel *infoModel;
@end

@implementation RRFXTDelegateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 0;
    self.leverStr = @"A";
    WEAKSELF
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.estimatedRowHeight = 120.0f;
    tableView.rowHeight = UITableViewAutomaticDimension;
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

    
    RRFXTDelegateHeaderView *headerView = [[RRFXTDelegateHeaderView alloc]init];
    headerView.frame = CGRectMake(0, 0, SCREENWidth, 62);
    self.headerView = headerView;
    self.tableView.tableHeaderView = headerView;
    headerView.XTDelegateHeaderBlock = ^(NSNumber *typeNum){
        int typeInt = [typeNum intValue];
        if (typeInt == 0) {
           // 一级
            weakSelf.leverStr = @"A";
            [weakSelf.footBarView setNumber:weakSelf.infoModel.countDiamondOfALevel];
        }else if (typeInt == 1){
           // 二级
            weakSelf.leverStr = @"B";
            [weakSelf.footBarView setNumber:weakSelf.infoModel.countDiamondOfBLevel];
        }else{
           // 三级
            weakSelf.leverStr = @"C";
            [weakSelf.footBarView setNumber:weakSelf.infoModel.countDiamondOfCLevel];
        };
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    
    
    RRFXTDelegateFootBarView *footBarView = [[RRFXTDelegateFootBarView alloc]init];
    self.footBarView = footBarView;
    [self.view addSubview:footBarView];
    [footBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    [self requestInfo];
}
-(void)requestInfo
{
    WEAKSELF
    [RRFMeTool requestUserInviterAmountMsgWithSuccess:^(id json) {
        RRFXTDelegateInfoModel *model = [RRFXTDelegateInfoModel yy_modelWithJSON:json];
        weakSelf.infoModel = model;
        weakSelf.headerView.model = model;
        [weakSelf.footBarView setNumber:weakSelf.infoModel.countDiamondOfALevel];
        [weakSelf.tableView.mj_footer beginRefreshing];
    } failBlock:^(id json) {
        
    }];
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
        temp = [[NSMutableArray alloc]initWithArray:self.allData];
    }
    [RRFMeTool requestLevelUserInfoMsgWithUserId:self.infoModel.userId Level:self.leverStr PageNo:self.pageNo Size:10 Success:^(id json) {
        NSArray *dicArray = json[@"content"];
        for (NSDictionary *diction in dicArray) {
            RRFXTDelegateCellModel *model = [RRFXTDelegateCellModel yy_modelWithJSON:diction];
            [temp addObject:model];
        }
        self.allData = temp;
        if (self.allData.count == 0) {
            [self settingNoDataView];
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
            }];
            self.footBarView.hidden = YES;
            [self.footBarView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
        }else{
            self.tableView.tableFooterView = [UIView new];
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-44);
            }];
            self.footBarView.hidden = NO;
            [self.footBarView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(44);
            }];
        }
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        self.pageNo ++;
        
        BOOL last = [json[@"last"] boolValue];
        if (last) {
            [self.tableView.mj_footer setHidden:YES];
        }else{
            [self.tableView.mj_footer setHidden:NO];
        }
    } failBlock:^(id json) {
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RRFXTDelegateCellModel *model = self.allData[indexPath.row];
    RRFXTDelegateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRFXTDelegateController"];
    if (cell == nil) {
        cell = [[RRFXTDelegateCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RRFXTDelegateController"];
    }
    cell.model = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.leverStr isEqualToString:@"C"]) {
        return;
    }
    RRFXTDelegateCellModel *model = self.allData[indexPath.row];
    RRFXTNextDelegateController *desc = [[RRFXTNextDelegateController alloc]init];
    desc.title = model.userName;
    desc.userId = [NSString stringWithFormat:@"%ld",model.userId];
    desc.leverStr = self.leverStr;
    desc.diamondAmount = model.diamondAmount;
    [self.navigationController pushViewController:desc animated:YES];
    
}
-(void)settingNoDataView
{
    NSString *titleStr = @"您还没有邀请客户!";
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
