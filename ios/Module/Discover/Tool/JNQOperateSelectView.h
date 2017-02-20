//
//  JNQOperateSelectView.h
//  Puzzle
//
//  Created by HuHuiPay on 16/9/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JNQOperateSelectView : UIView

@property (nonatomic, strong) UIView *glideView;
@property (nonatomic, strong) NSArray *btnTitleArray;
@property (nonatomic, strong) ButtonBlock buttonBlock;

- (instancetype)initWithFrame:(CGRect)frame btnCount:(NSInteger)count;

@end
