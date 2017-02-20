//
//  JNQVIPUpdateView.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/12.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JNQVIPUpdateView : UIView

@end

@interface JNQVIPUpdateHeaderView : UIView

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *vipBtn;
@property (nonatomic, strong) NSString *identityName;

- (void)setStartTime:(NSString *)startTime endTime:(NSString *)endTime;

@end
