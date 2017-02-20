//
//  HomeRankCell.m
//  Puzzle
//
//  Created by huipay on 2016/8/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "HomeRankCell.h"
#import "HomeRankModel.h"
#import "UIImageView+WebCache.h"
#import "PZBetCurrency.h"

@interface HomeRankCell()

@property(weak,nonatomic) UILabel* indexLabel ;
@property(weak,nonatomic) UILabel* nameLabel ;
@property(weak,nonatomic) PZBetCurrency* amountLabel ;
@property(weak,nonatomic) UIImageView* avatarLabel ;

@end

@implementation HomeRankCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        // index avatar  name  amount
        UILabel* indexLabel = [[UILabel alloc]init];
        indexLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:indexLabel];
        [indexLabel sizeToFit];
        [indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25);
            make.width.mas_equalTo(12);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        self.indexLabel = indexLabel ;
        
        
        UIImageView* avatarLabel = [[UIImageView alloc]init];
        avatarLabel.layer.cornerRadius = 2 ;
        avatarLabel.layer.masksToBounds = YES ;
        [self.contentView addSubview:avatarLabel];
        [avatarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(indexLabel.mas_right).offset(8);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        self.avatarLabel = avatarLabel ;
        
        UILabel* nameLabel = [[UILabel alloc]init];
        nameLabel.textColor = [UIColor whiteColor];
        [nameLabel sizeToFit];
        nameLabel.font = PZFont(15);
        [self.contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(avatarLabel.mas_right).offset(8);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(SCREENWidth*0.5);
        }];
        self.nameLabel = nameLabel ;
        
        
        PZBetCurrency* amountLabel = [[PZBetCurrency alloc]initWithTitle:@"" imageLeft:YES];
        amountLabel.textLabel.textColor = [UIColor whiteColor];
        amountLabel.textLabel.font = PZFont(15.0f) ;
        [amountLabel sizeToFit];
        [self.contentView addSubview:amountLabel];
        [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20-5);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        self.amountLabel = amountLabel ;
        
    }
    return self ;
}


-(void)setModel:(HomeRankModel *)m{
    self.indexLabel.text = [NSString stringWithFormat:@"%d",m.ranking];
    [self.avatarLabel sd_setImageWithURL:[NSURL URLWithString:m.iconUrl] placeholderImage:DefaultImage];
    self.nameLabel.text = m.userName ;
    self.amountLabel.textLabel.text = [NSString stringWithFormat:@"%d",m.bonusXtbAmount];
}
@end
