//
//  PurchaseGameActivity.m
//  Puzzle
//
//  Created by huibei on 16/12/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PurchaseGameActivity.h"

@implementation PurchaseGameActivity
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"ID" : @"id"
             };
}

@end

@implementation PurchaseGameActivityList
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"content": [PurchaseGameActivity class]
             };
}
@end
