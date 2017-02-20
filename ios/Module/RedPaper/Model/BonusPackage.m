//
//  BonusPackage.m
//  Puzzle
//
//  Created by huibei on 17/1/16.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "BonusPackage.h"

@implementation BonusPackage
-(instancetype)initWithBonusType:(NSString *)bonusType count:(NSInteger)count averageMount:(NSInteger)averageMount totalMount:(NSInteger)totalMount desc:(NSString *)desc place:(NSString *)place{
    if (self = [super init]) {
        self.bonusType = bonusType ;
        self.count = count ;
        self.averageMount = averageMount ;
        self.totalMount = totalMount ;
        self.desInfo = desc ;
        self.place = place ;
    }
    return self ;
}
@end
