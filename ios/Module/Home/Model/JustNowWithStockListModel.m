
//
//  JustNowWithStockListModel.m
//  Puzzle
//
//  Created by huipay on 2016/8/30.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JustNowWithStockListModel.h"
#import "JustNowWithStockModel.h"
@implementation JustNowWithStockListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"content" : [JustNowWithStockModel class]
             };
}
@end
