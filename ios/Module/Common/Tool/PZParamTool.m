
//
//  HBParamTool.m
//  HuiBeiWaterMerchant
//
//  Created by 朱理哲 on 16/5/11.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZParamTool.h"
#import "PZMMD5.h"
#import "PZAccessInfo.h"
#import "Singleton.h"
#import <Realm/Realm.h>
#import "PZHttpTool.h"
#import "WechatUserInfo.h"
#import <sys/utsname.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation PZParamTool

+(NSMutableDictionary*)registeWechatRequestParam:(WechatUserInfo*)wechatModel {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                 @"app_key":AppKey,
                                                                                 @"access_token":wechatModel.access_token,
                                                                                 @"phone_num":wechatModel.unionid,
                                                                                 @"signature":[PZMMD5 digest:[NSString stringWithFormat:@"%@",AppSecret]]
                                                                                 }];
    return param;
}


+(NSMutableDictionary*)registeBaseRequestParam:(NSString*)phone_num{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                 @"app_key":AppKey,
                                                                                 @"access_token":@"",
                                                                                 @"phone_num":phone_num,
                                                                                 @"signature":[PZMMD5 digest:[NSString stringWithFormat:@"%@",AppSecret]]
                                                                                 }];
    return param;
}


+(NSString*)getLoginSignatureWithUserName:(NSString*)userName pwd:(NSString*)pwd md5key:(NSString*)md5key{
    NSString* param1 = [NSString stringWithFormat:@"%@%@%@",userName,pwd,md5key];
    NSString* param2 = [NSString stringWithFormat:@"%@%@",AppSecret,[PZMMD5 digest:param1]];
    NSString* md5String = [PZMMD5 digest:param2];
    return md5String ;
}

+(NSString*)getLoginSignatureWithOpenId:(NSString*)openId{
    NSString* param2 = [NSString stringWithFormat:@"%@%@",AppSecret,openId];
    NSString* md5String = [PZMMD5 digest:param2];
    return md5String ;
}


+(LoginModel *)currentUser{
    RLMResults *users = [LoginModel allObjects];
    return users.lastObject ;
}

+(void)loginOut{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    LoginModel* user = [[LoginModel objectsWhere:@"login == 1"] lastObject];
    user.login = @(NO) ;
    user.access_token = nil ;
    user.access_token_secret = nil ;
    [Singleton sharedInstance].loginModel = user;
    [realm commitWriteTransaction];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADHOME" object:nil];
}

+(BOOL)hasLogin{
    LoginModel* user = [[LoginModel objectsWhere:@"login == 1"] lastObject];
    if (user == nil ||user.access_token == nil) {
        return NO ;
    }
    return YES ;
}

//基本请求参数
+(PZAccessInfo*)createAccessInfo{
    LoginModel* user = [self currentUser];
    NSString* access_token = @"" ;
    NSString* phone_num = @"" ;
    NSString* signature = [PZMMD5 digest:[NSString stringWithFormat:@"%@",AppSecret]] ;
    if (user != nil) {
        access_token = user.access_token ;
        phone_num = user.phone_num ;
        signature = [PZMMD5 digest:[NSString stringWithFormat:@"%@&%@",AppSecret,user.access_token_secret]];
    }
    PZAccessInfo* accessInfo = [[PZAccessInfo alloc]init];
    accessInfo.app_key = AppKey;
    accessInfo.signature = signature;
    accessInfo.access_token = access_token;
    accessInfo.phone_num = phone_num;
    accessInfo.os = @"ios" ;
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    accessInfo.version = currentVersion ;
    return accessInfo;
}

+(PZAccessInfo*)createWeChatAccessInfo{
    WechatUserInfo* user = [WechatUserInfo allObjects].lastObject ;
    NSString* access_token = @"" ;
    NSString* signature = [PZMMD5 digest:[NSString stringWithFormat:@"%@",AppSecret]] ;
    PZAccessInfo* accessInfo = [[PZAccessInfo alloc]init];
    accessInfo.app_key = AppKey;
    accessInfo.signature = signature;
    accessInfo.access_token = access_token;
    accessInfo.phone_num = user.unionid;
    accessInfo.os = @"ios" ;
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    accessInfo.version = currentVersion ;
    return accessInfo;
}




