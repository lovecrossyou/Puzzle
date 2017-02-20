//
//  RRFOrderListModel.h
//  Puzzle
//
//  Created by huibei on 16/8/27.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRFOrderListModel : NSObject
//{
//    addressId = 8;
//    createTime = "2016-09-12 15:59";
//    expressFee = 0;
//    orderId = 77;
//    products =             (
//                            {
//                                count = 1;
//                                picUrl = "";
//                                productId = 14;
//                                productName = "\U82f9\U679c6";
//                                xtbPrice = 2220;
//                            }
//                            );
//    status = "\U5f85\U53d1\U8d27";
//    statusVal = 0;
//    tradeWay = 2;
//    userId = 76;
//    xtbPrice = 100;
//}

@property(nonatomic,assign)NSInteger addressId;
@property(nonatomic,strong)NSString *createTime;
// 快递费
@property(nonatomic,assign)CGFloat expressFee;
// 订单号
@property(nonatomic,strong)NSNumber *orderId;
@property(nonatomic,assign)NSInteger ID;

@property(nonatomic,strong)NSString *status;
//create(0, "待发货"),
//send(1, "已发货"),
//finish(2, "已收货"),
//evaluate(3, "已评价"),
//acceptPrize(4, "已领奖"),
@property(nonatomic,strong)NSString *statusVal;
@property(nonatomic,assign)NSInteger userId;
// 订单金额
@property(nonatomic,assign)CGFloat xtbPrice;

@property(nonatomic,strong)NSArray *products;
//(2, "商品兑换"),(5, "领取奖品"
@property(nonatomic,assign)NSInteger tradeWay;


@end
