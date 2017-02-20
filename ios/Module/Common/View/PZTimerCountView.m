
//
//  HBTimerCountView.m
//  HuiBeiWaterMerchant
//
//  Created by 朱理哲 on 16/6/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//
#define timerTotalCount 60
#import "PZTimerCountView.h"

@interface PZTimerCountView()
{
    NSTimer* _timer ;
    int _currentCount ;
}
@property(weak,nonatomic)UILabel* labelCount ;
@property(copy,nonatomic)NSString* waitStr ;

@end

@implementation PZTimerCountView

-(instancetype)initWithWaitMsg:(NSString*)waitStr{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        WEAKSELF
        _currentCount = timerTotalCount ;
        self.waitStr  = waitStr;
        UILabel* labelCount = [[UILabel alloc]init];
        labelCount.text = waitStr ;
        labelCount.font = [UIFont systemFontOfSize:13];
        labelCount.textColor = [UIColor colorWithHexString:@"aaaaaa"];
        labelCount.textAlignment = NSTextAlignmentCenter ;
//        labelCount.layer.borderColor = [UIColor colorWithHexString:@"ffc800"].CGColor;
//        labelCount.layer.borderWidth = 1 ;
//        labelCount.layer.masksToBounds = YES ;
//        labelCount.layer.cornerRadius =  5;
        [labelCount sizeToFit];
        [self addSubview:labelCount];
        [labelCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.left.mas_equalTo(12);
            make.height.mas_equalTo(32.0f);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        self.labelCount = labelCount ;
        [[self rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [weakSelf startTimer];
        }];
    }
    return self ;
}

-(void)startTimer{
    if (_timer == nil ) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    }
    [_timer fire];
}

#pragma mark - 刷新倒计时
-(void)updateTimer{
    if (_currentCount > 0) {
        NSString* timeString = [NSString stringWithFormat:@"%d(s)",_currentCount];
        self.labelCount.text = timeString ;
        self.labelCount.textColor = [UIColor lightGrayColor];
        self.userInteractionEnabled = NO ;
        _currentCount -- ;
    }
    else{
        [_timer invalidate];
        _timer = nil ;
        _currentCount= timerTotalCount ;
        self.labelCount.text = self.waitStr ;
        self.userInteractionEnabled = YES ;
    }
}

-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor ;
    self.labelCount.textColor = textColor ;
}

@end
