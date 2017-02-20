//
//  JNQShoppingCartView.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PZTitleInputView.h"

@interface JNQShoppingCartView : UIView

@end

@interface JNQShoppingCartBottomView : UIView

@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, strong) UIButton *allPrice;
@property (nonatomic, strong) UIButton *allBtn;

- (void)updateAllSelectState:(BOOL)state totalPrice:(NSInteger)totalPrice totalCount:(NSInteger)totalCount;

@end



@interface JNQShoppingCartSectionHeaderView : UIView

@property (nonatomic, strong) UIButton *allBtn;
@property (nonatomic, strong) ButtonBlock btnBlock;

@end
