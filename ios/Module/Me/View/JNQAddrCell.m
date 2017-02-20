//
//  RRFShippingAddressCell.m
//  Puzzle
//
//  Created by huibei on 16/8/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQAddrCell.h"
@interface JNQAddrCell ()
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *phoneLabel;
@property(nonatomic,strong)UILabel *addressLabel;


@property(nonatomic,strong)UIButton *deleteBtn;
@property(nonatomic,strong)UIButton *editBtn;
@end

@implementation JNQAddrCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *separateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 12)];
        [self.contentView addSubview:separateView];
        separateView.backgroundColor = HBColor(245, 245, 245);
        
        _nameLabel = [[UILabel alloc]init];
        [self addSubview:_nameLabel];
        _nameLabel.textColor = HBColor(51, 51, 51);
        _nameLabel.font = [UIFont systemFontOfSize:12];
        [_nameLabel sizeToFit];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(24);
        }];
        
        _phoneLabel = [[UILabel alloc]init];
        [self addSubview:_phoneLabel];
        _phoneLabel.textColor = HBColor(51, 51, 51);
        _phoneLabel.font = [UIFont systemFontOfSize:12];
        [_phoneLabel sizeToFit];
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel.mas_right).offset(12);
            make.top.mas_equalTo(24);
        }];
        
        
        _addressLabel = [[UILabel alloc]init];
        [self addSubview:_addressLabel];
        _addressLabel.numberOfLines = 2;
        _addressLabel.textColor = HBColor(153, 153, 153);
        [_addressLabel sizeToFit];
        _addressLabel.font = PZFont(13);
        [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(6);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(40);
        }];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, SCREENWidth, 0.5)];
        [self.contentView addSubview:lineView];
        lineView.backgroundColor = HBColor(231, 231, 231);
        
        _defaultBtn = [[UIButton alloc]init];
        [self addSubview:_defaultBtn];
        [_defaultBtn setTitle:@" 设为默认" forState:UIControlStateNormal];
        [_defaultBtn setTitleColor:HBColor(153, 153, 153) forState:UIControlStateNormal];
        [_defaultBtn setImage:[UIImage imageNamed:@"btn_choose_d"] forState:UIControlStateNormal];
        [_defaultBtn setImage:[UIImage imageNamed:@"btn_choose_s"] forState:UIControlStateSelected];
        _defaultBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_defaultBtn sizeToFit];
        [_defaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.height.mas_equalTo(30);
            make.bottom.mas_equalTo(0);
        }];
        [[_defaultBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.addrBlock) {
                self.addrBlock(1);
            }
        }];
        
        
        _deleteBtn = [[UIButton alloc]init];
        [self addSubview:_deleteBtn];
        [_deleteBtn setTitle:@" 删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:HBColor(153, 153, 153) forState:UIControlStateNormal];
        [_deleteBtn setImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_deleteBtn sizeToFit];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(30);
            make.bottom.mas_equalTo(0);
        }];
        [[_deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.addrBlock) {
                self.addrBlock(2);
            }
        }];
        
        _editBtn = [[UIButton alloc]init];
        [self addSubview:_editBtn];
        [_editBtn setTitle:@" 编辑" forState:UIControlStateNormal];
        [_editBtn setTitleColor:HBColor(153, 153, 153) forState:UIControlStateNormal];
        [_editBtn setImage:[UIImage imageNamed:@"icon_edit"] forState:UIControlStateNormal];
        _editBtn.titleLabel.font = PZFont(12);
        [_editBtn sizeToFit];
        [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.deleteBtn.mas_left).offset(-25);
            make.height.mas_equalTo(30);
            make.bottom.mas_equalTo(0);
        }];
        [[_editBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.addrBlock) {
                self.addrBlock(3);
            }
        }];
    }
    return self;
}

- (void)setAddrModel:(JNQAddressModel *)addrModel {
    _addrModel = addrModel;
    if (addrModel.isDefault) {
        self.defaultBtn.selected = YES;
    } else {
        self.defaultBtn.selected = NO;
    }
    _nameLabel.text = addrModel.recievName;
    _phoneLabel.text = addrModel.phoneNum;
    NSString* addrString = addrModel.fullAddress ;
    if ([addrString hasSuffix:@"null"]) {
        NSInteger len = addrString.length ;
        addrString = [addrString substringToIndex:len - 4];
    }
    _addressLabel.text = addrString ;
}

@end
