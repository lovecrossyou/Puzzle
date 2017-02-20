//
//  RRFRebateView.h
//  Puzzle
//
//  Created by huipay on 2016/12/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRFRebateDetailInfoModel,RRFRebateMonthModel;
@interface RRFRebateView : UIView
@property(nonatomic,strong)RRFRebateDetailInfoModel *model;
@end


@interface RRFRebateSectionHeaderView : UIControl
@property(nonatomic,strong)RRFRebateMonthModel *model;
@end

