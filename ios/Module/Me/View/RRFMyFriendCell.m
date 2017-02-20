//
//  RRFMyFriendCell.m
//  Puzzle
//
//  Created by huibei on 16/11/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFMyFriendCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@interface RRFMyFriendCell ()
@property(nonatomic,weak)UIButton *headView;
@property(nonatomic,weak)UILabel *nameLabel;
@property(nonatomic,weak)UILabel *noLabel;
@property(nonatomic,weak)UIButton *statusBtn;
@property(nonatomic,weak)UIView *topLine;
@property(nonatomic,weak)UIView *botLine;
@end
@implementation RRFMyFriendCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        WEAKSELF
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *headView = [[UIButton alloc]init];
//        headView.image = [UIImage imageNamed:@"common_head_default-diagram"];
        [self addSubview:headView];
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
//            make.bottom.mas_equalTo(-12);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        self.headView = headView;
        [[headView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.headerBlock) {
                weakSelf.headerBlock();
            }
        }];
       
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.textColor = [UIColor colorWithHexString:@"777777"];
        nameLabel.font = [UIFont systemFontOfSize:15];
        [nameLabel sizeToFit];
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headView.mas_right).offset(10);
            make.top.mas_equalTo(headView.mas_top).offset(3);
            make.right.mas_equalTo(-80);
        }];
        
        UILabel *noLabel = [[UILabel alloc]init];
        noLabel.text = @"喜腾号:--";
        noLabel.textColor = HBColor(153, 153, 153);
        noLabel.font = [UIFont systemFontOfSize:13];
        [noLabel sizeToFit];
        self.noLabel = noLabel;
        [self addSubview:noLabel];
        [noLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headView.mas_right).offset(10);
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(5);
        }];
        
        UIButton *statusBtn = [[UIButton alloc]init];
        [statusBtn setTitle:@"提示投注" forState:UIControlStateNormal];
        [statusBtn setTitle:@"已投注" forState:UIControlStateSelected];
        [statusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [statusBtn setTitleColor:HBColor(153, 153, 153) forState:UIControlStateSelected];
        [statusBtn setBackgroundColor:[UIColor colorWithHexString:@"4964ef"]];
        statusBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        [statusBtn sizeToFit];
        self.statusBtn = statusBtn;
        [self addSubview:statusBtn];
        [statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.right.mas_equalTo(-12);
            make.size.mas_equalTo(CGSizeMake(55+8, 32));
        }];
        [[statusBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.clickBlock) {
                weakSelf.clickBlock();
            }
        }];
        statusBtn.layer.cornerRadius = 2;
        statusBtn.layer.masksToBounds = YES;
        
        UIView *topline = [[UIView alloc] init];
        [self.contentView addSubview:topline];
        [topline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
        topline.backgroundColor = HBColor(231, 231, 231);
        self.topLine = topline;
        
        UIView *botline = [[UIView alloc] init];
        [self.contentView addSubview:botline];
        [botline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(self);
            make.left.mas_equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
        botline.backgroundColor = HBColor(231, 231, 231);
        self.botLine = botline;
    }
    return self;
}

-(void)setModel:(InviteBonuses *)model{
    [self setBaseModel:model.model];
}


-(void)setBaseModel:(InviteBaseModel *)baseModel{
    [self.headView sd_setImageWithURL:[NSURL URLWithString:baseModel.acceptUserIconUrl] forState:UIControlStateNormal placeholderImage:DefaultImage];
    _nameLabel.text = baseModel.acceptUserName;
    self.statusBtn.selected = [baseModel.hasGuess isEqualToString:@"true"] ? YES : NO;
    self.statusBtn.userInteractionEnabled = [baseModel.hasGuess isEqualToString:@"true"] ? NO : YES;
    self.statusBtn.backgroundColor = [baseModel.hasGuess isEqualToString:@"true"] ? [UIColor clearColor] : BasicBlueColor;
    NSInteger xitengCode = baseModel.xitengCode ;
    if (xitengCode != 0) {
        self.noLabel.text = [NSString stringWithFormat:@"喜腾号：%ld",xitengCode];
    }
}

- (void)setIsTop:(BOOL)isTop {
    _isTop = isTop;
    self.topLine.hidden = !isTop;
}

- (void)setIsBot:(BOOL)isBot {
    _isBot = isBot;
    if (isBot) {
        [self.botLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
        }];
    } else {
        [self.botLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(12);
        }];
    }
}

@end
