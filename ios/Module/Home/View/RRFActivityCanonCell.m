//
//  RRFActivityCanonCell.m
//  Puzzle
//
//  Created by huibei on 16/9/30.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFActivityCanonCell.h"
#import "PZCommonCellModel.h"
@interface RRFActivityCanonCell()
@property(nonatomic,weak)UILabel *titleLabel;
@property(nonatomic,weak)UILabel *subTitleLabel;

@end
@implementation RRFActivityCanonCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *bgView =[[UIView alloc]init];
        bgView.backgroundColor = [UIColor colorWithRed:98/255.0 green:116/255.0 blue:220/255.0 alpha:0.3];
        [self.contentView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.top.bottom.mas_equalTo(0);
        }];
        
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"nihaha";
        titleLabel.textColor = [UIColor colorWithHexString:@"ffba26"];
        titleLabel.font = [UIFont systemFontOfSize:15];
        [titleLabel sizeToFit];
        titleLabel.numberOfLines = 0;
        self.titleLabel = titleLabel;
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(24);
            make.right.mas_equalTo(-24);
            make.top.mas_equalTo(12);

        }];
        
        UILabel *subTitleLabel = [[UILabel alloc]init];
        subTitleLabel.numberOfLines = 0;
        subTitleLabel.text = @"nihaha";
        subTitleLabel.textColor = [UIColor whiteColor];
        subTitleLabel.font = [UIFont systemFontOfSize:13];
        [subTitleLabel sizeToFit];
        self.subTitleLabel = subTitleLabel;
        [self.contentView addSubview:subTitleLabel];
        [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(24);
            make.right.mas_equalTo(-24);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
            make.bottom.mas_equalTo(-12);
            
        }];
        
        UIView *sep = [[UIView alloc]init];
        sep.backgroundColor = [UIColor colorWithHexString:@"2d3460"];
        [self addSubview:sep];
        [sep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}
-(void)setModel:(PZCommonCellModel *)model
{
    self.titleLabel.text = model.title;
    self.subTitleLabel.text = model.subTitle;
}
@end
