//
//  JNQConfirmFBOrderView.h
//  Puzzle
//
//  Created by HuHuiPay on 16/12/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNQButton.h"
#import "FBProductListModel.h"

@interface JNQConfirmFBOrderView : UIView

@end

@interface JNQConfirmFBOrderHeaderView : UIView

@property (nonatomic, strong) FBProductModel *productM;
@property (nonatomic, assign) NSInteger inCount;

@end

@interface JNQConfirmFBOrderFooterView : UIView

@property (nonatomic, strong) JNQOperationButton *inBtn;

@end
