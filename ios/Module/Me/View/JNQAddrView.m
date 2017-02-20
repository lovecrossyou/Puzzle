//
//  JNQAddrView.m
//  Puzzle
//
//  Created by HuHuiPay on 16/9/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQAddrView.h"

@implementation JNQAddrView

@end

@implementation JNQAddrHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HBColor(245, 245, 245);
        
        _addNewAddr = [[PZTitleInputView alloc] initWithTitle:@"+ 新建收货地址"];
        [self addSubview:_addNewAddr];
        [_addNewAddr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(15);
            make.left.mas_equalTo(-0.5);
            make.right.mas_equalTo(0.5);
            make.bottom.mas_equalTo(-12);
        }];
        _addNewAddr.layer.borderColor = HBColor(231, 231, 231).CGColor;
        _addNewAddr.layer.borderWidth = 0.5;
        _addNewAddr.textEnable = NO;
        _addNewAddr.titleLabel.textColor = HBColor(51, 51, 51);
    }
    return self;
}

@end
