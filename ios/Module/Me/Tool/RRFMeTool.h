//
//  RRFMeTool.h
//  Puzzle
//
//  Created by huibei on 16/8/3.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RRFFattestationModel,RRFDrawModel;
@interface RRFMeTool : NSObject
// 获取喜腾币全部账户金额
+(void)requestAccountXTBWithSuccess:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 获取钻石账户
+(void)requestAccountDiamondWithSuccess:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 获取喜腾币本金部分金额
+(void)requestAccountCapitalWithSuccess:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 获取地址列表
+(void)requestAddressListWithPageNo:(int)pageNo Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 获取兑换商品列表
+(void)requestOrderListWithStatus:(int)status pageNo:(int)pageNo Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 获取订单详情
+(void)requestOrderDatailOrderId:(NSInteger)orderId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 签收
+(void)dealWithOrderId:(NSNumber *)orderId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 投注列表
+(void)requestRewoardListWithPageNo:(int)pageNo direction:(NSString *)direction
 Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 投注统计
+(void)getGuessWithStockStatisticSuccess:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 评论订单
+(void)addCommentWithContent:(NSString *)content OrderId:( NSInteger)orderId Score:(NSInteger)score ImageUrls:(NSArray *)imageUrls IsSynchoron:(int)isSynchoron Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 账单列表
+(void)requestBillListWithType:(NSInteger)type Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 修改名字
+(void)modifyNameWith:(NSString *)name Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 修改头像
+(void)modifyIconWithUrlStr:(NSString *)iconUrl Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 获取用户信息
+(void)requestUserInfoWithSuccess:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 我的提问
+(void)requestMyQuestionListPageNo:(int)pageNo Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
;
// 吧主认证
+(void)applicationReviewWithModel:(RRFFattestationModel *)model  Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;

// 吧主信息
+(void)getQuestionBarMsgWithUserId:(NSInteger)userId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 最新提问
+(void)getWaitAnswerQuestionListWithPageNo:(int)pageNo Size:(int)size Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 最新回答
+(void)getAlReadyAnswerQuestionListWithPageNo:(int)pageNo Size:(int)size Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;

// 最新回答
+(void)requestFattestationInfoWithSuccess:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;

// 打赏列表  
+(void)requestPraiseListWithUrl:(NSString *)url PageNo:(int)pageNo size:(int)size entityType:(NSString *)entityType entityId:(NSInteger)entityId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 修改密码
+(void)updatePwdWithOldPassword:(NSString *)oldPassword NewPassword:(NSString *)newPassword Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 通知列表
+(void)requestNoticeListWithPageNo:(int)pageNo Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 领取奖品
+(void)prizeWithModel:(RRFDrawModel*)model Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 请求是否认证
+(void)checkIsDelegaterWithSuccess:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
//修改个性签名
+(void)modifySelfSignWithText:(NSString *)text Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
//修改性别
+(void)modifySexWithSex:(int)sex Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
//修改地址
+(void)modifyUserAreaWithAddress:(NSString *)address Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 详细资料
+(void)requestFriendTnfoWithUserId:(NSInteger)userId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
+(void)requestFriendVerifyInfoWithInviteId:(NSInteger)inviteId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 朋友圈的资料
+(void)requestFriendSelfProfitWithType:(NSString *)type Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 朋友圈的资料
+(void)requestOrderInfoWithSuccess:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 代理改版信息
+(void)requestDelegateRebateWithSuccess:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 我的返利
+(void)requestDelegateRebateInfoMsgWithSuccess:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 代理邀请用户
+(void)requestUserInviterAmountMsgWithSuccess:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 获取某个级别下的用户数量
+(void)requestLevelUserInfoMsgWithUserId:(NSString *)userId Level:(NSString*)level PageNo:(int)pageNo Size:(int)size Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 返利月信息
+(void)requestrebateMonthMsgWithPageNo:(int)pageNo Size:(int)size Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 根据月获取用户详细返利
+(void)requestRebateDetailByMonthWithYear:(NSString *)year Month:(NSString *)month PageNo:(int)pageNo Size:(int)size Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;

+(void)requestWiningOrderListWithPageNo:(int)pageNo Size:(int)size Status:(NSString *)status Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 提醒发货
+(void)stockWinOrderShowWithTradeOrderId:(NSInteger)tradeOrderId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 中奖订单信息
+(void)requestWiningOrderInfoWithTradeOrderId:(NSInteger)tradeOrderId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;

@end
