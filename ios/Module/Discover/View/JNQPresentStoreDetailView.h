//
//  JNQPresentStoreDetailView.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "PZTitleInputView.h"
#import "JNQCountOperateView.h"
#import "JNQPresentProductModel.h"
#import "HBVerticalBtn.h"
#import "JNQAwardDetailModel.h"

typedef void(^CountBlock)(NSInteger count);

@interface JNQPresentStoreDetailView : UIView

@end

@interface JNQPresentDetailHeaderView : UIView

@property (nonatomic, assign) ProductDetailViewType viewType;
@property (nonatomic, strong) SDCycleScrollView *comPicScrollView;
@property (nonatomic, strong) UIView *desView;
@property (nonatomic, strong) UIView *opeView;
@property (nonatomic, strong) UIView *speciView;
@property (nonatomic, strong) PZTitleInputView *speciSelectView;

@property (nonatomic, strong) JNQPresentProductModel *productModel;
@property (nonatomic, strong) JNQAwardDetailModel *awardModel;

@end

@interface JNQPresentStoreDetailBottomView : UIView

@property (nonatomic, strong) HBVerticalBtn *seviceBtn;
@property (nonatomic, strong) HBVerticalBtn *shoppingCartBtn;
@property (nonatomic, strong) UIButton *addShopCart;
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, assign) NSInteger productCount;

@end

@interface JNQPresentDetailSectionHeaderView : UIView

@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, strong) PZTitleInputView *allCommentBtn;
@property (nonatomic, strong) ItemClickBlock buttonBlock;

@end

@interface JNQPresentStoreDetailOperationView : UIView

@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) JNQCountOperateView *addMinusView;
@property (nonatomic, strong) UIButton *quitBtn;
@property (nonatomic, strong) CountBlock countBlock;

@end