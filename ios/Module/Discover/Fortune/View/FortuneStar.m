//
//  FortuneStar.m
//  Puzzle
//
//  Created by huibei on 17/1/3.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "FortuneStar.h"

@implementation FortuneStar
-(instancetype)initWithStar:(int)stars{
    if (self = [super init]) {
        [self createViews:stars];
    }
    return self ;
}

-(void)createViews:(int)stars{
    UIImageView* lastIcon = nil ;
    for (int i = 0; i<5; i++) {
        UIImageView* starIcon = [[UIImageView alloc]init];
        NSString* starName = i<stars ? @"draiy_icon_stars" : @"draiy_icon_star" ;
        starIcon.image = [UIImage imageNamed:starName];
        [self addSubview:starIcon];
        [starIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(16, 16));
            make.centerY.mas_equalTo(self.mas_centerY);
            if (lastIcon!= nil) {
                make.left.mas_equalTo(lastIcon.mas_right).offset(3.5);
            }
            else{
                make.left.mas_equalTo(0);
            }
        }];
        lastIcon = starIcon ;
    }
    [lastIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
    }];
}

-(void)updateStar:(int)stars{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self createViews:stars];
}
@end
