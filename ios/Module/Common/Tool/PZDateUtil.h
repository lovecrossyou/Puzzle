//
//  PZDateUtil.h
//  Puzzle
//
//  Created by huipay on 2016/9/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface PZDateUtil : NSObject
+(NSString*)dateToMDW:(NSDate*)d;
+(NSString*)dateRemain:(NSString*)startTime endTime:(NSDate*)endTime;
+(NSString *)intervalSinceNow: (NSString *) theDate;
+(NSString *)intervalSinceNowMillisecond: (NSString *) theDate;
#pragma mark - 时间处理
+(NSString*)getLocalDate:(NSString*)time;
@end
