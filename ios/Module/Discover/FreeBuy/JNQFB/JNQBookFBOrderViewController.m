//  0元夺宝立即下单页
//  JNQBookTableViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/12/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQBookFBOrderViewController.h"
#import "JNQConfirmFBOrderViewController.h"

#import "JNQBookFBOrderView.h"

#import "JNQHttpTool.h"
#import "TPKeyboardAvoidingTableView.h"

@interface JNQBookFBOrderViewController () <UITextFieldDelegate> {
    JNQBookFBOrderHeaderView *_fbBookOrderHeaderV;
    JNQBookFBOrderFooterView *_fbBookOrderFooterV;
    NSInteger _inCount;
    NSInteger _restCount;
}

@end

@implementation JNQBookFBOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TPKeyboardAvoidingTableView *tableview = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
    self.tableView = tableview;
    _inCount = 1;
    [self buildBookFBOrderUI];
    [self loadrestCountData];
}

- (void)buildBookFBOrderUI {
    _fbBookOrderHeaderV = [[JNQBookFBOrderHeaderView alloc] init];
    _fbBookOrderHeaderV.frame = CGRectMake(0, 0, SCREENWidth, 245);
    _fbBookOrderHeaderV.productM = _productM;
    NSArray *titleA = @[@"5", @"20", @"50", @"100", @"包尾"];
    _fbBookOrderHeaderV.titleA = titleA;
    [self.tableView setTableHeaderView:_fbBookOrderHeaderV];
    _fbBookOrderHeaderV.delegateVC = self;
    _fbBookOrderHeaderV.countBlock = ^(NSInteger count) {
        _inCount = count;
    };
    
    _fbBookOrderFooterV = [[JNQBookFBOrderFooterView alloc] init];
    _fbBookOrderFooterV.frame = CGRectMake(0, 0, SCREENWidth, SCREENHeight-64-245);
    [self.tableView setTableFooterView:_fbBookOrderFooterV];
    [[_fbBookOrderFooterV.inBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (_inCount > _restCount) {
            [MBProgressHUD showInfoWithStatus:@"剩余不足"];
            _inCount = _productM.restPurchaseCount;
            _fbBookOrderHeaderV.operateV.countOpeV.count = _productM.restPurchaseCount;
        }
        JNQConfirmFBOrderViewController *confirmFBOrderVC = [[JNQConfirmFBOrderViewController alloc] init];
        confirmFBOrderVC.navigationItem.title = @"确认订单";
        confirmFBOrderVC.productM = _productM;
        confirmFBOrderVC.inCount = _inCount;
        [self.navigationController pushViewController:confirmFBOrderVC animated:YES];
    }];
}

- (void)loadrestCountData {
    [MBProgressHUD show];
    [JNQHttpTool JNQHttpRequestWithURL:@"purchaseGame/restBidCount" requestType:@"post" showSVProgressHUD:NO parameters:@{@"purchaseGameId":@(_productM.purchaseGameId)} successBlock:^(id json) {
        [MBProgressHUD dismiss];
        _fbBookOrderHeaderV.restCount = [json[@"restBidCount"] integerValue];
        _restCount = [json[@"restBidCount"] integerValue];
    } failureBlock:^(id json) {
        
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (![textField.text integerValue]) {
        [MBProgressHUD showInfoWithStatus:@"请勿输入非法数字"];
        textField.text = @"1";
        _fbBookOrderHeaderV.operateV.countOpeV.count = 1;
        _inCount = 1;
    } else if ([textField.text integerValue]>_restCount) {
        [MBProgressHUD showInfoWithStatus:@"剩余不足"];
        textField.text = [NSString stringWithFormat:@"%ld", _restCount];
        _inCount = _productM.restPurchaseCount;
        _fbBookOrderHeaderV.operateV.countOpeV.count = _restCount;
    }
}

@end
