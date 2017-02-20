
//
//  ShoppingCartTool.m
//  PrivateTeaStall
//
//  Created by 朱理哲 on 16/6/16.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "ShoppingCartTool.h"
#import <Realm/Realm.h>
#import "JNQHttpTool.h"
#import "JNQPresentProductModel.h"

@interface ShoppingCartTool () {
}
@property (nonatomic, strong) NSMutableDictionary *dict;

@end
@implementation ShoppingCartTool

+ (NSMutableArray*)loadShoppingCart {
    RLMResults* results = [JNQPresentProductModel objectsWhere:@"validState !='delete'"];
    NSMutableArray* shoppingCarts = [NSMutableArray array];
    for (id shoppingCartM in results) {
        [shoppingCarts addObject:shoppingCartM];
    }
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    for (JNQPresentProductModel *model in shoppingCarts) {
//        NSMutableArray *array = [dict objectForKey:@(model.shopId)];
//        if (!array) {
//            array = [NSMutableArray array];
//        }
//        [array addObject:model];
//        [dict setObject:array forKey:@(model.shopId)];
//        NSLog(@"1");
//    }
//    NSMutableArray *temp = [NSMutableArray arrayWithArray:[dict allValues]];
    if (shoppingCarts.count) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:@[shoppingCarts]];
        return array;
    } else {
        return shoppingCarts;
    }
}

+ (NSInteger)queryShoppingCarCount {
    RLMResults *results = [JNQPresentProductModel allObjects];
    int shoppingCarCount = 0 ;
    if (results!= nil && results.count > 0) {
        for (JNQPresentProductModel *productM in results) {
            shoppingCarCount += productM.count;
        }
    }else{
        shoppingCarCount = 0;
    }
   return shoppingCarCount;
}

+ (void)addOrUpdatePoduct:(JNQPresentProductModel *)productM {
    // Open the default Realm file
    RLMRealm *defaultRealm = [RLMRealm defaultRealm];
    [defaultRealm beginWriteTransaction];
    NSInteger productId = productM.productId;
    RLMResults *results = [JNQPresentProductModel objectsWhere:[NSString stringWithFormat:@"productId == %ld",(long)productId]];
    if (results!= nil && results.count >0) {
        JNQPresentProductModel *model = [results firstObject];
        model.count += 1;
    }
    else{
        productM.selected = @(1) ;
        productM.count = 1 ;
        [defaultRealm addObject:productM];
    }
    [defaultRealm commitWriteTransaction];
}



+ (void)delShoppingCart:(id)shoppingCart {
    
}

+ (void)delProduct:(id)product {
    
}

//+(void)createOrder:(HBCreateOrderModel*)orderModel  successBlock:(HBRequestSuccess)success  fail:(HBRequestFailure)failBlock;{
//    NSArray* productlist = [orderModel.productList yy_modelToJSONObject];
//    for (NSDictionary* d in productlist) {
//        [d setValue:d[@"teaStoreCardId"] forKey:@"productId"];
//        [d setValue:d[@"totalAmount"] forKey:@"totalCount"];
//        [d setValue:d[@"totalPrice"] forKey:@"price"];
//    }
//    NSDictionary* params = [orderModel yy_modelToJSONObject];
//    [params setValue:productlist forKey:@"productList"];
//    [HBHttpTool postRequestWithUrl:@"createTradeOrder" parameters:params successBlock:^(id json) {
//        success(json);
//    } fail:^(id json) {
//        failBlock(json);
//    }];
//}

//+(void)queryChannel:(NSString *)channel orderId:(NSString *)orderId successBlock:(HBRequestSuccess)success fail:(HBRequestFailure)failBlock{
//    NSDictionary* params = @{
//        @"channel":channel,
//        @"orderId":orderId
//     };
//    [HBHttpTool postRequestWithUrl:@"tradeOrder/query" parameters:params successBlock:^(id json) {
//        success(json);
//    } fail:^(id json) {
//        
//    }];
//}


@end
