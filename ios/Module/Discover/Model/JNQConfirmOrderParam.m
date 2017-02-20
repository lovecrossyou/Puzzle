//
//  JNQConfirmOrderParam.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/30.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQConfirmOrderParam.h"

@implementation WeXinSpec
@end
@implementation AliPayModel
@end

@implementation JNQConfirmOrderParam

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"wexinSpec" : [WeXinSpec class],
             @"paras":[AliPayModel class]
             };
}

@end
