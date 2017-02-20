//
//  RRFRebateModel.m
//  Puzzle
//
//  Created by huipay on 2016/12/30.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFRebateModel.h"

@implementation RRFRebateModel

@end

@implementation RRFRebateMonthModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"dayList" : [RRFRebateDayModel class]
             };
}
@end

@implementation RRFRebateDayModel

@end
