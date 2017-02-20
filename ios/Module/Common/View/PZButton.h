//
//  PZButton.h
//  Puzzle
//
//  Created by huibei on 16/8/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PZButton : UIControl
@property(nonatomic,weak)UIButton *countBtn;
@property(nonatomic,weak)UIImageView *iconView;
@property(nonatomic,weak)UILabel *nameLabel;
-(void)setCount:(int)count;
@end
