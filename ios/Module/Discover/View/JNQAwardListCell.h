//
//  JNQAwardListCell.h
//  Puzzle
//
//  Created by HuHuiPay on 16/9/9.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNQAwardModel.h"

@interface JNQAwardListCell : UITableViewCell

@property (nonatomic, assign) RankType rankType;
@property (nonatomic, strong) JNQAwardModel *awardModel;
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, strong) ItemClickBlock btnBlock;

@end
