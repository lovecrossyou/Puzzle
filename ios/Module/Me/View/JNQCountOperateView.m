//
//  JNQCountOperateView.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/25.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQCountOperateView.h"
//#import <Realm/Realm.h>

@implementation JNQCountOperateView {
    UIView *_leftLine;
    UIView *_rightLine;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _btnMinus = [[UIButton alloc] init];
        [self addSubview:_btnMinus];
        [_btnMinus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(frame.size.width/4);
        }];
        [_btnMinus setTitle:@"-" forState:UIControlStateNormal];
        _btnMinus.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_btnMinus setTitleColor:HBColor(211, 211, 211) forState:UIControlStateNormal];
        _btnMinus.titleLabel.font = PZFont(20);
        [[_btnMinus rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            self.count -= 1;
            if (self.count <= 0) {
                self.count = 1;
            }
        }];
        
        _btnAdd = [[UIButton alloc] init];
        [self addSubview:_btnAdd];
        [_btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(frame.size.width/4);
        }];
        [_btnAdd setTitle:@"+" forState:UIControlStateNormal];
        _btnAdd.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_btnAdd setTitleColor:HBColor(211, 211, 211) forState:UIControlStateNormal];
        _btnAdd.titleLabel.font = PZFont(20);
        [[_btnAdd rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            self.count += 1;
        }];
        
        _numField = [[UITextField alloc]init];
        [self addSubview:_numField];
        [_numField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.btnMinus.mas_right).offset(1);
            make.right.mas_equalTo(self.btnAdd.mas_left).offset(-1);
            make.top.mas_equalTo(1);
            make.bottom.mas_equalTo(-1);
        }];
        _numField.keyboardType = UIKeyboardTypeNumberPad ;
        _numField.textAlignment = NSTextAlignmentCenter;
        _numField.textColor = HBColor(51, 51, 51);
        _numField.font = PZFont(16.0f);
        _numField.text = @"1";
        [_numField.rac_textSignal subscribeNext:^(NSString* countString) {
            self.count = [countString integerValue];
        }];
        
        _leftLine = [[UIView alloc] init];//WithFrame:CGRectMake(frame.size.width/4, 0, 0.7, frame.size.height)];
        [self addSubview:_leftLine];
        [_leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.mas_equalTo(self);
            make.left.mas_equalTo(self).offset(frame.size.width/4);
            make.width.mas_equalTo(0.7);
        }];
        _leftLine.backgroundColor = HBColor(211, 211, 211);
        
        _rightLine = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/4*3, 0, 0.7, frame.size.height)];
        [self addSubview:_rightLine];
        [_rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.mas_equalTo(self);
            make.left.mas_equalTo(self).offset(frame.size.width/4*3);
            make.width.mas_equalTo(0.7);
        }];
        _rightLine.backgroundColor = HBColor(211, 211, 211);

    }
    return self;
}

- (void)setCount:(NSInteger)count {
    _count = count;
    _numField.text = [NSString stringWithFormat:@"%ld", count];
    if (self.countBlock) {
        self.countBlock(count);
    }
}

- (void)setTextColor:(UIColor *)textColor {
    _numField.textColor = textColor;
}

- (void)setLineColor:(UIColor *)lineColor {
    _leftLine.backgroundColor = lineColor;
    _rightLine.backgroundColor = lineColor;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    [_leftLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(lineWidth);
    }];
    [_rightLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(lineWidth);
    }];
}

@end
