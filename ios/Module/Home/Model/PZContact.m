//
//  PZContact.m
//  Puzzle
//
//  Created by huibei on 16/11/9.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZContact.h"

@implementation PZContact


@end

@implementation PZContactList

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"content" : [PZContact class]
             };
}

@end
