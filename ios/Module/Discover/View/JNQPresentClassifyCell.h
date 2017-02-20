//
//  JNQPresentClassifyCell.h
//  Puzzle
//
//  Created by HuHuiPay on 16/12/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNQProductListModel.h"

@interface JNQPresentClassifyCell : UICollectionViewCell

@property (nonatomic, strong) JNQPresentClassifyModel *classifyM;
@property (nonatomic, strong) UIButton *imgBtn;
@property (nonatomic, strong) UILabel *titleL;

@end
