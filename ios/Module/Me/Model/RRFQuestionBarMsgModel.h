//
//  RRFQuestionBarMsgModel.h
//  Puzzle
//
//  Created by huibei on 16/9/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRFQuestionBarMsgModel : NSObject
///Printing description of json:
//{
//    answerAmount = 0;
//    commentAmount = 5;
//    fansAmount = 0;
//    isFollower = noFollower;
//    questionBarId = 19;
//    selfSign = "<null>";
//    sex = "\U7537";
//    statue = "<null>";
//    userIconUrl = "http://wx.qlogo.cn/mmopen/BMHKHSSSwme6Rbb4IXPjCXsacJv07Os2zEA1xZTyvVwvgqS34yytw7pXBktsqogRyvKH5ZVzaZ7erTRJfjaRgd1RAmhF0p5I/0";
//    userId = 19;
//    userIntroduce = "<null>";
//    userName = change;
//}

// 是否展开
@property(nonatomic,assign)BOOL isFanning;
//回答的数量
@property(nonatomic,assign)NSInteger answerAmount;
// 评论数量
@property(nonatomic,assign)NSInteger commentAmount;
// 粉丝数量
@property(nonatomic,assign)NSInteger fansAmount;
//是否关注   alreadyFollower 已经关注  noFollower  没关注
@property(nonatomic,strong)NSString *isFollower;
//问吧 id
@property(nonatomic,assign)NSInteger questionBarId;
// 个性签名
@property(nonatomic,strong)NSString *selfSign;
// 性别
@property(nonatomic,strong)NSString *sex;
//是否认证 already_review 已经认证
@property(nonatomic,strong)NSString *statue;
//头像地址
@property(nonatomic,strong)NSString *userIconUrl;
// 用户id
@property(nonatomic,assign)NSInteger userId;
// //用户名称
@property(nonatomic,strong)NSString *userName;
// 介绍
@property(nonatomic,strong)NSString *userIntroduce;


@end
