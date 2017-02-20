//  0元夺宝确认订单页
//  JNQComfirmFBOrderViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/12/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQConfirmFBOrderViewController.h"
#import "JNQFBCompleteViewController.h"

#import "JNQConfirmFBOrderView.h"
#import "PZCache.h"
#import "JNQHttpTool.h"



@interface JNQConfirmFBOrderViewController () {
    JNQConfirmFBOrderHeaderView *_fbConfirmHeaderV;
    JNQConfirmFBOrderFooterView *_fbConfirmFooterV;
}

@end

@implementation JNQConfirmFBOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self builConfirmFBOrderUI];
}

- (void)builConfirmFBOrderUI {
    _fbConfirmHeaderV = [[JNQConfirmFBOrderHeaderView alloc] init];
    _fbConfirmHeaderV.frame = CGRectMake(0, 0, SCREENWidth, 160);
    _fbConfirmHeaderV.productM = _productM;
    _fbConfirmHeaderV.inCount = _inCount;
    [self.tableView setTableHeaderView:_fbConfirmHeaderV];
    
    _fbConfirmFooterV = [[JNQConfirmFBOrderFooterView alloc] init];
    _fbConfirmFooterV.frame = CGRectMake(0, 0, SCREENWidth, SCREENHeight-64-160);
    [self.tableView setTableFooterView:_fbConfirmFooterV];
    [[_fbConfirmFooterV.inBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self partInFB];
    }];
}

- (void)partInFB {
    NSString* phoneModel = [PZCache sharedInstance].phoneType ;
    NSDictionary* addrInfo = [PZCache sharedInstance].addrInfo ;
    NSString* ip = [addrInfo objectForKey:@"ip"];
    NSString* city = [addrInfo objectForKey:@"city"];
    NSString* county = [addrInfo objectForKey:@"county"];
    NSString* area = [NSString stringWithFormat:@"%@%@",city,county];
    NSDictionary *param = @{
                            @"purchaseGameId" : @(_productM.purchaseGameId),
                            @"bidXtb"         : @(_productM.priceOfOneBidInXtb*_inCount),
                            @"area"           : area,
                            @"ip"             : ip,
                            @"phoneModel"     : phoneModel
                            };
    [MBProgressHUD show];
    [JNQHttpTool JNQHttpRequestWithURL:@"purchaseGame/bid" requestType:@"post" showSVProgressHUD:NO parameters:param successBlock:^(id json) {
        FBProductModel *productM = [FBProductModel yy_modelWithJSON:json[@"content"]];
        JNQFBCompleteViewController *fbCompleteVC = [[JNQFBCompleteViewController alloc] init];
        fbCompleteVC.navigationItem.title = @"参与结果";
        fbCompleteVC.productM = productM;
        fbCompleteVC.inCount = _inCount;
        [self.navigationController pushViewController:fbCompleteVC animated:YES];
        [MBProgressHUD dismiss];
    } failureBlock:^(id json) {
        [MBProgressHUD dismiss];
    }];
}

@end
