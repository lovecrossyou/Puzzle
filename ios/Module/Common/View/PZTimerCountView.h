//
//  HBTimerCountView.h
//  HuiBeiWaterMerchant
//
//  Created by 朱理哲 on 16/6/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PZTimerCountView : UIControl
@property(strong,nonatomic)UIColor* textColor ;
-(instancetype)initWithWaitMsg:(NSString*)waitStr;
-(void)startTimer;
@end
