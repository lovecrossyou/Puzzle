//
//  QuestionBarListModel.h
//  Puzzle
//
//  Created by huipay on 2016/8/30.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionBarModel :NSObject

//{
//    answerAmount = 0;
//    commentAmount = "<null>";
//    fansAmount = 1;
//    isFollower = alreadyFollower;
//    questionBarId = 2;
//    sex = "";
//    statue = "<null>";
//    userIconUrl = "http://114.251.53.22/M00/00/01/wKgKZlf9pauAABlMAAAHrEeg0cA28.JPEG";
//    userId = 2;
//    userIntroduce = "<null>";
//    userName = "\U516d\U70b9\U8d77\U7684\U53e4\U5c0f\U8bd7";
//}

// 性别
@property(strong,nonatomic)NSString* sex ;
@property(assign,nonatomic)int answerAmount ;
@property(assign,nonatomic)int fansAmount ;
//alreadyFollower已经关注  noFollower 没关注
@property(strong,nonatomic)NSString* isFollower ;
@property(assign,nonatomic)int questionBarId ;

@property(strong,nonatomic)NSString* userIconUrl ;
@property(assign,nonatomic)int userId ;
@property(strong,nonatomic)NSString* userIntroduce ;

@property(strong,nonatomic)NSString* userName ;
@property(strong,nonatomic)NSString* hotSign ;

@property(strong,nonatomic) NSString* statue ;

@end

@interface QuestionBarListModel : NSObject
@property NSArray *content ;
@property(assign,nonatomic)BOOL last ;
@end
