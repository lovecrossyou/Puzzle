//
//  ReplyInnerCell.m
//  Puzzle
//
//  Created by huipay on 2016/9/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#define kMargin 12
#import "ReplyInnerCell.h"
#import "InsetsLabel.h"
@implementation ReplyInnerCell

-(instancetype)initWithIndex:(NSString*)index name:(NSString*)name content:(NSString*)content{
    if (self = [super init]) {
        UILabel* indexLabel = [[UILabel alloc]init];
        indexLabel.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
        indexLabel.text = index ;
        indexLabel.textColor = [UIColor colorWithHexString:@"333333"];
        indexLabel.font = PZFont(12.0f);
        indexLabel.textAlignment = NSTextAlignmentCenter ;
        [self addSubview:indexLabel];
        [indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kMargin);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
        
        UILabel* nameLabel = [[UILabel alloc]init];
        [nameLabel sizeToFit];
        nameLabel.text = name ;
        nameLabel.font = PZFont(15.0f);
        nameLabel.textColor = [UIColor colorWithHexString:@"2b5490"];
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(indexLabel.mas_right).offset(10);
            make.centerY.mas_equalTo(indexLabel.mas_centerY);
        }];
        
        InsetsLabel *contentLabel = [[InsetsLabel alloc]initWithInsets:UIEdgeInsetsZero];
        [contentLabel sizeToFit];
        contentLabel.numberOfLines = 0 ;
        contentLabel.text = content ;
        contentLabel.font = PZFont(12.0f);
        contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [self addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(indexLabel.mas_right).offset(10);
            make.top.mas_equalTo(indexLabel.mas_bottom).offset(6);
            make.right.mas_equalTo(-kMargin);
            make.bottom.mas_equalTo(-kMargin);
        }];
        
        UIView* bottomSep = [[UIView alloc]init];
        bottomSep.backgroundColor = [UIColor whiteColor];
        [self addSubview:bottomSep];
        [bottomSep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.bottom.left.right.mas_equalTo(0);
        }];
    }
    return self ;
}

@end
