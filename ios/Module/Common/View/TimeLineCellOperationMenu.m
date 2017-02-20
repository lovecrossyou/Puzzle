//
//  TimeLineCellOperationMenu.m
//  Puzzle
//
//  Created by huibei on 16/12/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "TimeLineCellOperationMenu.h"

@implementation TimeLineCellOperationMenu
{
    UIButton *_likeButton;
    UIButton *_commentButton;
    UIView *_centerLineS;
    UIButton *_awardButton;

}

-(instancetype)init{
    if (self = [super init]) {
        self.hidden = YES ;
        [self setup];
    }
    return self ;
}

- (void)setup
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    self.backgroundColor = [UIColor blackColor];
    
    _likeButton = [self creatButtonWithTitle:@"点赞" selTitle:@"取消" image:[UIImage imageNamed:@"btn_like_white"] selImage:[UIImage imageNamed:@""] target:self selector:@selector(likeButtonClicked)];
    [self addSubview:_likeButton];
    [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(80);
    }];
    
    UIView *centerLine = [UIView new];
    centerLine.backgroundColor = [UIColor grayColor];
    [self addSubview:centerLine];
    [centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_likeButton.mas_right);
        make.width.mas_equalTo(1);
        make.top.bottom.mas_equalTo(0);
    }];
    
    _commentButton = [self creatButtonWithTitle:@"评论" selTitle:@"" image:[UIImage imageNamed:@"btn_comment_white"] selImage:[UIImage imageNamed:@""] target:self selector:@selector(commentButtonClicked)];
    [self addSubview:_commentButton];
    [_commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(centerLine.mas_right);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(80);
    }];
    
    _centerLineS = [UIView new];
    _centerLineS.backgroundColor = [UIColor grayColor];
    [self addSubview:_centerLineS];
    [_centerLineS mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_commentButton.mas_right);
        make.width.mas_equalTo(1);
        make.top.bottom.mas_equalTo(0);
    }];
    
    _awardButton = [self creatButtonWithTitle:@"赞赏" selTitle:@"" image:[UIImage imageNamed:@"btn_appreciate_white"] selImage:[UIImage imageNamed:@""] target:self selector:@selector(awardButtonClicked)];
    [self addSubview:_awardButton];
    [_awardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_centerLineS.mas_right);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(80);
    }];
}



- (UIButton *)creatButtonWithTitle:(NSString *)title selTitle:(NSString *)selTitle image:(UIImage *)image selImage:(UIImage *)selImage target:(id)target selector:(SEL)sel
{
    UIButton *btn = [UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:selTitle forState:UIControlStateSelected];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selImage forState:UIControlStateSelected];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    return btn;
}
-(void)isShowAwardButton:(BOOL)isShow
{
    _awardButton.hidden = isShow;
    _centerLineS.hidden = isShow;
}
-(void)settingIsLikeSelected:(BOOL)isSelected
{
    _likeButton.selected = isSelected;
}

- (void)likeButtonClicked
{
    if (self.likeButtonClickedOperation) {
        self.likeButtonClickedOperation();
    }
    self.hidden = YES ;
}

- (void)commentButtonClicked
{
    if (self.commentButtonClickedOperation) {
        self.commentButtonClickedOperation();
    }
    self.hidden = YES ;
}

-(void)awardButtonClicked{
    if (self.awardButtonClickedOperation) {
        self.awardButtonClickedOperation();
    }
    self.hidden = YES ;
}

- (void)setShow:(BOOL)show
{
    _show = show;
    self.hidden = !show ;
}



@end
