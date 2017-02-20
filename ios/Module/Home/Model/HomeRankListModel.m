//
//  HomeRankListModel.m
//  Puzzle
//
//  Created by huipay on 2016/8/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "HomeRankListModel.h"
#import "HomeRankModel.h"
@implementation HomeRankListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"content" : [HomeRankModel class]
             };
}
@end
