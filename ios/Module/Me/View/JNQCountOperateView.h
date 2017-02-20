//
//  JNQCountOperateView.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/25.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface JNQCountOperateView : UIView

@property (nonatomic, strong) UIButton *btnMinus;
@property (nonatomic, strong) UIButton *btnAdd;
@property (nonatomic, strong) UITextField *numField;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) CountBlock countBlock;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;

@end
