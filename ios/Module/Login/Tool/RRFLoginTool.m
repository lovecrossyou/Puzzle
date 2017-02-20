
//  Created by on 16/5/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFLoginTool.h"
#import "PZHttpTool.h"
#import "PZMMD5.h"
#import "PZParamTool.h"
#import "Singleton.h"
#import "PZAccessInfo.h"
#import "WechatUserInfo.h"
#import <JMessage/JMessage.h>
#import "XTChatUtil.h"
#import "RRFMeTool.h"
@implementation RRFLoginTool
#pragma mark - 获取验证码
+(void)sendResetPwdSMS:(NSString*)userName reset:(BOOL)reset successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    NSString *url = @"reqcheckCode/getCode";
    NSString* codeType = @"Register" ;
    if (reset == YES) {
        codeType = @"ResetPwd";
    }
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfoNotLogin];
    NSDictionary* params = @{
                             @"codeType":codeType,
                             @"phoneNum":userName,
                             @"accessInfo":[accessInfo yy_modelToJSONObject]
                             };
    [MBProgressHUD show];
    [PZHttpTool postHttpRequestUrl:url parameters:params successBlock:^(id json) {
        [MBProgressHUD dismiss];
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}


+(void)verifySMS:(NSString*)phone code:(NSString*)code codeType:(NSString*)codeType successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfoNotLogin];
    NSDictionary* params = @{
                             @"codeType":codeType,
                             @"code":code,
                             @"phoneNum":phone,
                             @"accessInfo":[accessInfo yy_modelToJSONObject]
                             };
    [MBProgressHUD show];
    [PZHttpTool postHttpRequestUrl:@"reqcheckCode/checkCode" parameters:params successBlock:^(id json) {
        [MBProgressHUD dismiss];
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

#pragma mark - 重置密码&注册
+(void)resetWithUserName:(NSString*)userName pwd:(NSString*)password checkCode:(NSString*)checkCode reset:(BOOL)reset successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
   ;
    if (reset) {
         //重置密码(忘记密码)
        [PZHttpTool getMd5KeyWithUserName:userName successBlock:^(id json) {
            NSString *md5Key = json[@"userMD5"];
            NSString *pwd = [PZMMD5 digest:[NSString stringWithFormat:@"%@%@%@",userName,password,md5Key]];
            NSDictionary* accessInfo = [PZParamTool registeBaseRequestParam:userName];
            NSDictionary* params = @{
                                     @"check_code":checkCode,
                                     @"password":pwd,
                                     @"phone_num":userName,
                                     @"accessInfo":accessInfo
                                     };
            [PZHttpTool postRequestUrl:@"resetPwd" parameters:params successBlock:^(id json) {
                success(json);
            } fail:^(id json) {
             }];

        } fail:^(id json) {
        }];
    }else{
        // 绑定手机号
        CFUUIDRef udid = CFUUIDCreate(NULL);
        NSString *md5Key = (NSString *) CFBridgingRelease(CFUUIDCreateString(NULL, udid));
        NSString *pwd = [PZMMD5 digest:[NSString stringWithFormat:@"%@%@%@",userName,password,md5Key]];
        NSDictionary* accessInfo = [PZParamTool registeBaseRequestParam:userName];
        NSDictionary* params = @{
                                 @"md5_key":md5Key,
                                 @"check_code":checkCode,
                                 @"password":pwd,
                                 @"phone_num":userName,
                                 @"accessInfo":accessInfo
                                 };
        [PZHttpTool postRequestUrl:@"regist" parameters:params successBlock:^(id json) {
            success(json);
        } fail:^(id json) {
            failBlock(json);
        }];
    }

}

#pragma mark - 登录
+(void)loginWithUserName:(NSString*)userName nickName:(NSString*)nickName head_imgUrl:(NSString*)imgUrl pwd:(NSString*)pwd type:(NSString*)type sex:(int)sex successBlock:(PZRequestSuccess)success  fail:(PZRequestFailure)failBlock{
    WEAKSELF
    if ([type isEqualToString:@"phonenum"]) {
        [PZHttpTool getMd5KeyWithUserName:userName successBlock:^(id json) {
            NSString* md5key = json[@"userMD5"] ;
            NSString* signature = [PZParamTool getLoginSignatureWithUserName:userName pwd:pwd md5key:md5key];
            NSMutableDictionary* accessInfo = [PZParamTool registeBaseRequestParam:userName];
            [accessInfo setValue:type forKey:@"loginType"];
            [accessInfo setValue:signature forKey:@"signature"];
            NSDictionary* params = @{
                                     @"userName":userName,
                                     @"app_key":AppKey,
                                     @"accessInfo":accessInfo
                                     };
            [PZHttpTool postRequestUrl:@"login" parameters:params successBlock:^(id json) {
                [PZParamTool getAccountInfo];
                //获取喜腾号 登录喜信
                [weakSelf requestUserInfo];
                NSMutableString* md5Temp = [NSMutableString stringWithString:md5key];
                NSString* md5String = [md5Temp stringByReplacingOccurrencesOfString:@"-" withString:@""] ;
                [Singleton sharedInstance].md5key = md5String;
                [JPUSHService setAlias:[Singleton sharedInstance].md5key callbackSelector:nil object:nil];
                success(json);
            } fail:^(id json) {
                failBlock(json);
            }];
            
        } fail:^(id json) {
            failBlock(json);
        }];
    }
    else{
        
        [self quickLoginWithUserName:userName pwd:pwd nickName:nickName head_imgUrl:imgUrl sex:sex successBlock:^(id json) {
            success(json);
        } fail:^(id json) {
            failBlock(json);
        }];
    }
}

+(void)requestUserInfo{
    if ([PZParamTool hasLogin]) {
        [RRFMeTool requestUserInfoWithSuccess:^(id json) {
            if(json != nil){
                LoginModel* userM = [LoginModel yy_modelWithJSON:json[@"userInfo"]];
                [XTChatUtil loginChatAccount:userM.xtNumber pwd:@"123456" complete:^(id resultObject, NSError *error) {
                    
                }];
            }
        } failBlock:^(id json) {
        }];
    }
}


+(void)quickLoginWithUserName:(NSString*)userName pwd:(NSString*)pwd nickName:(NSString*)nickName head_imgUrl:(NSString*)imgUrl  sex:(int)sex successBlock:(PZRequestSuccess)success  fail:(PZRequestFailure)failBlock{
    NSString* signature = [PZParamTool getLoginSignatureWithOpenId:pwd];
    NSMutableDictionary* accessInfo = [PZParamTool registeBaseRequestParam:userName];
    [accessInfo setValue:@"weixin" forKey:@"loginType"];
    [accessInfo setValue:signature forKey:@"signature"];
    NSDictionary* params = @{
                             @"sex":@(sex),
                             @"userName":userName,
                             @"nickName":nickName,
                             @"headImageUrl":imgUrl,
                             @"app_key":AppKey,
                             @"accessInfo":accessInfo
                             };
    [PZHttpTool postRequestUrl:@"login" parameters:params successBlock:^(id json) {
        [PZParamTool getAccountInfo];
        success(json);
    } fail:^(id json) {
        
    }];
    
}

+(void)getAccessTokenWithCode:(NSString*)code  successBlock:(PZRequestSuccess)success  fail:(PZRequestFailure)failBlock{
    NSString* url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WechatAppID,WechatSecret,code];
    [PZHttpTool getRequestFullUrl:url parameters:nil successBlock:^(id json) {
        
    } fail:^(id json) {
        failBlock(json);
    }];
}

