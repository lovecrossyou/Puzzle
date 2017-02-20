//
//  RRFFattestationWorkInfoView.m
//  Puzzle
//
//  Created by huibei on 16/9/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFFattestationWorkInfoView.h"
#import "PZTitleInputView.h"
#import "PZTextView.h"

@interface RRFFattestationWorkInfoView ()
{
  
    UILabel *_subTitleLabel;
    UIButton *_addBtn;
    UIButton *_nextBtn;
}
@end

@implementation RRFFattestationWorkInfoView
-(instancetype)init{
    if (self = [super init]) {
       
        PZTitleInputView *nameLabel = [[PZTitleInputView alloc]initWithTitle:@"单位名称:" placeHolder:@"请填写你的单位名称"];
        self.nameLabel = nameLabel;
        nameLabel.indicatorEnable = NO;
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(12);
        }];
        [nameLabel.singnal subscribeNext:^(id x) {
            self.workName = x;
        }];
        
        PZTitleInputView *workLabel = [[PZTitleInputView alloc]initWithTitle:@"职务认证:" placeHolder:@"请填写您的职务/职称/从业资格"];
        self.workLabel = workLabel;
        workLabel.indicatorEnable = NO;
        [self addSubview:workLabel];
        [workLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(_nameLabel.mas_bottom).offset(8);
        }];
        [workLabel.singnal subscribeNext:^(id x) {
            self.positionName = x;
        }];
        
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.text = @"上传职务/职称/从业资格证照正面照片";
        _subTitleLabel.textColor = [UIColor colorWithHexString:@"999999"];
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
        [_subTitleLabel sizeToFit];
        [self addSubview:_subTitleLabel];
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(_workLabel.mas_bottom).offset(12);
        }];
        
        UIView *imageContentView = [[UIView alloc]init];
        imageContentView.backgroundColor = [UIColor whiteColor];
        self.imageContentView = imageContentView;
        [self addSubview:imageContentView];
        [imageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(_subTitleLabel.mas_bottom).offset(8);
            make.height.mas_equalTo(90);
        }];
        
        _addBtn = [[UIButton alloc]init];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"btn_add_card"] forState:UIControlStateNormal];
        _addBtn.layer.cornerRadius = 5;
        _addBtn.layer.masksToBounds = YES;
        [_addBtn sizeToFit];
        [self addSubview:_addBtn];
        [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(6);
            make.top.mas_equalTo(_subTitleLabel.mas_bottom).offset(18);
            make.size.mas_equalTo(CGSizeMake(70, 70));
        }];
        [[_addBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.fattestationWorkInfoBlock) {
                self.fattestationWorkInfoBlock(@(0));
            }
        }];

        
        PZTextView *infoView = [[PZTextView alloc]initWithPlaceHolder:@"请填写个人简介"];
        self.infoView = infoView;
        [self addSubview:infoView];
        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(_imageContentView.mas_bottom).offset(12);
            make.height.mas_equalTo(200);
        }];
        
        
        _nextBtn = [[UIButton alloc]init];
        [_nextBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue_bg"] forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _nextBtn.layer.cornerRadius = 5;
        _nextBtn.layer.masksToBounds = YES;
        [_nextBtn sizeToFit];
        [self addSubview:_nextBtn];
        [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(infoView.mas_bottom).offset(30);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(44);
        }];
        [[_nextBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.fattestationWorkInfoBlock) {
                self.fattestationWorkInfoBlock(@(1));
            }
        }];
 
    }
    return self;
}

@end
