//
//  RRFCalendarView.m
//  Puzzle
//
//  Created by huipay on 2016/12/16.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFCalendarView.h"
#import <WMPageController/WMPageController.h>

@interface RRFCalendarView ()<WMMenuViewDataSource,WMMenuViewDelegate>
@property(nonatomic,weak)UIButton *lunarCalendarBtn;
@property(nonatomic,weak)UIButton *solarCalendarBtn;
@property(strong,nonatomic) NSArray* menuTitles ;

@end
@implementation RRFCalendarView
-(instancetype)init
{
    if (self = [super init]) {
        WEAKSELF
        self.menuTitles = @[@"阴历",@"阳历"];
        self.backgroundColor = [UIColor whiteColor];
        WMMenuView* menuView = [[WMMenuView alloc]init];
        menuView.frame = CGRectMake(0, 0, SCREENWidth-40, 32);
        menuView.delegate = self ;
        menuView.dataSource = self ;
        menuView.progressWidths = @[@(40),@(40)];
        menuView.style = WMMenuViewStyleLine ;
        [menuView setLineColor:StockRed];
        menuView.backgroundColor = [UIColor whiteColor];
        [self addSubview:menuView];

        UIButton *sureBtn = [[UIButton alloc]init];
        sureBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        sureBtn.frame = CGRectMake(0, 0, 60, 32);
        self.sureBtn = sureBtn;
        menuView.rightView = sureBtn ;
        [[sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.confirmBlock) {
                weakSelf.confirmBlock();
            }
        }];
        
        UIPickerView *pickerView = [[UIPickerView alloc]init];
        pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        pickerView.showsSelectionIndicator = YES ;
        self.pickerView = pickerView;
        [self addSubview:pickerView];
        [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(menuView.mas_bottom).offset(12);
        }];
        
    }
    return self;
}

#pragma mark - menu Deledate
-(NSString *)menuView:(WMMenuView *)menu titleAtIndex:(NSInteger)index{
    return self.menuTitles[index];
}

-(NSInteger)numbersOfTitlesInMenuView:(WMMenuView *)menu{
    return self.menuTitles.count ;
}
- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state{
    if (state == WMMenuItemStateNormal) {
        return [UIColor darkGrayColor];
    }
    return StockRed ;
}


-(void)menuView:(WMMenuView *)menu didSelesctedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex{
    if (self.switchSolarBlock) {
        self.switchSolarBlock(index);
    }
}


@end
