
//
//  HBShareTool.m
//  HuiBeiWaterMerchant
//
//  Created by 朱理哲 on 16/5/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "HBShareTool.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import <AVFoundation/AVFoundation.h>
@interface HBShareTool()<UMSocialUIDelegate>
@property(strong,nonatomic)NSString* shareTitle ;
@property(strong,nonatomic)NSString* url ;
@end
@implementation HBShareTool

static HBShareTool* sharedInstance ;

+(HBShareTool *)sharedInstance{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized (self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    return nil;
}

-(id)copyWithZone:(NSZone *)zone
{
    return self;
}


-(void)shareSingleSNSWithType:(NSString*)type title:(NSString*)title image:(UIImage*)image url:(NSString*)url msg:(NSString*)content presentedController:(UIViewController *)presentedController{
    self.shareTitle = title;
    self.url = url ;
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeNone;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.shareTitle ;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.url ;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.shareTitle ;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.url ;
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
    [UMSocialData defaultData].extConfig.qqData.title = self.shareTitle;
    [UMSocialData defaultData].extConfig.qqData.url = self.url;
    [UMSocialData defaultData].extConfig.qqData.shareImage = image;
    [UMSocialData defaultData].extConfig.qqData.shareText = content;
    if ([type isEqualToString:UMShareToQQ]) {
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQQ] content:content image:image location:nil urlResource:nil presentedController:presentedController completion:nil];
    } else {
        [UMSocialWechatHandler setWXAppId:WechatAppID appSecret:WechatSecret url:url];
        [[UMSocialControllerService defaultControllerService] setShareText:content shareImage:image socialUIDelegate:self];
        UMSocialUrlResource *obj = [[UMSocialUrlResource alloc] init];
        [obj setResourceType:UMSocialUrlResourceTypeWeb url:url];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[type] content:content image:image location:nil urlResource:obj presentedController:presentedController completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                [MBProgressHUD showInfoWithStatus:@"分享成功！"];
            }
        }];
    }
}
-(void)shareImage:(UIImage *)image imageUrl:(NSString *)imageUrl platForm:(NSString *)platForm {
    UIViewController* rootVC = [UIApplication sharedApplication].keyWindow.rootViewController  ;
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    UMSocialUrlResource *obj = [[UMSocialUrlResource alloc] init];
    [obj setResourceType:UMSocialUrlResourceTypeImage url:imageUrl];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[platForm] content:@"" image:image location:nil urlResource:obj presentedController:rootVC completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            [MBProgressHUD showInfoWithStatus:@"分享成功！"];
        }
    }];
}
-(void)shareInView:(UIViewController *)view title:(NSString *)title shareText:(NSString *)text shareImage:(UIImage *)image url:(NSString*)url type:(NSString*)type{
    self.shareTitle = title ;
    self.url = url ;
    if (image == nil) {
        image = [UIImage imageNamed:@"share_icon"];
    }
    NSArray* platForms = @[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ];
    [UMSocialConfig hiddenNotInstallPlatforms:platForms];
    
    if (type != nil) {
        platForms = @[type];
        [[UMSocialControllerService defaultControllerService] setShareText:text shareImage:image socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:type].snsClickHandler(view,[UMSocialControllerService defaultControllerService],YES);
    }
    else{
        [UMSocialSnsService presentSnsIconSheetView:view
                                             appKey:UMShareAppKey
                                          shareText:text
                                         shareImage:image
                                    shareToSnsNames:platForms
                                           delegate:self];
    }
}


-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    //qq
    [UMSocialData defaultData].extConfig.qqData.title = self.shareTitle;
    [UMSocialData defaultData].extConfig.qqData.url = self.url ;
    //微信好友
    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.shareTitle ;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.url ;
    //微信朋友圈
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.shareTitle ;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.url ;
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    if (response.responseCode == UMSResponseCodeSuccess) {
        [MBProgressHUD showInfoWithStatus:@"分享成功！"];
    }
}

//-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options{
//    return [UMSocialSnsService handleOpenURL:url];
//}

@end
