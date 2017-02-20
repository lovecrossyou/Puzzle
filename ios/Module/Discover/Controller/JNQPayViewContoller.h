//
//  JNQPayViewContoller.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNQConfirmOrderModel.h"
#import "JNQPayReadyModel.h"
#import "JNQDiamondModel.h"
#import "JNQVIPModel.h"

typedef NS_ENUM(NSInteger, PayViewType) {
    PayViewTypeDiamond = 1,       //支付钻石
    PayViewTypeXTB     = 2,       //兑换喜腾币
    PayViewTypeVIP     = 3,       //支付会员
    PayViewTypeProduct = 4,       //兑换商品
    PayViewTypeDelegate= 5,       //喜鹊代理
    PayViewTypeHaul    = 7        //运程
};


@interface JNQPayViewContoller : UITableViewController

@property (nonatomic, strong) JNQConfirmOrderModel *confirmOrderModel;
@property (nonatomic, strong) JNQPayReadyModel *payRedyModel;
@property (nonatomic, strong) JNQProductPayResultModel *productPayResultModel;
@property (nonatomic, assign) PayViewType viewType;
@property (nonatomic, assign) BOOL isDelegateBuyDiamond;
@property (nonatomic, strong) JNQDiamondModel *diamondModel;
//@property (nonatomic, assign) NSInteger diamondCount;
@property (nonatomic, strong) JNQVIPModel *vipModel;

@end
