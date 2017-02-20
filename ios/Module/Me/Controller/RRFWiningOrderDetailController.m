//
//  RRFWiningOrderDetailController.m
//  Puzzle
//
//  Created by huipay on 2017/2/7.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "RRFWiningOrderDetailController.h"
#import "RRFWiningOrderDetailView.h"
#import "RRFWiningOrderListCell.h"
#import "RRFWiningOrderModel.h"
#import "RRFReceiveController.h"
#import "RRFRemarkViewController.h"
#import "RRFMeTool.h"
#import "RRFWiningOrderDetailModel.h"
#import "RRFShareOrderDetailInfoController.h"
@interface RRFWiningOrderDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)RRFWiningOrderDetailView *headView;
@end

@implementation RRFWiningOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200.0;
    [self.tableView registerClass:[RRFWiningOrderListCell class] forCellReuseIdentifier:@"RRFWiningOrderDetailController"];
    
    RRFWiningOrderDetailView *headView = [[RRFWiningOrderDetailView alloc]init];
    headView.frame = CGRectMake(0, 0, SCREENWidth, 184);
    self.headView = headView;
    [self.tableView setTableHeaderView:headView];
    
    [self requestOrderInfo];
    
}
-(void)requestOrderInfo
{
    [RRFMeTool requestWiningOrderInfoWithTradeOrderId:[self.model.orderId integerValue] Success:^(id json) {
        RRFWiningOrderDetailModel *model = [RRFWiningOrderDetailModel yy_modelWithJSON:json];
        self.headView.model = model;
    } failBlock:^(id json) {
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    RRFWiningOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRFWiningOrderDetailController"];
    if (cell == nil) {
        cell = [[RRFWiningOrderListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RRFWiningOrderListController"];
    }
    cell.winingOrderListCellBlock = ^(){
        [weakSelf cellClcikWithModel:self.model];
    };
    cell.model = self.model;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
-(void)cellClcikWithModel:(RRFWiningOrderModel *)model
{
    WEAKSELF
    if ([model.orderStatus isEqualToString:@"create"]) {
        RRFReceiveController *desc = [[RRFReceiveController alloc]init];
        desc.title = @"领奖";
        desc.winingM = model;
        [self.navigationController pushViewController:desc animated:YES];
    }else if ([model.orderStatus isEqualToString:@"send"] || [model.orderStatus isEqualToString:@"acceptPrize"] ){
        // 签收
        [self dealWithOrderId:model.orderId];
    }else if ([model.orderStatus isEqualToString:@"finish"] ){
        // 去晒单
        RRFRemarkViewController *desc = [[RRFRemarkViewController alloc]init];
        desc.title = @"晒单";
        desc.showOrderType = RRFShowOrderTypeWining;
        desc.winingModel = model;
        [self.navigationController pushViewController:desc animated:YES];
    }else{
        RRFShareOrderDetailInfoController *desc = [[RRFShareOrderDetailInfoController alloc]init];
        desc.title = @"晒单详情";
        desc.winingOrderShowId = model.stockWinOrderShowId;
        desc.showOrderType =  RRFShowOrderTypeWining;
        [self.navigationController pushViewController:desc animated:YES];
    }
    if (weakSelf.refreBlock) {
        weakSelf.refreBlock(@(YES));
    }
}
-(void)dealWithOrderId:(NSNumber *)orderId
{
    [RRFMeTool dealWithOrderId:orderId Success:^(id json) {
        [MBProgressHUD showInfoWithStatus:@"签收成功!"];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.refreBlock) {
            self.refreBlock(YES);
        }
    } failBlock:^(id json) {
        [MBProgressHUD showInfoWithStatus:@"签收失败,请稍候重试!"];
    }];
}
-(void)remindWithTradeOrderId:(NSInteger)tradeOrderId
{
    [RRFMeTool stockWinOrderShowWithTradeOrderId:tradeOrderId  Success:^(id json) {
        [MBProgressHUD showInfoWithStatus:@"提醒成功!"];
    } failBlock:^(id json) {
        
    }];
}




@end
