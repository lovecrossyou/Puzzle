//
//  RRFHomeHeaderView.h
//  Puzzle
//
//  Created by huibei on 16/9/30.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockGameList.h"
@class PurchaseGameActivity ;
@interface RRFHomeHeaderView : UIView
@property(copy,nonatomic)void(^activityClickBlock)(PurchaseGameActivity* model);
@property(nonatomic,weak)UIButton *avtivityBtn;
-(void)updateDate:(StockGameList*)stockModel;
-(void)configModel:(NSArray *)models;

@end
