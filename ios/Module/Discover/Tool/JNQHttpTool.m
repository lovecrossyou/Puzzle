//
//  JNQHttpTool.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQHttpTool.h"
#import "PZHttpTool.h"
#import "PZParamTool.h"
#import "PZAccessInfo.h"
#import "PZMMD5.h"
#import "JNQOrderModel.h"
#import "JNQProductModel.h"


@implementation JNQHttpTool


+ (void)payOrderWithType:(OrderType)orderType productId:(NSInteger)productId totalParice:(NSInteger)totalPrice successBlock:(JNQRequestSuccess)successBlock failureBlock:(JNQRequestFailure)failureBlock {
    JNQOrderModel *orderModel = [[JNQOrderModel alloc] init];
    if (orderType == OrderTypeDiamond) {
        orderModel.totalPrice = totalPrice;
        orderModel.totalProductCount = totalPrice;
        orderModel.productType = 2;
        orderModel.orderType = 1;
        orderModel.productList = @[];
    } else if (orderType == OrderTypeVIP) {
        JNQProductModel *productModel = [[JNQProductModel alloc] init];
        productModel.productId = productId;
        productModel.totalCount = 1;
        productModel.price = totalPrice;
        productModel.shopId = 1;
        orderModel.productList = @[productModel];
        orderModel.totalPrice = totalPrice;
        orderModel.totalProductCount = 1;
        orderModel.productType = orderType;
        orderModel.orderType = 1;
    }
    NSDictionary *params = [orderModel yy_modelToJSONObject];
    [JNQHttpTool JNQHttpRequestWithURL:@"createTradeOrder" requestType:@"post" showSVProgressHUD:YES parameters:params successBlock:^(id json) {
        successBlock(json);
    } failureBlock:^(id json) {
        failureBlock(json);
    }];
}

+ (void)payHautOrderWithFortuneProduct:(FortuneProduct *)productM successBlock:(JNQRequestSuccess)successBlock failureBlock:(JNQRequestFailure)failureBlock {
    JNQOrderModel *orderModel = [[JNQOrderModel alloc] init];
    JNQProductModel *productModel = [[JNQProductModel alloc] init];
    productModel.productId = productM.productId;
    productModel.totalCount = 1;
    productModel.price = productM.price;
    productM.shopId = productM.shopId;
    orderModel.productList = @[productModel];
    orderModel.totalPrice = productM.price;
    orderModel.totalProductCount = 1;
    orderModel.productType = productM.productType;
    orderModel.orderType = 1;
    NSDictionary *params = [orderModel yy_modelToJSONObject];
    [JNQHttpTool JNQHttpRequestWithURL:@"createTradeOrder" requestType:@"post" showSVProgressHUD:YES parameters:params successBlock:^(id json) {
        successBlock(json);
    } failureBlock:^(id json) {
        failureBlock(json);
    }];
}


+ (void)JNQHttpRequestWithURL:(NSString *)URL requestType:(NSString *)requestType showSVProgressHUD:(BOOL)show parameters:(NSDictionary *)params successBlock:(JNQRequestSuccess)successBlock failureBlock:(JNQRequestFailure)failureBlock {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:params];
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *dict = [accessInfo yy_modelToJSONObject];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    if ([URL isEqualToString:@"diamond/list"] || [URL isEqualToString:@"identity/list"] || [URL isEqualToString:@"product/list"] || [URL isEqualToString:@"product/detail"] || [URL isEqualToString:@"award/list"]) {
        NSString *access_token = @"" ;
        NSString *phone_num = @"" ;
        NSString *signature = [PZMMD5 digest:[NSString stringWithFormat:@"%@",AppSecret]] ;
        [tempDict setObject:access_token forKey:@"access_token"];
        [tempDict setObject:phone_num forKey:@"phone_num"];
        [tempDict setObject:signature forKey:@"signature"];
    }
    [param setObject:tempDict forKey:@"accessInfo"];
    [param addEntriesFromDictionary:params];
    if ([requestType isEqualToString:@"get"]) {
        
        [PZHttpTool getRequestUrl:URL parameters:param successBlock:^(id json) {
            successBlock(json);
        } fail:^(id json) {
            failureBlock(json);
        }];
    } else if ([requestType isEqualToString:@"post"]) {
        if (show) {
            [PZHttpTool postRequestUrl:URL parameters:param successBlock:^(id json) {
                successBlock(json);
            } fail:^(id json) {
                failureBlock(json);
            }];
        } else {
            [PZHttpTool postRequestUrl:URL showSVProgressHUD:NO parameters:param successBlock:^(id json) {
                successBlock(json);
            } fail:^(id json) {
                failureBlock(json);
            }];
        }
    } else if ([requestType isEqualToString:@"put"]) {
        [PZHttpTool putRequestUrl:URL parameters:param successBlock:^(id json) {
            successBlock(json);
        } fail:^(id json) {
            failureBlock(json);
        }];
    } else if ([requestType isEqualToString:@"other"]) {
        [PZHttpTool postHttpRequestUrl:URL parameters:param successBlock:^(id json) {
            successBlock(json);
        } fail:^(id json) {
            failureBlock(json);
        }];
    }
}

+ (NSString *)errorDataString:(NSError *)errorData {
    NSString *errorString;
    id error = [self toArrayOrNSDictionary:errorData];
    id errorMsg = error[@"message"] ;
    if (![errorMsg isNull]&&[errorMsg isKindOfClass:[NSString class]]) {
        errorString = errorMsg;
    }
    return errorString;
}

+ (id)toArrayOrNSDictionary:(NSError *)errorData {
    NSError *error = nil;
    if ([errorData.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"]) {
        NSData* data = errorData.userInfo[@"com.alamofire.serialization.response.error.data"];
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
        
        if (jsonObject != nil && error == nil){
            return jsonObject;
        }else{
            // 解析错误
            return nil;
        }
    } else if ([errorData.userInfo objectForKey:@"NSLocalizedDescription"]) {
//        [SVProgressHUD showWithStatus:[errorData.userInfo objectForKey:@"NSLocalizedDescription"]];
        return nil;
    } else {
        return nil;
    }
}

@end
