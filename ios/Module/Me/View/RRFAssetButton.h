//
//  RRFAssetButton.h
//  Puzzle
//
//  Created by huibei on 16/8/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRFAssetButton : UIControl
@property(nonatomic,weak)UILabel *titleLabel;
@property(nonatomic,weak)UIImageView *iconView;

@end

@interface RRFAssetLabel : UIControl
@property(nonatomic,weak)UILabel *titleLabel;
@property(nonatomic,weak)UIButton *subTitleLabel;

@end