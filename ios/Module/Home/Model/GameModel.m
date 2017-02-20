
//
//  GameModel.m
//  Puzzle
//
//  Created by huipay on 2016/8/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "GameModel.h"
@implementation StockModel
@end

@implementation GameModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"content" : [StockModel class]
             };
}
@end
