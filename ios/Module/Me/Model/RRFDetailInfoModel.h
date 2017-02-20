//
//  RRFDetailInfoModel.h
//  Puzzle
//
//  Created by huipay on 2016/11/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRFDetailInfoModel : NSObject
//address = "<null>";
//authorityTypeContent = "\U670b\U53cb\U5708";
//authorityTypeValue = 4;
//cnName = "\U4efb\U854a\U82b3";
//commentNum = 3;
//dynamicNum = 4;
//guessGameNum = 50;
//icon = "http://wx.qlogo.cn/mmopen/BMHKHSSSwmcVqviczyOnYe4zoJ0siapApxuukmK4xmWj19NVadQibmsiaOox8uNCImicf2Fuhm6xYHQR2Yx0KnF1iaUMNLVWxAHkVm/0";
//inviteId = "<null>";
//phoneNumber = 17600850481;
//relationTypeContent = "";
//relationTypeValue = "<null>";
//selfSign = "<null>";
//sex = 2;
//userId = 5;
//xtNumber = 71031036;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,assign)NSInteger ID;
@property(nonatomic,assign)NSInteger userId;
@property(nonatomic,assign)NSInteger inviteId;
@property(nonatomic,strong)NSString *phoneNumber;
@property(nonatomic,strong)NSString *cnName;
@property(nonatomic,strong)NSString *xtNumber;
@property(nonatomic,strong)NSString *icon;
@property(nonatomic,strong)NSString *selfSign;
@property(nonatomic,assign)int sex;
@property(nonatomic,assign)NSInteger dynamicNum;
@property(nonatomic,assign)NSInteger guessGameNum;
@property(nonatomic,assign)NSInteger commentNum;
@property(nonatomic,strong)NSString *passVerity;

@property(nonatomic,assign)NSInteger relationTypeValue;
@property(nonatomic,strong)NSString *relationTypeContent;
@property(nonatomic,assign)NSInteger authorityTypeValue;
@property(nonatomic,strong)NSString *authorityTypeContent;
@end
