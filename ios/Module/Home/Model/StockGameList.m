
//
//  StockGameList.m
//  Puzzle
//
//  Created by huipay on 2016/8/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "StockGameList.h"
#import "GameModel.h"
@implementation StockGameList
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"content" : [GameModel class]
             };
}
@end
