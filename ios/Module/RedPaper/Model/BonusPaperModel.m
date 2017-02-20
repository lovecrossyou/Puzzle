//
//  BonusPaperModel.m
//  Puzzle
//
//  Created by huibei on 17/1/17.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "BonusPaperModel.h"

@implementation AcceptModel

@end
@implementation BonusPaperModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id",
             @"desInfo":@[@"desInfo",@"description"]
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"acceptModel" : [AcceptModel class], @"acceptModels" : [AcceptModel class]};
}
@end
