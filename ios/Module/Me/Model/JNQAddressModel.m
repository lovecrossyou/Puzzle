//
//  RRFCreadAddressModel.m
//  Puzzle
//
//  Created by huibei on 16/8/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQAddressModel.h"

@implementation JNQAddressModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"addressId" : @"id",
             @"addressId" : @"deliveryAddressId"
             };
}
@end
