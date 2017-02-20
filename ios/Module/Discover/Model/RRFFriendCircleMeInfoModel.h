//
//  RRFFriendCircleMeInfoModel.h
//  Puzzle
//
//  Created by huipay on 2016/11/9.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRFFriendCircleMeInfoModel : NSObject

//addGuessAmount = 2;
//bonusXtbAmount = 428;
//hitAmount = 2;
//hitRate = "100.00%";
//iconUrl = "http://wx.qlogo.cn/mmopen/ajNVdqHZLLBqRsB4vJ3VEsiadTfYcINZNFFM8wR6AK7Yu4z8OfqtQ8NMKqom4eibCJI2NurjYugDyXfZJqBWcbPA/0";
//identityType = 0;
//monthRanking = 0;
//ranking = 2;
//selfSign = "\U54c8\U75db\U53e3\U54e6\Uff0c\U54af\U54e6\U4e86\U843d\U5bde\U674e\U6770\U6211\U5c31\U56f0\U54e6\U5934\Uff0c\Uff1f";
//sex = "\U7537";
//userId = 10;
//userIntroduce = "<null>";
//userName = "\U732a\U732a\U4fa0";
//userStatue = "<null>";
//weekRanking = 0;
//yearRanking = 0;

@property(nonatomic,strong)NSString *userStatue;
@property(nonatomic,strong)NSString *userIntroduce;
@property(nonatomic,strong)NSString *sex;
@property(nonatomic,strong)NSString *iconUrl;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,assign)NSInteger bonusXtbAmount;
@property(nonatomic,assign)NSInteger weekRanking;
@property(nonatomic,assign)NSInteger yearRanking;
@property(nonatomic,assign)NSInteger ranking;

@property(nonatomic,strong)NSString *hitRate;
@property(nonatomic,assign)NSInteger userId;

@property(nonatomic,assign)NSInteger hitAmount;
@property(nonatomic,assign)NSInteger addGuessAmount;
@property(nonatomic,strong)NSString *selfSign;

@end
