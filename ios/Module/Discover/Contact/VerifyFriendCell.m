//
//  VerifyFriendCell.m
//  Puzzle
//
//  Created by huipay on 2016/11/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "VerifyFriendCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Image.h"

@interface VerifyFriendCell()

@property(weak,nonatomic)UIImageView* iconView ;
@property(weak,nonatomic)UILabel* nameLabel ;
@property(weak,nonatomic)UILabel* xtNoLabel ;
@property(weak,nonatomic)UIButton* rightBtn ;

@end

@implementation VerifyFriendCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView* iconView = [[UIImageView alloc]init];
        [self.contentView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(44, 44));
            make.top.mas_equalTo(12);
            make.bottom.mas_equalTo(-12);
        }];
        self.iconView = iconView ;
        
        UILabel* nameLabel = [[UILabel alloc]init];
        nameLabel.font = PZFont(16.0f);
        [nameLabel sizeToFit];
        [self.contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(12);
            make.top.mas_equalTo(iconView.mas_top);
        }];
        self.nameLabel = nameLabel ;
        
        UILabel* xtNoLabel = [[UILabel alloc]init];
        xtNoLabel.font = PZFont(13.0f);
        xtNoLabel.textColor = [UIColor darkGrayColor];
        [xtNoLabel sizeToFit];
        [self.contentView addSubview:xtNoLabel];
        [xtNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(12);
            make.bottom.mas_equalTo(iconView.mas_bottom);
        }];
        self.xtNoLabel = xtNoLabel ;
        
        UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.layer.masksToBounds = YES ;
        rightBtn.layer.cornerRadius = 4 ;
        UIColor* normalColor = [UIColor whiteColor];
        UIColor* selectColor = [UIColor lightGrayColor];
        rightBtn.titleLabel.font = PZFont(14.0f);
        [rightBtn setTitleColor:normalColor forState:UIControlStateNormal];
        [rightBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"4964ef"]] forState:UIControlStateNormal];
        [rightBtn setTitle:@"已接受" forState:UIControlStateSelected];
        [rightBtn setTitle:@"接受" forState:UIControlStateNormal];
        [rightBtn setBackgroundImage:[UIImage createImageWithColor:selectColor] forState:UIControlStateSelected];
        WEAKSELF
        [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton* sender) {
            sender.selected = YES ;
            if (weakSelf.itemClock) {
                weakSelf.itemClock();
            }
        }];
        [self.contentView addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 32));
            make.right.mas_equalTo(-6);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        self.rightBtn = rightBtn ;
        
    }
    return self ;
}

-(void)setMyCircle:(BOOL)myCircle{
    self.rightBtn.hidden = myCircle ;
}


-(void)setContact:(RRFDetailInfoModel *)contact{
    _contact = contact ;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:contact.icon] placeholderImage:[UIImage imageNamed:@"default-avatar"]] ;
    self.nameLabel.text = contact.cnName;
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
}
@end
