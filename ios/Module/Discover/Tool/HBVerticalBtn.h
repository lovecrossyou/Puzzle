//
//  HBVerticalBtn.h
//  PrivateTeaStall
//
//  Created by 朱理哲 on 16/6/6.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBVerticalBtn : UIControl
@property (nonatomic, strong) UILabel *titleView;
@property (nonatomic, assign) BOOL isDelegate;
-(instancetype)initWithIcon:(NSString*)icon title:(NSString*)title;
-(void)setBadge:(NSInteger)count;
-(void)setBadgeWidth:(NSInteger)width;
-(void)setFontSize:(CGFloat)size;
- (void)setTextColor:(UIColor *)textColor;
-(void)setIcon:(NSString*)icon;
-(void)setTitle:(NSString*)title;
@end
