//
//  ContactPopMenuCell.m
//  Puzzle
//
//  Created by huipay on 2016/11/11.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "ContactPopMenuCell.h"

@interface ContactPopMenuCell()

@property(weak,nonatomic)UIImageView* iconView ;
@property(weak,nonatomic)UILabel* menuTitleLabel ;
@end



@implementation ContactPopMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView* iconView = [[UIImageView alloc]init];
        iconView.contentMode = UIViewContentModeScaleAspectFit ;
        [self.contentView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(6);
            make.left.mas_equalTo(14);
            make.bottom.mas_equalTo(-6);
        }];
        self.iconView = iconView ;
        
        UILabel* menuTitleLabel = [[UILabel alloc]init];
        [menuTitleLabel sizeToFit];
        menuTitleLabel.textColor = [UIColor whiteColor];
        menuTitleLabel.font = PZFont(16.0f);
        [self.contentView addSubview:menuTitleLabel];
        [menuTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(6);
            make.left.mas_equalTo(iconView.mas_right).offset(12);
            make.bottom.mas_equalTo(-6);
        }];
        self.menuTitleLabel = menuTitleLabel ;
        
        UIView* line = [[UIView alloc]init];
        line.backgroundColor = [UIColor lightGrayColor];
        line.alpha = 0.1 ;
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(14);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(0);
        }];
    }
    return self ;
}


-(void)setMenuTitle:(NSString *)menuTitle{
    self.menuTitleLabel.text = menuTitle ;
}

-(void)setImageName:(NSString *)imageName{
    self.iconView.image = [UIImage imageNamed:imageName];
}
@end
