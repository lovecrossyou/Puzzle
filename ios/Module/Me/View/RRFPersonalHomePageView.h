//
//  RRFPersonalHomePageView.h
//  Puzzle
//
//  Created by huibei on 16/9/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRFQuestionBarMsgModel,InsetsLabel;
@interface RRFPersonalHomePageView : UIControl
@property(nonatomic,strong)NSString *type;
// 认证简介
@property(nonatomic,strong)UILabel *introduceLabel;
// 展开
@property(nonatomic,strong)UIButton *fanningBtn;
// 认证
@property(nonatomic,strong)UIButton *attestationBtn;
@property(nonatomic,strong)RRFQuestionBarMsgModel *userM;

-(CGFloat)HeadViewHeightWithModel:(RRFQuestionBarMsgModel *)model;
@end