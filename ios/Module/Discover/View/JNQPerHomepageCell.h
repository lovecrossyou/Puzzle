//
//  JNQPerHomepageCell.h
//  Puzzle
//
//  Created by HuHuiPay on 16/9/13.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNQFriendCircleModel.h"

@interface JNQPerHomepageCell : UITableViewCell

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) JNQFriendCircleModel *circleModel;
@property (nonatomic, strong) ButtonBlock btnBlock;

@end
