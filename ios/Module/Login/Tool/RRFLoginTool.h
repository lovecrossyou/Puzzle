
//  Created by on 16/5/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LoginModel,WechatUserInfo ;
@interface RRFLoginTool : NSObject
// 获取验证码
+(void)sendResetPwdSMS:(NSString*)userName reset:(BOOL)reset successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
+(void)verifySMS:(NSString*)phone code:(NSString*)code codeType:(NSString*)codeType successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
#pragma mark - 重置密码&注册
+(void)resetWithUserName:(NSString*)userName pwd:(NSString*)password checkCode:(NSString*)checkCode reset:(BOOL)reset successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
// 登录
+(void)loginWithUserName:(NSString*)userName nickName:(NSString*)nickName head_imgUrl:(NSString*)imgUrl pwd:(NSString*)pwd type:(NSString*)type sex:(int)sex  successBlock:(PZRequestSuccess)success  fail:(PZRequestFailure)failBlock;
//
//+(void)loginOutWithSuccessBlock:(HBRequestSuccess)success fail:(HBRequestFailure)failBlock;
////forget pwd user/reset_password/sms.json

//通过code获取access_token[wechat]
+(void)getAccessTokenWithCode:(NSString*)code  successBlock:(PZRequestSuccess)success  fail:(PZRequestFailure)failBlock;
//获取用户个人信息（UnionID机制）[wechat]
+(void)getUserInfoWithCode:(NSString*)code  successBlock:(PZRequestSuccess)success  fail:(PZRequestFailure)failBlock;
+(void)loginWithWithCode:(NSString*)code successBlock:(PZMutilRequestSuccess)success  fail:(PZRequestFailure)failBlock;

//是否绑定手机号
+(void)checkBindPhone:(WechatUserInfo*)wechatInfo successBlock:(PZRequestSuccess)success  fail:(PZRequestFailure)failBlock;
//绑定手机号
+(void)bindPhone:(WechatUserInfo*)wechatInfo phone:(NSString*)phone pwd:(NSString*)pwd checkCode:(NSString*)checkCode md5Key:(NSString*)md5Key successBlock:(PZRequestSuccess)success  fail:(PZRequestFailure)failBlock;

@end

