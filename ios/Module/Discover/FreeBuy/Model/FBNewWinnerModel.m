//
//  FBNewWinnerModel.m
//  Puzzle
//
//  Created by huibei on 16/12/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "FBNewWinnerModel.h"

@implementation FBNewWinnerModel
@end



@implementation FBNewWinnerListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"content" : [FBNewWinnerModel class]
             };
}
@end
