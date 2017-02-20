//
//  PZCache.m
//  Puzzle
//
//  Created by huipay on 2016/11/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZCache.h"
static PZCache *sharedInstance = nil;

@implementation PZCache
#pragma mark - 获取Singleton单例
+(PZCache *)sharedInstance
{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}
#pragma mark 唯一一次alloc单例，之后均返回nil
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
#pragma mark copy返回单例本身
-(id)copyWithZone:(NSZone *)zone
{
    return self;
}


+(BOOL)isFirstLaunch{
    return NO ;
}
@end
