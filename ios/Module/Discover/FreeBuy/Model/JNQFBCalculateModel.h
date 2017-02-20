//
//  JNQFBCalculateModel.h
//  Puzzle
//
//  Created by HuHuiPay on 16/12/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNQCalUserModel : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userIcon;
@property (nonatomic, assign) NSInteger xiTengCode;
@property (nonatomic, assign) NSInteger bidCode;
@property (nonatomic, strong) NSString *time;

@end

@interface JNQFBCalculateModel : NSObject

@property (nonatomic, assign) NSInteger stockValue;
@property (nonatomic, assign) NSInteger luckCode;
@property (nonatomic, strong) NSArray *content;
@property (nonatomic, assign) NSInteger avalue;
@property (nonatomic, strong) NSString *time;

@end
