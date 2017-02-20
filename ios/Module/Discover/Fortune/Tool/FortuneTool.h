//
//  FortuneTool.h
//  Puzzle
//
//  Created by huibei on 16/12/19.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FortuneTool : NSObject
//用户运程基本信息
///fortune/userFortuneInfo
+(void)getuserFortuneInfoSuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;

//fortune/computeFortune
+(void)computeFortune:(NSString*)birthday fortuneDay:(NSString*)fortuneDay gender:(NSInteger)gender  successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
///fortune/recordList

+(void)getRecordListListWithPageNo:(int)no pageSize:(int)size successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;

//运程商品列表
+(void)getFortuneListSuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;

@end
