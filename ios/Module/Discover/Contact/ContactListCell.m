//
//  ContactListCell.m
//  Puzzle
//
//  Created by huipay on 2016/11/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "ContactListCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Image.h"
#import "UIButton+WebCache.h"
@interface ContactListCell()

@property(weak,nonatomic)UIButton* iconView ;
@property(weak,nonatomic)UILabel* nameLabel ;
@property(weak,nonatomic)UILabel* xtNoLabel ;
@property(weak,nonatomic)UIButton* rightBtn ;

@end

@implementation ContactListCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        UIButton* iconView = [[UIButton alloc]init];
        [self.contentView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(44, 44));
            make.top.mas_equalTo(12);
            make.bottom.mas_equalTo(-12);
        }];
        self.iconView = iconView ;
        
        WEAKSELF
        [[iconView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton* sender) {
            sender.selected = YES ;
            if (weakSelf.headClock) {
                weakSelf.headClock();
            }
        }];
        
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
        [rightBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forState:UIControlStateDisabled];
        [rightBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forState:UIControlStateSelected];
        [rightBtn setTitle:@"已发送" forState:UIControlStateSelected];
        [rightBtn setTitle:@"邀请" forState:UIControlStateNormal];
        [rightBtn setTitle:@"已注册" forState:UIControlStateDisabled];
        [rightBtn setTitleColor:selectColor forState:UIControlStateDisabled];
        [rightBtn setBackgroundImage:[UIImage createImageWithColor:selectColor] forState:UIControlStateSelected];
        [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton* sender) {
            sender.selected = YES ;
            if (weakSelf.itemClock) {
                weakSelf.itemClock();
            }
        }];
        [self.contentView addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 32));
            make.right.mas_equalTo(-12);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        self.rightBtn = rightBtn ;

    }
    return self ;
}

-(void)setMyCircle:(BOOL)myCircle{
    self.rightBtn.hidden = myCircle ;
}

-(void)setCircleContact:(RRFDetailInfoModel *)circleContact{
    _circleContact = circleContact ;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:circleContact.icon] forState:UIControlStateNormal];
    self.nameLabel.text = circleContact.cnName;
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
}

-(void)setContact:(PZContact *)contact{
    _contact = contact ;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:contact.iconUrl] forState:UIControlStateNormal];
    self.nameLabel.text = contact.userName;
    NSString* xitengCode = contact.xitengCode ;
    NSString* status = contact.status ;
    if (![status isEqualToString:@"no_regist"]) {
        self.rightBtn.enabled = NO ;
    }
    else{
        self.rightBtn.enabled = YES ; 
    }
    if (xitengCode != nil && xitengCode.length) {
        self.xtNoLabel.text = [NSString stringWithFormat:@"喜腾号: %@",xitengCode];
    }
    else{
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
    }
}

@end
