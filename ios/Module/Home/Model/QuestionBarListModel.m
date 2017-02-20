
//
//  QuestionBarListModel.m
//  Puzzle
//
//  Created by huipay on 2016/8/30.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "QuestionBarListModel.h"
@implementation QuestionBarModel

@end

@implementation QuestionBarListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"content" : [QuestionBarModel class]
             };
}
@end
