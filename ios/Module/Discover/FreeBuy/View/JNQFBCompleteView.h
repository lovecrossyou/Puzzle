//
//  JNQFBCompleteView.h
//  Puzzle
//
//  Created by HuHuiPay on 16/12/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBProductListModel.h"

@interface JNQFBCompleteView : UIView

@end

@interface JNQFBCompleteHeaderView : UIView

@property (nonatomic, strong) FBProductModel *productM;
@property (nonatomic, strong) ButtonBlock buttonBlock;

@end



@interface JNQFBCompleteFooterView : UIView

@property (nonatomic, strong) UIButton *fbContinueBtn;

@end