//获取用户个人信息（UnionID机制）[wechat]
+(void)getUserInfoWithCode:(NSString*)code  successBlock:(PZRequestSuccess)success  fail:(PZRequestFailure)failBlock{
    NSString* url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WechatAppID,WechatSecret,code];
    [PZHttpTool getRequestFullUrl:url parameters:nil successBlock:^(id json) {
        NSString* access_token = json[@"access_token"] ;
        NSString* openid = json[@"openid"] ;
        NSString* url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid];
        [PZHttpTool getRequestFullUrl:url parameters:nil successBlock:^(id json) {
            WechatUserInfo* userInfo = [WechatUserInfo yy_modelWithJSON:json];
            success(userInfo);
        } fail:^(id json) {
            failBlock(json);
        }];
    } fail:^(id json) {
        failBlock(json);
    }];
}


+(void)loginWithWithCode:(NSString*)code successBlock:(PZMutilRequestSuccess)success  fail:(PZRequestFailure)failBlock{
    [self getUserInfoWithCode:code successBlock:^(WechatUserInfo* userInfo) {
        [self loginWithUserName:userInfo.unionid nickName:userInfo.nickname head_imgUrl:userInfo.headimgurl pwd:userInfo.unionid type:@"weixin" sex:[userInfo.sex intValue] successBlock:^(id json) {
            success(json,userInfo);
        } fail:^(id json) {
            failBlock(json);
        }];
    } fail:^(id json) {
        failBlock(json);
    }];
}


//是否绑定手机号
+(void)checkBindPhone:(WechatUserInfo*)wechatInfo successBlock:(PZRequestSuccess)success  fail:(PZRequestFailure)failBlock{
    NSMutableDictionary* accessInfo = [[NSMutableDictionary alloc]initWithDictionary:[[PZParamTool createAccessInfo] yy_modelToJSONObject]];
    [accessInfo setValue:@"weixin" forKey:@"loginType"];
    [accessInfo setValue:wechatInfo.unionid forKey:@"phone_num"];

    NSDictionary* params = @{
                             @"cName":wechatInfo.nickname,
                             @"userIconUrl":wechatInfo.headimgurl,
                             @"accessInfo":accessInfo
                             };
    [PZHttpTool postRequestUrl:@"checkBind" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}
//绑定手机号
+(void)bindPhone:(WechatUserInfo*)wechatInfo phone:(NSString*)phone pwd:(NSString*)pwd checkCode:(NSString*)checkCode md5Key:(NSString*)md5Key successBlock:(PZRequestSuccess)success  fail:(PZRequestFailure)failBlock{
    NSMutableDictionary* accessInfo = [[NSMutableDictionary alloc]initWithDictionary:[[PZParamTool createAccessInfo] yy_modelToJSONObject]];
    [accessInfo setValue:@"weixin" forKey:@"loginType"];
    [accessInfo setValue:wechatInfo.unionid forKey:@"phone_num"];
    
    pwd = [PZMMD5 digest:[NSString stringWithFormat:@"%@%@%@",phone,pwd,md5Key]];

    NSDictionary* params = @{
                             @"md5_key":md5Key,
                             @"check_code":checkCode,
                             @"password":pwd,
                             @"phone_num":phone,
                             @"cName":wechatInfo.nickname,
                             @"userIconUrl":wechatInfo.headimgurl,
                             @"accessInfo":accessInfo
                             };
    
    [PZHttpTool postRequestUrl:@"bindPhone" parameters:params successBlock:^(id json) {
        //注册到极光
        NSString* unionId = [md5Key stringByReplacingOccurrencesOfString:@"_" withString:@""];
        unionId = [unionId stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [JPUSHService setAlias:unionId callbackSelector:nil object:nil];
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

@end
