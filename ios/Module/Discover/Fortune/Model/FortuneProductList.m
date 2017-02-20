//
//  FortuneProductList.m
//  Puzzle
//
//  Created by huibei on 16/12/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "FortuneProductList.h"

@implementation FortuneProduct
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"desc" : @"description"
             };
}
@end

@implementation FortuneProductList
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"fortuneList" : [FortuneProduct class]
             };
}
@end
