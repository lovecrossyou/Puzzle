//
//  FBShareOrderListModel.m
//  Puzzle
//
//  Created by 朱理哲 on 2016/12/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "FBShareOrderListModel.h"
#import "ImageModel.h"

@implementation FBPurchaseGameInfo
//description
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"desc" : @"description"
             };
}

@end
@implementation FBShareOrderModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"ID" : @"id"
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"pictures": [ImageModel class]
             };
}

@end

@implementation FBShareOrderListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"content" : [FBShareOrderModel class]
             };
}
@end
