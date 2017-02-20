//
//  NSString+Valid.m
//  PrivateTeaStall
//
//  Created by 朱理哲 on 16/6/30.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "NSString+Valid.h"

@implementation NSString (Valid)

-(NSString*)getUrl{
    //可以识别url的正则表达式
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSError* error ;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSArray *arrayOfAllMatches = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        NSString* substringForMatch;
        substringForMatch = [self substringWithRange:match.range];
        [arr addObject:substringForMatch];
        
    }
    if (arr.count) {
        return arr.firstObject ;
    }
    return self ;
}

-(BOOL)isNull{
    BOOL nullString = [self isKindOfClass:[NSNull class]];
    BOOL nilString = (self == nil) ;
    BOOL nullStr = ([self isEqual:[NSNull null]]) ;
    return nullString || nilString || nullStr ;
}

+ (NSString *)typeForImageData:(NSData *)data {
    
    
    uint8_t c;
    
    [data getBytes:&c length:1];
    
    
    
    switch (c) {
            
        case 0xFF:
            
            return @"image/jpeg";
            
        case 0x89:
            
            return @"image/png";
            
        case 0x47:
            
            return @"image/gif";
            
        case 0x49:
            
        case 0x4D:
            
            return @"image/tiff";
            
    }
    
    return nil;
    
}

@end
