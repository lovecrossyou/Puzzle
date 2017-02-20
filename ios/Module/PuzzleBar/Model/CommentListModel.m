//
//  CommentListModel.m
//  Puzzle
//
//  Created by huipay on 2016/8/25.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "CommentListModel.h"
#import "RRFCommentsCellModel.h"
@implementation CommentListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"content" : [RRFCommentsCellModel class]
             };
}
@end
