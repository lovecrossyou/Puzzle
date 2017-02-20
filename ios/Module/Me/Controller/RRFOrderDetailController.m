//
//  RRFOrderDetailController.m
//  Puzzle
//
//  Created by huibei on 16/8/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//
#import "RRFOrderDetailController.h"
#import "RRFOrderDetailView.h"
#import "RRFMeTool.h"
#import "RRFOrderListModel.h"
#import "RRFAddressModel.h"
#import "RRFOrderListCell.h"
#import "RRFProductModel.h"
#import "NSString+TimeConvert.h"
#import "RRFPhoneListModel.h"
#import "Singleton.h"
#import "RRFShareOrderDetailInfoController.h"
#import "RRFRemarkViewController.h"
@interface RRFOrderDetailController ()<UITableViewDelegate,UITableViewDataSource>
{
    RRFOrderDetailHeadView *_headerView;
    RRFOrderDetailFooterView *_footerView;
    RRFOrderDetailFooterBarView *_bottomView;
    UITableView *_orderDetailTableView;
    NSArray *_productList;
    NSInteger _orderId;
    NSInteger _tradeWay;
}
@end

@implementation RRFOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestOrderDetail];
}
-(void)requestOrderDetail
{
    [RRFMeTool requestOrderDatailOrderId:self.orderId Success:^(id json) {
        RRFOrderListModel *listM = [RRFOrderListModel yy_modelWithJSON:[json objectForKey:@"orderInfo"]];
        _tradeWay = listM.tradeWay;
        _productList = listM.products;
        _orderId = listM.orderId;
        RRFAddressModel *addrM = [RRFAddressModel yy_modelWithJSON:[json objectForKey:@"address"]];
        [self settingUIViewAddressModel:addrM liseModel:listM];
    } failBlock:^(id json) {
        
    }];
    
}
-(void)settingUIViewAddressModel:(RRFAddressModel*)addrM liseModel:(RRFOrderListModel *)listModel
{
    WEAKSELF
    _orderDetailTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [_orderDetailTableView registerClass:[RRFOrderListCell class] forCellReuseIdentifier:@"RRFOrderDetailController"];
    _orderDetailTableView.delegate = self;
    _orderDetailTableView.dataSource = self;
    _orderDetailTableView.rowHeight = UITableViewAutomaticDimension;
    _orderDetailTableView.estimatedRowHeight = 68.0;
    _orderDetailTableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    [self.view addSubview:_orderDetailTableView];
    [_orderDetailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
    }];
    
    _headerView = [[RRFOrderDetailHeadView alloc]init];
    _headerView.listM = listModel;
    _headerView.addrM = addrM;
    _headerView.frame = CGRectMake(0, 0, SCREENWidth, 200);
    _orderDetailTableView.tableHeaderView = _headerView;
    
    if(listModel.tradeWay == 2){
        _footerView = [[RRFOrderDetailFooterView alloc]init];
        _footerView.listM = listModel;
        _footerView.frame = CGRectMake(0, 0, SCREENWidth, 130);
        _orderDetailTableView.tableFooterView = _footerView;
    }

    _bottomView = [[RRFOrderDetailFooterBarView alloc]init];
    [_bottomView.clickBtn setTitle:[listModel.statusVal orderState] forState:UIControlStateNormal];
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(_orderDetailTableView.mas_bottom).offset(0);
    }];
    _bottomView.footBarBlock = ^(NSNumber *type){
        int typeInt = [type intValue];
        if (typeInt == 1) {// 客服
            [weakSelf call];
        }else{// 待处理的订单
            
            if ([listModel.statusVal isEqualToString:@"1"]) {
                // 1:签收
                [weakSelf dealWithOrderId:listModel.orderId];
            }else if([listModel.statusVal isEqualToString:@"2"]){
                // 2:评价
                [weakSelf goCommentControllerWithListM:listModel];
            }else if([listModel.statusVal isEqualToString:@"0"]){
                //0:提醒发货
                [weakSelf  remindWithTradeOrderId:listModel.orderId];
            }else if([listModel.statusVal isEqualToString:@"3"]){
                RRFShareOrderDetailInfoController *desc = [[RRFShareOrderDetailInfoController alloc]init];
                desc.title = @"晒单详情";
                desc.showOrderType =  RRFShowOrderTypeGift;
                desc.giftOrderShowId = listModel.ID;
                [weakSelf.navigationController pushViewController:desc animated:YES];
            }
        }
        if (weakSelf.refreBlock) {
            weakSelf.refreBlock(@(YES));
        }
    };
   
}
-(void)remindWithTradeOrderId:(NSNumber *)tradeOrderId
{
    [RRFMeTool stockWinOrderShowWithTradeOrderId:[tradeOrderId integerValue] Success:^(id json) {
        [MBProgressHUD showInfoWithStatus:@"提醒成功!"];
    } failBlock:^(id json) {
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _productList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RRFProductModel *model = _productList[indexPath.row];
    RRFOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRFOrderDetailController"];
    if (cell == nil) {
        cell = [[RRFOrderListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RRFOrderDetailController"];
    }
    model.tradeWay = _tradeWay;
    cell.model = model;
    return cell;
}
-(void)call
{
    RRFPhoneListModel *model = [Singleton sharedInstance].phoneListM;
    NSString *northPhoneNum = model.tel;
    if (northPhoneNum.length == 0) {
        northPhoneNum = @"";
    }
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",northPhoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(void)goCommentControllerWithListM:(RRFOrderListModel *)listM
{
    // 去评价
    RRFRemarkViewController *desc = [[RRFRemarkViewController alloc]init];
    desc.title = @"晒单";
    desc.showOrderType = RRFShowOrderTypeGift;
    desc.listModel = listM;
    [self.navigationController pushViewController:desc animated:YES];
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

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
@end
