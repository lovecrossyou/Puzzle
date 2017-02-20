//
//  RRFPrizeView.h
//  Puzzle
//
//  Created by huibei on 16/9/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNQAddressOperateView.h"
@class JNQAddressOperateHeaderView,RRFNoticeModel,RRFDrawModel;
@interface RRFPrizeView : UIView
@property(nonatomic,strong)RRFNoticeModel *model;
@property(nonatomic,strong)RRFDrawModel *drawModel;
@property(nonatomic,weak)JNQAddressOperateHeaderView *addView;
@property(nonatomic,copy)ItemClickBlock chooseContactBlock;
@property(nonatomic,copy)ItemClickBlock chooseAddressBlcok;
@property(nonatomic,copy)ItemClickBlock determineBlock;

@end
