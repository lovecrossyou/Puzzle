//
//  JNQFBStateModel.m
//  Puzzle
//
//  Created by HuHuiPay on 16/12/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQFBStateModel.h"

@implementation JNQFBLukyUserModel

@end

@implementation JNQFBStateModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"bidRecords" : [FBBidRecordModel class],
             @"luckUserInfo" : [JNQFBLukyUserModel class]
             };
}

@end
