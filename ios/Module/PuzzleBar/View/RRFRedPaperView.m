//
//  RRFRedPaperView.m
//  Puzzle
//
//  Created by huipay on 2017/1/23.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "RRFRedPaperView.h"
#import "BonusPaperModel.h"
@interface RRFRedPaperView ()
@property(nonatomic,strong)UILabel *titleLabel;
@end
@implementation RRFRedPaperView
-(instancetype)init
{
    if (self = [super init]) {
        UIImageView *bgView = [[UIImageView alloc]init];
        bgView.userInteractionEnabled = NO;
        bgView.image = [UIImage imageNamed:@"circle-of-friends_red-packet"];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(52);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(12);
        }];
        
        UILabel *subTitleLabel = [[UILabel alloc]init];
        subTitleLabel.text = @"领取红包";
        subTitleLabel.textColor = [UIColor whiteColor];
        subTitleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:subTitleLabel];
        [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(52);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(4);

        }];
        
        
        UILabel *logoLabel = [[UILabel alloc]init];
        logoLabel.text = @"喜腾红包";
        logoLabel.textColor = [UIColor colorWithHexString:@"666666"];
        logoLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:logoLabel];
        [logoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-3);
        }];
    }
    return self;
}
-(void)setModel:(BonusPaperModel *)model
{
    self.titleLabel.text = model.desInfo;
}
@end
