//
//  PZCache.h
//  Puzzle
//
//  Created by huipay on 2016/11/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PZCache : NSObject

//苹果审核检测标示
@property(assign,nonatomic) BOOL versionRelease;
//位置缓存
@property(strong,nonatomic) NSString* addrString;
//手机型号缓存
@property(strong,nonatomic) NSString* phoneType;

//网络获取当前用户位置信息
@property(strong,nonatomic) NSDictionary* addrInfo ;
+(PZCache *)sharedInstance;
+(BOOL)isFirstLaunch;
@end
