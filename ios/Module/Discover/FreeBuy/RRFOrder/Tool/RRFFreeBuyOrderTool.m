//
//  RRFFreeBuyOrderTool.m
//  Puzzle
//
//  Created by huipay on 2016/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFFreeBuyOrderTool.h"
#import "PZHttpTool.h"
#import "PZParamTool.h"
#import "PZAccessInfo.h"
#import "LoginModel.h"
#import "Singleton.h"
#import "PZMMD5.h"
#import "RRFRequestAcceptPrizeModel.h"

@implementation RRFFreeBuyOrderTool
+(void)requestFreeBuyOrderListWithStatus:(NSString *)status isEvaluate:(NSString *)isEvaluate pageNo:(int)pageNo Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[accessInfo yy_modelToJSONObject] forKey:@"accessInfo"];
    [param setObject:status forKey:@"bidOrderStatus"];
    [param setObject:@(pageNo) forKey:@"pageNo"];
    [param setObject:@(20) forKey:@"size"];
    [param setObject:isEvaluate forKey:@"isEvaluate"];
    [PZHttpTool postRequestUrl:@"bidOrder/list" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
        NSLog(@"夺宝订单");
    }];
    
}

//请求路径：/bidOrder/acceptPrize
//请求方法：POST
//请求参数：
//
//{
//    "accessInfo":{
//        "app_key":"b5958b665e0b4d8cae77d28e1ad3f521",
//        "access_token":"e1b2478b957f412d9f94a7c545eda082",
//        "phone_num":"18601250910",
//        "signature":"4CC219C0F50F4BDAB6F3CA9F35001014"
//    },
//    "bidOrderId": 1,
//    "deliveryAddressId": null,
//    "recievName":"某某某",
//    "phoneNum":"13436836055",
//    "districtAddress":"北京市西城区",
//    "detailAddress":"百万庄大街11号粮科大厦",
//    "fullAddress":"北京市西城区百万庄大街11号粮科大厦"
//}
// 领取奖品
+(void)requestAcceptPrizeWithParam:(NSMutableDictionary *)param Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    [param setObject:[accessInfo yy_modelToJSONObject] forKey:@"accessInfo"];
    [PZHttpTool postRequestUrl:@"bidOrder/acceptPrize" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
        NSLog(@"领取奖品");
    }];

}

//请求路径：/bidOrder/signIn
//请求方法：POST
//请求参数：
//
//{
//    "accessInfo":{
//        "app_key":"b5958b665e0b4d8cae77d28e1ad3f521",
//        "access_token":"e1b2478b957f412d9f94a7c545eda082",
//        "phone_num":"18601250910",
//        "signature":"4CC219C0F50F4BDAB6F3CA9F35001014"
//    },
//    "bidOrderId": 1
//}
//签收
+(void)requestSignInWithBidOrderId:(NSInteger )bidOrderId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"bidOrderId":@(bidOrderId),
                            @"accessInfo":[accessInfo yy_modelToJSONObject]
                            };
    [PZHttpTool postRequestUrl:@"bidOrder/signIn" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
        NSLog(@"领取奖品");
    }];
    
}

//请求路径：/purchaseGame/show/add
//请求方法：POST
//请求参数：
//
//{
//    "accessInfo":{
//        "app_key":"xxxxxxxxx",
//        "access_token":"",
//        "phone_num":"xxxxxxxxx",
//        "signature":"xxxxxxxxx"
//    },
//    "bidOrderId":1 //夺宝订单ID，long类型
//    "content":"中奖喽，晒个单", //晒单内容，String
//    "isSynchoron":true,//是否同步到朋友圈
//    "pictures":[
//                {
//                    "head_img":"",
//                    "big_img":""
//                }
//                ]
//}
// 晒单
+(void)requestShowOrderWithBidOrderId:(NSInteger )bidOrderId content:(NSString *)content isSynchoron:(int)isSynchoron pictures:(NSArray*)pictures Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    NSString *synchoron = isSynchoron == 1?@"yes":@"no";
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"bidOrderId":@(bidOrderId),
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"content":content,
                            @"isSynchoron":synchoron,
                            @"pictures":pictures
                            };
    [PZHttpTool postRequestUrl:@"purchaseGame/show/add" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
        NSLog(@"晒单");
    }];
    
}

// 中奖订单晒单
+(void)requestShowWiningOrderWithTradeOrderId:(NSInteger )tradeOrderId content:(NSString *)content isSynchoron:(int)isSynchoron pictures:(NSArray*)pictures Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"tradeOrderId":@(tradeOrderId),
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"content":content,
                            @"isSynchoron":@"yes",
                            @"pictures":pictures
                            };
    [PZHttpTool postRequestUrl:@"stockWinOrderShow" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
        NSLog(@"晒单");
    }];
    
}

//请求路径：/deliveryAddress/getByUser
//请求方法：POST
//请求参数：
//
//{
//    "accessInfo":{
//        "app_key":"b5958b665e0b4d8cae77d28e1ad3f521",
//        "access_token":"e1b2478b957f412d9f94a7c545eda082",
//        "phone_num":"18601250910",
//        "signature":"4CC219C0F50F4BDAB6F3CA9F35001014"
//    }
//}
// 获取收获地址
+(void)requestAddressWithSuccess:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject]
                            };
    [PZHttpTool postRequestUrl:@"deliveryAddress/getByUser" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
        NSLog(@"收获地址");
    }];
    
}
@end
