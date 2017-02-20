//
//  JNQProductCommentModel.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/30.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNQProductCommentModel : NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *xtNumber;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *userIconUrl;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSArray *contentImages;

@end
