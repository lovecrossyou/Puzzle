//
//  FBPublicListModel.h
//  Puzzle
//
//  Created by huibei on 16/12/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBPublicModel : NSObject
//{
//    area = "<null>";
//    bidCount = "<null>";
//    finishTime = "<null>";
//    ip = "<null>";
//    luckCode = "<null>";
//    phoneModel = "<null>";
//    productName = "<null>";
//    productUrl = "<null>";
//    purchaseGameId = 1;
//    stage = 20161201;
//    userIcon = "<null>";
//    userName = "<null>";
//    userSex = "<null>";
//Integer targetCount;
//String purchaseGameStatus;
//},
// 总需
@property(nonatomic,assign)NSInteger targetCount;
// 是否开奖
//finish_bid(2, "夺宝结束"),
//have_lottery(3, "已经开奖");
@property(nonatomic,copy)NSString *purchaseGameStatus;

@property(nonatomic,copy)NSString *openResultTime;
//
@property(nonatomic,copy)NSString *area;
// 揭晓时间
@property(nonatomic,copy)NSString *finishTime;
// 参与分数
@property(nonatomic,assign)NSInteger bidCount;
// 幸运号码
@property(nonatomic,assign)NSInteger luckCode;
@property(nonatomic,copy)NSString *phoneModel;
@property(nonatomic,copy)NSString *productName;
@property(nonatomic,copy)NSString *productUrl;
@property(nonatomic,assign)NSInteger purchaseGameId;

@property(nonatomic,assign)NSInteger stage;

@property(nonatomic,copy)NSString *ip;

@property(nonatomic,copy)NSString *userIcon;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *userSex;


@property (nonatomic, strong) NSString *m_titleStr;
@property (nonatomic)         int       m_countNum;

/**
 *  便利构造器
 *
 *  @param title         标题
 *  @param countdownTime 倒计时
 *
 *  @return 实例对象
 */
/**
 *  计数减1(countdownTime - 1)
 */
- (void)countDown;

/**
 *  将当前的countdownTime信息转换成字符串
 */
- (NSString *)currentTimeString;

@end
@interface FBPublicListModel : NSObject
@property(strong,nonatomic) NSArray* content;
@property(assign,nonatomic) BOOL last ;
@end
