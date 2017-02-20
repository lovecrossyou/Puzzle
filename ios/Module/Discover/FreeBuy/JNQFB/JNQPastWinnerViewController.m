//
//  JNQPastWinnerViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/12/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQPastWinnerViewController.h"
#import "JNQFBComContentPageController.h"
#import "FBPublicListModel.h"
#import "JNQPastWinnerCell.h"
#import "JNQHttpTool.h"
#import "MJRefresh.h"

@interface JNQPastWinnerViewController () {
    int _pageNo;
}

@property (nonatomic, strong) NSMutableArray *pastWinnerA;

@end

@implementation JNQPastWinnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = HBColor(245, 245, 245);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _pastWinnerA = [NSMutableArray array];
    [self buildPastWinnerUI];
    [self loadPastWinnerData];
}

- (void)buildPastWinnerUI {
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadPastWinnerData)];
    footer.triggerAutomaticallyRefreshPercent = 1;
    footer.automaticallyHidden = YES;
    footer.automaticallyRefresh = YES;
    footer.stateLabel.textColor = HBColor(135, 135, 135);
    self.tableView.mj_footer = footer;
}

- (void)buildHeaderV {
    if (!_pastWinnerA.count) {
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
        label.text = @"还没有往期揭晓";
    } else {
        [self.tableView setTableHeaderView:nil];
    }
}

- (void)loadPastWinnerData {
    NSDictionary *param = @{
                            @"productId" : @(_productId),
                            @"status" : @"",
                            @"size" : @(10),
                            @"pageNo":@(_pageNo)
                            };
    [JNQHttpTool JNQHttpRequestWithURL:@"purchaseGame/open" requestType:@"post" showSVProgressHUD:NO parameters:param successBlock:^(id json) {
        FBPublicListModel *model = [FBPublicListModel yy_modelWithJSON:json];
        NSArray *array = model.content;
        [_pastWinnerA addObjectsFromArray:array];
        [self.tableView.mj_footer endRefreshing];
        if (!_pageNo) {
            [self buildHeaderV];
        }
        [self.tableView reloadData];
        _pageNo++;
        self.tableView.mj_footer.hidden = model.last;
    } failureBlock:^(id json) {
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _pastWinnerA.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 164;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JNQPastWinnerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JNQPastWinnerCell"];
    if (!cell) {
        cell = [[JNQPastWinnerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JNQPastWinnerCell"];
    }
    FBPublicModel *pubM = _pastWinnerA[indexPath.row];
    cell.pubM = pubM;
    cell.clickBlock = ^() {
        JNQFBComContentPageController *comPageVC = [[JNQFBComContentPageController alloc] init];
        comPageVC.fbPurchaseGameId = pubM.purchaseGameId;
        [self.navigationController pushViewController:comPageVC animated:YES];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FBPublicModel *pubM = _pastWinnerA[indexPath.row];
    JNQFBComContentPageController *comPageVC = [[JNQFBComContentPageController alloc] init];
    comPageVC.fbPurchaseGameId = pubM.purchaseGameId;
    [self.navigationController pushViewController:comPageVC animated:YES];
}

@end
