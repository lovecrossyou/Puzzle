//
//  JNQAwardDetailModel.h
//  Puzzle
//
//  Created by HuHuiPay on 16/11/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNQAwardDetailModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int rank;
@property (nonatomic, strong) NSString *picUrl;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, strong) NSArray *awardPictures;

@end
