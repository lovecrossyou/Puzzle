//
//  RRFBillCellModel.h
//  Puzzle
//
//  Created by huibei on 16/9/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRFBillCellModel : NSObject
//{
//    "date":"08-29",  //日期，月-日，String
//    "time":"09:56",  //时间，String
//    "amount":"-88",  //金额，String
//    "description":"钻石购买会员",//详情中的描述，String
//    "operationType":12,//操作类型，Integer，见下面详细说明
//    "orderId":10000865,//订单ID，Long
//    "price":"", //支付价格，String
//    "createTime":"2016-08-29 09:56:37",//时间，String
//    "xtbCount":88,  //钻石兑换喜腾币的数量，Long
//    "identityType":"黄金会员",  //购买的会员类型，String
//    "detail":""  //描述，String
//}
//操作类型operationType说明： 0：钻石打赏 4：玩游戏支出 //5：钻石兑换  6：购买会员 8：投注亏损
//0：钻石打赏  1：购买钻石  2：平台创建钻石  3：平台赠送  4：玩游戏支出
//5：钻石兑换  6：购买会员  7：投注盈利     8：投注亏损  9：兑换商品
//10：平台创建喜腾币  11：返还本金  12：钻石购买会员


//currencyType：货币类型
//xtb(1, "喜腾币"),
//diamond(2, "钻石"),
//rmb(3, "人民币");
//货币类型
@property(nonatomic,strong)NSString *currencyType;
//日期
@property(nonatomic,strong)NSString *date;
//时间
@property(nonatomic,strong)NSString *time;
//金额
@property(nonatomic,strong)NSString *amount;
//详情中的描述
@property(nonatomic,strong)NSString *descriptionStr;
///操作类型
@property(nonatomic,assign)NSInteger operationType;
//订单ID
@property(nonatomic,strong)NSNumber *orderId;
//支付价格
@property(nonatomic,strong)NSString *price;
//时间
@property(nonatomic,strong)NSString *createTime;
//钻石兑换喜腾币的数量
@property(nonatomic,assign)NSInteger xtbCount;
//购买的会员类型
@property(nonatomic,strong)NSString *identityType;
//描述
@property(nonatomic,strong)NSString *detail;



@end

