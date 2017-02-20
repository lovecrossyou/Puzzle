//
//  RRFWiningOrderModel.m
//  Puzzle
//
//  Created by huipay on 2017/1/20.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "RRFWiningOrderModel.h"

@implementation RRFWiningOrderModel

@end
@implementation RRFWiningOrderListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"content" : [RRFWiningOrderModel class]};
}
@end
