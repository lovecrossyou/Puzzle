//
//  JNQFriendCircleModel.m
//  Puzzle
//
//  Created by HuHuiPay on 16/9/3.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQFriendCircleModel.h"
#import "RRFCommentsCellModel.h"

@implementation JNQFriendCircleModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"ID" : @"id"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"praiseUsers" : [PraiseUsersModel class],
             @"presentUsers" : [PraiseUsersModel class]
             };
}

@end
