//
//  FBTool.h
//  Puzzle
//
//  Created by huibei on 16/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBTool : NSObject
//夺宝商品列表 purchaseGame/list
+(void)getPurchaseGameListWithPageNo:(int)no pageSize:(int)size FilterDic:(NSDictionary *)filterDic SuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
// 夺宝揭晓（往期揭晓、首页全部揭晓）
+(void)getPurchaseGameOpenListWithPageNo:(int)no pageSize:(int)size ProductId:(NSInteger)productId Status:(NSString *)status  SuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
//8、晒单列表
+(void)getShareOrderListWithPageNo:(int)no pageSize:(int)size PurchaseGameId:(NSInteger)purchaseGameId Stage:(NSString *)stage ProductId:(NSInteger)productId isAll:(NSString *)isAll SuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;

//purchaseGameActivity/list
+(void)getPurchaseGameActivity:(NSString*)activityCategory
                  successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
+(void)getNewstWinSuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
@end
