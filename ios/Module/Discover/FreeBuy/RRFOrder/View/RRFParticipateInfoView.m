//
//  RRFParticipateInfoView.m
//  Puzzle
//
//  Created by huipay on 2016/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//
#define totalCount 3
#define margin 6
#define Width SCREENWidth/totalCount
#define Height 30

#import "RRFParticipateInfoView.h"
#import "RRFFreeBuyOrderModel.h"

@interface RRFParticipateInfoView ()
@property(nonatomic,weak)UIView *contentListView;
@property(nonatomic,weak)UILabel *titelLabel;
@end
@implementation RRFParticipateInfoView

-(instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *titelLabel = [[UILabel alloc]init];
        titelLabel.textColor = [UIColor colorWithHexString:@"666666"];
        titelLabel.font = [UIFont systemFontOfSize:15];
        titelLabel.textAlignment = NSTextAlignmentCenter;
        self.titelLabel = titelLabel;
        [self addSubview:titelLabel];
        [titelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(12);
            make.right.mas_equalTo(-12);
        }];
        
        UIView *contentListView = [[UIView alloc]init];
        self.contentListView = contentListView;
        [self addSubview:contentListView];
        [contentListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(titelLabel.mas_bottom).offset(8);
        }];
        
    }
    return self;
}
-(CGFloat)ViewHeightWithListArray:(NSArray *)listArray
{
    NSInteger count = listArray.count;
    for (int i = 0; i< count; i++) {
        CGFloat row = i/totalCount;
        CGFloat loc = i%totalCount;
        CGFloat iconX = Width * loc;
        CGFloat iconY = (Height+margin) * row + margin;
        
        UILabel *textLabel = [[UILabel alloc]init];
        RRFBidRecordsModel *model = listArray[i];
        NSString *str = [NSString stringWithFormat:@"%ld",model.purchaseCode];
        textLabel.text = str;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor  =[UIColor colorWithHexString:@"333333"];
        textLabel.font = [UIFont systemFontOfSize:14];
        textLabel.frame = CGRectMake(iconX, iconY, Width, Height);
        [self.contentListView addSubview:textLabel];
    }
    NSInteger totalRow = (count+totalCount-1)/totalCount;
    CGFloat totalHeight = totalRow * (Height+margin) + margin;
    [self.contentListView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(totalHeight);
    }];
    
    self.titelLabel.text = [NSString stringWithFormat:@"您已参与了%ld份,以下是所有的夺宝记录",count];
    return totalHeight + 40;
}
@end
