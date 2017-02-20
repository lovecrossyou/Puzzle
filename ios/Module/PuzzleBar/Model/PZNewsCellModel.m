//
//  PZNewsCellModel.m
//  Puzzle
//
//  Created by huibei on 16/12/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZNewsCellModel.h"

@implementation PZNewsCellModel

@end

@implementation PZNewsCellListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"content" : [PZNewsCellModel class]
             };
}
@end

