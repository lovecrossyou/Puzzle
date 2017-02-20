//
//  JNQRankView.m
//  Puzzle
//
//  Created by HuHuiPay on 16/9/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQRankView.h"

@implementation JNQRankView

@end

@implementation JNQRankSelectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        CGFloat width = (SCREENWidth-106)/3;
        for (int i = 0; i<3; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((width+35)*i, 0, width, 35)];
            [self addSubview:btn];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 4;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"ranking_Btn_n"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"-ranking_btn_s"] forState:UIControlStateSelected];
            btn.titleLabel.font = PZFont(15);
            [btn addTarget:self action:@selector(btnsDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
        }
    }
    return self;
}

- (void)btnsDidClicked:(UIButton *)button {

    if (self.btnBlock) {
        self.btnBlock(button);
    }
}

- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    for (UIButton *btn in self.subviews) {
        [btn setTitle:titleArray[btn.tag] forState:UIControlStateNormal];
    }
}

@end


@interface JNQRankHeaderView()
@end

@implementation JNQRankHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _backImgView = [[UIImageView alloc] init];
//        _backImgView.userInteractionEnabled = YES ;
        _backImgView.contentMode = UIViewContentModeScaleAspectFill ;
        [self addSubview:_backImgView];
        [_backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.left.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth-24, RankBannerHeight));
        }];
        _backImgView.backgroundColor = [UIColor whiteColor];
        _backImgView.layer.masksToBounds = YES;
        _backImgView.layer.cornerRadius = 4;
        
        _moreBtn = [[UIButton alloc] init];
        [self addSubview:_moreBtn];
        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_backImgView).offset(-12);
            make.bottom.mas_equalTo(_backImgView).offset(-10);
            make.height.mas_equalTo(20);
        }];
        [_moreBtn setTitleColor:HBColor(51, 51, 51) forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = PZFont(13);
        
//        _selfRankView = [[JNQFriendsCircleRankHeaderView alloc] initWithFrame:CGRectMake(0, 191, SCREENWidth-24, 80)];
//        [self addSubview:_selfRankView];
//        _selfRankView.backView.layer.masksToBounds = YES;
//        _selfRankView.backView.layer.cornerRadius = 4;
//        _selfRankView.backgroundColor = [UIColor clearColor];
//        _selfRankView.rankType = FriendRankTypeIncome;
    }
    return self;
}

- (void)setRankType:(RankType)rankType {
    _rankType = rankType;
//    _selfRankView.rank = rankType;
    if (_rankType <=3 || _rankType == 7) {
        [_moreBtn setTitle:@"获奖名单" forState:UIControlStateNormal];
    } else {
        [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    }
}

@end
