//
//  JNQPresentStoreDetailView.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQPresentStoreDetailView.h"


@implementation JNQPresentStoreDetailView

@end

@implementation JNQPresentDetailHeaderView {
    UILabel *_proName;
    UILabel *_proDes;
    UIButton *_proPrice;
    UILabel *_proInventory;
    UIButton *_mailFeeBtn;
    UIButton *_soldOutBtn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HBColor(245, 245, 245);
        
        _comPicScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENWidth) imageURLStringsGroup:nil];
        [self addSubview:_comPicScrollView];
        _comPicScrollView.backgroundColor = [UIColor whiteColor];
        _comPicScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _comPicScrollView.currentPageDotColor = HBColor(254, 205, 52);
        _comPicScrollView.pageDotColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _comPicScrollView.placeholderImage = [UIImage imageNamed:@"product_img_default"];
        _comPicScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        
        //详情backView
        _desView = [[UIView alloc] init];//WithFrame:CGRectMake(-0.5, CGRectGetMaxY(_comPicScrollView.frame), SCREENWidth+1, 90)];
        [self addSubview:_desView];
        [_desView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_comPicScrollView.mas_bottom);
            make.centerX.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth+1, 85));
        }];
        _desView.backgroundColor = [UIColor whiteColor];
        _desView.layer.borderColor = HBColor(231, 231, 231).CGColor;
        _desView.layer.borderWidth = 0.5;
        
        //名字
        _proName = [[UILabel alloc] init];//WithFrame:CGRectMake(10, 15, SCREENWidth-20, 25)];
        [_desView addSubview:_proName];
        [_proName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_desView).offset(8);
            make.left.mas_equalTo(_desView).offset(10);
            make.height.mas_equalTo(25);
        }];
        _proName.textColor = HBColor(51, 51, 51);
        _proName.font = PZFont(16);
        
        //产品描述
        _proDes = [[UILabel alloc] init];//WithFrame:CGRectMake(10, CGRectGetMaxY(_proName.frame), SCREENWidth-20, 25)];
        [_desView addSubview:_proDes];
        [_proDes mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_proName.mas_bottom);
            make.left.mas_equalTo(_proName);
            make.height.mas_equalTo(25);
        }];
        _proDes.textColor = HBColor(153, 153, 153);
        _proDes.font = PZFont(13);
        
        //价格
        _proPrice = [[UIButton alloc] init];//WithFrame:CGRectMake(10, CGRectGetMaxY(_proDes.frame), SCREENWidth-20, 25)];
        [_desView addSubview:_proPrice];
        [_proPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_proDes.mas_bottom);
            make.left.mas_equalTo(_proDes);
            make.height.mas_equalTo(25);
        }];
        [_proPrice setTitleColor:BasicRedColor forState:UIControlStateNormal];
        [_proPrice setImage:[UIImage imageNamed:@"icon_big"] forState:UIControlStateNormal];
        _proPrice.titleLabel.font = PZFont(16);
        _proPrice.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        //库存
        _proInventory = [[UILabel alloc] init];//WithFrame:CGRectMake(SCREENWidth/2, CGRectGetMaxY(_proDes.frame), SCREENWidth/2-10, 25)];
        [_desView addSubview:_proInventory];
        [_proInventory mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_proDes.mas_bottom);
            make.right.mas_equalTo(_desView).offset(-10);
            make.height.mas_equalTo(25);
        }];
        _proInventory.textColor = HBColor(153, 153, 153);
        _proInventory.font = PZFont(13);
        _proInventory.textAlignment = NSTextAlignmentRight;
        
        
        //操作BackView
        _opeView = [[UIView alloc] init];//WithFrame:CGRectMake(-0.5, CGRectGetMaxY(_desView.frame)-0.5, SCREENWidth+1, 35)];
        [self addSubview:_opeView];
        [_opeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_desView.mas_bottom).offset(-0.5);
            make.centerX.width.mas_equalTo(_desView);
            make.height.mas_equalTo(35);
        }];
        _opeView.backgroundColor = [UIColor whiteColor];
        _opeView.layer.borderColor = HBColor(231, 231, 231).CGColor;
        _opeView.layer.borderWidth = 0.5;
        
        //快递费
        _mailFeeBtn = [[UIButton alloc] init];//WithFrame:CGRectMake(10, 0, SCREENWidth/2-10, 35)];
        [_opeView addSubview:_mailFeeBtn];
        [_mailFeeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_opeView);
            make.left.mas_equalTo(_opeView).offset(10);
            make.height.mas_equalTo(35);
        }];
        [_mailFeeBtn setImage:[UIImage imageNamed:@"icon_duihao_red"] forState:UIControlStateNormal];
        _mailFeeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_mailFeeBtn setTitle:@" 快递：0.0" forState:UIControlStateNormal];
        [_mailFeeBtn setTitleColor:HBColor(119, 119, 119) forState:UIControlStateNormal];
        _mailFeeBtn.titleLabel.font = PZFont(12);
        
        //销售量
        _soldOutBtn = [[UIButton alloc] init];//WithFrame:CGRectMake(SCREENWidth/2, 0, SCREENWidth/2-10, 35)];
        [_opeView addSubview:_soldOutBtn];
        [_soldOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.mas_equalTo(_mailFeeBtn);
            make.left.mas_equalTo(_opeView).offset(SCREENWidth/2);
        }];
        [_soldOutBtn setImage:[UIImage imageNamed:@"icon_duihao_red"] forState:UIControlStateNormal];
        _soldOutBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_soldOutBtn setTitleColor:HBColor(119, 119, 119) forState:UIControlStateNormal];
        _soldOutBtn.titleLabel.font = PZFont(12);
        
        _speciView = [[UIView alloc] init];//WithFrame:CGRectMake(0, CGRectGetMaxY(_opeView.frame), SCREENWidth, 15)];
        [self addSubview:_speciView];
        [_speciView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_opeView.mas_bottom);
            make.left.right.mas_equalTo(self);
            make.height.mas_equalTo(15);
        }];
        _speciView.backgroundColor = HBColor(245, 245, 245);
        
        
