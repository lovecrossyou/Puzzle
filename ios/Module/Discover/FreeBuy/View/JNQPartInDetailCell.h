//
//  JNQPartInDetailCell.h
//  Puzzle
//
//  Created by HuHuiPay on 16/12/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNQFBBidRecodModel.h"

@interface JNQPartInDetailCell : UITableViewCell

@property (nonatomic, strong) JNQFBBidRecodModel *bidRecodModel;
@property (nonatomic, strong) ButtonBlock buttonBlock;

@end
