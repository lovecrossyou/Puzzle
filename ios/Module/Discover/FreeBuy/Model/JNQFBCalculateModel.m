//
//  JNQFBCalculateModel.m
//  Puzzle
//
//  Created by HuHuiPay on 16/12/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQFBCalculateModel.h"

@implementation JNQCalUserModel

@end

@implementation JNQFBCalculateModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"content" : [JNQCalUserModel class]
             };
}

@end
