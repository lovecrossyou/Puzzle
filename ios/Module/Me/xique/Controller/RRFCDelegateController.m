//
//  RRFCDelegateController.m
//  Puzzle
//
//  Created by huipay on 2017/1/9.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "RRFCDelegateController.h"
#import "RRFXTDelegateCellModel.h"
#import "RRFXTDelegateCell.h"
#import "MJRefresh.h"
#import "RRFMeTool.h"
@interface RRFCDelegateController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *datas;
@property(nonatomic,assign)int pageNo;
@end

@implementation RRFCDelegateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 120.0f;
    [self.tableView registerClass:[RRFXTDelegateCell class] forCellReuseIdentifier:@"RRFCDelegateController"];

    
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
    [self.tableView.mj_footer beginRefreshing];
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
        }else{
            self.tableView.tableFooterView = [UIView new];
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
    RRFXTDelegateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRFCDelegateController"];
    if (cell == nil) {
        cell = [[RRFXTDelegateCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RRFCDelegateController"];
    }
    cell.model = model;
    return cell;
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
