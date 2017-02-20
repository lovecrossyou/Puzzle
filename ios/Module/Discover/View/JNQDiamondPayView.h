//
//  JNQXTBExchangeView.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBVerticalBtn.h"

@interface JNQDiamondPayView : UIView

@end

@interface JNQDiamondPayHeaderView : UIView

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger stockCount;

@property (nonatomic, strong) HBVerticalBtn *backBtn;
@property (nonatomic, strong) UIView *stockBackView;
@property (nonatomic, strong) UIView *line;

@end
