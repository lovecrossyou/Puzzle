//
//  JNQOperateSelectView.m
//  Puzzle
//
//  Created by HuHuiPay on 16/9/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQOperateSelectView.h"

@implementation JNQOperateSelectView {
    UIView *_backView;
}

- (instancetype)initWithFrame:(CGRect)frame btnCount:(NSInteger)count {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0.5, 0, SCREENWidth+1, frame.size.height)];
        [self addSubview:_backView];
        _backView.layer.borderColor = HBColor(231, 231, 231).CGColor;
        _backView.layer.borderWidth = 0.5;
        
        for (int i = 0; i<count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWidth/count*i+0.5, 0, SCREENWidth/count, frame.size.height)];
            [_backView addSubview:btn];
            [btn setTitleColor:HBColor(51, 51, 51) forState:UIControlStateNormal];
            btn.titleLabel.font = PZFont(15);
            btn.tag = i;
            [btn addTarget:self action:@selector(btnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        for (int i = 0; i<count-1; i++) {
            UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(SCREENWidth/count*(i+1), (frame.size.height-20)/2, 1, 20)];
            [self addSubview:sep];
            sep.backgroundColor = HBColor(231, 231, 231);
            
        }
        
        _glideView = [[UIView alloc] init];
        [self addSubview:_glideView];
        [_glideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth/count, 2));
        }];
        _glideView.backgroundColor = BasicBlueColor;
    }
    return self;
}

- (void)setBtnTitleArray:(NSArray *)btnTitleArray {
    _btnTitleArray = btnTitleArray;
    for (UIButton *btn in _backView.subviews) {
        [btn setTitle:btnTitleArray[btn.tag] forState:UIControlStateNormal];
    }
}

- (void)btnDidClicked:(UIButton *)btn {
    if (self.buttonBlock) {
        self.buttonBlock(btn);
    }
}

@end
