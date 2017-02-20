//
//  JNQOperationButton.m
//  Puzzle
//
//  Created by HuHuiPay on 16/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQButton.h"

@implementation JNQButton

@end

@implementation JNQOperationButton

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = BasicBlueColor;
        self.titleLabel.font = PZFont(15);
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 2;
    }
    return self;
}

@end


@implementation JNQXTButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setTitleColor:HBColor(51, 51, 51) forState:UIControlStateNormal];
        [self setTitleColor:BasicRedColor forState:UIControlStateSelected];
        [self setImage:[UIImage imageNamed:@"xitengbi"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"icon_xitengbi-canyu"] forState:UIControlStateSelected];
    }
    return self;
}

@end
