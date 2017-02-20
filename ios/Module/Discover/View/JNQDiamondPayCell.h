//
//  JNQXTBExchangeCell.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNQDiamondModel.h"
#import "JNQOrderModel.h"
#import "JNQProductModel.h"

@class JNQDiamondPayCell;

typedef void(^DiamondPayBlock)(JNQDiamondPayCell *cell);

@interface JNQDiamondPayCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *count;
@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong) UIButton *payBtn;

@property (nonatomic, strong) JNQDiamondModel *diamondModel;
@property (nonatomic, strong) JNQOrderModel *orderModel;
@property (nonatomic, strong) JNQProductModel *productModel;
@property (nonatomic, strong) DiamondPayBlock diamondPayBlock;

@end
