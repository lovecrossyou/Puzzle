//
//  XTChatUtil.h
//  Puzzle
//
//  Created by 朱理哲 on 2016/12/3.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JMessage/JMessage.h>

@interface XTChatUtil : NSObject
+(void)loginChatAccount:(NSString*)username pwd:(NSString*)pwd complete:(JMSGCompletionHandler)complete;
+(void)logout;
+(void)autoLogin:(JMSGCompletionHandler)complete;
+(void)getConversationBadge:(ItemClickParamBlock)completeBlock;
+(void)updateAvatar:(UIImage*)image;
//修改昵称
+(void)updateNickName:(NSString*)name;
//修改好友备注
+ (void)update:(JMSGUser*)friend noteText:(NSString *)noteText completionHandler:(JMSGCompletionHandler)handler;
@end
