//
//  RRFWenBarCellModel.m
//  Puzzle
//
//  Created by huibei on 16/8/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFWenBarCellModel.h"
@implementation RRFAnswerModel

@end
@implementation RRFQuestionModel

@end

@implementation RRFWenBarCellModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
              @"answerModels" : [RRFAnswerModel class]
             };
}



@end

@implementation RRFQuestionModelList
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"content" : [RRFQuestionModel class]
             };
}
@end


@implementation RRFWenBarCellModelList
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"content" : [RRFWenBarCellModel class]
             };
}
@end
