//
//  FriendListModel.m
//  Puzzle
//
//  Created by huibei on 16/11/9.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "FriendListModel.h"
#import "RRFDetailInfoModel.h"
@implementation FriendListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"list" : [RRFDetailInfoModel class]
             };
}
@end
