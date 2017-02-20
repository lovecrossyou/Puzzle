//
//  JNQConfirmOrderView.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PZTitleInputView.h"
#import "JNQAddressModel.h"

typedef void(^TrunToAddrBlcok)();

@interface JNQConfirmOrderView : UIView

@end

@interface JNQConfirmOrderHeaderView : UIView

@property (nonatomic, strong) PZTitleInputView *defaultView;
@property (nonatomic, strong) UILabel *receiveName;
@property (nonatomic, strong) UILabel *receiveNumber;
@property (nonatomic, strong) UILabel *receiveAddr;
@property (nonatomic, strong) UIView *nonDefaultView;
@property (nonatomic, strong) UIButton *addrSelectBtn;
@property (nonatomic, strong) JNQAddressModel *addrModel;
@property (nonatomic, strong) TrunToAddrBlcok block;

@end

@interface JNQConfirmOrderSectionFooterView : UIView

@property (nonatomic, assign) CGFloat mailFee;
@property (nonatomic, assign) NSInteger secTotalFee;
@property (nonatomic, assign) NSInteger secTotalCount;

@end

@interface JNQConfirmOrderBottomView : UIView

@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger totalFee;
@property (nonatomic, strong) UIButton *comCount;
@property (nonatomic, strong) UIButton *totalPrice;
@property (nonatomic, strong) UIButton *payBtn;

@end
