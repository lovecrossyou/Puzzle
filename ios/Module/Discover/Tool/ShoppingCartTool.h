//
//  ShoppingCartTool.h
//  PrivateTeaStall
//
//  Created by 朱理哲 on 16/6/16.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JNQPresentProductModel;
@interface ShoppingCartTool : NSObject
+(NSMutableArray*)loadShoppingCart;
+(void)addOrUpdatePoduct:(JNQPresentProductModel *)productM;
+(void)delShoppingCart:(id)shoppingCart;
+(void)delProduct:(id)product;
+(NSInteger)queryShoppingCarCount;

//+(void)createOrder:(HBCreateOrderModel*)orderModel  successBlock:(HBRequestSuccess)success  fail:(HBRequestFailure)failBlock;
//+(void)queryChannel:(NSString*)channel orderId:(NSString*)orderId  successBlock:(HBRequestSuccess)success  fail:(HBRequestFailure)failBlock;
@end
