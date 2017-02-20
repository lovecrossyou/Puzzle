//
//  EChatHeadCell.m
//  Puzzle
//
//  Created by huipay on 2016/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "EChatHeadCell.h"
#import "UIColor+helper.h"
#import "JustNowWithStockModel.h"
#import "UIImageView+WebCache.h"
#import "PZBetCurrency.h"
#import "NSString+TimeConvert.h"
@interface EChatHeadCell()
{
    UIImageView* avatarLabel ;
    UILabel* titleLabel;
    PZBetCurrency* amountLabel;
    UILabel* timeLabel;
}
@end

@implementation EChatHeadCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor=[UIColor clearColor];
        //icon  name  time  amount
        avatarLabel = [[UIImageView alloc]init];
        avatarLabel.layer.masksToBounds = YES ;
        avatarLabel.layer.cornerRadius = 2 ;
        [self.contentView addSubview:avatarLabel];
        [avatarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12+12);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = PZFont(13);
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(avatarLabel.mas_right).offset(8);
            make.centerY.mas_equalTo(avatarLabel.mas_centerY);
            make.width.mas_equalTo(SCREENWidth*0.3);
        }];
        
        //xx XT币
        amountLabel = [[PZBetCurrency alloc]initWithTitle:@"" imageLeft:YES];
        amountLabel.textLabel.textColor = [UIColor whiteColor];
        amountLabel.textLabel.font = PZFont(13);
        [amountLabel sizeToFit];
        [self.contentView addSubview:amountLabel];
        [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(avatarLabel.mas_centerY);
            make.right.mas_equalTo(-12-12);
        }];
        
        //time
        timeLabel = [[UILabel alloc]init];
        timeLabel.textColor = [UIColor lightGrayColor];
        timeLabel.font = PZFont(12);
        timeLabel.textAlignment = NSTextAlignmentLeft ;
        [timeLabel sizeToFit];
        [self.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(avatarLabel.mas_centerY);
            make.left.mas_equalTo(self.contentView.mas_centerX);
        }];
    }
    return self ;
}


-(void)setModel:(JustNowWithStockModel *)m{
    [avatarLabel sd_setImageWithURL:[NSURL URLWithString:m.userIconUrl] placeholderImage:DefaultImage];
    titleLabel.text = m.userName ;
    amountLabel.textLabel.text = [NSString stringWithFormat:@"%d",m.guessXitbAmount] ;
    amountLabel.textLabel.textAlignment = NSTextAlignmentRight ;
    timeLabel.text = [m.time localizedTime] ;
}
@end
