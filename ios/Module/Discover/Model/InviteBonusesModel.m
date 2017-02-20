//
//  InviteBonusesModel.m
//  Puzzle
//
//  Created by huipay on 2016/9/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "InviteBonusesModel.h"

@implementation InviteBaseModel

@end


@implementation InviteBonuses
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"model" : [InviteBaseModel class]
             };
}
@end

@implementation InviteBonusesModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"content" : [InviteBonuses class]
             };
}
@end
