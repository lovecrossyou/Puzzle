//
//  AppDelegate.m
//  Puzzle
//
//  Created by 朱理哲 on 16/7/21.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "AppDelegate.h"
#import "RRFLoginController.h"
#import "PZNavController.h"
#import "PZTabController.h"
#import "WXApi.h"
#import "RRFLoginTool.h"
#import "WechatUserInfo.h"
#import "LoginModel.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "WXApiManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "PZHttpTool.h"
#import "RRFFindPwdController.h"
#import "Singleton.h"
#import "RRFExceptionalListController.h"
#import "RRFBettingRecordController.h"
#import "RRFCommentsCellModel.h"
#import "RRFReplyListController.h"
//#import <Bugly/Bugly.h>
#import "NotificateMsgUtil.h"
#import "RRFNoticeListController.h"
#import "UIImage+Image.h"
#import "JNQHttpTool.h"
#import "RRFPhoneListModel.h"
#import "PZCache.h"
#import "InviteFriendController.h"
#import "HomeTool.h"
#import "JNQDiamondViewController.h"
#import "CommonPopOutController.h"
#import "STPopup.h"
#import "RRFMessageNoticeListModel.h"
#import "XTChatUtil.h"
#import "RRFFreeBuyOrderViewController.h"
#import "PZParamTool.h"
typedef void(^AlertAction)();
@interface AppDelegate ()<WXApiDelegate,JMSGEventDelegate>
@property(strong,nonatomic)PZTabController* rootController ;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [NSThread sleepForTimeInterval:2.0];
  self.window = [[UIWindow alloc]init];
  self.window.frame = [UIScreen mainScreen].bounds ;
  
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
  [self enterMainScreen];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLogin) name:@"goLogin" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkBindPhone:) name:@"checkBindPhone" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BuyDiamond:) name:@"BuyDiamond" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goExchangeXT:) name:@"ExchangeXT" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterMainScreen) name:@"RELOADHOME" object:nil];
  [self otherSetting];
  
  
  // init third-party SDK
  [JMessage addDelegate:self withConversation:nil];
  //    [JMessage setDebugMode];
  [JMessage setupJMessage:launchOptions
                   appKey:JPushAppKey
                  channel:nil apsForProduction:YES
                 category:nil];
  
  //Required
  [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound |
                                                    UIUserNotificationTypeAlert)
                                        categories:nil];
  
  //Required
  [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey
                        channel:nil
               apsForProduction:YES
          advertisingIdentifier:nil];
  [self requestServicePhoneNumber];
  
  [self registerJPushStatusNotification];
  
  [PZCache sharedInstance].phoneType = [PZParamTool iphoneType];
  return YES;
}

- (void)registerJPushStatusNotification {
  NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
  [defaultCenter addObserver:self
                    selector:@selector(networkDidRegister:)
                        name:kJPFNetworkDidRegisterNotification
                      object:nil];
  [defaultCenter addObserver:self
                    selector:@selector(networkDidLogin:)
                        name:kJPFNetworkDidLoginNotification
                      object:nil];
}

#pragma - mark JMessageDelegate
- (void)onReceiveNotificationEvent:(JMSGNotificationEvent *)event{
  SInt32 eventType = (JMSGEventNotificationType)event.eventType;
  switch (eventType) {
      case kJMSGEventNotificationCurrentUserInfoChange:{
      }
      break;
      case kJMSGEventNotificationReceiveFriendInvitation:
      case kJMSGEventNotificationAcceptedFriendInvitation:
      case kJMSGEventNotificationDeclinedFriendInvitation:
      case kJMSGEventNotificationDeletedFriend:
    {
    }
      break;
      case kJMSGEventNotificationReceiveServerFriendUpdate:
      break;
      case kJMSGEventNotificationLoginKicked:
      case kJMSGEventNotificationServerAlterPassword:
      case kJMSGEventNotificationUserLoginStatusUnexpected:
    {
      [PZParamTool loginOut];
    }
      break;
      
    default:
      break;
  }
}


// notification from JPush
- (void)networkDidSetup:(NSNotification *)notification {
}

// notification from JPush
- (void)networkDidRegister:(NSNotification *)notification {
}

// notification from JPush
- (void)networkDidLogin:(NSNotification *)notification {
}


#pragma mark - 进入主屏幕
-(void)enterMainScreen{
  PZTabController* rootController = [[PZTabController alloc]init];
  self.window.rootViewController = rootController;
  self.rootController = rootController ;
  [self.window makeKeyAndVisible];
}

