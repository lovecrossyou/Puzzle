//
//  RRFBillBtn.m
//  Puzzle
//
//  Created by huibei on 16/9/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFBillBtn.h"
@interface RRFBillBtn ()
@end
@implementation RRFBillBtn
-(instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = [UIColor colorWithHexString:@"777777"];
        titleLabel.font = [UIFont systemFontOfSize:15];
        [titleLabel sizeToFit];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(4);
            make.height.mas_equalTo(25);
        }];
        
        UIButton *subTitleBtn = [[UIButton alloc]init];
        subTitleBtn.userInteractionEnabled = NO;
        [subTitleBtn sizeToFit];
        self.subTitleBtn = subTitleBtn;
        [self addSubview:subTitleBtn];
        [subTitleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-6);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(0);
        }];
    }
    return self;
}
@end
