//
//  JNQHttpTool.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FortuneProductList.h"

typedef NS_ENUM(NSInteger, OrderType) {
    OrderTypeVIP       = 1,        //会员支付
    OrderTypeDiamond   = 2         //钻石支付
};

typedef void(^JNQRequestSuccess) (id json);
typedef void(^JNQRequestFailure) (id json);

@interface JNQHttpTool : NSObject

+ (void)JNQHttpRequestWithURL:(NSString *)URL requestType:(NSString *)requestType showSVProgressHUD:(BOOL)show parameters:(NSDictionary *)params successBlock:(JNQRequestSuccess)successBlock failureBlock:(JNQRequestFailure)failureBlock;
+ (void)payOrderWithType:(OrderType)orderType productId:(NSInteger)productId totalParice:(NSInteger)totalPrice successBlock:(JNQRequestSuccess)successBlock failureBlock:(JNQRequestFailure)failureBlock;
+ (void)payHautOrderWithFortuneProduct:(FortuneProduct *)productM successBlock:(JNQRequestSuccess)successBlock failureBlock:(JNQRequestFailure)failureBlock;
+ (NSString *)errorDataString:(NSError *)errorData;
+ (id)toArrayOrNSDictionary:(NSError *)errorData;

@end
