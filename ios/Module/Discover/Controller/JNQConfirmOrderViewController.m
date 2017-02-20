//
//  JNQConfirmOrderViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQConfirmOrderViewController.h"
#import "JNQPayViewContoller.h"
#import "JNQAddressController.h"

#import "JNQAddressModel.h"
#import "JNQProductModel.h"
#import "JNQConfirmOrderModel.h"
#import "JNQPresentProductModel.h"
#import "JNQProductExchangeModel.h"

#import "JNQConfirmOrderView.h"
#import "JNQConfirmOrderCell.h"

#import "JNQHttpTool.h"
#import "ShoppingCartTool.h"

@interface JNQConfirmOrderViewController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_confirmOrderTv;
    JNQConfirmOrderBottomView *_bottomView;
    JNQAddressModel *_addrModel;
    BOOL _loadDefaultAddr;
}

@property (nonatomic, strong) JNQConfirmOrderHeaderView *headerView;
@property (nonatomic, strong) JNQProductExchangeModel *productExchangeModel;
@property (nonatomic, strong) JNQProductPayResultModel *productPayResultModel;

@end
@implementation JNQConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HBColor(245, 245, 245);
    _productExchangeModel = [[JNQProductExchangeModel alloc] init];
    _loadDefaultAddr = YES;
    [self buildUI];
    [_confirmOrderTv reloadData];
}

- (void)buildUI {
    WEAKSELF
    _confirmOrderTv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64-45) style:UITableViewStyleGrouped];
    [self.view addSubview:_confirmOrderTv];
    _confirmOrderTv.delegate = self;
    _confirmOrderTv.dataSource = self;
    _confirmOrderTv.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _headerView = [[JNQConfirmOrderHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 90)];
    [_confirmOrderTv setTableHeaderView:_headerView];
    _headerView.block = ^() {
        JNQAddressController *addrVC = [[JNQAddressController alloc] init];
        addrVC.viewType = PZAddrViewTypeSelect;
        addrVC.navigationItem.title = @"选择地址";
        addrVC.selectBlock = ^(JNQAddressModel *addrModel) {
            _loadDefaultAddr = NO;
            weakSelf.productExchangeModel.addressId = addrModel.addressId;
            weakSelf.headerView.addrModel = addrModel;
        };
        [weakSelf.navigationController pushViewController:addrVC animated:YES];
    };
    
    
    _bottomView = [[JNQConfirmOrderBottomView alloc] init];//WithFrame:CGRectMake(-1, SCREENHeight-45-64, SCREENWidth+2, 45)];
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(0.5);
        make.size.mas_equalTo(CGSizeMake(SCREENWidth+1, 45));
    }];
    _bottomView.layer.borderColor = HBColor(231, 231, 231).CGColor;
    _bottomView.layer.borderWidth = 0.5;
    [[_bottomView.payBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (!_productExchangeModel.addressId) {
            [MBProgressHUD showInfoWithStatus:@"请选择收货地址"];
            return;
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"兑换确认" message:@"确认兑换以上商品吗？" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        }];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self payProduct];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:deleteAction];
        [self presentViewController:alertController animated:YES completion:^{
        }];
    }];
    _bottomView.totalCount = [self computerTotalCount];
    _bottomView.totalFee = [self computerTotalPrice];
}

- (void)loadDefaultAddress {
    [JNQHttpTool JNQHttpRequestWithURL:@"deliveryAddress/getDefault" requestType:@"post" showSVProgressHUD:NO parameters:@{} successBlock:^(id json) {
        NSLog(@"11111111");
        _addrModel = [JNQAddressModel yy_modelWithJSON:json];
        _headerView.addrModel = _addrModel;
        _productExchangeModel.addressId = _addrModel.addressId;
    } failureBlock:^(id json) {
        
    }];
}

- (void)payProduct {
    _productExchangeModel.count = (int)[self computerTotalCount];
    _productExchangeModel.xtbPrice = [self computerTotalPrice];
    NSMutableArray *array = [NSMutableArray array];
    for (NSArray *sec in _dataArray) {
        for (JNQPresentProductModel *model in sec) {
            JNQProductModel *proModel = [[JNQProductModel alloc] init];
            proModel.productId = model.productId;
            proModel.totalCount = (int)model.count;
            proModel.price = model.price;
            proModel.shopId = 1;
            [array addObject:proModel];
        }
    }
    _productExchangeModel.productList = array;
    NSDictionary *param = [_productExchangeModel yy_modelToJSONObject];
    [JNQHttpTool JNQHttpRequestWithURL:@"exchange/product" requestType:@"post" showSVProgressHUD:NO parameters:param successBlock:^(id json) {
        JNQConfirmOrderModel *confirmOrderModel = [[JNQConfirmOrderModel alloc] init];
        confirmOrderModel.orderId = [json[@"orderNo"] integerValue];
        confirmOrderModel.realTotalFee = [json[@"xtbPrice"] integerValue];
        confirmOrderModel.createTime = json[@"tradeTime"];
        JNQPayViewContoller *payVC = [[JNQPayViewContoller alloc] init];
        payVC.confirmOrderModel = confirmOrderModel;
        payVC.viewType = PayViewTypeProduct;
        payVC.navigationItem.title = @"支付结果";
        [[NSNotificationCenter defaultCenter] postNotificationName:ShoppingCartClearNotificate object:nil];
        [self.navigationController pushViewController:payVC animated:YES];
    } failureBlock:^(id json) {
        NSError *error = json;
        NSString *errorStr = [JNQHttpTool errorDataString:error];
        if ([errorStr isEqualToString:@"喜腾币利润账户不足"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ExchangeXT" object:@(2)];
        }
    }];
}



- (NSInteger)computerTotalCount {
    NSInteger totalCount = 0;
    for (NSArray *sec in _dataArray) {
        for (JNQPresentProductModel *model in sec) {
            totalCount += model.count;
        }
    }
    return totalCount;
}

- (NSInteger)computerCountInSection:(NSInteger)section {
    NSInteger count = 0;
    NSArray *sec = _dataArray[section];
    for (JNQPresentProductModel *model in sec) {
        count += model.count;
    }
    return count;
}

- (NSInteger)computerTotalPrice {
    NSInteger totalPrice = 0;
    for (NSArray *sec in _dataArray) {
        for (JNQPresentProductModel *model in sec) {
            totalPrice += model.count * model.price;
        }
    }
    return totalPrice;
}

- (NSInteger)computerPriceInSection:(NSInteger)section {
    NSInteger price = 0;
    NSArray *sec = _dataArray[section];
    for (JNQPresentProductModel *model in sec) {
        price += model.count * model.price;
    }
    return price;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sec = _dataArray[section];
    return sec.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 15)];
    header.backgroundColor = HBColor(245, 245, 245);
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    JNQConfirmOrderSectionFooterView *footer = [[JNQConfirmOrderSectionFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 35)];
    footer.secTotalFee = [self computerPriceInSection:section];
    footer.secTotalCount = [self computerCountInSection:section];
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sec = _dataArray[indexPath.section];
    JNQConfirmOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JNQConfirmOrderViewController"];
    if (!cell) {
        cell = [[JNQConfirmOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JNQConfirmOrderViewController"];
    }
    JNQPresentProductModel *model = [sec objectAtIndex:indexPath.row];
    cell.presentProductModel = model;
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_loadDefaultAddr) {
        [self loadDefaultAddress];
    }
}

@end
