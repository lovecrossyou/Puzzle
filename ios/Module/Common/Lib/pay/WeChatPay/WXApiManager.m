
//
//  WXApiManager.m
//  HuiBeiWaterMerchant
//
//  Created by 朱理哲 on 16/5/13.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "WXApiManager.h"
#import "RRFLoginTool.h"
#import "RLMRealm.h"
#import "LoginModel.h"
#import "WechatUserInfo.h"
#import <JMessage/JMessage.h>
#import "Singleton.h"
@implementation WXApiManager
#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

- (void)dealloc {
    self.delegate = nil;
}


#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        [[NSNotificationCenter defaultCenter] postNotificationName:QueryOrderState object:nil];
    }
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp* authResp = (SendAuthResp*)resp ;
        if (resp.errCode == 0) {
            NSString* code = authResp.code ;
            [RRFLoginTool loginWithWithCode:code successBlock:^(id json,WechatUserInfo* userInfo) {
                [MBProgressHUD dismiss];
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm beginWriteTransaction];
                LoginModel* loginM = [LoginModel yy_modelWithJSON:json];
                loginM.phone_num = userInfo.unionid ;
                loginM.headimgurl = userInfo.headimgurl ;
                loginM.nickname = userInfo.nickname ;
                userInfo.access_token = loginM.access_token ;
                [realm addObject:loginM];
                [realm addObject:userInfo];
                [realm commitWriteTransaction];
                //检测绑定手机号
                [[NSNotificationCenter defaultCenter] postNotificationName:@"checkBindPhone" object:userInfo];
            } fail:^(id json) {
                
            }];
        }
    }
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (!resp.errCode) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"quitInviteVC" object:nil];
            [MBProgressHUD showInfoWithStatus:@"分享成功！"];
        }
    }
}


#pragma mark - jpush
-(void)jpushCallBack{
    
}

- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvGetMessageReq:)]) {
            GetMessageFromWXReq *getMessageReq = (GetMessageFromWXReq *)req;
            [_delegate managerDidRecvGetMessageReq:getMessageReq];
        }
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvShowMessageReq:)]) {
            ShowMessageFromWXReq *showMessageReq = (ShowMessageFromWXReq *)req;
            [_delegate managerDidRecvShowMessageReq:showMessageReq];
        }
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvLaunchFromWXReq:)]) {
            LaunchFromWXReq *launchReq = (LaunchFromWXReq *)req;
            [_delegate managerDidRecvLaunchFromWXReq:launchReq];
        }
    }
}

@end
