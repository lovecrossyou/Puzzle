//
//  FBSharePanel.m
//  Puzzle
//
//  Created by huibei on 16/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "FBSharePanel.h"
#import "UIButton+EdgeInsets.h"
@implementation FBSharePanel
-(instancetype)init{
    if (self = [super init]) {
        WEAKSELF
        self.backgroundColor = [UIColor whiteColor];
        NSArray* titles = @[@"微信好友",@"微信朋友圈",@"新浪微博",@"QQ好友"];
        NSArray* images = @[@"jnq_icon_wechat",@"icon_Circle-of-friends",@"0yuan_home_btn_help",@"0yuan_home_btn_help"];
        NSInteger count = titles.count ;
        CGFloat itemW = SCREENWidth/count ;
        for (int i = 0; i<count; i++) {
            UIButton* shareItem = [UIButton new];
            shareItem.titleLabel.font = PZFont(11.0f);
            shareItem.titleLabel.textAlignment = NSTextAlignmentCenter ;
            [shareItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [shareItem setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            [shareItem setTitle:titles[i] forState:UIControlStateNormal];
            shareItem.tag = i ;
            [[shareItem rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                if (weakSelf.itemClickBlock) {
                    weakSelf.itemClickBlock(i);
                }
                if (weakSelf.cancelBlock) {
                    weakSelf.cancelBlock();
                }
            }];
            shareItem.frame = CGRectMake(i*itemW, 0, itemW, 90);
            [self addSubview:shareItem];
            [shareItem layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageTop imageTitlespace:6 imageWidth:itemW];
        }
        
        UIView* line = [[UIView alloc]init];
        line.backgroundColor = HBColor(243, 243, 243);
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(90);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(1);
        }];
        
        UIButton* cancel = [UIButton new];
        cancel.titleLabel.font = PZFont(14.0f);
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:cancel];
        [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(44);
            make.left.right.mas_equalTo(0);
        }];
        [[cancel rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.cancelBlock) {
                weakSelf.cancelBlock();
            }
        }];
        
    }
    return self ;
}
@end
