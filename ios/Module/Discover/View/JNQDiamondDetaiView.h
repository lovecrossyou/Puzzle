//
//  JNQDiamondDetaiView.h
//  Puzzle
//
//  Created by HuHuiPay on 16/9/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNQDiamondModel.h"
#import "JNQCountOperateView.h"

@interface JNQDiamondDetaiView : UIView

@end

@interface JNQDiamondDetaiHeaderView : UIView

@property (nonatomic, strong) JNQCountOperateView *countOperateView;
@property (nonatomic, strong) JNQDiamondModel *diamondModel;
@property (nonatomic, strong) CountBlock countBlock;

@end
