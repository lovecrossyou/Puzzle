//
//  JNQRedPaperClickedView.h
//  Puzzle
//
//  Created by HuHuiPay on 17/1/16.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BonusPaperModel.h"

@interface JNQRedPaperClickedView : UIView

@property (nonatomic, strong) BonusPaperModel *pModel;
@property (nonatomic, strong) ButtonBlock btnBlock;
@property (nonatomic, assign) BOOL isOver;
@property (nonatomic, assign) BOOL isTimeOut;
@property (nonatomic, assign) BOOL isSend;

@end
