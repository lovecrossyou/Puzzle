//
//  RRFWiningOrderDetailModel.m
//  Puzzle
//
//  Created by huipay on 2017/2/7.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "RRFWiningOrderDetailModel.h"
#import "ImageModel.h"
@implementation RRFWiningOrderInfoModel

@end
@implementation RRFWiningOrderAddressModel

@end
@implementation UserInfo

@end
@implementation AwardInfo

@end
@implementation RRFWiningOrderDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"pictures": [ImageModel class]
             };
}
@end
