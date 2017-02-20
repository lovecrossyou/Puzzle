//
//  HomeTool.h
//  Puzzle
//
//  Created by huipay on 2016/8/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeTool : NSObject
+(void)getStockGameListWithPageNo:(int)no pageSize:(int)size SuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;

//guessGame
+(void)guessGameWithAmount:(NSString*)cathecticAmount guessType:(int)guessType stockId:(int)stockId successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
//rakingList
+(void)getRankListWithPageNo:(int)no pageSize:(int)size type:(NSString*)type SuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;

//addComment
+(void)addCommentWithStockId:(int)stockId imgs:(NSArray*)imgs content:(NSString*)content successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
//commentList
+(void)getCommentListWithParam:(NSMutableDictionary *)Param successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;

//stockGameDetail
+(void)getStockGameDetailWithStockId:(int)stockId successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
//getJustNowWithStockList
+(void)getJustNowWithStockListWithPageNo:(int)no pageSize:(int)size SuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
//questionBarList
+(void)getQuestionBarListWithPageNo:(int)no pageSize:(int)size questionBarType:(NSString*)questionBarType successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
//邀请
+(void)inviteWithContent:(NSString*)content successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;

+(void)inviteBonusesWithPageNo:(int)no pageSize:(int)size successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;

+(void)inviteTwoPersonListWithPageNo:(int)no pageSize:(int)size otherUserId:(int)otherUserId successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;

+(void)recruitWithContent:(NSString*)content successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;


//依据时间类型 获取冠军奖品 1周2月3年champion
+(void)getChampionAwardByType:(int)awardType successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;

//联系方式
+(void)getContactWithsuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;

//获取股票赔率 /client/companyBaseInfo
+(void)getStockOddsWithStockId:(int)stockId  successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;


//APP上线检测
+(void)getAppStateSuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;

//发表动态 friendCircle
+(void)addFriendCircleCommentWithContent:(NSString*)content imgs:(NSArray*)imgs isSynchroniz:(BOOL)isSynchroniz successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
//短信邀请
+(void)inviteByMessageWithPhone:(NSString*)phone successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
//friend/list  我的朋友列表
+(void)friendListWithSuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
//inviteList  我的朋友列表
+(void)inviteListWithSuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;

+(void)addFriendWithUserId:(NSInteger)userId successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
+(void)verifyFriendWithUserId:(NSInteger)userId successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
//client/addressBook/addOrUpdate
+(void)addOrUpdateFriendWithFriends:(NSArray*)friends successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;

//推送消息 未读的数量
+(void)pushMsgUnReadCountWithSuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;

//推送消息  未读的更新
+(void)pushMsgUpdateSuccessBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;


+(void)loadShareImage:(NSDictionary*)param  successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
//中奖订单-晒单详情
+(void)requestShowOrderInfoWithStockWinOrderShowId:(NSInteger)stockWinOrderShowId successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
//礼品订单-晒单详情
+(void)requestShowOrderInfoWithExchangeOrderId:(NSInteger)exchangeOrderId successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
//0元夺宝订单-晒单详情
+(void)requestShowOrderInfoWithPurchaseGameShowId:(NSInteger)purchaseGameShowId successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
@end
