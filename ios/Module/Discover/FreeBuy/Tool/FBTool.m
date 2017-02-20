//
//  FBTool.m
//  Puzzle
//
//  Created by huibei on 16/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "FBTool.h"
#import "PZParamTool.h"
#import "YYModel.h"
#import "PZAccessInfo.h"
#import "PZHttpTool.h"

@implementation FBTool
//夺宝商品列表 purchaseGame/list
+(void)getPurchaseGameListWithPageNo:(int)no pageSize:(int)size FilterDic:(NSDictionary *)filterDic SuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfoNotLogin];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:filterDic];
    [param setObject:@(no) forKey:@"pageNo"];
    [param setObject:@(size) forKey:@"size"];
    [param setObject:[accessInfo yy_modelToJSONObject] forKey:@"accessInfo"];
    [PZHttpTool postRequestUrl:@"purchaseGame/list" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}
// 夺宝揭晓（往期揭晓、首页全部揭晓）
+(void)getPurchaseGameOpenListWithPageNo:(int)no pageSize:(int)size ProductId:(NSInteger)productId Status:(NSString *)status  SuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    if(productId !=0){
        status = @"" ;
    }
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfoNotLogin];
    NSDictionary* params = @{
                             @"pageNo":@(no),
                             @"size":@(size),
                             @"accessInfo":[accessInfo yy_modelToJSONObject],
                             @"productId":@(productId),
                             @"status":status
                             };
    [PZHttpTool postRequestUrl:@"purchaseGame/open" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}
//8、晒单列表
+(void)getShareOrderListWithPageNo:(int)no pageSize:(int)size PurchaseGameId:(NSInteger)purchaseGameId Stage:(NSString *)stage ProductId:(NSInteger)productId isAll:(NSString *)isAll SuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    if (productId != 0) {
        isAll = @"no" ;
    }
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfoNotLogin];
    NSDictionary* params = @{
                             @"pageNo":@(no),
                             @"size":@(size),
                             @"accessInfo":[accessInfo yy_modelToJSONObject],
                             @"purchaseGameId":@(purchaseGameId),
                             @"stage":stage,
                             @"isAll":isAll,
                             @"productId":@(productId)
                             };
    [PZHttpTool postRequestUrl:@"purchaseGame/show/list" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

//purchaseGameActivity/list
+(void)getPurchaseGameActivity:(NSString*)activityCategory
 successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfoNotLogin];
    NSDictionary* params = @{
                             @"accessInfo":[accessInfo yy_modelToJSONObject],
                             @"activityCategory":activityCategory
                             };
    [PZHttpTool postRequestUrl:@"activity/list" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

//
+(void)getNewstWinSuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfoNotLogin];
    NSDictionary* params = @{
                             @"accessInfo":[accessInfo yy_modelToJSONObject]
                             };
    [PZHttpTool postRequestUrl:@"purchaseGame/newestWin" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}
@end
