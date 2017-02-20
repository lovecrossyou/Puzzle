//
//  JNQProvinceCityModel.h
//  Puzzle
//
//  Created by HuHuiPay on 16/9/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNQProvinceCityModel : NSObject

@property (nonatomic, assign) NSInteger modelId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, assign) NSInteger parentAreaId;
@property (nonatomic, assign) NSInteger priority;

@end
