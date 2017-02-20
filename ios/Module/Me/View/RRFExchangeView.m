//
//  RRFExchangeView.m
//  Puzzle
//
//  Created by huibei on 16/8/24.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFExchangeView.h"
#import "PZShoppingCartPlusMinusView.h"
#import "JNQCountOperateView.h"

@interface RRFExchangeView ()
{
    UIView *_bgView;
    UILabel *_titleLabel;
    UIView *_contentView;
    UILabel *_subTitleLabel;
    JNQCountOperateView *_modifyView;
    UILabel *_buyNumLabel;
    UILabel *_payNumLabel;
    UIButton *_exchangeBtn;
    
}
@end
@implementation RRFExchangeView
-(instancetype)initWithArray:(NSArray *)array
{
    if (self = [super init]) {
        
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor =[UIColor whiteColor];
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(12);
            
        }];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"选择套餐:";
        _titleLabel.textColor = [UIColor colorWithHexString:@"777777"];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [_titleLabel sizeToFit];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(24);
        }];
        
        _contentView = [[UIView alloc]init];
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(12);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(100);
        }];
        
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.text = @"填写数量:";
        _subTitleLabel.textColor = [UIColor colorWithHexString:@"999999"];
        [self addSubview:_subTitleLabel];
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(_contentView.mas_bottom).offset(8);
        }];
        
        NSInteger count = array.count;
        CGFloat contentHeight = 0;

        if (count > 0) {
            int totalCount = 3;
            CGFloat btnH = 90;
            CGFloat btnW = 75;
            CGFloat margin =((SCREENWidth-24) - totalCount * btnW)/totalCount;
            for (int i = 0; i < count ;i ++) {
                int row = i/totalCount;// 行号
                int loc = i%totalCount;// 列号
                CGFloat btnx= (margin+btnW)*loc;
                CGFloat btny= (btnH)*row +20;
                
                NSString *str = [NSString stringWithFormat:@"%@\n喜腾币",array[i]];
                UIButton *exchangeBtn = [[UIButton alloc]init];
                exchangeBtn.titleLabel.numberOfLines = 2;
                exchangeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                [exchangeBtn setTitle:str forState:UIControlStateNormal];
                [exchangeBtn setTitleColor:BasicBlueColor forState:UIControlStateNormal];
                [exchangeBtn setTitleColor:[UIColor colorWithHexString:@"<#name#>"] forState:UIControlStateSelected];
                [exchangeBtn setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
                [exchangeBtn setBackgroundImage:[UIImage imageNamed:@"red"] forState:UIControlStateSelected];
                exchangeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                exchangeBtn.frame = CGRectMake(btnx, btny, btnW, btnH);
                [exchangeBtn sizeToFit];
                [_contentView addSubview:exchangeBtn];
                if (i == count - 1) {
                    int row = i/totalCount ;
                    contentHeight = row * (btnH+10) + (btnH+10);
                }
            }
            
            [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(contentHeight);
            }];
            CGFloat bgViewHeight = contentHeight+ 150;
            [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(bgViewHeight);
            }];
            [_subTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_contentView.mas_bottom).offset(12);
            }];
        }
        
       
        
        _modifyView = [[JNQCountOperateView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_subTitleLabel.frame)+8, 100, 40)];
        [self addSubview:_modifyView];
        _modifyView.layer.cornerRadius = 5;
        _modifyView.layer.masksToBounds = YES;
        
        
        _buyNumLabel = [[UILabel alloc]init];
        _buyNumLabel.textColor = [UIColor colorWithHexString:@"777777"];
//        _buyNumLabel.text = @"购买喜腾币: 200";
        [self addSubview:_buyNumLabel];
        [_buyNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_bgView.mas_bottom).offset(12);
            make.right.mas_equalTo(-12);
        }];
        
        _payNumLabel = [[UILabel alloc]init];
//        _payNumLabel.text = @"应付钻石: 100颗";
        _payNumLabel.textColor = [UIColor redColor];
        [self addSubview:_payNumLabel];
        [_payNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(_buyNumLabel.mas_bottom).offset(12);
        }];
        
        
        _exchangeBtn = [[UIButton alloc]init];
        [_exchangeBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
        [_exchangeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_exchangeBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue_bg"] forState:UIControlStateNormal];
        _exchangeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_exchangeBtn sizeToFit];
        [self addSubview:_exchangeBtn];
        [_exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(_payNumLabel.mas_bottom).offset(30);
        }];
        
    }
    return self;
}

@end
