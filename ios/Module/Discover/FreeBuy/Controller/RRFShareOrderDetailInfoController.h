//
//  RRFShareOrderDetailInfoController.h
//  Puzzle
//
//  Created by huipay on 2016/12/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZBaseTableViewController.h"
@interface RRFShareOrderDetailInfoController : PZBaseTableViewController
// 中奖订单的id
@property(nonatomic,assign)NSInteger winingOrderShowId;
// 礼品订单的id
@property(nonatomic,assign)NSInteger giftOrderShowId;
// 0元夺宝订单的id
@property(nonatomic,assign)NSInteger purchaseGameShowId;

@property(nonatomic,assign)RRFShowOrderType showOrderType;

@end
