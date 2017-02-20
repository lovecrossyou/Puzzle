//
//  BonusPaperSortPanel.m
//  Puzzle
//
//  Created by huibei on 17/1/18.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "BonusPaperSortPanel.h"
#import "DDSortView.h"


@interface BonusPaperSortPanel()
@property (nonatomic, strong) NSMutableArray *list_now; // 功能待完善
/** 已经删除的频道 */
@property (nonatomic, strong) NSMutableArray *list_del; // 功能待完善
@end

@implementation BonusPaperSortPanel
-(instancetype)initWithFrame:(CGRect)frame data:(NSArray*)data{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UIView* headerBg = [UIView new];
        headerBg.backgroundColor = HBColor(243, 243, 243);
        [self addSubview:headerBg];
        [headerBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(20+6+42);
        }];
        
        UILabel* titleLabel = [[UILabel alloc]init];
        titleLabel.font = PZFont(15.0f);
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.textAlignment = NSTextAlignmentCenter ;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = @"频道管理" ;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(20+6);
            make.height.mas_equalTo(40);
        }];
        
        UIButton* btnComplete = [UIButton new];
        btnComplete.titleLabel.font= PZFont(15.0f);
        [btnComplete setTitle:@"完成" forState:UIControlStateNormal];
        [btnComplete setTitleColor:[UIColor colorWithHexString:@"2487d8"] forState:UIControlStateNormal];
        [self addSubview:btnComplete];
        [btnComplete addTarget:self action:@selector(arrowButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [btnComplete mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(44.0f);
            make.centerY.mas_equalTo(titleLabel.mas_centerY);
        }];
        
        self.list_now = [NSMutableArray arrayWithArray:data];
        self.list_del = [NSMutableArray arrayWithArray:data];
       //已添加 面板
        CGFloat headerHeight = 88 ;
        CGFloat sortViewHeight = (frame.size.height - headerHeight)/2 ;
        DDSortView* sortViewTop = [[DDSortView alloc]initWithFrame:CGRectMake(0, headerHeight, frame.size.width, sortViewHeight) channelList:self.list_now leftTitle:@"已添加" rightTitle:@"点击删除，长按拖动排序"];
        sortViewTop.haveVIP = YES ;
        [self addSubview:sortViewTop];
       //快速添加面板
        DDSortView* sortViewBot = [[DDSortView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(sortViewTop.frame), frame.size.width, sortViewHeight) channelList:self.list_del leftTitle:@"快速添加" rightTitle:@"快速点击，完成添加"];
        [self addSubview:sortViewBot];
        
        
        sortViewTop.cellButtonClick = ^(PZNewsCategoryModel* model){
            NSLog(@"xxxx");
            [sortViewBot update:model];
        };
        sortViewBot.cellButtonClick = ^(PZNewsCategoryModel* model){
            NSLog(@"oooo");
            [sortViewTop update:model];
        };
    }
    return self ;
}

#pragma mark 点击事件
/** 箭头按钮点击事件 */
- (void)arrowButtonClick
{
    self.arrowBtnClickBlock();
}

/** cell按钮点击事件 */
- (void)cellButtonClick:(UIButton *)button
{
    if (self.cellButtonClick) {
        self.cellButtonClick(button);
    }
}
@end
