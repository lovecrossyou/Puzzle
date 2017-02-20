//
//  RRFFreeBuyOrderDetailController.m
//  Puzzle
//
//  Created by huipay on 2016/12/21.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFFreeBuyOrderDetailController.h"
#import "RRFFreeBuyOrderDetailView.h"
#import "RRFFreeBuyOrderModel.h"
#import "RRFReceiveController.h"
#import "RRFRemarkViewController.h"
#import "RRFFreeBuyOrderTool.h"
#import "JNQConfirmOrderView.h"
#import "JNQFBComContentPageController.h"
#import "RRFParticipateInfoController.h"
#import "RRFShareOrderDetailInfoController.h"
@interface RRFFreeBuyOrderDetailController ()
@property(nonatomic,weak) RRFFreeBuyOrderDetailView *footView;
@property(nonatomic,weak)JNQConfirmOrderHeaderView *headerView;
@end

@implementation RRFFreeBuyOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // accept 已领奖
    NSString *status = self.model.bidOrderStatus;
    if ([status isEqualToString:@"accept"] || [status isEqualToString:@"evaluate"] || [status isEqualToString:@"send"]||[status isEqualToString:@"finish"]) {
        JNQConfirmOrderHeaderView *headerView = [[JNQConfirmOrderHeaderView alloc]init];
        headerView.addrModel = self.model.addressInfo;
        headerView.frame = CGRectMake(0, 0, SCREENWidth, 90);
        self.headerView = headerView;
        self.tableView.tableHeaderView = headerView;
    }
    
    
    WEAKSELF
    RRFFreeBuyOrderDetailView *footView = [[RRFFreeBuyOrderDetailView alloc]init];
    footView.model = self.model;
    footView.frame = CGRectMake(0, 0, SCREENWidth, 350);
    self.footView = footView;
    self.tableView.tableFooterView = footView;
    footView.seeAllBlock = ^(){
        RRFParticipateInfoController *desc = [[RRFParticipateInfoController alloc]init];
        desc.recordList = self.model.bidRecords;
        desc.title = @"夺宝号码";
        [weakSelf.navigationController pushViewController:desc animated:YES];
    };
    footView.operationBlock = ^(){
        NSString *str = [self.model.bidOrderStatus bidOrderStatusOperationBtnStr];
        if ([str isEqualToString:@"去领奖"]) {
            RRFReceiveController *desc = [[RRFReceiveController alloc]init];
            desc.title = @"领奖";
            desc.model = weakSelf.model;
            [weakSelf.navigationController pushViewController:desc animated:YES];
        }else if ([str isEqualToString:@"去晒单"]){
            RRFRemarkViewController *desc = [[RRFRemarkViewController alloc]init];
            desc.title = @"晒单";
            desc.showOrderType = RRFShowOrderTypeFreeBuy;
            desc.model = weakSelf.model;
            [weakSelf.navigationController pushViewController:desc animated:YES];
        }else if ([str isEqualToString:@"查看晒单"]){
            RRFShareOrderDetailInfoController *desc = [[RRFShareOrderDetailInfoController alloc]init];
            desc.title = @"晒单详情";
            desc.showOrderType =  RRFShowOrderTypeFreeBuy;
            desc.purchaseGameShowId = self.model.purchaseGameShowId;
            [self.navigationController pushViewController:desc animated:YES];

        }else if ([str isEqualToString:@"再次参与"]){
            JNQFBComContentPageController *vc = [[JNQFBComContentPageController alloc] init];
            vc.fbPurchaseGameId = self.model.purchaseGameId;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (weakSelf.isRefre) {
            weakSelf.isRefre(YES);
        }
    };
    footView.productBtnBlock = ^(){
        JNQFBComContentPageController *desc =[[JNQFBComContentPageController alloc]init];
        desc.fbPurchaseGameId = self.model.purchaseGameId;
        [self.navigationController pushViewController:desc animated:YES];
    };
}

@end
