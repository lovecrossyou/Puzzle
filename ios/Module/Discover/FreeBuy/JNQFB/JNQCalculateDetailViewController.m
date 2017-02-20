//
//  JNQCalculateDetailViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/12/19.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQCalculateDetailViewController.h"

#import "JNQFBCalculateModel.h"

#import "JNQCalculateDetailView.h"
#import "JNQCalculateDetailCell.h"

#import "JNQHttpTool.h"
#import "MJRefresh.h"

@interface JNQCalculateDetailViewController () {
    int _pageNo;
    NSMutableArray *_calculateA;
    JNQCalculateDetailHeaderView *_calHeaderV;
    JNQCalculateDetailFooterView *_calFooterV;
    BOOL _isSpeard;
}
@property (nonatomic, strong) JNQFBCalculateModel *calculateM;

@end

@implementation JNQCalculateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = HBColor(245, 245, 245);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _calculateA = [NSMutableArray array];
    _isSpeard = NO;
    [self buildCalculateDetailUI];
    [self loadCalculateDetailData];
}

- (void)buildCalculateDetailUI {
    WEAKSELF
    _calHeaderV = [[JNQCalculateDetailHeaderView alloc] init];
    _calHeaderV.frame = CGRectMake(0, 0, SCREENWidth, 153);
    _calHeaderV.buttonBlock = ^(UIButton *button) {
        button.selected = !button.selected;
        _isSpeard = button.selected;
        [weakSelf.tableView reloadData];
    };
    [self.tableView setTableHeaderView:_calHeaderV];
    
    _calFooterV = [[JNQCalculateDetailFooterView alloc] init];
    _calFooterV.frame = CGRectMake(0, 0, SCREENWidth, 128);
    [weakSelf.tableView setTableFooterView:_calFooterV];
}

- (void)loadCalculateDetailData {
    NSDictionary *param = @{
                            @"purchaseGameId" : @(_purchaseGameId),
                            @"size"           : @(50),
                            @"pageNo"         : @(_pageNo)
                            };
    [JNQHttpTool JNQHttpRequestWithURL:@"purchaseGame/lastBidRecord" requestType:@"post" showSVProgressHUD:NO parameters:param successBlock:^(id json) {
        _calculateM = [JNQFBCalculateModel yy_modelWithJSON:json];
        [_calculateA addObjectsFromArray:_calculateM.content];
        _calHeaderV.aValue = _calculateM.avalue;
        [_calFooterV setBValue:_calculateM.stockValue tradeTime:_calculateM.time];
        [_calFooterV setBidStatus:_bidStatus luckCode:_calculateM.luckCode];
    } failureBlock:^(id json) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _isSpeard ? _calculateA.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _isSpeard ? 30 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_isSpeard) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 30)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *attenL = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, SCREENWidth/2, 30)];
        [view addSubview:attenL];
        attenL.font = PZFont(12.5);
        attenL.textColor = HBColor(102, 102, 102);
        attenL.text = @"夺宝时间";
        
        UILabel *nameAttenL = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWidth-12-62.5, 0, 62.5, 30)];
        [view addSubview:nameAttenL];
        nameAttenL.font = attenL.font;
        nameAttenL.textColor = attenL.textColor;
        nameAttenL.text = @"用户名";
        
        return view;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 19;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JNQCalculateDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JNQCalculateDetailCell"];
    if (!cell) {
        cell = [[JNQCalculateDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JNQCalculateDetailCell"];
    }
    cell.calUserM = _calculateA[indexPath.row];
    return cell;
}
@end
