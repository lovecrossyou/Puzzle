//
//  RRFInputPwdView.h
//  Puzzle
//
//  Created by huibei on 16/8/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//
typedef void (^RRFInputPwdBlock)(NSString *pwd);

#import <UIKit/UIKit.h>

@interface RRFInputPwdView : UIView
-(instancetype)initWithRegiste:(BOOL)registe;
@property(nonatomic,copy)RRFInputPwdBlock regiseBlock;

@end
