//
//  HBVerticalBtn.m
//  PrivateTeaStall
//
//  Created by 朱理哲 on 16/6/6.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "HBVerticalBtn.h"
@interface HBVerticalBtn()
@property(weak,nonatomic)UILabel* badgeView ;
//@property(weak,nonatomic)UILabel* titleView ;
@property(weak,nonatomic)UIImageView* iconView ;
@end
@implementation HBVerticalBtn
-(instancetype)initWithIcon:(NSString*)icon title:(NSString*)title{
    if (self = [super init]) {
        //图片  badge  文字
        UIImageView* iconView = [[UIImageView alloc]init];
        iconView.image = [UIImage imageNamed:icon];
        [self addSubview:iconView];
        iconView.contentMode = UIViewContentModeScaleAspectFit ;
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY).offset(-6);
            make.width.mas_equalTo(iconView.mas_height);
        }];
        self.iconView = iconView ;
        self.iconView.userInteractionEnabled = NO;
        
        UILabel* badgeView = [[UILabel alloc]init];
        [badgeView sizeToFit];
        badgeView.hidden = YES ;
        badgeView.textAlignment = NSTextAlignmentCenter;
        badgeView.backgroundColor = [UIColor redColor];
        badgeView.textColor = [UIColor whiteColor];
        badgeView.font = PZFont(11.0f);
        badgeView.layer.masksToBounds = YES ;
        badgeView.layer.cornerRadius = 8;
        [iconView addSubview:badgeView];
        [badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-4);
            make.right.mas_equalTo(16);
            make.width.mas_equalTo(16);
            make.height.mas_equalTo(16);
        }];
        self.badgeView = badgeView ;
        
        
        _titleView = [[UILabel alloc]init];
        _titleView.text = title ;
        _titleView.textColor = HBColor(119, 119, 119);
        _titleView.textAlignment = NSTextAlignmentCenter ;
        _titleView.layer.masksToBounds = YES ;
        _titleView.font = PZFont(10.0f);
        _titleView.layer.cornerRadius = 8 ;
        [self addSubview:_titleView];
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(_iconView.mas_bottom).offset(4);
            make.height.mas_equalTo(16);
        }];
        self.titleView = _titleView ;
        
    }
    return self ;
}

-(void)setBadge:(NSInteger)count{
    if (count > 0) {
        self.badgeView.hidden = NO ;
    }
    else{
        self.badgeView.hidden = YES ;
    }
    self.badgeView.text = count>99 ? @"99+" : [NSString stringWithFormat:@"%ld",(long)count];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:PZFont(13), NSParagraphStyleAttributeName:paragraphStyle};
    CGRect rect = [self.badgeView.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 15)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:attributes
                                                context:nil];
    NSInteger width = CGRectGetWidth(rect)+3 <= 16 ? 16 : CGRectGetWidth(rect)+3;
    [self.badgeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
}

- (void)setBadgeWidth:(NSInteger)width {
    [self.badgeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(width);
    }];
    self.badgeView.layer.cornerRadius = width/2;
}

-(void)setIcon:(NSString*)icon{
    self.iconView.image = [UIImage imageNamed:icon];
    if (_isDelegate) {
        if ([icon isEqualToString:@""]) {
            [_titleView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_iconView.mas_bottom).offset(-32);
                make.height.mas_equalTo(80);
            }];
        } else {
            [_titleView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_iconView.mas_bottom).offset(4);
                make.height.mas_equalTo(16);
            }];
        }
    }
}

-(void)setTitle:(NSString*)title{
    self.titleView.text = title ;
    NSInteger height = [title isEqualToString:@""] ? 0 : 16;
    [self.titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    NSInteger center = [title isEqualToString:@""] ? 0 : -6;
    [self.iconView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self).offset(center);
    }];
}


- (void)setTextColor:(UIColor *)textColor {
    self.titleView.textColor = textColor;
}

-(void)setFontSize:(CGFloat)size{
    self.titleView.font = PZFont(size);
}

@end
