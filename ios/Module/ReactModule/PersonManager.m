//
//  PersonManager.m
//  Puzzle
//
//  Created by 朱理哲 on 2017/2/8.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "PersonManager.h"
#import "WXApi.h"
#import "PZAccessInfo.h"
#import "PZParamTool.h"
#import "PZMMD5.h"
#import "ReactSingleTool.h"

@implementation PersonManager
RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(goUserHomePageEvent:(int)userId)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goUserHomePageEvent" object:@(userId)];
}
//
RCT_EXPORT_METHOD(goUserProfileEvent:(int)userId)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goUserProfileEvent" object:@(userId)];
}

RCT_EXPORT_METHOD(registeWeChat)
{
    [self sendAuthRequest];
}


RCT_EXPORT_METHOD(goLogin)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeFirstLoginView" object:nil];

}

RCT_EXPORT_METHOD(getMd5:(NSString*)param callback:(RCTResponseSenderBlock)callBack)
{
  NSArray* events = @[[PZMMD5 digest:param]];
  callBack(@[[NSNull null], events]);

}


RCT_EXPORT_METHOD(shareTo:(NSString*)platform){
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReactShareNotificate" object:platform];

}

RCT_EXPORT_METHOD(reportClick){
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReactShareNotificate" object:@"reportClick"];
}

RCT_EXPORT_METHOD(cancelClick){
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReactShareNotificate" object:@"cancelClick"];
}


RCT_EXPORT_METHOD(blackList){
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReactShareNotificate" object:@"blackList"];
}

-(void)sendAuthRequest
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ;
    req.state = [NSString stringWithFormat:@"%d",arc4random_uniform(100000)] ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

//获取AccessInfo getAccessInfo
RCT_EXPORT_METHOD(getAccessInfo:(RCTResponseSenderBlock)callBack){
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfo];
    NSArray* events = @[[accessInfo yy_modelToJSONObject]];
    callBack(@[[NSNull null], events]);
}

RCT_EXPORT_METHOD(isWeChatInstall:(RCTResponseSenderBlock)callBack){
    NSNumber* flag = [WXApi isWXAppInstalled] ? @(1) : @(0) ;
    NSArray* events = @[flag];
    callBack(@[[NSNull null], events]);
}


//--------------控制器相关操作
RCT_EXPORT_METHOD(popView){
  if ([ReactSingleTool sharedInstance].currentCotroller) {
    [[ReactSingleTool sharedInstance].currentCotroller.navigationController popViewControllerAnimated:YES];
  }
}

RCT_EXPORT_METHOD(dismissView){
  if ([ReactSingleTool sharedInstance].currentCotroller) {
    [[ReactSingleTool sharedInstance].currentCotroller dismissViewControllerAnimated:YES completion:nil];
  }
}

//--------沙龙 头像点击
RCT_EXPORT_METHOD(headClick){
  [[ReactSingleTool sharedInstance].delegate headClick];
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

@end
