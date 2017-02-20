//
//  JNQPartInDetailViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/12/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQPartInDetailViewController.h"
#import "JNQBookFBOrderViewController.h"
#import "RRFDetailInfoController.h"

#import "JNQFBBidRecodModel.h"

#import "HBLoadingView.h"
#import "JNQPartInDetailCell.h"

#import "JNQHttpTool.h"
#import "MJRefresh.h"

@interface JNQPartInDetailViewController () {
    NSMutableArray *_partInA;
    int _pageNo;
}

@end

@implementation JNQPartInDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = HBColor(245, 245, 245);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _partInA = [NSMutableArray array];
    [self buildUI];
}

- (void)buildUI {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadPartInData:)];
    header.tag = 10010;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.textColor = HBColor(135, 135, 135);
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadPartInData:)];
    footer.triggerAutomaticallyRefreshPercent = 1;
    footer.automaticallyRefresh = YES;
    footer.stateLabel.textColor = HBColor(135, 135, 135);
    self.tableView.mj_footer = footer;
}

- (void)buildHeaderV {
    if (!_partInA.count) {
        WEAKSELF
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
        [self.tableView setTableHeaderView:header];
        header.backgroundColor = HBColor(245, 245, 245);
        UILabel *label = [[UILabel alloc] init];
        [header addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(header);
            make.centerY.mas_equalTo(header).offset(-20);
            make.width.mas_equalTo(SCREENWidth-30);
        }];
        label.font = PZFont(13);
        label.textColor = HBColor(153, 153, 153);
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 2;
        label.text = @"还没有人参与，成为第一个！";
        
        UIButton *button = [[UIButton alloc] init];
        [header addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(header);
            make.top.mas_equalTo(label.mas_bottom).offset(8);
            make.height.mas_equalTo(25);
        }];
        button.backgroundColor = BasicBlueColor;
        button.titleLabel.font = PZFont(13.5);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"  立即参与  " forState:UIControlStateNormal];
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            JNQBookFBOrderViewController *bookFBOrderVC = [[JNQBookFBOrderViewController alloc] init];
            bookFBOrderVC.navigationItem.title = @"夺宝订单";
            bookFBOrderVC.productM = weakSelf.productM;
            [weakSelf.navigationController pushViewController:bookFBOrderVC animated:YES];
        }];
    } else {
        [self.tableView setTableHeaderView:nil];
    }
}

- (void)loadPartInData:(UIView *)sender {
    WEAKSELF
//    [HBLoadingView showCircleView:self.view];
    _pageNo = sender.tag == 10010 || sender == nil ? 0 : _pageNo;
    NSDictionary *param = @{
                            @"purchaseGameId"  :  @(_productM.purchaseGameId),
                            @"size"            :  @(10),
                            @"pageNo"          :  @(_pageNo)
                            };
    [JNQHttpTool JNQHttpRequestWithURL:@"bidOrder/record" requestType:@"post" showSVProgressHUD:NO parameters:param successBlock:^(id json) {
        [HBLoadingView dismiss];
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in json[@"content"]) {
            JNQFBBidRecodModel *model = [JNQFBBidRecodModel yy_modelWithJSON:dict];
            [array addObject:model];
        }
        if (_pageNo) {
            [_partInA addObjectsFromArray:array];
        } else {
            _partInA = array;
            [weakSelf buildHeaderV];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView reloadData];
        _pageNo++;
        weakSelf.tableView.mj_footer.hidden = [json[@"last"] boolValue];
    } failureBlock:^(id json) {
        [HBLoadingView dismiss];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _partInA.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 97.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JNQPartInDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JNQPartInDetailCell"];
    if (!cell) {
        cell = [[JNQPartInDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JNQPartInDetailCell"];
    }
    JNQFBBidRecodModel *model = _partInA[indexPath.row];
    cell.bidRecodModel = model;
    cell.buttonBlock = ^(UIButton *button) {
        RRFDetailInfoController *desc = [[RRFDetailInfoController alloc]init];
        desc.title = @"详细资料";
        desc.userId = model.userId;
        desc.verityInfo = NO;
        desc.detailInfoComeInType =  RRFDetailInfoComeInTypeOther;
        [self.navigationController pushViewController:desc animated:YES];
    };
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadPartInData:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [HBLoadingView dismiss];
}

@end
