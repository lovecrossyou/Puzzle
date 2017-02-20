//
//  BonusPaperTool.h
//  Puzzle
//
//  Created by huibei on 17/1/16.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BonusPackage;
@interface BonusPaperTool : NSObject
//1、创建红包
+(void)sendBonusPaper:(BonusPackage *)paper Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
//2、单聊 点击红包
+(void)singleDraw:(NSInteger)bonusPackageId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
//3、单聊 拆开红包
+(void)singleOpenBonus:(NSInteger)bonusPackageId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
//4、群聊 点击红包
+(void)groupDraw:(NSInteger)bonusPackageId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;

//5、群聊 拆开红包
+(void)groupOpenBonus:(NSInteger)bonusPackageId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
//6、查看大家的手气
+(void)lookBonusPackage:(NSInteger)bonusPackageId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
@end
