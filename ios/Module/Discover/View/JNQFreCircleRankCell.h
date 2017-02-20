//
//  JNQFreCircleRankCell.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNQSelfRankModel.h"


@interface JNQFreCircleRankCell : UITableViewCell

@property (nonatomic, strong) UIButton *rankLabel;

@property (nonatomic) FriendRankType rankType;
@property (nonatomic, strong) JNQSelfRankModel *selfRankModel;
@property (nonatomic, strong) UIView *topBackView;
@property (nonatomic, strong) UIView *botBackView;

@end
