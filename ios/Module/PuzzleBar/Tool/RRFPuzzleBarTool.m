//
//  RRFPuzzleBarTool.m
//  Puzzle
//
//  Created by huibei on 16/8/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFPuzzleBarTool.h"
#import "PZHttpTool.h"
#import "PZAccessInfo.h"
#import "PZParamTool.h"
@implementation RRFPuzzleBarTool
+(void)requestCommentDetailListWithUrl:(NSString *)url CommentId:(NSInteger)commentId pageNo:(int)pageNo Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfoNotLogin];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"commentId":@(commentId),
                            @"pageNo":@(pageNo),
                            @"size":@(20)
                            };
    [PZHttpTool postRequestUrl:url parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
+(void)requestFollowerListWithPageNo:(int)pageNo Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"pageNo":@(pageNo),
                            @"size":@(20)
                            };
    [PZHttpTool postRequestUrl:@"followerList" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
+(void)requestQuestionBarListWithPageNo:(NSInteger)pageNo Size:(NSInteger)size questionBarType:(NSString *)questionBarType Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"pageNo":@(pageNo),
                            @"size":@(size),
                            @"questionBarType":questionBarType
                            };
    [PZHttpTool postRequestUrl:@"questionBarList" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
+(void)addFllowerWithUserId:(NSInteger)userId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"beFollowUserId":@(userId)
                            };
    [PZHttpTool postRequestUrl:@"addFollower" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
+(void)requestAnswerListWithPageNo:(NSInteger)pageNo otherUserId:(NSInteger )otherUserId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfoNotLogin];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"pageNo":@(pageNo),
                            @"size":@(20),
                            @"otherUserId":@(otherUserId)
                            };
    [PZHttpTool postRequestUrl:@"questionList" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
    
}

+(void)putForwardtQuestionWithQuestionBarId:(NSInteger)questionBarId ContentText:(NSString *)contentText Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"questionBarId":@(questionBarId),
                            @"content":contentText
                            };
    [PZHttpTool postRequestUrl:@"addQuestion" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
    
}
+(void)deleteCommentWithEntityWithUrl:(NSString *)url Type:(NSString *)entityType entityId:(NSInteger )entityId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    if (![PZParamTool hasLogin]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin" object:nil];
        return;
    }
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"entityType":entityType,
                            @"entityId":@(entityId)
                            };
    [PZHttpTool postRequestUrl:url parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
    
}
//请求路径: /client/friendCircle/friendCircleList
//请求方法: POST
//请求参数:
//
//
//{
//    
//    "accessInfo":{"app_key":"b5958b665e0b4d8cae77d28e1ad3f521","phone_num":"","signature":"D0ADEDF7BE3B8B2F299D2B0E4C103562"},
//    "commentTypeId":"1",//如果是别人朋友圈 传 用户id
//    "commentType":"otherUser",// otherUser别人朋友圈  userSelf  自己朋友圈
//    "pageNo":"0",
//    "size":"5"
//}

+(void)requestFriendCommentListWithCommentTypeId:(NSInteger)commentTypeId commentType:(NSString *)commentType PageNo:(int)pageNo Size:(int)size Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    if (![PZParamTool hasLogin]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin" object:nil];
        return;
    }
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"commentTypeId":@(commentTypeId),
                            @"commentType":commentType,
                            @"pageNo":@(pageNo),
                            @"size":@(size)
                            };
    [PZHttpTool postRequestUrl:@"client/friendCircle/friendCircleList" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
    
}

+(void)getPresentDiamondsListWithSuccess:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject]
                            };
    [PZHttpTool postRequestUrl:@"getPresentDiamondsList" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}

+(void)reportWithCommentId:(NSInteger)comId comment:(NSString *)comment success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail{
    LoginModel* user = [PZParamTool currentUser];
    
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"reportUserId":user.userId,
                            @"commentId":@(comId),
                            @"content":comment
                            };
    [PZHttpTool postRequestUrl:@"information/report/add" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}

+(void)addBlackList:(NSInteger)userId success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"passiveUserId":@(userId)
                            };
    [PZHttpTool postRequestUrl:@"blackList/add" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
@end
