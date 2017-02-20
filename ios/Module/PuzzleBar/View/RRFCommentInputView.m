//
//  RRFCommentInputView.m
//  Puzzle
//
//  Created by huibei on 16/10/11.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFCommentInputView.h"
@implementation RRFCommentInputView
-(instancetype)initWithTitle:(NSString*)title redPaper:(BOOL)redPaper{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        if (redPaper) {
            WEAKSELF
            UIButton *btnRedPaper = [[UIButton alloc]init];
            [btnRedPaper setImage:[UIImage imageNamed:@"chat-btn_red-packet"] forState:UIControlStateNormal];
            [self addSubview:btnRedPaper];
            [btnRedPaper mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-6);
                make.size.mas_equalTo(CGSizeMake(30, 30));
                make.centerY.mas_equalTo(self.mas_centerY);
            }];
            [[btnRedPaper rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                if (weakSelf.redPaperBlock) {
                    weakSelf.redPaperBlock();
                }
            }];
            UIImageView *faceView = [[UIImageView alloc]init];
            faceView.image = [UIImage imageNamed:@"face"];
            [self addSubview:faceView];
            [faceView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(btnRedPaper.mas_left).offset(-6);
                make.size.mas_equalTo(CGSizeMake(30, 30));
                make.centerY.mas_equalTo(self.mas_centerY);
            }];
        }
        else{
            UIImageView *faceView = [[UIImageView alloc]init];
            faceView.image = [UIImage imageNamed:@"face"];
            [self addSubview:faceView];
            [faceView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-6);
                make.size.mas_equalTo(CGSizeMake(30, 30));
                make.centerY.mas_equalTo(self.mas_centerY);
            }];
        }
        UIButton *inputBtn = [[UIButton alloc]init];
        inputBtn.userInteractionEnabled = NO;
        inputBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [inputBtn setTitle:[NSString stringWithFormat:@"  %@",title] forState:UIControlStateNormal];
        [inputBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [inputBtn setImage:[UIImage imageNamed:@"icon_pen"] forState:UIControlStateNormal];
        [inputBtn setBackgroundImage:[UIImage imageNamed:@"input_assess"] forState:UIControlStateNormal];
        inputBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
        inputBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
        inputBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [inputBtn sizeToFit];
        [self addSubview:inputBtn];
        CGFloat offsetRight = redPaper? 12+30*2 : 30+6 ;
        [inputBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(8);
            make.right.mas_equalTo(-offsetRight);
            make.bottom.mas_equalTo(-8);
        }];
    }
    return self;
}



@end
