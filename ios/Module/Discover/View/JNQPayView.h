//
//  JNQPayView.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNQConfirmOrderModel.h"
#import "HBVerticalBtn.h"
#import "JNQVIPModel.h"
#import "JNQDiamondModel.h"

@interface JNQPayView : UIView

@end

@interface JNQPayHeaderView : UIView

@property (nonatomic, assign) NSInteger orderType;//(1钻石 2喜腾币 3会员 4兑换商品)
@property (nonatomic, strong) HBVerticalBtn *backBtn;
@property (nonatomic, strong) NSString *payResult;
//会员相关
@property (nonatomic, strong) UIView *vipPayBackView;
@property (nonatomic, strong) JNQVIPModel *vipModel;
//代理相关
@property (nonatomic, assign) NSInteger payCount;

@end

@interface JNQPayDiamondHeaderView : UIView

@property (nonatomic, strong) UIView *diamondPayBackView;
@property (nonatomic, strong) UILabel *diamondCount;
@property (nonatomic, strong) UILabel *diamondGiveCount;
@property (nonatomic, strong) UILabel *payPrice;
@property (nonatomic, strong) JNQConfirmOrderModel *confirmModel;
@property (nonatomic, strong) JNQDiamondModel *diamondModel;
@property (nonatomic, assign) NSInteger viewType;
@property (nonatomic, strong) JNQVIPModel *vipModel;
@end

@interface JNQProductPayView : UIView

@end

@interface JNQPayReadyFooterView : UIView

@property (nonatomic, strong) UIButton *payBtn;

@end

@interface JNQPayFooterView : UIView

@property (nonatomic, strong) NSString *payTypeStr;
@property (nonatomic, assign) NSInteger orderType;//(1钻石 2喜腾币 3会员 4兑换商品 5喜鹊代理 )
@property (nonatomic, assign) BOOL isDelegateBuyDiamond;
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, strong) UIButton *quitBtn;
@property (nonatomic, strong) NSString *vipIdentity;
@property (nonatomic, strong) JNQConfirmOrderModel *confirmOrderModel;

@end

