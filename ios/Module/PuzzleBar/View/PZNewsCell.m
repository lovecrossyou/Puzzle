//
//  PZNewsCell.m
//  Puzzle
//
//  Created by huibei on 16/12/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZNewsCell.h"
#import "PZNewsCellModel.h"
#import "UIImageView+WebCache.h"

@interface PZNewsCell(){
    UIImageView* logoView ;
    UILabel* titleLabel ;
    UILabel* cateLabel ;
    UILabel* timeLabel ;
}

@end
@implementation PZNewsCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        logoView = [[UIImageView alloc]init];
        logoView.contentMode = UIViewContentModeScaleAspectFit ;
        [self.contentView addSubview:logoView];
        [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(90, 60));
            make.left.top.mas_equalTo(12);
            make.bottom.mas_equalTo(-12);
        }];
        
        titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        titleLabel.numberOfLines = 2 ;
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(logoView.mas_right).offset(6);
            make.top.mas_equalTo(12);
            make.right.mas_equalTo(-12);
        }];
        
        cateLabel = [[UILabel alloc]init];
        cateLabel.textColor = [UIColor lightGrayColor];
        [cateLabel sizeToFit];
        cateLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        [self.contentView addSubview:cateLabel];
        [cateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(logoView.mas_right).offset(6);
            make.bottom.mas_equalTo(logoView.mas_bottom);
            make.right.mas_equalTo(-12);
        }];
        
        timeLabel = [[UILabel alloc]init];
        timeLabel.textColor = [UIColor lightGrayColor];
        [timeLabel sizeToFit];
        timeLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        [self.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(logoView.mas_bottom);
            make.right.mas_equalTo(-12);
        }];
        
    }
    return self ;
}

-(void)configModel:(PZNewsCellModel *)model{
    NSString* url  = model.thumbnail_pic_s ;
    [logoView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:DefaultImage];
    titleLabel.text = model.title ;
    cateLabel.text = model.author_name ;
    timeLabel.text = model.date ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
