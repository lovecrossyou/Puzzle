//
//  NotificateMsgUtil.h
//  Puzzle
//
//  Created by huipay on 2016/10/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NotificateMsgModel ;
@interface NotificateMsgUtil : NSObject
+(void)saveMsg:(id)msg type:(int)type;
+(void)updateMsg:(NotificateMsgModel*)msg;
+(NSArray *)loadMsgUnRead;
+(NSArray *)loadAllMsg;

+(NSArray *)loadCircleAll:(BOOL)unread;
+(NSArray *)loadCircleAll;
+(NSUInteger)unReadMsgCount;

+(void)setAllUnread;
+(void)setAllCicleUnread;
+(NSArray *)loadCircleVerifyUnRead;
+(void)clearAllCircleData;
+(void)clearAllSLData;

//清除验证朋友数据
+(void)clearVerifyFriendData;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//+(BOOL)
@end
