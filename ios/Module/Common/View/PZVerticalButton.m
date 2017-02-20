
//
//  PZVerticalButton.m
//  Puzzle
//
//  Created by huipay on 2016/8/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#define kImageHeightProportion 0.8
#import "PZVerticalButton.h"

@implementation PZVerticalButton

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 0, contentRect.size.width, contentRect.size.height * kImageHeightProportion);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat imageHeight = contentRect.size.height * kImageHeightProportion ;
    CGFloat titleHeight = contentRect.size.height * (1- kImageHeightProportion) ;
    return CGRectMake(0, imageHeight, contentRect.size.width, titleHeight);

}


@end


@interface VerticalTextButton()

@property(weak,nonatomic)UIView* bgView ;
@property(weak,nonatomic)UILabel* titleLabel ;
@end

@implementation VerticalTextButton

-(instancetype)initWithTitle:(NSString*)title subTitle:(NSString*)subtitle{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView* bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_choose"]];
        bgView.userInteractionEnabled = NO ;
        bgView.alpha = 0.8 ;
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        self.bgView = bgView ;
        
        self.layer.masksToBounds = YES ;
        self.layer.cornerRadius = 6 ;
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",title,subtitle]];
        NSRange range = NSMakeRange(0, title.length);
        [attriString addAttributes:@{NSFontAttributeName:PZFont(18.0f)} range:range];
        UILabel* titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = [UIColor whiteColor];
        [titleLabel sizeToFit];
        titleLabel.numberOfLines = 0 ;
        titleLabel.textAlignment = NSTextAlignmentCenter ;
        titleLabel.font = PZFont(12.0f);
        titleLabel.attributedText = attriString ;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.center);
        }];
        self.titleLabel = titleLabel ;
    }
    return self ;
}


-(instancetype)initWithHorizonTitle:(NSString*)title subTitle:(NSString*)subtitle {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        UILabel* titleLabel = [[UILabel alloc]init];
        titleLabel.text = title ;
        titleLabel.font = PZFont(14);
        titleLabel.textColor = [UIColor whiteColor];
        [titleLabel sizeToFit];
        [self addSubview:titleLabel];

        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        UIImageView* moneyIcon = [[UIImageView alloc]init];
        //home-S-currency  icon_maddle
        moneyIcon.image = [UIImage imageNamed:@"home-S-currency"];
        [self addSubview:moneyIcon];
        [moneyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).offset(2);
            make.centerY.mas_equalTo(titleLabel.mas_centerY);
        }];
        
        UILabel* moneyLabel = [[UILabel alloc]init];
        moneyLabel.text = subtitle ;
        [moneyLabel sizeToFit];
        moneyLabel.font = PZFont(16);
        moneyLabel.textColor = [UIColor whiteColor];
        [self addSubview:moneyLabel];
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(moneyIcon.mas_right).offset(2);
            make.centerY.mas_equalTo(titleLabel.mas_centerY);
            make.right.mas_equalTo(0);
        }];

    }
    return self ;
}

-(void)setBackViewColor:(UIColor *)color{
    self.bgView.backgroundColor = color ;
    self.titleLabel.textColor = [UIColor whiteColor];
}

/**
 *  label可以成为第一响应者
 */
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return YES ;
}

@end
