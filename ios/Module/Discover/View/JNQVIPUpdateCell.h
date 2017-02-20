//
//  JNQVIPUpdateCell.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNQVIPModel.h"

@class JNQVIPUpdateCell;

typedef void(^VIPUpdateBlock)(JNQVIPUpdateCell *cell);

@interface JNQVIPUpdateCell : UITableViewCell

@property (nonatomic, strong) UIButton *levelBtn;
@property (nonatomic, strong) JNQVIPModel *vipModel;
@property (nonatomic, strong) VIPUpdateBlock vipUpdateBlock;

@end
