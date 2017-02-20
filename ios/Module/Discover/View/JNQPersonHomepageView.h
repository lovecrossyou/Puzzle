//
//  JNQPersonHomepageView.h
//  Puzzle
//
//  Created by HuHuiPay on 16/9/13.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNQSelfRankModel.h"
#import "PZTitleInputView.h"

@interface JNQPersonHomepageView : UIView

@end

@interface JNQPersonHomepageHeaderView : UIControl

@property (nonatomic, strong) JNQSelfRankModel *selfRankModel;
@property (nonatomic, strong) UIButton *headImgBtn;
@property (nonatomic, strong)  UILabel *infoLabel;
@property (nonatomic, strong) UIButton *allInfoBtn;
@property (nonatomic, strong) UIView *rankView;
@property (nonatomic, strong) PZTitleInputView *rankInput;

@end
