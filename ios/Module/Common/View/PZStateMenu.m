//
//  PZStateMenu.m
//  Puzzle
//
//  Created by huibei on 16/12/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZStateMenu.h"
#import "UIButton+EdgeInsets.h"

@interface PZStateMenuItem()
{
    UIButton* selctedItem ;
}
@end

@implementation PZStateMenuItem
-(instancetype)initWithTitle:(NSString*)title icon:(NSString*)icon iconSel:(NSString*)iconSel{
    if (self = [super init]) {
        WEAKSELF
        UIButton* item = [UIButton new];
        selctedItem = item ;
        [item setTitle:title forState:UIControlStateNormal];
        [item setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
        [item setImage:[UIImage imageNamed:iconSel] forState:UIControlStateSelected];
        item.titleLabel.font = PZFont(14.0f);
        [item setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [item setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [self addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        if (![icon isEqualToString:@""]) {
            [item layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageRight imageTitlespace:0 imageWidth:9];
        }
        [[item rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton* sender) {
            if (weakSelf.itemClick) {
                sender.selected = !sender.selected ;
                weakSelf.itemClick(self,self.tag);
            }
        }];
    }
    return self ;
}

-(BOOL)selected{
    return selctedItem.selected ;
}

-(void)setSelected:(BOOL)selected{
    NSLog(@"selected %d",selected);
    selctedItem.selected = selected ;
}
@end

@interface PZStateMenu()
{
    NSArray* _titles ;
    PZStateMenuItem* selectedItem ;
}
@property(weak,nonatomic)UIView* botLine ;
@end


@implementation PZStateMenu
-(instancetype)initWithTitles:(NSArray*)titles{
    if (self = [super init]) {
        WEAKSELF
        self.backgroundColor = [UIColor whiteColor];
        NSInteger count = titles.count ;
        CGFloat itemWidth = (SCREENWidth-20*2)/count ;
        PZStateMenuItem* lastItem ;
        PZStateMenuItem* firstItem ;
        NSInteger tagIndex  = 0 ;
        for (NSString* title in titles) {
            NSString* icon = @"" ;
            NSString* iconSel = @"" ;
            if (tagIndex == 2) {
                icon = @"home_low_price_btn_" ;
                iconSel = @"home_high_price_btn_";
            }
            PZStateMenuItem* item = [[PZStateMenuItem alloc]initWithTitle:title icon:icon iconSel:iconSel];
            [self addSubview:item];
            if (tagIndex == 0) {
                firstItem = item ;
                item.selected = YES ;
                selectedItem = item ;
            }
            item.itemClick=^(PZStateMenuItem* sender,NSInteger index){
                [weakSelf.delegate didSelecteItemAt:index];
                [weakSelf.botLine mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(sender.mas_centerX);
                    make.width.mas_equalTo(itemWidth*0.4);
                    make.bottom.mas_equalTo(0);
                    make.height.mas_equalTo(2);
                }];
                selectedItem = sender ;
            };
            if (lastItem) {
                [item mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(itemWidth);
                    make.left.mas_equalTo(lastItem.mas_right);
                    make.top.bottom.mas_equalTo(0);
                }];
            }
            else{
                [item mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(itemWidth);
                    make.left.mas_equalTo(20);
                    make.top.bottom.mas_equalTo(0);
                }];
            }
            item.tag = tagIndex ;
            lastItem = item ;
            tagIndex++ ;
        }
        
        UIView* botLine = [[UIView alloc]init];
        botLine.backgroundColor = [UIColor redColor];
        [self addSubview:botLine];
        self.botLine = botLine ;
        [botLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(2);
            make.width.mas_equalTo(itemWidth*0.48);
            make.centerX.mas_equalTo(firstItem.mas_centerX);
        }];
    }
    return self ;
}
@end
