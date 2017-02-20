//
//  RRFShowOrderInfoView.h
//  Puzzle
//
//  Created by huipay on 2017/2/9.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ExchangeOrderListModel,AwardOrderModel,BidOrderModel;
@interface RRFShowOrderInfoView : UIView
// 礼品兑换订单详情
@property(nonatomic,strong)ExchangeOrderListModel *exchangeOrderModel;
// 中奖订单详情
@property(nonatomic,strong)AwardOrderModel *awardOrderModel;
// 0元夺宝的订单详情
@property(nonatomic,strong)BidOrderModel *bidOrderModel;
@end
