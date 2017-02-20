//
//  FortuneModel.m
//  Puzzle
//
//  Created by huibei on 16/12/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "FortuneModel.h"

@implementation FortuneModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}
@end

@implementation FortuneListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"content" : [FortuneModel class]
             };
}
@end
