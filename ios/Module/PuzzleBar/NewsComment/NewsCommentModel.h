//
//  PZNewsContainerController.m
//  Puzzle
//
//  Created by huibei on 16/12/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//
#import <Foundation/Foundation.h>
//
@interface NewsCommentResponseModels : NSObject
//"fromUserName": "朱理哲",
//"fromUserId": 7,
//"respContent": "这是个好的啊",
//"isSelf": "self",
//"toUserName": null,
//"toUserId": null,
//"respType": "resp",
//"responseId": 1
@property (nonatomic, strong) NSString* fromUserName;
@property(assign,nonatomic)NSInteger fromUserId ;
@property (nonatomic, strong) NSString* respContent;
@property (nonatomic, strong) NSString* isSelf;
@property (nonatomic, strong) NSString* toUserName;
@property(assign,nonatomic)NSInteger toUserId ;
@property (nonatomic, strong) NSString* respType;
@property(assign,nonatomic)NSInteger responseId ;
@property (nonatomic, strong) NSString* commenterSource;

@end


@interface NewsCommentModel : NSObject

@property (nonatomic, strong) NSString* content;
@property(assign,nonatomic)NSInteger fassAmount ;
@property(assign,nonatomic)NSInteger ID ;
@property(assign,nonatomic)NSInteger identityType ;
@property (nonatomic, strong) NSString* isSelfComment;
@property (nonatomic, strong) NSArray* responseModels;

@property (nonatomic, strong) NSString* sex;
@property (nonatomic, strong) NSString* time;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* userIconUrl;
@property (nonatomic, strong) NSString* commenterSource;

@property(assign,nonatomic)NSInteger userId ;
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSString* userStatue;

@end

@interface NewsCommentListModel : NSObject
@property (nonatomic, assign) BOOL last;
//
@property(assign,nonatomic)NSInteger totalElements ;
@property (nonatomic, strong) NSArray* content;

@end
