//
//  RRFFreeBuyOrderTool.h
//  Puzzle
//
//  Created by huipay on 2016/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RRFRequestAcceptPrizeModel;
@interface RRFFreeBuyOrderTool : NSObject
+(void)requestFreeBuyOrderListWithStatus:(NSString *)status isEvaluate:(NSString *)isEvaluate pageNo:(int)pageNo Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 领取奖品
+(void)requestAcceptPrizeWithParam:(NSMutableDictionary *)param Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
//签收
+(void)requestSignInWithBidOrderId:(NSInteger )bidOrderId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 晒单
+(void)requestShowOrderWithBidOrderId:(NSInteger )bidOrderId content:(NSString *)content isSynchoron:(int)isSynchoron pictures:(NSArray*)pictures Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 中奖订单晒单
+(void)requestShowWiningOrderWithTradeOrderId:(NSInteger )tradeOrderId content:(NSString *)content isSynchoron:(int)isSynchoron pictures:(NSArray*)pictures Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 获取收获地址
+(void)requestAddressWithSuccess:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
@end
