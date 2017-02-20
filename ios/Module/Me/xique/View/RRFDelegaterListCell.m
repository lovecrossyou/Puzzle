//
//  RRFDelegaterListCell.m
//  Puzzle
//
//  Created by huibei on 16/9/27.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFDelegaterListCell.h"
#import "RRFDelegateListModel.h"
#import "UIImageView+WebCache.h"
@interface RRFDelegaterListCell()
@property(nonatomic,weak)UIImageView *headIconView;
@property(nonatomic,weak)UILabel *nameLabel;
// 邀请人数
@property(nonatomic,weak)UILabel *invitationNumLabel;
@property(nonatomic,weak)UILabel *numLabel;
@property(nonatomic,weak)UILabel *sortLabel;
@end
@implementation RRFDelegaterListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIImageView *bgView = [[UIImageView alloc]init];
        bgView.backgroundColor  = [UIColor colorWithWhite:1.0f alpha:0.3f];
        [self.contentView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.bottom.mas_equalTo(-1);

        }];
        
        UIImageView *headIconView = [[UIImageView alloc]init];
        self.headIconView = headIconView;
        [bgView addSubview:headIconView];
        [headIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        }];
    
       
        
        UILabel *numLabel = [[UILabel alloc]init];
        numLabel.textColor = [UIColor whiteColor];
        numLabel.font = [UIFont systemFontOfSize:15];
        [numLabel sizeToFit];
        self.numLabel = numLabel;
        [bgView addSubview:numLabel];
        [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.centerY.mas_equalTo(headIconView.mas_centerY);
        }];
        
        UILabel *sortLabel = [[UILabel alloc]init];
        sortLabel.textColor = [UIColor whiteColor];
        sortLabel.font = [UIFont systemFontOfSize:12];
        [sortLabel sizeToFit];
        self.sortLabel = sortLabel;
        [bgView addSubview:sortLabel];
        [sortLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(numLabel.mas_left).offset(-10);
            make.centerY.mas_equalTo(headIconView.mas_centerY);
        }];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont systemFontOfSize:15];
        [nameLabel sizeToFit];
        self.nameLabel = nameLabel;
        [bgView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headIconView.mas_right).offset(12);
            make.top.mas_equalTo(headIconView.mas_top).offset(10);
            make.right.mas_equalTo(-80);
        }];
        
        UILabel *invitationNumLabel = [[UILabel alloc]init];
        invitationNumLabel.textColor = [UIColor whiteColor];
        invitationNumLabel.font = [UIFont systemFontOfSize:12];
        [invitationNumLabel sizeToFit];
        self.invitationNumLabel = invitationNumLabel;
        [bgView addSubview:invitationNumLabel];
        [invitationNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headIconView.mas_right).offset(12);
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(4);
        }];
        
        UIView *sep = [[UIView alloc]init];
        sep.backgroundColor = [UIColor colorWithHexString:@"8a7d88"];
        [self.contentView addSubview:sep];
        [sep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.8);
        }];

    }
    return self;
}
-(void)setModel:(RRFDelegateListModel *)model
{
    [self.headIconView sd_setImageWithURL:[NSURL URLWithString:model.userIconUrl] placeholderImage:[UIImage imageNamed:@"common_head_default-diagram"]];
    self.nameLabel.text = model.userName;
    self.numLabel.text = [NSString stringWithFormat:@"%ld颗",model.diamondAmount];
    self.sortLabel.text = model.operationType;
    NSInteger amount = model.inventoryAmount;
    if (amount != 0) {
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headIconView.mas_top).offset(4);
        }];
        self.invitationNumLabel.text = [NSString stringWithFormat:@"邀请%ld人",amount];
        self.invitationNumLabel.hidden = NO;

    }else{
        self.invitationNumLabel.hidden = YES;
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headIconView.mas_top).offset(10);
        }];
    }
    
}
@end
