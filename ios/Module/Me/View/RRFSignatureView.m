//
//  RRFSignatureView.m
//  Puzzle
//
//  Created by huibei on 16/9/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFSignatureView.h"
#import "PZTextView.h"

@interface RRFSignatureView()

@end
@implementation RRFSignatureView
-(instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *sep = [[UIView alloc]init];
        sep.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self addSubview:sep];
        [sep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
        
        self.messageView = [[UITextField alloc]init];
        self.messageView.font = [UIFont systemFontOfSize:13];
        self.messageView.textColor = [UIColor colorWithHexString:@"777777"];
        [self addSubview:self.messageView];
        [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(sep.mas_bottom).offset(0);
            make.right.mas_equalTo(-12);
            make.bottom.mas_equalTo(-30);
        }];
        
        UILabel *numLabel = [[UILabel alloc]init];
        numLabel.textColor = [UIColor colorWithHexString:@"999999"];
        numLabel.font = [UIFont systemFontOfSize:14];
        [numLabel sizeToFit];
        self.numLabel = numLabel;
        [self addSubview:numLabel];
        [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(-12);
            make.top.mas_equalTo(self.messageView.mas_bottom).offset(0);
            
        }];
    }
    return self;
}

@end
