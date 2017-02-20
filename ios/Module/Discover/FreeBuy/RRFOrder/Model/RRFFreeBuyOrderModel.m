//
//  RRFFreeBuyOrderModel.m
//  Puzzle
//
//  Created by huipay on 2016/12/16.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFFreeBuyOrderModel.h"

@implementation RRFBidRecordsModel

@end
@implementation RRFFreeBuyOrderModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"bidRecords" : [RRFBidRecordsModel class]
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"ID" : @"id"
             };
}
@end
