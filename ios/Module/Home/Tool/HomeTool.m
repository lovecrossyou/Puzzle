//
//  HomeTool.m
//  Puzzle
//
//  Created by huipay on 2016/8/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "HomeTool.h"
#import "PZParamTool.h"
#import "YYModel.h"
#import "PZAccessInfo.h"
#import "PZHttpTool.h"
@implementation HomeTool
+(void)getStockGameListWithPageNo:(int)no pageSize:(int)size SuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfoNotLogin];
    NSDictionary* params = @{
                            @"pageNo":@(no),
                            @"size":@(size),
                            @"accessInfo":[accessInfo yy_modelToJSONObject]
                            };
    [PZHttpTool postRequestUrl:@"stockGameList" showSVProgressHUD:NO parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

+(void)guessGameWithAmount:(NSString*)cathecticAmount guessType:(int)guessType stockId:(int)stockId successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfo];
    NSDictionary* params = @{
                             @"cathecticAmount":cathecticAmount,
                             @"guessType":@(guessType),
                             @"stockId":@(stockId),
                             @"accessInfo":[accessInfo yy_modelToJSONObject]
                             };
    [PZHttpTool postRequestUrl:@"guessGame" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}


+(void)getRankListWithPageNo:(int)no pageSize:(int)size type:(NSString*)type SuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfoNotLogin];
    NSDictionary* params = @{
                             @"pageNo":@(no),
                             @"size":@(size),
                             @"type":type,
                             @"accessInfo":[accessInfo yy_modelToJSONObject]
                             };
    [PZHttpTool postRequestUrl:@"rakingList" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

+(void)addCommentWithStockId:(int)stockId imgs:(NSArray*)imgs content:(NSString*)content successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    if (imgs == nil) {
        imgs = [NSArray array];
    }
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfo];
    NSDictionary* params = @{
                             @"stockGameId":@(stockId),
                             @"imageUrls":imgs,
                             @"content":content,
                             @"accessInfo":[accessInfo yy_modelToJSONObject]
                             };
    [PZHttpTool postRequestUrl:@"addComment" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

//发表动态 friendCircle
+(void)addFriendCircleCommentWithContent:(NSString*)content imgs:(NSArray*)imgs isSynchroniz:(BOOL)isSynchroniz successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    if (imgs == nil) {
        imgs = [NSArray array];
    }
    NSString* sync = isSynchroniz? @"yes" : @"no" ;
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfo];
    NSDictionary* params = @{
                             @"isSynchroniz":sync,
                             @"imageUrls":imgs,
                             @"content":content,
                             @"accessInfo":[accessInfo yy_modelToJSONObject]
                             };
    [PZHttpTool postRequestUrl:@"client/friendCircle/addComment" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

+(void)getCommentListWithParam:(NSMutableDictionary *)Param successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfoNotLogin];
    [Param addEntriesFromDictionary:@{@"accessInfo":[accessInfo yy_modelToJSONObject]}];
    [PZHttpTool postRequestUrl:@"commentList" parameters:Param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

//stockGameDetail
+(void)getStockGameDetailWithStockId:(int)stockId successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfoNotLogin];
    NSDictionary* params = @{
                             @"stockGameId":@(stockId),
                             @"accessInfo":[accessInfo yy_modelToJSONObject]
                             };
    [PZHttpTool postRequestUrl:@"stockGameDetail" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}


//getJustNowWithStockList
+(void)getJustNowWithStockListWithPageNo:(int)no pageSize:(int)size SuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfoNotLogin];
    NSDictionary* params = @{
                             @"pageNo":@(no),
                             @"size":@(size),
                             @"sortProperties":@[@"time"],
                             @"direction":@"DESC",
                             @"accessInfo":[accessInfo yy_modelToJSONObject]
                             };
    [PZHttpTool postRequestUrl:@"getJustNowWithStockList" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

+(void)getQuestionBarListWithPageNo:(int)no pageSize:(int)size questionBarType:(NSString*)questionBarType successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfoNotLogin];
    NSDictionary* params = @{
                             @"pageNo":@(no),
                             @"size":@(size),
                             @"questionBarType":questionBarType,
                             @"accessInfo":[accessInfo yy_modelToJSONObject]
                             };
    [PZHttpTool postRequestUrl:@"questionBarList" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

//邀请
+(void)inviteWithContent:(NSString*)content successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfo];
    NSDictionary* params = @{
                             @"description":content,
                             @"accessInfo":[accessInfo yy_modelToJSONObject]
                             };
    [PZHttpTool postRequestUrl:@"invite" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

+(void)loadShareImage:(NSDictionary*)param  successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    /*PZAccessInfo* accessInfo = [PZParamTool createAccessInfo];
    NSDictionary* params = @{
                             @"description":content,
                             @"accessInfo":[accessInfo yy_modelToJSONObject]
                             };
    [PZHttpTool postRequestUrl:@"invite" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];*/
}

+(void)inviteBonusesWithPageNo:(int)no pageSize:(int)size successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfo];
    NSDictionary* params = @{
                             @"pageNo":@(no),
                             @"size":@(size),
                             @"accessInfo":[accessInfo yy_modelToJSONObject]
                             };
    [PZHttpTool postRequestUrl:@"inviteBonuses" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

//inviteTwoPersonList
+(void)inviteTwoPersonListWithPageNo:(int)no pageSize:(int)size otherUserId:(int)otherUserId successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfo];
    NSDictionary* params = @{
                             @"pageNo":@(no),
                             @"size":@(size),
                             @"otherUserId":@(otherUserId),
                             @"accessInfo":[accessInfo yy_modelToJSONObject]
                             };
    [PZHttpTool postRequestUrl:@"inviteBonuses" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}


