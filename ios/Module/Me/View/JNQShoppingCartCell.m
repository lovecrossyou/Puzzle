//
//  JNQShoppingCartCell.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQShoppingCartCell.h"
#import "UIImageView+WebCache.h"

@interface JNQShoppingCartCell () {
    UIImageView *_comImg;
    UILabel *_comName;
    UIButton *_comPrice;
}

@end

@implementation JNQShoppingCartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        _selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 95)];
        [self.contentView addSubview:_selectBtn];
        [_selectBtn setImage:[UIImage imageNamed:@"btn_choose_d"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"btn_choose_s"] forState:UIControlStateSelected];
        [[_selectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.btnBlock) {
                self.btnBlock(_selectBtn);
            }
        }];
        
        _comImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_selectBtn.frame), 10, 75, 75)];
        [self.contentView addSubview:_comImg];
        _comImg.layer.borderWidth = 0.5;
        _comImg.layer.borderColor = HBColor(231, 231, 231).CGColor;
        
        _comName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_comImg.frame)+12, 20, SCREENWidth-139, 18)];
        [self.contentView addSubview:_comName];
        _comName.textColor = HBColor(51, 51, 51);
        _comName.font = PZFont(15);
        
        _comPrice = [[UIButton alloc] init];
        [self.contentView addSubview:_comPrice];
        [_comPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_comName.mas_bottom).offset(15);
            make.left.mas_equalTo(_comName);
            make.height.mas_equalTo(18);
        }];
        [_comPrice setTitleColor:BasicRedColor forState:UIControlStateNormal];
        [_comPrice setImage:[UIImage imageNamed:@"icon_big"] forState:UIControlStateNormal];
        _comPrice.titleLabel.font = PZFont(14);
        _comPrice.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        _comCount = [[UILabel alloc] init];
        [self.contentView addSubview:_comCount];
        [_comCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_comName.mas_bottom).offset(15);
            make.left.mas_equalTo(_comPrice.mas_right);
            make.height.mas_equalTo(18);
        }];
        _comCount.textColor = HBColor(153, 153, 153);
        _comCount.font = PZFont(13);
        
        
        _addMinusView = [[JNQCountOperateView alloc]
                         initWithFrame:CGRectMake(SCREENWidth-12-85, 58, 85, 22)];
        [self.contentView addSubview:_addMinusView];
        [_addMinusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCREENWidth-12-85);
            make.centerY.mas_equalTo(_comCount.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(85, 22));
        }];
        _addMinusView.layer.borderColor = HBColor(231, 231, 231).CGColor;
        _addMinusView.layer.borderWidth = 0.6;
        _addMinusView.layer.cornerRadius = 2;
        WEAKSELF
        _addMinusView.countBlock = ^(NSInteger count) {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            weakSelf.productModel.count = count ;
            NSInteger ccount = weakSelf.productModel.count;
            weakSelf.comCount.text = [NSString stringWithFormat:@"  x%ld", count];
            NSLog(@"%ld", ccount);
            [realm commitWriteTransaction];
            if (weakSelf.countBlock) {
                weakSelf.countBlock(count);
            }
        };
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 94.5, SCREENWidth, 0.5)];
        [self.contentView addSubview:sep];
        sep.backgroundColor = HBColor(231, 231, 231);
    }
    return self;
}

- (void)setProductModel:(JNQPresentProductModel *)productModel {
    _productModel = productModel;
    [_comImg sd_setImageWithURL:[NSURL URLWithString:productModel.smallPicture] placeholderImage:[UIImage imageNamed:@"shopping-cart_image"]];
    _comName.text = productModel.productName;
    [_comPrice setTitle:[NSString stringWithFormat:@"%.2f", (float)productModel.price/100] forState:UIControlStateNormal];
    _comCount.text = [NSString stringWithFormat:@"  x%ld", productModel.count];
    _addMinusView.count = productModel.count;
    _selectBtn.selected = productModel.selected;
}

- (void)setVc:(id<UITextFieldDelegate>)vc {
    _vc = vc;
    _addMinusView.numField.delegate = vc;
}


@end
