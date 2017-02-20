//
//  CommonTableViewCell.h
//  PrivateTeaStall
//
//  Created by 朱理哲 on 16/6/12.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *sepLine;
@property (nonatomic, assign) BOOL topLineShow;
@property (nonatomic, assign) BOOL bottomLineSetFlush;
@property (nonatomic, assign) CGFloat sepHeight;

@end
