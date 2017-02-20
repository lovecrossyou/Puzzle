//
//  JNQVIPUpdateViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/12.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQVIPUpdateViewController.h"
#import "JNQPayViewContoller.h"
#import "JNQPageViewController.h"
#import "JNQRankViewController.h"

#import "JNQVIPModel.h"
#import "JNQVIPExchangeModel.h"
#import "JNQConfirmOrderModel.h"

#import "JNQVIPUpdateView.h"
#import "JNQVIPUpdateCell.h"
#import "JNQFailFooterView.h"

#import "JNQHttpTool.h"
#import "PZParamTool.h"

static NSString *vipImgArr[3] = {
    @"icon_goldvip",
    @"icon_Platinum-vip",
    @"icon_diamonds-vip"
};

@interface JNQVIPUpdateViewController () <UITableViewDelegate, UITableViewDataSource> {
    JNQVIPUpdateHeaderView *_headerView;
    NSMutableArray *_dataArray;
    NSString *_identityType;
}

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) JNQVIPExchangeModel *vipExchangeModel;
@property (nonatomic, strong) JNQFailFooterView *failFooterView;

@end

@implementation JNQVIPUpdateViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    self.view.backgroundColor = HBColor(245, 245, 245);
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREENWidth, SCREENHeight)];
    [self.view addSubview:self.tableview];
    self.tableview.backgroundColor = HBColor(245, 245, 245);
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    _failFooterView = [[JNQFailFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
    _failFooterView.reloadBlock = ^() {
        [weakSelf loadData];
    };
    _dataArray = [NSMutableArray array];
    self.vipExchangeModel = [[JNQVIPExchangeModel alloc] init];
    [self setNav];
    [self buildUI];
    [self loadData];
}

- (void)setNav {
    
    UIView *nav = [[UIView alloc] init];
    [self.view addSubview:nav];
    [nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    nav.backgroundColor = [UIColor whiteColor];
    
    UILabel *navTitle = [[UILabel alloc] init];
    [nav addSubview:navTitle];
    [navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nav).offset(20);
        make.left.width.bottom.mas_equalTo(nav);
    }];
    navTitle.font = PZFont(17);
    navTitle.textColor = HBColor(51, 51, 51);
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.text = @"升级会员";
    
    UIButton *navBack = [[UIButton alloc] init];
    [nav addSubview:navBack];
    [navBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(navTitle);
        make.width.mas_equalTo(60);
    }];
    [navBack setImage:[UIImage imageNamed:@"nav_back_btn"] forState:UIControlStateNormal];
    navBack.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [navBack setImageEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
    [[navBack rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)buildUI {
    _headerView = [[JNQVIPUpdateHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 140)];
    [self.tableview setTableHeaderView:_headerView];
    _headerView.backgroundColor = HBColor(247, 41, 41);
    [_headerView.backBtn addTarget:self action:@selector(headerViewBtnsDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.vipBtn addTarget:self action:@selector(headerViewBtnsDidClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)headerViewBtnsDidClicked:(UIButton *)button {
    JNQPageViewController *pageVC = [[JNQPageViewController alloc] init];
    pageVC.rankViewType = RankViewTypeCurrent;
    pageVC.title = @"股神争霸";
    [self.navigationController pushViewController:pageVC animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)loadData {
    [JNQHttpTool JNQHttpRequestWithURL:@"identity/list" requestType:@"post" showSVProgressHUD:NO parameters:@{} successBlock:^(id json) {
        [self.tableview setTableFooterView:nil];
        NSArray *array = json[@"identityList"];
        for (NSDictionary *dict in array) {
            JNQVIPModel *model = [JNQVIPModel yy_modelWithJSON:dict];
            [_dataArray addObject:model];
        }
        [self.tableview reloadData];
    } failureBlock:^(id json) {
        [self.tableview setTableFooterView:_failFooterView];
    }];
}

- (void)loadIdentityData {
    [JNQHttpTool JNQHttpRequestWithURL:@"identity/info" requestType:@"post" showSVProgressHUD:NO parameters:@{} successBlock:^(id json) {
        NSString *identityName = json[@"identityName"];
        _headerView.identityName = identityName;
        [_headerView setStartTime:json[@"startTime"] endTime:json[@"endTime"]];
    } failureBlock:^(id json) {
    }];
}

- (void)vipPay:(NSString *)identityName vipModel:(JNQVIPModel *)vipModel {
    [JNQHttpTool payOrderWithType:OrderTypeVIP productId:vipModel.productId totalParice:vipModel.price successBlock:^(id json) {
        JNQConfirmOrderModel *model = [JNQConfirmOrderModel yy_modelWithJSON:json];
        JNQPayViewContoller *payVC = [[JNQPayViewContoller alloc] init];
        payVC.navigationItem.title = @"确认购买";
        payVC.confirmOrderModel = model;
        payVC.viewType = PayViewTypeVIP;
        payVC.vipModel = vipModel;
        [self.navigationController pushViewController:payVC animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    } failureBlock:^(id json) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF
    JNQVIPUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JNQVIPUpdateViewController"];
    if (!cell) {
        cell = [[JNQVIPUpdateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JNQVIPUpdateViewController"];
    }
    JNQVIPModel *vipModel = [_dataArray objectAtIndex:indexPath.row];
    cell.vipModel = vipModel;
    [cell.levelBtn setImage:[UIImage imageNamed:vipImgArr[indexPath.row]] forState:UIControlStateNormal];
    cell.vipUpdateBlock = ^(JNQVIPUpdateCell *cell) {
        BOOL hasLogin = [PZParamTool hasLogin];
        if (!hasLogin) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin" object:nil];
            return;
        }
/*        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认支付" message:[NSString stringWithFormat:@"购买%@您需要支付%.0f颗钻，请确认支付！", vipModel.identityName, (float)vipModel.price/100] preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        }];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){*/
            weakSelf.vipExchangeModel.diamondPrice = vipModel.price/100;
            weakSelf.vipExchangeModel.productId = vipModel.productId;
            [weakSelf vipPay:vipModel.identityName vipModel:vipModel];
/*        }];
        [alertController addAction:cancelAction];
        [alertController addAction:deleteAction];
        [self presentViewController:alertController animated:YES completion:^{
        }];*/
    };
    return cell;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([PZParamTool hasLogin]) {
        [self loadIdentityData];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
