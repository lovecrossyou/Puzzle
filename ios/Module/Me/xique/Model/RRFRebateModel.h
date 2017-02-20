//
//  RRFRebateModel.h
//  Puzzle
//
//  Created by huipay on 2016/12/30.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRFRebateModel : NSObject

@end



@interface RRFRebateMonthModel : NSObject

//{
//    month = 01;
//    rebateCount = "0.03";
//    year = 2017;
//}
//);

@property(nonatomic,strong)NSArray *dayList;
@property(nonatomic,strong)NSString *month;
@property(nonatomic,assign)double rebateCount;
@property(nonatomic,strong)NSString *year;
@property(nonatomic,assign)BOOL isOpen;
@property(nonatomic,assign)BOOL isRequest;

@end


@interface RRFRebateDayModel : NSObject
//{
//    buyDiamondAmount = 1000;
//    fassAmount = 0;
//    identityType = 0;
//    rebateAmount = 3;
//    sex = "\U5973";
//    time = "2016-12-29 19:33:30";
//    userIconUrl = "http://wx.qlogo.cn/mmopen/zw9xd1aIFpHfYv2Pn8laNaOOLKKBpaLWQWmhSUU8ibiczCEhicGeFYkicDGEZ679DxsBTBibKpm78LrcR9Hw9eFbrsKcBCSE0eMrU/0";
//    userId = 34;
//    userName = 13;
//    userStatue = "<null>";
//}
@property(nonatomic,assign)NSInteger buyDiamondAmount;
@property(nonatomic,assign)NSInteger fassAmount;
@property(nonatomic,assign)NSInteger identityType;
@property(nonatomic,assign)double rebateAmount;
@property(nonatomic,strong)NSString *sex;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *userIconUrl;
@property(nonatomic,assign)NSInteger userId;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *userStatue;

@end