+(void)recruitWithContent:(NSString*)content successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfo];
    NSDictionary* params = @{
                             @"description":content,
                             @"accessInfo":[accessInfo yy_modelToJSONObject]
                             };
    [PZHttpTool postRequestUrl:@"delegater/invite" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}


//依据时间类型 获取冠军奖品 1周2月3年champion
+(void)getChampionAwardByType:(int)awardType successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfo];
    NSDictionary* params = @{
                             @"awardType":@(awardType),
                             @"accessInfo":[accessInfo yy_modelToJSONObject]
                             };
    [PZHttpTool postRequestUrl:@"award/champion" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

//联系方式
+(void)getContactWithsuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfo];
    NSDictionary* params = @{
                             @"accessInfo":[accessInfo yy_modelToJSONObject]
                             };
    [PZHttpTool postRequestUrl:@"service/tel" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

//获取股票赔率
+(void)getStockOddsWithStockId:(int)stockId  successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfo];
    NSDictionary* params = @{
                             @"accessInfo":[accessInfo yy_modelToJSONObject],
                             @"stockGameId":@(stockId)
                             };
    [PZHttpTool postRequestUrl:@"stockGameBaseInfo" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

//APP上线检测
+(void)getAppStateSuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    NSDictionary* params = @{@"version":currentVersion};
    [PZHttpTool getHttpRequestUrl:@"client/getAppState" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

+(void)inviteByMessageWithPhone:(NSString*)phone successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfo];
    NSDictionary* params = @{
                             @"accessInfo":[accessInfo yy_modelToJSONObject],
                             @"phoneNum":phone};

    [PZHttpTool postRequestUrl:@"inviteByMessage" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

//friend/list  我的朋友列表
+(void)friendListWithSuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfo];
    NSDictionary* params = @{
                             @"accessInfo":[accessInfo yy_modelToJSONObject]
                             };
    [PZHttpTool postRequestUrl:@"friend/list" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

+(void)inviteListWithSuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfo];
    NSDictionary* params = @{
                             @"accessInfo":[accessInfo yy_modelToJSONObject]
                             };
    [PZHttpTool postRequestUrl:@"friend/inviteList" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

//friend/addFriend
+(void)addFriendWithUserId:(NSInteger)userId successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfo];
    NSDictionary* params = @{
                             @"accessInfo":[accessInfo yy_modelToJSONObject],
                             @"userId":@(userId)};
    [PZHttpTool postRequestUrl:@"friend/addFriend" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

//验证朋友
+(void)verifyFriendWithUserId:(NSInteger)userId successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfo];
    NSDictionary* params = @{
                             @"accessInfo":[accessInfo yy_modelToJSONObject],
                             @"id":@(userId)};
    [PZHttpTool postRequestUrl:@"friend/passVerity" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

//client/addressBook/addOrUpdate
+(void)addOrUpdateFriendWithFriends:(NSArray*)friends successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfo];
    NSDictionary* params = @{
                             @"accessInfo":[accessInfo yy_modelToJSONObject],
                             @"datas":friends};
    [PZHttpTool postRequestUrl:@"client/addressBook/addOrUpdate" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

//推送消息 未读的数量
+(void)pushMsgUnReadCountWithSuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfo];
    NSDictionary* params = @{
                             @"accessInfo":[accessInfo yy_modelToJSONObject]};
    [PZHttpTool postRequestUrl:@"pushMessage/unread/count" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

//推送消息  未读的更新
+(void)pushMsgUpdateSuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfo];
    NSDictionary* params = @{
                             @"accessInfo":[accessInfo yy_modelToJSONObject]};
    [PZHttpTool postRequestUrl:@"pushMessage/unread/update" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}
//礼品订单-晒单详情
+(void)requestShowOrderInfoWithExchangeOrderId:(NSInteger)exchangeOrderId successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfo];
    NSDictionary* params = @{
                             @"accessInfo":[accessInfo yy_modelToJSONObject],
                             @"exchangeOrderId":@(exchangeOrderId)};
    [PZHttpTool postRequestUrl:@"product/comment/detail" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}
//中奖订单-晒单详情
+(void)requestShowOrderInfoWithStockWinOrderShowId:(NSInteger)stockWinOrderShowId successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfo];
    NSDictionary* params = @{
                             @"accessInfo":[accessInfo yy_modelToJSONObject],
                             @"stockWinOrderShowId":@(stockWinOrderShowId)};
    [PZHttpTool postRequestUrl:@"stockWinOrderShowDetail" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

//0元夺宝订单-晒单详情
+(void)requestShowOrderInfoWithPurchaseGameShowId:(NSInteger)purchaseGameShowId successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfo];
    NSDictionary* params = @{
                             @"accessInfo":[accessInfo yy_modelToJSONObject],
                             @"purchaseGameShowId":@(purchaseGameShowId)};
    [PZHttpTool postRequestUrl:@"purchaseGame/show/detail" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}
@end
