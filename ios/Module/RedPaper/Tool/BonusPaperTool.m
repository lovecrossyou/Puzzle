//
//  BonusPaperTool.m
//  Puzzle
//
//  Created by huibei on 17/1/16.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "BonusPaperTool.h"
#import "BonusPackage.h"
#import "PZAccessInfo.h"
#import "PZHttpTool.h"
#import "PZParamTool.h"
#import "BonusPaperModel.h"
@implementation BonusPaperTool
+(void)sendBonusPaper:(BonusPackage *)paper Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail{
    NSDictionary* bonusPaperParam = [paper yy_modelToJSONObject];
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithDictionary:bonusPaperParam];
    [parameters setObject:[accessInfo yy_modelToJSONObject] forKey:@"accessInfo"];
    [PZHttpTool postRequestUrl:@"client/bonusPackage/createBonusPackage" parameters:parameters successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}

//2、单聊 点击红包
+(void)singleDraw:(NSInteger)bonusPackageId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary* parameters = @{
                             @"bonusPackageId":@(bonusPackageId),
                             @"accessInfo":[accessInfo yy_modelToJSONObject]
                        };
    [PZHttpTool postRequestUrl:@"client/bonusPackage/singleDraw" parameters:parameters successBlock:^(id json) {
        BonusPaperModel* model = [BonusPaperModel yy_modelWithJSON:json];
        success(model);
    } fail:^(id json) {
        fail(json);
    }];

}
//3、单聊 拆开红包
+(void)singleOpenBonus:(NSInteger)bonusPackageId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary* parameters = @{
                                 @"bonusPackageId":@(bonusPackageId),
                                 @"accessInfo":[accessInfo yy_modelToJSONObject]
                                 };
    [PZHttpTool postRequestUrl:@"client/bonusPackage/singleOpenBonus" parameters:parameters successBlock:^(id json) {
        BonusPaperModel* model = [BonusPaperModel yy_modelWithJSON:json];
        success(model);
    } fail:^(id json) {
        fail(json);
    }];
}
//4、群聊 点击红包
+(void)groupDraw:(NSInteger)bonusPackageId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary* parameters = @{
                                 @"bonusPackageId":@(bonusPackageId),
                                 @"accessInfo":[accessInfo yy_modelToJSONObject]
                                 };
    [PZHttpTool postRequestUrl:@"client/bonusPackage/groupDraw" parameters:parameters successBlock:^(id json) {
        BonusPaperModel* model = [BonusPaperModel yy_modelWithJSON:json];
        success(model);
    } fail:^(id json) {
        fail(json);
    }];
}

//5、群聊 拆开红包
+(void)groupOpenBonus:(NSInteger)bonusPackageId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary* parameters = @{
                                 @"bonusPackageId":@(bonusPackageId),
                                 @"accessInfo":[accessInfo yy_modelToJSONObject]
                                 };
    [PZHttpTool postRequestUrl:@"client/bonusPackage/groupOpenBonus" parameters:parameters successBlock:^(id json) {
        BonusPaperModel* model = [BonusPaperModel yy_modelWithJSON:json];
        success(model);
    } fail:^(id json) {
        fail(json);
    }];
}
//6、查看大家的手气
+(void)lookBonusPackage:(NSInteger)bonusPackageId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary* parameters = @{
                                 @"bonusPackageId":@(bonusPackageId),
                                 @"accessInfo":[accessInfo yy_modelToJSONObject]
                                 };
    [PZHttpTool postRequestUrl:@"client/bonusPackage/lookBonusPackage" parameters:parameters successBlock:^(id json) {
        BonusPaperModel* model = [BonusPaperModel yy_modelWithJSON:json];
        success(model);
    } fail:^(id json) {
        fail(json);
    }];
}
@end
