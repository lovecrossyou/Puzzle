//
//  RRFMyOrderModel.h
//  Puzzle
//
//  Created by huipay on 2016/12/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRFMyOrderModel : NSObject

//礼品订单待评价数量
@property(nonatomic,assign)int presentWaitEvaluateCount;
//礼品订单待收货数量
@property(nonatomic,assign)int presentWaitReceiveCount;
//礼品订单待发货数量
@property(nonatomic,assign)int presentWaitSendCount;

//夺宝订单待领奖数量
@property(nonatomic,assign)int bidOrderWaitAcceptCount;
//夺宝订单待晒单数量
@property(nonatomic,assign)int bidOrderWaitEvaluateCount;
//夺宝订单待揭晓数量
@property(nonatomic,assign)int bidOrderWaitLotteryCount;


//猜涨跌中奖订单待发货数量
@property(nonatomic,assign)int stockWinOrderWaitSendCount;
//猜涨跌中奖订单待收货数量
@property(nonatomic,assign)int stockWinOrderWaitReceiveCount;
//猜涨跌中奖订单待评价数量
@property(nonatomic,assign)int stockWinOrderWaitEvaluateCount;


@end
