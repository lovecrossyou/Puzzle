//
//  RRFPlanTool.m
//  Puzzle
//
//  Created by huibei on 16/9/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFPlanTool.h"
#import "PZHttpTool.h"
#import "PZParamTool.h"
#import "PZAccessInfo.h"
#import "LoginModel.h"
#import "RRFApplyDelegaterModel.h"

@implementation RRFPlanTool
// 申请认证
+(void)requestApplyDelegaterWithModel:(RRFApplyDelegaterModel *)model Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    NSDictionary *param = [NSMutableDictionary dictionaryWithDictionary:[model yy_modelToJSONObject]];
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    [param setValue:[accessInfo yy_modelToJSONObject] forKey:@"accessInfo"];
    [PZHttpTool postRequestUrl:@"delegater/applyDelegater" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}

//5、喜鹊计划
+(void)requestDelegaterMyDelegaterInfoMsgInfoWithSuccess:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject]
                            };
    [PZHttpTool postRequestUrl:@"delegater/myDelegaterInfoMsg" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
//我的代理购买列表
+(void)requestDelegaterLowerLevelListWithUrl:(NSString *)url PageNo:(int)pageNo size:(int)size level:(NSString *)level Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"pageNo":@(pageNo),
                            @"size":@(size),
                            @"level":level
                            };
    [PZHttpTool postRequestUrl:url parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
// 我的代理信息
+(void)requestDelegaterMyDelegaterInfoWithUrl:(NSString *)url Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject]
                            };
    [PZHttpTool postRequestUrl:url parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
+(void)requestDelegaterUserLowerLevelBListWithPageNo:(int)pageNo size:(int)size level:(NSString *)level  userId:(NSInteger)userId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"pageNo":@(pageNo),
                            @"size":@(size),
                            @"level":level,
                            @"userId":@(userId)
                            };
    [PZHttpTool postRequestUrl:@"delegater/userLowerLevelBList" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}

// 代理的钻石列表
+(void)requestDelegaterDiamondListWithPageNo:(int)pageNo size:(int)size Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"pageNo":@(pageNo),
                            @"size":@(size)
                            };
    [PZHttpTool postRequestUrl:@"delegater/diamond/list" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
// 购买钻石
+(void)payDiamondWithProductList:(NSArray *)productList totalPrice:(NSInteger)totalPrice totalProductCount:(NSInteger)totalProductCount Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"productList":productList,
                            @"totalPrice":@(totalPrice),
                            @"totalProductCount":@(totalProductCount),
                            @"productType":@(5),
                            @"orderType":@(2)
                            };
    [PZHttpTool postRequestUrl:@"delegater/diamond/createTradeOrder" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
@end
