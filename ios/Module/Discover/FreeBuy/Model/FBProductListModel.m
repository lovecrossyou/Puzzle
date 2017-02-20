//
//  FBProductListModel.m
//  Puzzle
//
//  Created by huibei on 16/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "FBProductListModel.h"
@implementation FBBidRecordModel


@end

@implementation FBProductModel : NSObject

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"fbOrderId" : @"orderId",
             @"bidOrderId": @"id"
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"bidRecords" : [FBBidRecordModel class]
             };
}
@end

@implementation FBProductListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"content" : [FBProductModel class]
             };
}
@end
