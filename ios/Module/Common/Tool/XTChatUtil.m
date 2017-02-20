//
//  XTChatUtil.m
//  Puzzle
//
//  Created by 朱理哲 on 2016/12/3.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "XTChatUtil.h"
#import "JChatConstants.h"
#import "PZParamTool.h"
#import "RRFMeTool.h"
@implementation XTChatUtil
+(void)loginChatAccount:(NSString*)username pwd:(NSString*)pwd complete:(JMSGCompletionHandler)complete{
    WEAKSELF
    [JMSGUser loginWithUsername:username password:pwd completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            [[NSUserDefaults standardUserDefaults] setObject:username forKey:klastLoginUserName];
            // 显示登录状态？
            [[NSNotificationCenter defaultCenter] postNotificationName:kupdateUserInfo object:nil];
            [weakSelf userLoginSave:username pwd:pwd];
        }
        complete(resultObject,error);
    }];
}

+ (void)userLoginSave:(NSString*)username pwd:(NSString*)pwd {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:username forKey:kuserName];
    [userDefaults setObject:pwd forKey:kPassword];
    [userDefaults synchronize];
}

+(void)logout{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kuserName];
    [JMSGUser logout:^(id resultObject, NSError *error) {
        
    }];
}

+(void)autoLogin:(JMSGCompletionHandler)complete{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* userName = [userDefaults objectForKey:kuserName];
    NSString* pwd = [userDefaults objectForKey:kPassword];
    if (userName != nil && pwd != nil) {
        if (userName.length && pwd.length) {
            [self loginChatAccount:userName pwd:pwd complete:^(id resultObject, NSError *error) {
                complete(resultObject,error);
            }];
        }
    }
    else{
        //获取用户信息
        [self requestUserInfoAndLogin];
    }
}

+(void)requestUserInfoAndLogin{
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


+(void)getConversationBadge:(ItemClickParamBlock)completeBlock{
    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
        JCHATMAINTHREAD(^{
            if (error == nil) {
                NSArray* conversations = (NSArray*)resultObject ;
                NSInteger count = 0 ;
                for (JMSGConversation* c in conversations) {
                    count+= [c.unreadCount integerValue] ;
                }
                if (count == 0) {
                    completeBlock(nil);
                }
                else{
                    completeBlock(@(count));
                }
            }
            else{
                completeBlock(nil);
            }
        });
    }];
}

+(void)updateAvatar:(UIImage*)image{
    [JMSGUser updateMyInfoWithParameter:UIImageJPEGRepresentation(image, 1) userFieldType:kJMSGUserFieldsAvatar completionHandler:^(id resultObject, NSError *error) {
        JCHATMAINTHREAD(^{
            if (error == nil) {
            } else {
            }
        });
    }];
}

//修改昵称
+(void)updateNickName:(NSString*)name{
    [JMSGUser updateMyInfoWithParameter:name userFieldType:kJMSGUserFieldsNickname completionHandler:^(id resultObject, NSError *error) {
        JCHATMAINTHREAD(^{
            if (error == nil) {
            } else {
            }
        });
    }];

}


//修改好友备注
+ (void)update:(JMSGUser*)friend noteText:(NSString *)noteText completionHandler:(JMSGCompletionHandler)handler{
    [friend updateNoteText:noteText completionHandler:^(id resultObject, NSError *error) {
        
    }];
}


@end
