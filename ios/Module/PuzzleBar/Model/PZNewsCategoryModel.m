//
//  PZNewsCategoryModel.m
//  Puzzle
//
//  Created by huibei on 16/12/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZNewsCategoryModel.h"

@implementation PZNewsCategoryModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id",
             };
}
@end

@implementation PZNewsCategoryListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"content" : [PZNewsCategoryModel class]
             };
}
@end
