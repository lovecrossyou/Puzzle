//
//  RRFOrderListModel.m
//  Puzzle
//
//  Created by huibei on 16/8/27.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFOrderListModel.h"
#import "RRFProductModel.h"

@implementation RRFOrderListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"products" : [RRFProductModel class]};
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id",
             };
}
@end
