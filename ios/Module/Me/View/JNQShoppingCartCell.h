//
//  JNQShoppingCartCell.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNQPresentProductModel.h"
#import "JNQCountOperateView.h"

typedef void(^ProductCountBlock)(NSInteger count);

@interface JNQShoppingCartCell : UITableViewCell

@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UILabel *comCount;
@property (nonatomic, strong) JNQCountOperateView *addMinusView;
@property (nonatomic, strong) JNQPresentProductModel *productModel;
@property (nonatomic, strong) ProductCountBlock countBlock;
@property (copy, nonatomic) ItemClickBlock reloadBlock;
@property (nonatomic, strong) ButtonBlock btnBlock;
@property (nonatomic, strong) id<UITextFieldDelegate> vc;

@end
