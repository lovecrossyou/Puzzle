//
//  PZMenuView.m
//  Puzzle
//
//  Created by huipay on 2016/8/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#define padding 1
#define kSepPadding 6
#import "PZMenuView.h"
#import "PZVerticalButton.h"
#import "Masonry.h"

//#define titleWidth 100
#define titleHeight 40
#define backColor [UIColor colorWithWhite:0.300 alpha:1.000]
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


@interface PZMenuView(){
    UIView *_sliderView;
    NSArray* _titleArray ;
    CGFloat titleWidth ;
}
@property(weak,nonatomic) UIScrollView* scrollView ;
@property(weak,nonatomic) UIButton* selectButton ;
@property (nonatomic, strong) NSMutableArray *buttonArray;

@end


@implementation PZMenuView


-(instancetype)init{
    if (self = [super init]) {
        UIScrollView* containerView = [[UIScrollView alloc]init];
        containerView.bounces = NO;
        containerView.scrollEnabled = YES;
        containerView.showsHorizontalScrollIndicator = YES;
        [containerView flashScrollIndicators];
        containerView.backgroundColor = [UIColor colorR:243 colorG:243 colorB:243];
        [self addSubview:containerView];
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-2);
        }];
        self.scrollView = containerView ;
        
        //    滑块
        UIView *sliderV=[[UIView alloc]init];
        _sliderView = sliderV ;
        sliderV.backgroundColor = HBColor(24, 111, 254);
        [self addSubview:sliderV];
        [sliderV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREENWidth*0.5);
            make.top.mas_equalTo(containerView.mas_bottom).offset(1);
            make.height.mas_equalTo(2);
        }];
    }
    return self ;
}

-(NSMutableArray *)buttonArray{
    if (_buttonArray == nil) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray ;
}

-(void)setTitles:(NSArray *)titles fontSize:(CGFloat)size{
    _titleArray = titles ;
    NSInteger count = titles.count ;
    titleWidth = SCREENWidth / count ;
    for (int i = 0; i < count; i++) {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.frame = CGRectMake(titleWidth*i + i, 0, titleWidth, 44);
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        titleButton.backgroundColor = [UIColor whiteColor];
        titleButton.tag = 100+i;
        [titleButton addTarget:self action:@selector(scrollViewSelectToIndex:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:titleButton];
        if (i == 0) {
            self.selectButton = titleButton;
            [self.selectButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }
        [self.buttonArray addObject:titleButton];
        
    }
}

- (void)scrollViewSelectToIndex:(UIButton *)button
{
    [self selectButton:button.tag-100];
}


//选择某个标题
- (void)selectButton:(NSInteger)index
{
    if (index == 1) {
        self.rankTypeBlock(@"currentWeek");
    }
    else{
        self.rankTypeBlock(@"currentMonth");
    }
    [self.selectButton setTitleColor:backColor forState:UIControlStateNormal];
    self.selectButton = _buttonArray[index];
    [self.selectButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        CGRect lastFrame = _sliderView.frame ;
        lastFrame.origin.x = titleWidth*index ;
        _sliderView.frame = lastFrame ;
    }];
    
}

//监听滚动事件判断当前拖动到哪一个了
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.scrollView) {
        NSInteger index = scrollView.contentOffset.x / SCREENWidth;
        [self selectButton:index];
    } else {
        
    }
    
}





@end
