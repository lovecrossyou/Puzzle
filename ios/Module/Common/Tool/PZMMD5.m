//
//  PZMMD5.m
//  HuiBeiLifeMerchant
//
//  Created by niumu on 14-1-5.
//  Copyright (c) 2014年 huiyinfeng. All rights reserved.
//

#import "PZMMD5.h"
#import "CommonCrypto/CommonDigest.h"

#pragma mark 生成MD5摘要
@implementation PZMMD5

+ (NSString *)digest:(NSString *)source
{
    const char *cStr = [source UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    NSMutableString *md5str = [NSMutableString string];
    int count = sizeof(result)/sizeof(unsigned char);
    for (int i = 0; i<count; i++) {
        [md5str appendFormat:@"%02X", result[i]];
    }
    return md5str.uppercaseString;
}

#pragma mark - 验证合法网址
+(BOOL)isValidUrl:(NSString*)str{
    NSString *testUrl= @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",testUrl];
    return  [predicate evaluateWithObject:str];
    
}

@end
