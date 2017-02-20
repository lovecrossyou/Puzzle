//
//  RRFPlanView.h
//  Puzzle
//
//  Created by huipay on 2016/12/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRFXTPlanModel,RRFAssetButton;
@interface RRFXQPlanView : UIView

@end
@interface RRFPlanHeaderView : UIView

@property(nonatomic,strong)RRFXTPlanModel *model;
@property(nonatomic,copy)ItemClickParamBlock planHeaderBlock;
-(instancetype)initWithBackgroundColor:(UIColor *)backgroundColor TextColor:(UIColor *)textColor;
@end
@interface RRFPlanFooterBarView : UIControl

@end
