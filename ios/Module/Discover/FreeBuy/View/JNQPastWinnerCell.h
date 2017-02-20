//
//  JNQPastWinnerCell.h
//  Puzzle
//
//  Created by HuHuiPay on 16/12/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBPublicListModel.h"

@interface JNQPastWinnerCell : UITableViewCell

@property (nonatomic, strong) FBPublicModel *pubM;
@property (nonatomic, strong) ItemClickBlock clickBlock;

@end
