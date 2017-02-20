//
//  BonusPackage.h
//  Puzzle
//
//  Created by huibei on 17/1/16.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BonusPackage : NSObject

@property NSString* bonusType ;
@property NSInteger count ;
@property NSInteger averageMount ;
@property NSInteger totalMount ;
@property NSString* desInfo ;
@property NSString* place ;

-(instancetype)initWithBonusType:(NSString*)bonusType count:(NSInteger)count averageMount:(NSInteger)averageMount totalMount:(NSInteger)totalMount desc:(NSString*)desc place:(NSString*)place;


/**
 * 红包的类型
 */
//String bonusType;
///**
// * 红包的数量
// */
//Long count;
///**
// * 平均红包  每个红包的金额
// */
//Long averageMount;
///**
// * 随机红包 总共的金额
// */
//Long totalMount;
///**
// * 红包的备注
// */
//String description;
//
///**
// * 红包场所
// */
//String place;
@end
