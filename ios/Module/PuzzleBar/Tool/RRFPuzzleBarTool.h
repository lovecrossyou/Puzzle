//
//  RRFPuzzleBarTool.h
//  Puzzle
//
//  Created by huibei on 16/8/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRFPuzzleBarTool : NSObject
// 评论详情列表
+(void)requestCommentDetailListWithUrl:(NSString *)url CommentId:(NSInteger)commentId pageNo:(int)pageNo Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 我的关注列表
+(void)requestFollowerListWithPageNo:(int)pageNo Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 我的查找吧主列表
+(void)requestQuestionBarListWithPageNo:(NSInteger)pageNo Size:(NSInteger)size questionBarType:(NSString *)questionBarType Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 关注/取消关注
+(void)addFllowerWithUserId:(NSInteger)userId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 问吧列表
+(void)requestAnswerListWithPageNo:(NSInteger)pageNo otherUserId:(NSInteger )otherUserId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 提出问题
+(void)putForwardtQuestionWithQuestionBarId:(NSInteger)questionBarId ContentText:(NSString *)contentText Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 删除评论
+(void)deleteCommentWithEntityWithUrl:(NSString *)url Type:(NSString *)entityType entityId:(NSInteger )entityId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 朋友圈列表
+(void)requestFriendCommentListWithCommentTypeId:(NSInteger)commentTypeId commentType:(NSString *)commentType PageNo:(int)pageNo Size:(int)size Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;

//打赏数据
+(void)getPresentDiamondsListWithSuccess:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;

//举报
+(void)reportWithCommentId:(NSInteger)comId comment:(NSString*)comment success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
//加入黑名单
+(void)addBlackList:(NSInteger)userId success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
@end
