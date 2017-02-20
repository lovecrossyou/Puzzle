//
//  PZMMD5.h
//  HuiBeiLifeMerchant
//
//  Created by niumu on 14-1-5.
//  Copyright (c) 2014年 huiyinfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PZMMD5 : NSObject
// 生成MD5摘要
+ (NSString *)digest:(NSString *)source;
//合法网址验证
+(BOOL)isValidUrl:(NSString*)str;
@end
