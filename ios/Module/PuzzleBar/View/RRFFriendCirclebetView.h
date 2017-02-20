//
//  RRFFriendCirclebetView.h
//  Puzzle
//
//  Created by huipay on 2016/11/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRFFriendCircleModel.h"
@class GuessWithStockModel;
@interface RRFFriendCirclebetView : UIView
@property(nonatomic,strong)GuessWithStockModel *model;
@property(nonatomic,copy)ItemClickBlock betViewCheckBlock;

@end
