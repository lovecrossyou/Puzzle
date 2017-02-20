//
//  NSString+Valid.h
//  PrivateTeaStall
//
//  Created by 朱理哲 on 16/6/30.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Valid)
-(BOOL)isNull;
-(NSString*)getUrl;
+ (NSString *)typeForImageData:(NSData *)data;
@end
