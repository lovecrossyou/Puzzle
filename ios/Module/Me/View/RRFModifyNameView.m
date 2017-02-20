//
//  RRFModifyNameView.m
//  Puzzle
//
//  Created by huibei on 16/8/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFModifyNameView.h"

@implementation RRFModifyNameView


-(instancetype)init
{
    if (self = [super init]) {
        
        UITextField *nameText = [[UITextField alloc]init];
        nameText.backgroundColor = [UIColor whiteColor];
        UIView *left = [[UIView alloc]init];
        left.frame = CGRectMake(0, 0, 20, 44);
        nameText.leftView = left;
        nameText.leftViewMode = UITextFieldViewModeAlways;
        nameText.clearButtonMode = UITextFieldViewModeAlways;
        nameText.clearsOnBeginEditing = YES;
        nameText.placeholder = @"请输入名字";
        nameText.textColor = [UIColor colorWithHexString:@"777777"];
        nameText.font = PZFont(14);
        self.nameText = nameText;
        [self addSubview:nameText];
        [nameText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth, 44));
            make.top.mas_equalTo(20);
        }];
    }
    return self;
}
-(void)setPlaceholder:(NSString *)placeholder
{
    if (placeholder.length != 0) {
        self.nameText.placeholder = placeholder;
    }
}
@end
