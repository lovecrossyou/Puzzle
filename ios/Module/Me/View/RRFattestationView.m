//
//  RRFattestationView.m
//  Puzzle
//
//  Created by huibei on 16/9/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFattestationView.h"
#import "PZTitleInputView.h"
#import "RRFFattestationModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
@interface RRFattestationView()
{
    UILabel *_titleLabel;
    UILabel *_subTitleLabel;
    UIButton *_addBtn;
    UIButton *_nextBtn;
}
@end
@implementation RRFattestationView

-(instancetype)init
{
    if (self = [super init]) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"请填写资料并上传资料照片(请确保信息清晰可见),完成身份认证信息,仅用于审核,不对任何人可见";
        _titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.numberOfLines = 2;
        [_titleLabel sizeToFit];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(12);
            make.right.mas_equalTo(-12);
        }];
        
        PZTitleInputView *nameLabel = [[PZTitleInputView alloc]initWithTitle:@"姓  名:" placeHolder:@"请填写你的真实姓名"];
        self.nameLabel = nameLabel;
        nameLabel.indicatorEnable = NO;
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(8);
        }];
        [nameLabel.singnal subscribeNext:^(id x) {
            self.nameStr  = x;
        }];
        
        PZTitleInputView *noLabel = [[PZTitleInputView alloc]initWithTitle:@"身份证号:" placeHolder:@"请填写你的身份证号"];
        self.noLabel = noLabel;
        noLabel.indicatorEnable = NO;
        [self addSubview:noLabel];
        [noLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(8);
        }];
        [noLabel.singnal subscribeNext:^(id x) {
            self.identityCardStr  = x;
        }];
        
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.text = @"上传本人手持身份证和身份证正面照片";
        _subTitleLabel.textColor = [UIColor colorWithHexString:@"999999"];
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
        [_subTitleLabel sizeToFit];
        [self addSubview:_subTitleLabel];
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(noLabel.mas_bottom).offset(30);
        }];
        
        UIView *imageContentView = [[UIView alloc]init];
//        imageContentView.showsHorizontalScrollIndicator = YES;
//        imageContentView.showsVerticalScrollIndicator = NO;
//        imageContentView.bounces = YES;
//        imageContentView.frame = CGRectMake(82, 0, SCREENWidth-82, 90);
        imageContentView.backgroundColor = [UIColor whiteColor];
        self.imageContentView = imageContentView;
        [self addSubview:imageContentView];
        [imageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(_subTitleLabel.mas_bottom).offset(8);
            make.height.mas_equalTo(90);
        }];
        
        
        _addBtn = [[UIButton alloc]init];
        _addBtn.tag = 0;
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
            if (self.fattestationBlock) {
                self.fattestationBlock(@(0));
            }
        }];
        

        
        _nextBtn = [[UIButton alloc]init];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue_bg"] forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _nextBtn.layer.cornerRadius = 5;
        _nextBtn.layer.masksToBounds = YES;
        [_nextBtn sizeToFit];
        [self addSubview:_nextBtn];
        [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_imageContentView.mas_bottom).offset(30);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(44);

        }];
        [[_nextBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.fattestationBlock) {
                self.fattestationBlock(@(1));
            }
        }];
    }
    return self;
}
-(void)setImages:(NSArray *)images
{
    for (UIButton *imageBtn in _imageContentView.subviews) {
        if (imageBtn.tag<images.count) {
            [imageBtn sd_setImageWithURL:[NSURL URLWithString:images[imageBtn.tag]] forState:UIControlStateNormal placeholderImage:DefaultImage];
            imageBtn.hidden = NO;
        } else {
            imageBtn.hidden = YES;
        }
    }

}
@end
