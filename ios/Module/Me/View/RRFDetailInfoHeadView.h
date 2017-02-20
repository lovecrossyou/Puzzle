//
//  RRFDetailInfoHeadView.h
//  Puzzle
//
//  Created by huibei on 16/11/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRFDetailInfoModel;
@interface RRFDetailInfoHeadView : UIView
-(instancetype)initWithModel:(RRFDetailInfoModel *)model;
@end
@interface RRFDetailInfoFootView : UIControl
@property(nonatomic,strong)UIButton *titleBtn;
@end
