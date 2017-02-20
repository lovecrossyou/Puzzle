//
//  JNQFailFooterView.m
//  Puzzle
//
//  Created by HuHuiPay on 16/10/27.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQFailFooterView.h"

@interface JNQFailFooterView()
@property(weak,nonatomic)UIActivityIndicatorView* indicatorView ;
@end

@implementation JNQFailFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        WEAKSELF
        self.backgroundColor = [UIColor whiteColor];
        UILabel *atten = [[UILabel alloc] init];
        [self addSubview:atten];
        [atten mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self).offset(-80);
            make.left.mas_equalTo(self).offset(12);
            make.right.mas_equalTo(self).offset(-12);
        }];
        atten.font = PZFont(13);
        atten.textColor = HBColor(153, 153, 153);
        atten.textAlignment = NSTextAlignmentCenter;
        atten.text = @"出错啦？请点击重新加载按钮";
        
        UIActivityIndicatorView* indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:indicatorView];
        [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(atten.mas_top).offset(-18);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        self.indicatorView = indicatorView ;
        
        UIButton *reloadBtn = [[UIButton alloc] init];
        [self addSubview:reloadBtn];
        [reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(atten.mas_bottom).offset(25);
            make.centerX.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(200, 40));
        }];
        reloadBtn.layer.borderColor = HBColor(231, 231, 231).CGColor;
        reloadBtn.layer.borderWidth = 0.5;
        reloadBtn.layer.cornerRadius = 2;
        [reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        [reloadBtn setTitleColor:HBColor(51, 51, 51) forState:UIControlStateNormal];
        reloadBtn.titleLabel.font = PZFont(15);
        [[reloadBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.reloadBlock) {
                weakSelf.reloadBlock();
            }
            [weakSelf.indicatorView startAnimating];
            [weakSelf performSelector:@selector(stopAnimateRefresh) withObject:nil afterDelay:0.8];
        }];
    }
    return self;
}

-(void)stopAnimateRefresh{
    [self.indicatorView stopAnimating];
}

@end
