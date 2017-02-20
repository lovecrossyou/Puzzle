//
//  RRFCreatAddressView.m
//  Puzzle
//
//  Created by huibei on 16/8/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQAddressOperateView.h"

@implementation JNQAddressOperateView

@end

@interface JNQAddressOperateHeaderView ()
@property(nonatomic,weak)UILabel *titleLabel;
@end

@implementation JNQAddressOperateHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if (self = [super initWithFrame:frame]) {
            _addrModel = [[JNQAddressModel alloc]init];
            
            UILabel *titleLabel = [[UILabel alloc]init];
            titleLabel.text = @"    请填写正确的收货地址,以方便您收货";
            titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
            titleLabel.font = [UIFont systemFontOfSize:13];
            self.titleLabel = titleLabel;
            [self addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.mas_equalTo(0);
                make.height.mas_equalTo(40);
            }];
            
            _nameView = [[PZTitleInputView alloc]initWithTitle:@"收货人:" placeHolder:@"请填写姓名"];
            _nameView.indicatorEnable = NO;
            [self addSubview:_nameView];
            [_nameView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(titleLabel.mas_bottom);
                make.right.mas_equalTo(-90);
                make.height.mas_equalTo(44);
            }];
            [_nameView.singnal subscribeNext:^(id x) {
                _addrModel.recievName = x;
            }];
            
            _phoneView = [[PZTitleInputView alloc]initWithTitle:@"联系方式:" placeHolder:@"请填写您的手机号"];
            _phoneView.indicatorEnable = NO;
            [self addSubview:_phoneView];
            _phoneView.numberType = YES;
            [_phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(_nameView.mas_bottom).offset(1);
                make.right.mas_equalTo(-90);
                make.height.mas_equalTo(44);
            }];
            [_phoneView.singnal subscribeNext:^(id x) {
                _addrModel.phoneNum = x;
            }];
            
            _contactBtn = [[UIButton alloc]init];
            [_contactBtn setImage:[UIImage imageNamed:@"choose_contact"] forState:UIControlStateNormal];
            [_contactBtn sizeToFit];
            [self addSubview:_contactBtn];
            [_contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_nameView.mas_top);
                make.size.mas_equalTo(CGSizeMake(90, 88));
                make.right.mas_equalTo(0);
            }];
            [[_contactBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                if (self.chooseContactBlock) {
                    self.chooseContactBlock();
                }
            }];
            
            _addressView = [[PZTitleInputView alloc]initWithTitle:@"所在区域:" placeHolder:@"请选择收货区域"];
            [self addSubview:_addressView];
            [_addressView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(_phoneView.mas_bottom).offset(1);
                make.height.mas_equalTo(44);
            }];
            _addressView.textEnable = NO;
            [[_addressView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                if (self.chooseAddressBlcok) {
                    self.chooseAddressBlcok();
                }
            }];
            
            
            _detailInfoView = [[PZTitleInputView alloc]initWithTitle:@"详细地址:" placeHolder:@"请填写收货的详细地址"];
            _detailInfoView.indicatorEnable = NO;
            [self addSubview:_detailInfoView];
            [_detailInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(_addressView.mas_bottom).offset(1);
                make.height.mas_equalTo(44);
            }];
            [_detailInfoView.singnal subscribeNext:^(id x) {
                _addrModel.detailAddress = x;
            }];
            
            _settingView = [[RRFSettingDefaultView alloc]init];
            [self addSubview:_settingView];
            [_settingView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(_detailInfoView.mas_bottom).offset(1);
                make.height.mas_equalTo(44);
            }];
            [_settingView.signal subscribeNext:^(UISwitch *sender) {
                _addrModel.isDefault = sender.on ;
            }];
            
        }
        return self;

    }
    return self;
}

- (void)setAddrModel:(JNQAddressModel *)addrModel {
    _addrModel = addrModel;
    _settingView.switchView.on = addrModel.isDefault;
    _nameView.textValue = addrModel.recievName;
    _phoneView.textValue = addrModel.phoneNum;
    _addressView.textValue = addrModel.districtAddress;
    _detailInfoView.textValue = addrModel.detailAddress;
}
-(void)setHiddenDefault:(BOOL)hiddenDefault{
    if (hiddenDefault == YES) {
        _settingView.hidden = YES;
    }
}
-(void)setShowTitle:(BOOL)showTitle
{
    self.titleLabel.hidden = !showTitle;
    if (showTitle) {
        [_nameView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom);
        }];
    }else{
        [_nameView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(1);
        }];
    }
}
- (void)setVc:(id<UITextFieldDelegate>)vc {
    _vc = vc;
    _addressView.vc = vc;
}
@end
