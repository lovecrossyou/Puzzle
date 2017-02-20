//
//  RRFCustomNumBtn.m
//  Puzzle
//
//  Created by huibei on 16/8/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFCustomNumBtn.h"
@interface RRFCustomNumBtn ()
@end
@implementation RRFCustomNumBtn

-(instancetype)init{
    if (self = [super init]) {
        UITextField *inputNumLabel = [[UITextField alloc]init];
        inputNumLabel.placeholder = @"自定义数量";
        inputNumLabel.font = [UIFont systemFontOfSize:18];
        inputNumLabel.textColor = [UIColor colorWithHexString:@"4964ef"];
        inputNumLabel.textAlignment = NSTextAlignmentCenter;
        inputNumLabel.keyboardType = UIKeyboardTypeNumberPad;
        self.inputNumLabel = inputNumLabel;
        [self addSubview:inputNumLabel];
        [inputNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return self;
}

@end