-(void)requestServicePhoneNumber
{
  
  [JNQHttpTool JNQHttpRequestWithURL:@"service/tel" requestType:@"post" showSVProgressHUD:NO parameters:@{} successBlock:^(id json) {
    RRFPhoneListModel *phoneList = [RRFPhoneListModel yy_modelWithJSON:json];
    [Singleton sharedInstance].phoneListM = phoneList;
  } failureBlock:^(id json) {
    
  }];
}
-(void)goExchangeXT:(NSNotification*)notificate{
  BOOL appOpen = [PZCache sharedInstance].versionRelease ;
  //    NSString* title = appOpen? @"喜腾币不足" : @"喜腾币不足" ;
  NSString* title = appOpen? @"" : @"喜腾币不足" ;
  NSString* message = appOpen?@"您的喜腾币余额不足，需购买钻石兑换喜腾币" : @"分享获取喜腾币" ;
  NSString* titleVC = appOpen?@"购买钻石" : @"邀请朋友获取喜腾币" ;
  NSString* confirmTitle = appOpen?@"立即购买" : @"立即邀请" ;
  WEAKSELF
  [self showActionWithTitle:title message:message cancelAction:nil confirmAction:^{
    if (appOpen) {
      JNQDiamondViewController* exchangeVC = [[JNQDiamondViewController alloc]init];
      exchangeVC.title = titleVC ;
      [[weakSelf topController] pushViewController:exchangeVC animated:YES];
    }
    else{
      [weakSelf shareFriend];
    }
    
  } confirmTitle:confirmTitle];
}


#pragma mark - BuyDiamond
-(void)BuyDiamond:(NSNotification*)notificate{
  BOOL appOpen = [PZCache sharedInstance].versionRelease ;
  NSString* title = appOpen?@"钻石余额不足" : @"喜腾币不足" ;
  NSString* message = appOpen?@"您需要购买钻石" : @"分享获取喜腾币" ;
  NSString* titleVC = appOpen?@"购买钻石" : @"邀请朋友获取喜腾币" ;
  NSString* confirmTitle = appOpen?@"立即购买" : @"立即邀请" ;
  WEAKSELF
  [self showActionWithTitle:title message:message cancelAction:nil confirmAction:^{
    if (appOpen) {
      JNQDiamondViewController* goDiamond = [[JNQDiamondViewController alloc]init];
      goDiamond.title = titleVC;
      //            goDiamond.showCancel = YES ;
      PZNavController* homeController = [[PZNavController alloc]initWithRootViewController:goDiamond];
      [[weakSelf topController] presentViewController:homeController animated:YES completion:nil];
    }
    else{
      [weakSelf shareFriend];
    }
  } confirmTitle:confirmTitle];
}

-(UINavigationController*)topController{
  NSArray* controllers = self.rootController.childViewControllers ;
  UINavigationController* visibleController = controllers.firstObject ;
  NSInteger maxLevel = 0 ;
  for (UINavigationController* nav in controllers) {
    NSInteger levels = nav.childViewControllers.count ;
    if (levels>=maxLevel) {
      visibleController = nav ;
      maxLevel = levels ;
    }
  }
  return visibleController ;
}

#pragma mark - 分享
-(void)shareFriend{
  WEAKSELF
  InviteFriendController* invite = [[InviteFriendController alloc]init];
  invite.title = @"邀请朋友" ;
  invite.showCancel = YES ;
  PZNavController* homeController = [[PZNavController alloc]initWithRootViewController:invite];
  [weakSelf.window.rootViewController presentViewController:homeController animated:YES completion:nil];
}


-(void)showActionWithTitle:(NSString*)title message:(NSString*)msg cancelAction:(AlertAction)cancelAct confirmAction:(AlertAction)confirm confirmTitle:(NSString*)confirmTitle{
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:cancelAct];
  UIAlertAction *okAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:confirm];
  [alertController addAction:cancelAction];
  [alertController addAction:okAction];
  [self.window.rootViewController presentViewController:alertController animated:YES completion:^{
    
  }];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  /// Required - 注册 DeviceToken
  [JPUSHService registerDeviceToken:deviceToken];
}



- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  //Optional
  NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


