//
//  StockDetailModel.m
//  Puzzle
//
//  Created by huipay on 2016/8/30.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "StockDetailModel.h"

@implementation StockDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"content" : [StockModel class]
             };
}
@end
