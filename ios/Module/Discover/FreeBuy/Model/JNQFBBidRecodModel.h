//
//  JNQFBBidRecodModel.h
//  Puzzle
//
//  Created by HuHuiPay on 16/12/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNQFBBidRecodModel : NSObject

@property (nonatomic, assign) NSInteger bidOrderId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, assign) NSInteger xiTengCode;
@property (nonatomic, strong) NSString *userIcon;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSString *phoneModel;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, assign) NSInteger bidCount;
@property (nonatomic, assign) NSInteger userId;

@end