#pragma mark - 检测绑定手机号
-(void)checkBindPhone:(NSNotification*)notificate{
  WechatUserInfo* obj = notificate.object ;
  [RRFLoginTool checkBindPhone:obj successBlock:^(id json) {
    if ([json[@"statue"] isEqualToString:@"un_bind"]) {
      [[NSNotificationCenter defaultCenter] postNotificationName:DISMISSLOGIN object:nil];
      // 提示绑定手机号
      RRFFindPwdController* regController = [[RRFFindPwdController alloc]init];
      regController.wechatInfo = obj;
      PZNavController* nav = [[PZNavController alloc]initWithRootViewController:regController];
      [self.rootController presentViewController:nav animated:YES completion:^{
        [Singleton sharedInstance].wechatInfo = obj ;
      }];
    }
    else{
      RLMRealm *realm = [RLMRealm defaultRealm];
      NSString* phoneNum = json[@"phoneNum"];
      NSString* xtNumber = json[@"xtNumber"];
      [realm beginWriteTransaction];
      LoginModel* loginM = [LoginModel allObjects].lastObject;
      loginM.phone_num = phoneNum ;
      loginM.login = @(1) ;
      [realm commitWriteTransaction];
      [self registeToJPush:obj.unionid];
      [XTChatUtil loginChatAccount:xtNumber pwd:@"123456" complete:^(id resultObject, NSError *error) {
        
      }];
    }
    [MBProgressHUD dismiss];
  } fail:^(id json) {
    
  }];
}


