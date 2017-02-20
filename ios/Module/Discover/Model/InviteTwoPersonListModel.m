//
//  InviteTwoPersonListModel.m
//  Puzzle
//
//  Created by huipay on 2016/9/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "InviteTwoPersonListModel.h"
#import "InviteBonusesModel.h"
@implementation InviteTwoPersonListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"content" : [InviteBaseModel class]
             };
}
@end
