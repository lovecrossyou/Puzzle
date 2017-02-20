//
//  PraiseResultView.m
//  Puzzle
//
//  Created by huipay on 2016/10/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PraiseResultView.h"

@interface PraiseResultView()
@property(nonatomic,weak)UIButton *closeBtn;
@end

@implementation PraiseResultView

-(instancetype)initWithNumble:(NSString *)num{
    if (self = [super init]) {
        UIImageView *bgView = [[UIImageView alloc]init];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        UIButton *closeBtn = [[UIButton alloc]init];
        self.closeBtn = closeBtn;
        [closeBtn setImage:[UIImage imageNamed:@"reward_success_x_black"] forState:UIControlStateNormal];
        [self addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.right.top.mas_equalTo(0);
        }];
        [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.closeClick) {
                self.closeClick();
            }
        }];
        
        
        UIImageView *successIcon = [[UIImageView alloc]init];
        successIcon.image = [UIImage imageNamed:@"icon_-reward_success"];
        [self addSubview:successIcon];
        [successIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.center);
            make.top.mas_equalTo(42.5);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        UILabel *successLabel = [[UILabel alloc]init];
        successLabel.text = [NSString stringWithFormat:@"成功赞赏了%@喜腾币",num];
        successLabel.textColor = [UIColor colorWithHexString:@"333333"];
        successLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:successLabel];
        [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(successIcon.mas_bottom).offset(25);
        }];
        
        
    }
    return self ;
}
@end
