 //
//  PTChooseAddrCell.m
//  PrivateTeaStall
//
//  Created by HuHuiPay on 16/6/24.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZChooseAddrCell.h"
#import "JNQAddressModel.h"
@interface PZChooseAddrCell ()
@property(nonatomic,weak)UILabel *nameLabel;
@property(nonatomic,weak)UILabel *phoneLabel;
@property(nonatomic,weak)UIButton *defaultBtn;
@property(nonatomic,weak)UILabel *addrLabel;
@property(nonatomic,weak)UIButton *editBtn;


@end
@implementation PZChooseAddrCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIButton *chooseBtn = [[UIButton alloc]init];
        [chooseBtn setImage:[UIImage imageNamed:@"btn_choose_d"] forState:UIControlStateNormal];
        [chooseBtn setImage:[UIImage imageNamed:@"btn_choose_s"] forState:UIControlStateSelected];
        chooseBtn.userInteractionEnabled = NO;
        self.chooseBtn = chooseBtn;
        [self.contentView addSubview:chooseBtn];
        [chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.mas_equalTo(self.mas_centerY).offset(0);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        chooseBtn.tag = 520;
        [chooseBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.text = @"任瑞芳";
        nameLabel.textColor = HBColor(51, 51, 51);
        nameLabel.font = [UIFont systemFontOfSize:15];
        [nameLabel sizeToFit];
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.chooseBtn.mas_right).offset(6);
            make.top.mas_equalTo(12);
        }];
        
        
        UILabel *phoneLabel = [[UILabel alloc]init];
        phoneLabel.text = @"17600950493";
        phoneLabel.textColor = HBColor(51, 51, 51);
        phoneLabel.font = [UIFont systemFontOfSize:15];
        [phoneLabel sizeToFit];
        self.phoneLabel = phoneLabel;
        [self addSubview:phoneLabel];
        [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel.mas_right).offset(12);
            make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
            make.right.mas_lessThanOrEqualTo(-12);
        }];

        UIButton *defaultBtn = [[UIButton alloc]init];
        defaultBtn.contentMode = UIViewContentModeScaleAspectFit;
        [defaultBtn setImage:[UIImage imageNamed:@"icon_d"] forState:UIControlStateNormal];
        self.defaultBtn = defaultBtn;
        [self.contentView addSubview:defaultBtn];
        [defaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(8);
            make.left.mas_equalTo(self.nameLabel.mas_left).offset(0);
            make.height.mas_equalTo(14);
        }];
        
        UILabel *addrLabel = [[UILabel alloc]init];
        addrLabel.textColor = [UIColor colorWithHexString:@"aaaaaa"];
        addrLabel.font = [UIFont systemFontOfSize:12];
        [addrLabel sizeToFit];
        addrLabel.numberOfLines = 2;
        self.addrLabel = addrLabel;
        [self addSubview:addrLabel];
        [addrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.defaultBtn.mas_right).offset(12);
            make.centerY.mas_equalTo(self.defaultBtn.mas_centerY);
            make.right.mas_lessThanOrEqualTo(-30);
        }];
        
        
        UIButton *editBtn = [[UIButton alloc]init];
        editBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [editBtn setImage:[UIImage imageNamed:@"icon_edit"] forState:UIControlStateNormal];
        self.editBtn = editBtn;
        [self.contentView addSubview:editBtn];
        [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        [editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        editBtn.tag = 2333;
    }
    return self;
}
-(void)editBtnClick:(UIButton *)button {
    if (self.btnClick) {
        self.btnClick(button);
    }
}
-(void)setAddrModel:(JNQAddressModel *)addrModel
{
    _addrModel = addrModel;
    self.chooseBtn.selected = addrModel.isSelected;
    self.nameLabel.text = addrModel.recievName;
    self.phoneLabel.text = addrModel.phoneNum;
    self.addrLabel.text = addrModel.fullAddress;
    if (_addrModel.isDefault == 0) {
        self.defaultBtn.hidden = YES;
        [self.addrLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel.mas_left).offset(0);
        }];
    }else{
        self.defaultBtn.hidden = NO;
        [self.defaultBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(8);
            make.left.mas_equalTo(self.nameLabel.mas_left).offset(0);
            make.size.mas_equalTo(CGSizeMake(28, 14));
        }];
        [self.addrLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.defaultBtn.mas_right).offset(12);
            make.centerY.mas_equalTo(self.defaultBtn.mas_centerY);
            make.right.mas_lessThanOrEqualTo(-30);
        }];
    }
}
@end
