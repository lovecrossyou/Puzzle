//
//  JNQBookFBOrderView.h
//  Puzzle
//
//  Created by HuHuiPay on 16/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNQCountOperateView.h"
#import "FBProductListModel.h"
#import "JNQButton.h"

@interface JNQBookFBOrderView : UIView

@end



@interface JNQBookFBOrderOperateView : UIView

@property (nonatomic, strong) JNQCountOperateView *countOpeV;
@property (nonatomic, strong) NSArray *titleA;
@property (nonatomic, strong) FBProductModel *productM;
@property (nonatomic, assign) NSInteger restCount;
@property (nonatomic, strong) ButtonBlock buttonBlock;
@property (nonatomic, strong) CountBlock countBlock;
@property (nonatomic, strong) JNQXTButton *allInCountBtn;
@property (nonatomic, strong) id<UITextFieldDelegate> delegateVC;

@end

@interface JNQBookFBOrderHeaderView : UIView

@property (nonatomic, strong) JNQBookFBOrderOperateView *operateV;

@property (nonatomic, strong) FBProductModel *productM;
@property (nonatomic, assign) NSInteger restCount;
@property (nonatomic, strong) NSArray *titleA;
@property (nonatomic, strong) ButtonBlock buttonBlock;
@property (nonatomic, strong) CountBlock countBlock;
@property (nonatomic, strong) id<UITextFieldDelegate> delegateVC;

@end



@interface JNQBookFBOrderFooterView : UIView

@property (nonatomic, strong) UIButton *inBtn;

@end
