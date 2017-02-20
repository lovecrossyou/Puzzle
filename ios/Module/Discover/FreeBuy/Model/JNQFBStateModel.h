//
//  JNQFBStateModel.h
//  Puzzle
//
//  Created by HuHuiPay on 16/12/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBProductListModel.h"

@interface JNQFBLukyUserModel : NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userIcon;
@property (nonatomic, strong) NSString *userSex;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSString *phoneModel;
@property (nonatomic, assign) NSInteger bidCount;
@property (nonatomic, strong) NSString *winTime;
@property (nonatomic, assign) NSInteger luckCode;

@end

@interface JNQFBStateModel : NSObject

@property (nonatomic, strong) JNQFBLukyUserModel *luckUserInfo;
@property (nonatomic, strong) NSArray *bidRecords;
@property (nonatomic, assign) NSInteger purchaseGameId;
@property (nonatomic, assign) NSInteger stage;
@property (nonatomic, strong) NSString *finishTime;
@property (nonatomic, strong) NSString *purchaseGameStatus;
@property (nonatomic, assign) BOOL bid;
@property (nonatomic, strong) NSString *openResultTime;

@end
