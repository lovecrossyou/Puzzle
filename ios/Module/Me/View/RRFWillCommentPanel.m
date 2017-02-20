//
//  RRFWillCommentPanel.m
//  Puzzle
//
//  Created by huipay on 2017/1/22.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "RRFWillCommentPanel.h"
@interface RRFWillCommentPanel()
@property(nonatomic,weak)UIButton *willingBtn;
@property(nonatomic,weak)UIButton *commentBtn;
@property(nonatomic,weak)UIView *rollView;
@property(nonatomic,weak)UIButton *tempBtn;
@end
@implementation RRFWillCommentPanel
-(instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        UIButton *willingBtn = [[UIButton alloc]init];
        willingBtn.tag = 0;
        [willingBtn setTitle:@"待晒单" forState:UIControlStateNormal];
        [willingBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [willingBtn setTitleColor:[UIColor colorWithHexString:@"f23030"] forState:UIControlStateSelected];
        willingBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [willingBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.willingBtn = willingBtn;
        [self addSubview:willingBtn];
        [willingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(SCREENWidth/2);
        }];
        
        UIButton *commentBtn = [[UIButton alloc]init];
        commentBtn.tag = 1;
        [commentBtn setTitle:@"已晒单" forState:UIControlStateNormal];
        [commentBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [commentBtn setTitleColor:[UIColor colorWithHexString:@"f23030"] forState:UIControlStateSelected];
        commentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [commentBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.commentBtn = commentBtn;
        [self addSubview:commentBtn];
        [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(SCREENWidth/2);
            make.left.mas_equalTo(willingBtn.mas_right).offset(0);
        }];
        
        UIView *rollView = [[UIView alloc]init];
        rollView.frame = CGRectMake(SCREENWidth/6, 43, SCREENWidth/5, 2);
        rollView.backgroundColor = [UIColor colorWithHexString:@"f23030"];
        self.rollView = rollView;
        [self addSubview:rollView];
        
        [self clickBtn:willingBtn];
        
    }
    return self;
}
-(void)clickBtn:(UIButton *)button
{
    self.rollView.frame = CGRectMake(SCREENWidth/2 *button.tag + SCREENWidth/6, 43, SCREENWidth/5, 2);
    if (self.tempBtn == nil) {
        button.selected = YES;
        self.tempBtn = button;
    }else if (self.tempBtn != nil && self.tempBtn == button){
        button.selected = YES;
        
    }else if (self.tempBtn != nil && self.tempBtn != button){
        button.selected = YES;
        self.tempBtn.selected = NO;
        self.tempBtn = button;
    }
    if (self.commentPanelBlock) {
        self.commentPanelBlock(@(button.tag));
    }
}


@end