#pragma mark- 注册到极光推送 + 刷新首页
-(void)registeToJPush:(NSString*)userId{
  [PZHttpTool getMd5KeyWithUserName:userId successBlock:^(id json) {
    [MBProgressHUD dismiss];
    NSString* md5key = json[@"userMD5"] ;
    NSMutableString* md5Temp = [NSMutableString stringWithString:md5key];
    NSString* md5String = [md5Temp stringByReplacingOccurrencesOfString:@"-" withString:@""] ;
    [JPUSHService setAlias:md5String callbackSelector:nil object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:DISMISSLOGIN object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADHOME" object:nil];
  } fail:^(id json) {
    [MBProgressHUD dismiss];
  }];
}

-(void)showLogin
{
  RRFLoginController *loginVc = [[RRFLoginController alloc]init];
  PZNavController *nav = [[PZNavController alloc]initWithRootViewController:loginVc];
  PZTabController *mainController = self.rootController;
  [mainController presentViewController:nav animated:YES completion:nil];
}


-(void)otherSetting
{
  //umshare
  [UMSocialData setAppKey:UMShareAppKey];
  //设置微信AppId、appSecret，分享url
  //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
  [UMSocialQQHandler setQQWithAppId:QQAppID appKey:QQAppKey url:@"http://www.umeng.com/social"];
  [UMSocialWechatHandler setWXAppId:WechatAppID appSecret:WechatSecret url:@"http://www.umeng.com/social"];
  [UMSocialQQHandler setSupportWebView:YES];
  //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
  [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:WeiBoAppKey
                                            secret:WeiBoAppSecret
                                       RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
  
  
  [WXApi registerApp:WechatAppID withDescription:@"1.0"];
}

-(void)checkAppStatus{
  [HomeTool getAppStateSuccessBlock:^(id json) {
    NSString* appState = json ;
    if ([appState isEqualToString:@"wait_for_approve"]) {
      [PZCache sharedInstance].versionRelease = YES ;
    }
    else{
      [PZCache sharedInstance].versionRelease = YES ;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshCommentTableView object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshDiscover object:nil];
    
  } fail:^(id json) {
    [PZCache sharedInstance].versionRelease = NO ;
  }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  [self.rootController refreshBadgeValue];
  //    查询app状态开关
  [self checkAppStatus];
  [self resetBadge:application];
  //获取IP地址
  [PZParamTool getIpAddressesBlock:^(id json) {
    if (json!= nil) {
      NSDictionary* addrInfo = json[@"data"];
      if ([addrInfo isKindOfClass:[NSDictionary class]]) {
        [PZCache sharedInstance].addrInfo = addrInfo ;
      }
      else{
        NSMutableDictionary* info = [NSMutableDictionary dictionary];
        [info setObject:@"未知" forKey:@"ip"];
        [info setObject:@"火星用户" forKey:@"city"];
        [info setObject:@"" forKey:@"county"];
        [PZCache sharedInstance].addrInfo = info ;
      }
    }
    else{
      NSMutableDictionary* info = [NSMutableDictionary dictionary];
      [info setObject:@"未知" forKey:@"ip"];
      [info setObject:@"火星用户" forKey:@"city"];
      [info setObject:@"" forKey:@"county"];
      [PZCache sharedInstance].addrInfo = info ;
    }
  }];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
  [UMSocialSnsService handleOpenURL:url];
  return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
  BOOL isSuc = [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
  BOOL result = [UMSocialSnsService handleOpenURL:url];
  return  isSuc&&result;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
  if ([url.host isEqualToString:@"safepay"]) {
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
      [MBProgressHUD dismiss];
      [[NSNotificationCenter defaultCenter] postNotificationName:QueryOrderState object:resultDic];
    }];
  }
  if ([url.absoluteString hasPrefix:WechatAppID]) {
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
  }
  return YES;
}


#pragma mark- JPUSHRegisterDelegate
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  // Required, iOS 7 Support
  [JPUSHService handleRemoteNotification:userInfo];
  completionHandler(UIBackgroundFetchResultNewData);
  //打赏 评论
  [self showRewardWithUserInfo:userInfo];
  //重置
  [self resetBadge:application];
  
}

-(void)showRewardWithUserInfo:(NSDictionary*)userInfo{
  NSString* _j_type = userInfo[@"_j_type"] ;
  if ([_j_type isEqualToString:@"jmessage"]){
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyChat object:nil];
    return;
  }
  int msgType = [userInfo[@"type"] intValue] ;
  NSString* msg = userInfo[@"aps"][@"alert"];
  id msgModel = userInfo[@"msgModel"] ;
  //    presentDiamond(7, "打赏钻石"),
  //    upgradeIdentity(8, "升级会员"),
  //    lottery(9, "开奖"),
  //    weekAward(12, "周排行获奖"),
  //    monthAward(13, "月排行获奖"),
  //    yearAward(14, "年排行获奖"),
  //    commentReply(10, "对评论进行回复"),
  //    hasGuess(17, "第一次投注")
  //    replyToReply(11, "对回复进行回复");
  //    friendInvite(21,"别人添加你添加朋友"),
  //    acceptInviteFriend(22,"通过朋友验证");
  //    friendCirCleCommentReply(23,"朋友圈动态回复"),
  //    warnGuess(24,"提示投注"),
  //    friendCirCleReplyToReply(25,"朋友圈回复回复"),
  //    friendCirclePresentDiamond(26,"朋友圈打赏"),
  //    friendCirclePraise(27,"朋友圈点赞");
  //    bidWin(28, "夺宝中奖");
  NSString* tipTitle = @"确定" ;
  if (msgType == 16) {
    [self NotifyFriendToBet:msg messageModel:msgModel];
    return ;
  }
  if (msgType == 17) {
    [self freindFirstBetNotify:msg messageModel:msgModel];
    return;
  }
  if (msgType == 24) {
    [self noticeFriendBet:msg];
    return ;
  }
  if (msgType == 21 || msgType == 22 ||msgType == 23 ||msgType == 25 || msgType == 26 || msgType == 27) {
    if (msgModel != nil && ![msgModel isEqualToString:@"null"]) {
      if ([msgModel isKindOfClass:[NSString class]]) {
        [NotificateMsgUtil saveMsg:msgModel type:msgType] ;
      }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFriendCircleNoticeView object:nil];
    return ;
  }
  //RRFNoticeListController
  if (msgType == 7 || msgType == 10 || msgType == 11 || msgType == 15) {
    if (msgModel != nil&& ![msgModel isEqualToString:@"null"]) {
      if ([msgModel isKindOfClass:[NSString class]]) {
        [NotificateMsgUtil saveMsg:msgModel type:msgType] ;
      }
    }
    //发通知
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshBadgeValue object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshCommentNoticeView object:nil];
    return ;
  }
  // 提示绑定手机号
  [self showActionWithTitle:@"消息" message:msg cancelAction:nil confirmAction:^{
    //周 月 年 中奖
    if (msgType ==1 || msgType == 2 || msgType == 3){
      RRFNoticeListController* notificaeController = [[RRFNoticeListController alloc]init];
      notificaeController.showCancel = YES ;
      PZNavController* nav = [[PZNavController alloc]initWithRootViewController:notificaeController];
      [self.window.rootViewController presentViewController:nav animated:YES completion:^{
      }];
    }
    else if (msgType == 9){
      //开奖通知
      RRFBettingRecordController* notificaeController = [[RRFBettingRecordController alloc]init];
      notificaeController.title = @"投注记录" ;
      notificaeController.showCancel = YES ;
      PZNavController* nav = [[PZNavController alloc]initWithRootViewController:notificaeController];
      [self.window.rootViewController presentViewController:nav animated:YES completion:^{
      }];
    }
    else if (msgType == 28){
      //夺宝中奖
      RRFFreeBuyOrderViewController* orderList = [[RRFFreeBuyOrderViewController alloc]init];
      orderList.title = @"待领奖" ;
      orderList.showCancel = YES ;
      orderList.status = @"win" ;
      orderList.comminType = RRFFreeBuyOrderTypeMe;
      PZNavController* nav = [[PZNavController alloc]initWithRootViewController:orderList];
      [self.window.rootViewController presentViewController:nav animated:YES completion:^{
      }];
      
    }
  } confirmTitle:tipTitle];
}

