//
//  JNQAwardModel.h
//  Puzzle
//
//  Created by HuHuiPay on 16/9/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JNQPresentModel.h"

@interface JNQAwardModel : NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger awardId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, assign) NSInteger profit;
@property (nonatomic, strong) NSString *awardName;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, strong) NSString *picUrl;
@property (nonatomic, strong) NSString *userIcon;
@property (nonatomic, assign) int rank;
@property (nonatomic, assign) int count;
@property (nonatomic, strong) JNQPresentModel *presentModel;
@property (nonatomic, strong) NSString *rankStr;

@end
