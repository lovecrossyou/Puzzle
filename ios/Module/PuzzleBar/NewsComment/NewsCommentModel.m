//
//  PZNewsContainerController.m
//  Puzzle
//
//  Created by huibei on 16/12/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "NewsCommentModel.h"

@implementation NewsCommentResponseModels

@end
@implementation NewsCommentModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"responseModels" : [NewsCommentResponseModels class]
             };
}
@end
@implementation NewsCommentListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"content" : [NewsCommentModel class]
             };
}
@end