#pragma mark  - 提醒朋友投注
-(void)NotifyFriendToBet:(NSString*)descString messageModel:(NSString*)msg{
  if (msg == nil || ![msg isKindOfClass:[NSString class]]) return;
  if (descString == nil || ![descString isKindOfClass:[NSString class]]) return;
  NSDictionary* msgM = [NotificateMsgUtil dictionaryWithJsonString:msg];
  RRFMessageNoticeListModel* model = [RRFMessageNoticeListModel yy_modelWithJSON:msgM];
  CommonPopOutController* popDetail = [[CommonPopOutController alloc]init];
  NSMutableAttributedString* str = [[NSMutableAttributedString alloc]initWithString:descString];
  NSString* userName = model.userName ;
  if (userName == nil || userName.length == 0) {
    userName = @"" ;
  }
  NSRange range = [descString rangeOfString:userName];
  [str addAttributes:@{NSForegroundColorAttributeName:StockRed} range:range];
  [popDetail setTitle:@"提醒" descInfo:str];
  STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:popDetail];
  popupController.navigationBarHidden = YES ;
  popupController.style = STPopupStyleFormSheet;
  popupController.containerView.layer.cornerRadius = 6 ;
  [popupController presentInViewController:self.window.rootViewController];
  popDetail.popViewBlock = ^(){
    [popupController dismiss];
  };
}


#pragma mark - 朋友首次投注后
-(void)freindFirstBetNotify:(NSString*)descString messageModel:(NSString*)msg{
  if (msg == nil || ![msg isKindOfClass:[NSString class]]) return;
  if (descString == nil || ![descString isKindOfClass:[NSString class]]) return;
  NSDictionary* msgM = [NotificateMsgUtil dictionaryWithJsonString:msg];
  RRFMessageNoticeListModel* model = [RRFMessageNoticeListModel yy_modelWithJSON:msgM];
  CommonPopOutController* popDetail = [[CommonPopOutController alloc]init];
  NSMutableAttributedString* str = [[NSMutableAttributedString alloc]initWithString:descString];
  NSString* userName = model.userName ;
  if (userName == nil || userName.length == 0) {
    userName = @"" ;
  }
  NSRange range = [descString rangeOfString:userName];
  [str addAttributes:@{NSForegroundColorAttributeName:StockRed} range:range];
  [popDetail setTitle:@"通知" descInfo:str];
  STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:popDetail];
  popupController.navigationBarHidden = YES ;
  popupController.style = STPopupStyleFormSheet;
  popupController.containerView.layer.cornerRadius = 6 ;
  [popupController presentInViewController:self.window.rootViewController];
  popDetail.popViewBlock = ^(){
    [popupController dismiss];
  };
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
  if (jsonString == nil) {
    return nil;
  }
  
  NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
  NSError *err;
  NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                      options:NSJSONReadingMutableContainers
                                                        error:&err];
  if(err) {
    NSLog(@"json解析失败：%@",err);
    return @{};
  }
  return dic;
}

#pragma mark - 提醒投注
-(void)noticeFriendBet:(NSString*)descString{
  if (descString == nil) return;
  CommonPopOutController* popDetail = [[CommonPopOutController alloc]init];
  NSMutableAttributedString* str = [[NSMutableAttributedString alloc]initWithString:descString];
  NSRange range = [descString rangeOfString:@"喜腾币"];
  [str addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:range];
  [popDetail setTitle:@"友情提醒！" descInfo:str];
  STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:popDetail];
  popupController.navigationBarHidden = YES ;
  popupController.style = STPopupStyleFormSheet;
  popupController.containerView.layer.cornerRadius = 6 ;
  [popupController presentInViewController:self.window.rootViewController];
  popDetail.popViewBlock = ^(){
    [popupController dismiss];
  };
}


-(void)resetBadge:(UIApplication*)application{
  [JPUSHService resetBadge];
  [application setApplicationIconBadgeNumber:0];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
  
  // Required,For systems with less than or equal to iOS6
  [JPUSHService handleRemoteNotification:userInfo];
  [self showRewardWithUserInfo:userInfo];
  
  [self resetBadge:application];
  
}


-(void)setupMainTabBar{
  [self enterMainScreen];
}

@end
