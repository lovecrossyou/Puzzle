//
//  RedPaperInputCell.m
//  Puzzle
//
//  Created by huibei on 17/1/18.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "RedPaperInputCell.h"

@implementation RedPaperInputCell
-(instancetype)initWithTitle:(NSString*)title unitStr:(NSString*)unitStr placeHolder:(NSString*)placeholder{
    if (self = [super init]) {
        self.backgroundColor = HBColor(254,250,247);
        UIView* whiteBg = [[UIView alloc]init];
        whiteBg.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteBg];
        [whiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.bottom.mas_equalTo(0);
        }];
        
        UILabel* titleView = [[UILabel alloc]init];
        titleView.textColor = [UIColor darkGrayColor];
        titleView.text = title ;
        titleView.font = PZFont(15.0f);
        [whiteBg addSubview:titleView];
        [titleView sizeToFit];
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(6);
        }];
        
        UILabel* unitView = [[UILabel alloc]init];
        unitView.text = unitStr ;
        unitView.textColor = [UIColor darkGrayColor];
        unitView.font = PZFont(15.0f);
        [whiteBg addSubview:unitView];
        [unitView sizeToFit];
        [unitView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-6);
        }];
        
        UITextField* inputView = [[UITextField alloc]init];
        inputView.placeholder = placeholder;
        inputView.font = PZFont(13.0f);
        inputView.textAlignment = NSTextAlignmentRight ;
        inputView.keyboardType = UIKeyboardTypeNumberPad ;
        [whiteBg addSubview:inputView];
        [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.right.mas_equalTo(unitView.mas_left).offset(-6);
            make.width.mas_equalTo(SCREENWidth*.6);
        }];
        self.textSignal = inputView.rac_textSignal ;
    }
    return self ;
}


@end
