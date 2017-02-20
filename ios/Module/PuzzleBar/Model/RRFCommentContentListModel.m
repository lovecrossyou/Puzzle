//
//  RRFCommentContentListModel.m
//  Puzzle
//
//  Created by huibei on 16/8/27.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFCommentContentListModel.h"
#import "RRFRespToRespListModel.h"

@implementation RRFCommentContentListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"respToRespList" : [RRFRespToRespListModel class]};
}
@end
