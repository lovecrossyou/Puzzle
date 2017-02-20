//
//  NewsHttpTool.h
//  Puzzle
//
//  Created by huibei on 16/12/27.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsHttpTool : NSObject
+(void)postCommentWithId:(NSInteger)commentId content:(NSString*)content successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
+(void)postCommentRespWithId:(NSInteger)commentId content:(NSString*)content successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;

+(void)getNewsCommentListListWithPageNo:(int)no pageSize:(int)size commentId:(NSInteger)commentId successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
@end
