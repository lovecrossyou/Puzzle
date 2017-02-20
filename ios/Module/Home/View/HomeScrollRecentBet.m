//
//  HomeScrollRecentBet.m
//  Puzzle
//
//  Created by huipay on 2016/10/24.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "HomeScrollRecentBet.h"
#import "PZBetCurrency.h"
#import "JustNowWithStockModel.h"

#import "UIColor+helper.h"
#import "UIImageView+WebCache.h"
#import "NSString+TimeConvert.h"
#import "iCarousel.h"

//滚动时间间隔
#define SCROLL_TIME_INTERVAL 4

//每次滚动距离
#define SCROLL_DISTANCE 44.0f
@interface HomeScrollCell()
{
    UIImageView* avatarLabel ;
    UILabel* titleLabel;
    PZBetCurrency* amountLabel;
    UILabel* timeLabel;
}
@end


@implementation HomeScrollCell : UIView

-(void)setModel:(JustNowWithStockModel *)m{
    [avatarLabel sd_setImageWithURL:[NSURL URLWithString:m.userIconUrl] placeholderImage:DefaultImage];
    titleLabel.text = m.userName ;
    timeLabel.text = [m.time localized60Time] ;
    amountLabel.textLabel.text = [NSString stringWithFormat:@"%d",m.guessXitbAmount] ;
}

-(instancetype)initWithModel:(JustNowWithStockModel*)m{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        //icon  name  time  amount
        avatarLabel = [[UIImageView alloc]init];
        avatarLabel.layer.masksToBounds = YES ;
        avatarLabel.layer.cornerRadius = 2 ;
        [avatarLabel sd_setImageWithURL:[NSURL URLWithString:m.userIconUrl] placeholderImage:DefaultImage];
        [self addSubview:avatarLabel];
        [avatarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12+12);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = PZFont(13);
        titleLabel.text = m.userName ;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(avatarLabel.mas_right).offset(8);
            make.centerY.mas_equalTo(avatarLabel.mas_centerY);
            make.width.mas_equalTo(SCREENWidth*0.3);
        }];
        
        
        
        
        //xx XT币
        amountLabel = [[PZBetCurrency alloc]initWithTitle:@"" imageLeft:YES];
        amountLabel.textLabel.textColor = [UIColor whiteColor];
        amountLabel.textLabel.font = PZFont(13);
        [amountLabel sizeToFit];
        [self addSubview:amountLabel];
        [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(avatarLabel.mas_centerY);
            make.right.mas_equalTo(-12-12);
        }];
        
        UILabel* decStr = [UILabel new];
        decStr.textColor = [UIColor lightGrayColor];
        decStr.text = @"投注" ;
        decStr.font = PZFont(12.0f);
        [self addSubview:decStr];
        [decStr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(amountLabel.mas_left).offset(-4);
            make.centerY.mas_equalTo(avatarLabel.mas_centerY);
        }];
        
        //time
        timeLabel = [[UILabel alloc]init];
        timeLabel.textColor = [UIColor lightGrayColor];
        timeLabel.font = PZFont(12);
        timeLabel.textAlignment = NSTextAlignmentLeft ;
        timeLabel.text = [m.time localized60Time] ;
        [timeLabel sizeToFit];
        [self addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(avatarLabel.mas_centerY);
            make.left.mas_equalTo(self.mas_centerX);
        }];
        
        amountLabel.textLabel.text = [NSString stringWithFormat:@"%d",m.guessXitbAmount] ;
        amountLabel.textLabel.textAlignment = NSTextAlignmentRight ;
    }
    return self ;
}
@end


@interface HomeScrollRecentBet()<iCarouselDataSource, iCarouselDelegate>
@property(weak,nonatomic)iCarousel *carousel;
@end


@implementation HomeScrollRecentBet

-(instancetype)init{
    if (self = [super init]) {
        iCarousel* carousel = [[iCarousel alloc] init];
        carousel.type = iCarouselTypeLinear;
        carousel.delegate = self;
        carousel.dataSource = self;
        carousel.bounceDistance = 0 ;
        carousel.bounces = NO ;
        carousel.vertical = YES ;
        carousel.autoscroll = -0.2 ;
        carousel.clipsToBounds = YES ;
        [self addSubview:carousel];
        [carousel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(12, 0, 20, 0));
        }];
        self.carousel  = carousel ;
    }
    return self ;
}

-(void)setRecentList:(NSArray *)recentList{
    _recentList = recentList ;
    [self.carousel reloadData];
}


- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [_recentList count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    //create new view if no view is available for recycling
    JustNowWithStockModel* m = self.recentList[index];
    if (view == nil)
    {
        HomeScrollCell* cell = [[HomeScrollCell alloc]initWithModel:m];
        cell.frame = CGRectMake(0, 0, SCREENWidth, 44.0f);
        view = cell ;
    }
    else{
        HomeScrollCell* cellView = (HomeScrollCell*)view ;
        cellView.model = m ;
        
    }
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionWrap)
    {
        return YES;
    }
    return value;
}

-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    if (self.itemClick) {
        self.itemClick();
    }
}


@end