//        _speciSelectView = [[PZTitleInputView alloc] initWithTitle:@"规格：" placeHolder:@"请选择规格"];
//        [_speciView addSubview:_speciSelectView];
//        _speciSelectView.backgroundColor = [UIColor whiteColor];
//        _speciSelectView.frame = CGRectMake(-1, 15, SCREENWidth+2, 45);
//        _speciSelectView.textEnable = NO;
        
    }
    return self;
}

- (void)setViewType:(ProductDetailViewType)viewType {
    _viewType = viewType;
    _opeView.hidden = viewType == ProductDetailViewTypeProduct ? NO : YES;
    _proInventory.hidden = viewType == ProductDetailViewTypeProduct ? NO : YES;
    CGFloat height = viewType == ProductDetailViewTypeProduct ? 25 : 0;
    [_proDes mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    CGFloat desHeight = viewType == ProductDetailViewTypeProduct ? 85 : 60;
    [_desView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(desHeight);
    }];
}

- (void)setProductModel:(JNQPresentProductModel *)productModel {
    _productModel = productModel;
    _proName.text = productModel.productName;
    _proDes.text = productModel.detail;
    [_proPrice setTitle:[NSString stringWithFormat:@" %.0f", (float)productModel.price/100] forState:UIControlStateNormal];
    _proInventory.text = [NSString stringWithFormat:@"库存：%ld", (long)productModel.inventory];
    [_soldOutBtn setTitle:[NSString stringWithFormat:@" 已售：%ld", (long)productModel.sales] forState:UIControlStateNormal];
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in productModel.pictures) {
        NSString *picUrl = dict[@"picUrl"];
        [array addObject:picUrl];
    }
    _comPicScrollView.imageURLStringsGroup = array;
}

- (void)setAwardModel:(JNQAwardDetailModel *)awardModel {
    _awardModel = awardModel;
    _proName.text = awardModel.name;
    [_proPrice setTitle:[NSString stringWithFormat:@" %.0f", (float)awardModel.price/100] forState:UIControlStateNormal];
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in awardModel.awardPictures) {
        NSString *picUrl = dict[@"picUrl"];
        [array addObject:picUrl];
    }
    _comPicScrollView.imageURLStringsGroup = array;
}

@end

