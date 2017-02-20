//
//  HBParamTool.h
//  HuiBeiWaterMerchant
//
//  Created by 朱理哲 on 16/5/11.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginModel.h"

@class PZAccessInfo ,WechatUserInfo;
@interface PZParamTool : NSObject
//获取手机型号
+ (NSString *)iphoneType;
//获取手机ip地址
+ (void)getIpAddressesBlock:(PZRequestSuccess)complete;
//是否登陆
+(BOOL)hasLogin;
// 退出登录
+(void)loginOut;
//基本请求参数
+(PZAccessInfo*)createAccessInfo;
+(PZAccessInfo*)createWeChatAccessInfo;
// 获取喜腾币信息
+(void)getAccountInfo;
// 打赏
+(void)rewardWithUserId:(NSInteger)userId amount:(int)amount entityId:(NSInteger)entityId entityType:(NSString *)entityType Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 点赞
+(void)agreedToWithUrl:(NSString *)url param:(NSMutableDictionary *)param Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;
// 回复评论
+(void)replyCommentWithUrl:(NSString *)url param:(NSMutableDictionary *)param Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail;

+(NSMutableDictionary*)registeWechatRequestParam:(WechatUserInfo*)wechatModel;

// accessInfo
+(NSMutableDictionary*)registeBaseRequestParam:(NSString*)phone_num;


+(NSString*)getLoginSignatureWithUserName:(NSString*)userName pwd:(NSString*)pwd md5key:(NSString*)md5key;
+(NSString*)getLoginSignatureWithOpenId:(NSString*)openId;
//当前用户
+(LoginModel*)currentUser;

//未登录基本请求参数
+(PZAccessInfo*)createAccessInfoNotLogin;
+(NSString*)baseParamString;

+(NSString*)currentMonth;
+(NSString*)currentMonthFirst;

+ (NSString *)iphoneType ;
@end