//基本请求参数
+(PZAccessInfo*)createAccessInfoNotLogin{
    if ([self hasLogin]) {
        return [self createAccessInfo] ;
    }
    NSString* phone_num = @"" ;
    NSString* signature = [PZMMD5 digest:[NSString stringWithFormat:@"%@",AppSecret]] ;
    PZAccessInfo* accessInfo = [[PZAccessInfo alloc]init];
    accessInfo.app_key = AppKey;
    accessInfo.signature = signature;
    accessInfo.phone_num = phone_num;
    accessInfo.os = @"ios" ;
    accessInfo.access_token = @"" ;
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    accessInfo.version = currentVersion ;

    return accessInfo;
}
// 获取账户信息
+(void)getAccountInfo
{
    // 喜腾币信息
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    [PZHttpTool postRequestUrl:@"account/info" parameters:@{@"accessInfo":[accessInfo yy_modelToJSONObject]} successBlock:^(id json) {
        RLMRealm *defaultRealm = [RLMRealm defaultRealm];
        [defaultRealm beginWriteTransaction];
        LoginModel* userM = [LoginModel yy_modelWithJSON:json];
        LoginModel *userInfo = [PZParamTool currentUser];
        userInfo.xtbCapitalAmount = userM.xtbCapitalAmount;
        userInfo.xtbTotalAmount = userM.xtbTotalAmount;
        userInfo.diamondAmount =userM.diamondAmount;
        [defaultRealm commitWriteTransaction];
    } fail:^(id json) {
        NSLog(@"喜腾账户信息获取失败");
    }];
}
+(void)rewardWithUserId:(NSInteger)userId amount:(int)amount entityId:(NSInteger)entityId entityType:(NSString *)entityType Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [self createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"receiveuserId":@(userId),
                            @"amount":@(amount),
                            @"entityId":@(entityId),
                            @"entityType":entityType
                            };
    [PZHttpTool postRequestUrl:@"presentDiamonds" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
+(void)agreedToWithUrl:(NSString *)url param:(NSMutableDictionary *)param Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    if(![self hasLogin]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin" object:nil];
        return;
    }
    PZAccessInfo *accessInfo = [self createAccessInfo];
    [param addEntriesFromDictionary:@{@"accessInfo":[accessInfo yy_modelToJSONObject]}];
    [PZHttpTool postRequestUrl:url showSVProgressHUD:NO parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        
    }];
}
+(void)replyCommentWithUrl:(NSString *)url param:(NSMutableDictionary *)param Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail{
    
    PZAccessInfo *accessInfo = [self createAccessInfo];
    [param addEntriesFromDictionary:@{@"accessInfo":[accessInfo yy_modelToJSONObject]}];
    [PZHttpTool postRequestUrl:url parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
        NSLog(@"回复评论失败");
    }];
}
+(NSString*)jsonStrWithDic:(id)dictionary{
    NSError* error ;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    NSString* str = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    return str ;
}

// 本月的第一天
+(NSString*)currentMonthFirst{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger iCurYear = [components year];  //当前的年份
    NSInteger iCurMonth = [components month];  //当前的月份
    return [NSString stringWithFormat:@"%ld-%ld-1 0:0:0",(long)iCurYear,(long)iCurMonth];
}

+(NSString*)currentMonth{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
    NSInteger day = [dateComponent day];
    NSInteger h = [dateComponent hour];
    NSInteger m = [dateComponent minute];
    NSInteger s = [dateComponent second];
    return [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld:%ld",(long)year,(long)month,(long)day,(long)h,(long)m,(long)s];
    
}



+ (NSString *)iphoneType {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])  return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])  return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])  return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])  return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])  return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])  return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])   return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])  return @"iPhone Simulator";
    
    return platform;
    
}

+ (void)getIpAddressesBlock:(PZRequestSuccess)complete{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString *url = @"http://ip.taobao.com/service/getIpInfo.php?ip=myip";
        NSString *URLTmp = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData * resData = [NSData dataWithContentsOfURL:[NSURL URLWithString:URLTmp]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (resData) {
                //系统自带JSON解析
                NSError *error = nil;
                NSDictionary* jsonObject = [NSJSONSerialization JSONObjectWithData:resData
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];
                complete(jsonObject);
            }
        });
    });
}

@end
