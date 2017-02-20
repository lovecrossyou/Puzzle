//
//  RRFBettingLabel.h
//  Puzzle
//
//  Created by huibei on 16/9/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRFBettingLabel : UIView
-(instancetype)initWithTitle:(NSString *)title;
@property(nonatomic,weak)UIButton *subTitleLabel;
@property(nonatomic,strong)NSString *iconStr;
-(void)subTitleRight:(BOOL)right;

@end
