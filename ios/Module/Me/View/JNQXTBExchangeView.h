//
//  JNQXTBExchangeView.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/25.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNQCountOperateView.h"
typedef void(^JNQXTBExchangeHeaderBlock)(UIButton *button);

@interface JNQXTBExchangeView : UIView

@end

@interface JNQAcctDescribtionView : UIView

@property (nonatomic, assign) NSInteger diamondCount;

@end

@interface JNQXTBExchangeHeaderView : UIView

@property (nonatomic, assign) NSInteger diamondCount;
@property (nonatomic, assign) NSInteger xtbCount;
@property (nonatomic, assign) NSInteger diamondPrice;
@property (nonatomic, strong) UIView *btnsBackView;
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, strong) JNQXTBExchangeHeaderBlock block;

@end