@implementation JNQPresentStoreDetailBottomView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _seviceBtn = [[HBVerticalBtn alloc] initWithIcon:@"iconfont-dianhua-0" title:@"客服"];
        [self addSubview:_seviceBtn];
        [_seviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.mas_equalTo(self);
            make.width.mas_equalTo(SCREENWidth/6);
        }];
        
        _shoppingCartBtn = [[HBVerticalBtn alloc] initWithIcon:@"iconfont-gouwuche" title:@"购物车"];
        [self addSubview:_shoppingCartBtn];
        [_shoppingCartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self);
            make.left.mas_equalTo(_seviceBtn.mas_right);
            make.width.mas_equalTo(SCREENWidth/6);
        }];
        
        _addShopCart = [[UIButton alloc] init];
        [self addSubview:_addShopCart];
        [_addShopCart mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self);
            make.left.mas_equalTo(_shoppingCartBtn.mas_right);
            make.width.mas_equalTo(SCREENWidth/3);
        }];
        _addShopCart.backgroundColor = BasicGoldColor;
        [_addShopCart setTitle:@"加入购物车" forState:UIControlStateNormal];
        _addShopCart.titleLabel.font = PZFont(17);
        _addShopCart.userInteractionEnabled = NO;
        
        _payBtn = [[UIButton alloc] init];
        [self addSubview:_payBtn];
        [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.mas_equalTo(self);
            make.left.mas_equalTo(_addShopCart.mas_right);
//            make.width.mas_equalTo(SCREENWidth/3);
        }];
        _payBtn.backgroundColor = BasicRedColor;
        [_payBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
        _payBtn.titleLabel.font = PZFont(17);
        _payBtn.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setProductCount:(NSInteger)productCount {
    _productCount = productCount;
    [_shoppingCartBtn setBadge:productCount];
}

@end

@implementation JNQPresentDetailSectionHeaderView {
    UILabel *_commentCountLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _commentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREENWidth/2-10, 45)];
        [self addSubview:_commentCountLabel];
        _commentCountLabel.textColor = HBColor(51, 51, 51);
        _commentCountLabel.text = @"暂无评论";
        _commentCountLabel.font = PZFont(15);
        
        _allCommentBtn = [[PZTitleInputView alloc] initWithTitle:@"查看更多"];
        [self addSubview:_allCommentBtn];
        _allCommentBtn.frame = CGRectMake(SCREENWidth-90, 0, 90, 45);
        _allCommentBtn.titleLabel.textColor = BasicGoldColor;
        _allCommentBtn.titleLabel.font = PZFont(13);
//        _allCommentBtn.userInteractionEnabled = NO;
        [[_allCommentBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.buttonBlock) {
                self.buttonBlock();
            }
        }];
    }
    return self;
}

- (void)setCommentCount:(NSInteger)commentCount {
    if (commentCount) {
        _commentCountLabel.text = [NSString stringWithFormat:@"商品评论（%ld）", (long)commentCount];
    }
    _allCommentBtn.hidden = commentCount<2 ? YES : NO;
}

@end




@implementation JNQPresentStoreDetailOperationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HBColor(245, 245, 245);
        
        UILabel *atten = [[UILabel alloc] initWithFrame:CGRectMake(15, 45, SCREENWidth/2-15, 20)];
        [self addSubview:atten];
        atten.textColor = HBColor(51, 51, 51);
        atten.font = PZFont(15);
        atten.text = @"选择数量";
        
        WEAKSELF
        _addMinusView = [[JNQCountOperateView alloc] initWithFrame:CGRectMake(SCREENWidth-90-15, 45, 90, 22)];
        [self addSubview:_addMinusView];
        _addMinusView.numField.enabled = NO;
        _addMinusView.countBlock = ^(NSInteger count) {
            if (weakSelf.countBlock) {
                weakSelf.countBlock(count);
            }
        };
        
        _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, SCREENWidth, 50)];
        [self addSubview:_confirmBtn];
        _confirmBtn.backgroundColor = BasicGoldColor;
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        
        _quitBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWidth-33, 0, 33, 33)];
        [self addSubview:_quitBtn];
        [_quitBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [_quitBtn setTitleColor:HBColor(153, 153, 153) forState:UIControlStateNormal];
        _quitBtn.titleLabel.font = PZFont(14);
    }
    return self;
}

@end
