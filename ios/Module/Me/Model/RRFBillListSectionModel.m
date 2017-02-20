//
//  RRFBillListSectionModel.m
//  Puzzle
//
//  Created by huibei on 16/9/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFBillListSectionModel.h"
#import "RRFBillCellModel.h"

@implementation RRFBillListSectionModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"dayBills" : [RRFBillCellModel class]};
}
@end
