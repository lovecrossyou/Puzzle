//
//  RRFCommentsCellModel.m
//  Puzzle
//
//  Created by huibei on 16/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFCommentsCellModel.h"
#import "ImageModel.h"


@implementation PraiseUsersModel

@end
@implementation RRFCommentsCellModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"contentImages" : [ImageModel class],
             @"praiseUsers" : [PraiseUsersModel class],
             @"presentUsers" : [PraiseUsersModel class]
             };
}

@end
