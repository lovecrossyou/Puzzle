//
//  JNQComView.h
//  Puzzle
//
//  Created by HuHuiPay on 16/12/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNQButton.h"
#import "FBProductListModel.h"
#import "JNQFBStateModel.h"

@interface JNQComView : UIView

@end

@interface JNQComHeaderView : UIView

@property (nonatomic, strong) FBProductModel *fbProductModel;
@property (nonatomic, strong) JNQFBStateModel *stateM;
@property (nonatomic, strong) ButtonBlock buttonBlock;
- (void)updateContentHeight:(CGFloat)contentHeight nameHeight:(CGFloat)nameHeight descriptionHeight:(CGFloat)desHeight;
- (void)updateCountDown;

@end

@interface JNQComBottomView : UIView

@property (nonatomic, strong) JNQOperationButton *nowInBtn;

@end
