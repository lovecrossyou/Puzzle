//
//  FortuneTool.m
//  Puzzle
//
//  Created by huibei on 16/12/19.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "FortuneTool.h"
#import "PZParamTool.h"
#import "YYModel.h"
#import "PZAccessInfo.h"
#import "PZHttpTool.h"

@implementation FortuneTool
//用户运程基本信息
///fortune/userFortuneInfo
+(void)getuserFortuneInfoSuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfoNotLogin];
    NSDictionary* params = @{
                             @"accessInfo":[accessInfo yy_modelToJSONObject]
                             };
    [PZHttpTool postRequestUrl:@"fortune/userFortuneInfo" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];

}


//fortune/computeFortune
+(void)computeFortune:(NSString*)birthday fortuneDay:(NSString*)fortuneDay gender:(NSInteger)gender  successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfoNotLogin];
    NSDictionary* params = @{
                             @"birthday":birthday,
                             @"fortuneDay":fortuneDay,
                             @"sex":@(gender),
                             @"accessInfo":[accessInfo yy_modelToJSONObject]
                             };
    [PZHttpTool postRequestUrl:@"fortune/computeFortune" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

///fortune/recordList
+(void)getRecordListListWithPageNo:(int)no pageSize:(int)size successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfoNotLogin];
    NSDictionary* params = @{
                             @"pageNo":@(no),
                             @"size":@(size),
                             @"accessInfo":[accessInfo yy_modelToJSONObject]
                             };
    [PZHttpTool postRequestUrl:@"fortune/recordList" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

//运程商品列表
+(void)getFortuneListSuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfoNotLogin];
    NSDictionary* params = @{
                             @"accessInfo":[accessInfo yy_modelToJSONObject]
                             };
    [PZHttpTool postRequestUrl:@"fortune/list" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

@end
