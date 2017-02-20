//
//  RRFMyOrderViewController.m
//  Puzzle
//
//  Created by huipay on 2016/12/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFMyOrderViewController.h"
#import "RRFMyOrderView.h"
#import "RRFOrderListController.h"
#import "RRFFreeBuyOrderViewController.h"
#import "RRFMeTool.h"
#import "RRFMyOrderModel.h"
#import "RRFWiningOrderListController.h"

@interface RRFMyOrderViewController ()
@property(nonatomic,weak)RRFMyOrderView *headView;


@end

@implementation RRFMyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    
    
    RRFMyOrderView *headView = [[RRFMyOrderView alloc]init];
    headView.frame = CGRectMake(0, 0, SCREENWidth, 384);
    self.headView = headView;
    [self.tableView setTableHeaderView:headView];
    headView.giftOrder.giftOrderBlock = ^(NSNumber *typeNum){
        int type = [typeNum intValue];
        [self goOrderListVcWithType:type];
    };
    headView.bidOrder.bidOrderBlock = ^(NSNumber *typeNum){
        int type = [typeNum intValue];
        [self goFreeBuyOrderListType:type];
    };
    
    headView.WinningOrder.winningOrderBlock = ^(NSNumber *typeNum){
        int type = [typeNum intValue];
        [self goWiningOrderListType:type];
    };
}
-(void)requestOrderList
{
    WEAKSELF
    [RRFMeTool requestOrderInfoWithSuccess:^(id json) {
        RRFMyOrderModel *model = [RRFMyOrderModel yy_modelWithJSON:json];
        [weakSelf settingUIViewWithModel:model];
    } failBlock:^(id json) {
        
    }];
}
-(void)settingUIViewWithModel:(RRFMyOrderModel *)model
{
    [self.headView.giftOrder setPresentWaitEvaluateCount:model.presentWaitEvaluateCount presentWaitReceiveCount:model.presentWaitReceiveCount presentWaitSendCount:model.presentWaitSendCount];
    [self.headView.bidOrder setBidOrderWaitAcceptCount:model.bidOrderWaitAcceptCount bidOrderWaitEvaluateCount:model.bidOrderWaitEvaluateCount bidOrderWaitLotteryCount:model.bidOrderWaitLotteryCount];
    [self.headView.WinningOrder setWiningOrderWaitAcceptCount:model.stockWinOrderWaitSendCount WiningOrderWaitEvaluateCount:model.stockWinOrderWaitReceiveCount WiningOrderWaitLotteryCount:model.stockWinOrderWaitEvaluateCount];
}
- (void)goOrderListVcWithType:(int)type{
    NSString *titleStr;
    BOOL showSwitchPanel = NO;
    if (type == 10) {
        titleStr = @"全部订单";
    }else if (type == 0){
        titleStr = @"待发货";
    }else if (type == 1){
        titleStr = @"待收货";
    }else{
        titleStr = @"晒单";
        showSwitchPanel =YES;
    }
    RRFOrderListController *orderList = [[RRFOrderListController alloc]init];
    orderList.title = titleStr;
    orderList.status = type;
    orderList.showSwitchPanel = showSwitchPanel;
    [self.navigationController pushViewController:orderList animated:YES];
}
-(void)goFreeBuyOrderListType:(int)type
{
    NSString *titleStr;
    NSString *status ;
    BOOL showPanel = NO;
    if (type == 10) {
        titleStr = @"全部订单";
        status = @"";
    }else if (type == 1){
        titleStr = @"待揭晓";
        status = @"waiting";
    }else if (type == 2){
        titleStr = @"待领奖";
        status = @"win";
    }else{
        titleStr = @"晒单";
        status = @"evaluate";
        showPanel = YES;
    }
    RRFFreeBuyOrderViewController *desc = [[RRFFreeBuyOrderViewController alloc]init];
    desc.title = titleStr;
    desc.status = status;
    desc.showSwitchPanel = showPanel;
    desc.comminType = RRFFreeBuyOrderTypeMe;
    [self.navigationController pushViewController:desc animated:YES];
}

-(void)goWiningOrderListType:(int)type
{
    NSString *titleStr;
    NSString *status ;
    BOOL showSwitchPanel = NO;
    if (type == 10) {
        titleStr = @"全部订单";
        status = @"";
    }else if (type == 1){
        titleStr = @"待领奖";
        status = @"create";
    }else if (type == 2){
        titleStr = @"待收货";
        status = @"send";
    }else{
        titleStr = @"晒单";
        status = @"finish";
        showSwitchPanel = YES;
    }
    RRFWiningOrderListController *desc = [[RRFWiningOrderListController alloc]init];
    desc.title = titleStr;
    desc.status = status;
    desc.showSwitchPanel = showSwitchPanel;
    [self.navigationController pushViewController:desc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestOrderList];
}

@end
