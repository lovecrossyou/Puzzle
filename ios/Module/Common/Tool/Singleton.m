//
//  Singleton.m
//  HuiBeiWaterMerchant
//
//  Created by huibei on 16/5/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "Singleton.h"
static Singleton *sharedInstance = nil;
@implementation Singleton

#pragma mark - 获取Singleton单例
+(Singleton *)sharedInstance
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
@end
