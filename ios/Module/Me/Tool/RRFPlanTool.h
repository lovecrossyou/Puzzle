//
//  RRFPlanTool.h
//  Puzzle
//
//  Created by huibei on 16/9/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RRFApplyDelegaterModel;
@interface RRFPlanTool : NSObject
// 申请认证
+(void)requestApplyDelegaterWithModel:(RRFApplyDelegaterModel *)model Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
//喜鹊计划
+(void)requestDelegaterMyDelegaterInfoMsgInfoWithSuccess:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
//我的代理购买列表
+(void)requestDelegaterLowerLevelListWithUrl:(NSString *)url PageNo:(int)pageNo size:(int)size level:(NSString *)level Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 我的代理信息
+(void)requestDelegaterMyDelegaterInfoWithUrl:(NSString *)url Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
//a级用户列表
+(void)requestDelegaterUserLowerLevelBListWithPageNo:(int)pageNo size:(int)size level:(NSString *)level  userId:(NSInteger)userId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 代理的钻石列表
+(void)requestDelegaterDiamondListWithPageNo:(int)pageNo size:(int)size Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 购买钻石
+(void)payDiamondWithProductList:(NSArray *)productList totalPrice:(NSInteger)totalPrice totalProductCount:(NSInteger)totalProductCount Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
@end
