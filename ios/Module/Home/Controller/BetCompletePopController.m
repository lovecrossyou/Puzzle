//
//  BetCompletePopController.m
//  Puzzle
//
//  Created by huipay on 2016/10/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "BetCompletePopController.h"
#import <STPopup/STPopup.h>
#import "BetResultView.h"
#import "StockDetailModel.h"
#import "PraiseResultView.h"
@interface BetCompletePopController ()
@property(nonatomic,weak)BetResultView *customView;

@end

@implementation BetCompletePopController

-(instancetype)init{
    if (self = [super init]) {
        self.contentSizeInPopup = CGSizeMake(SCREENWidth - 70, 180.0f);
    }
    return self ;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    WEAKSELF
    BetResultView *customView = [[BetResultView alloc] initWithModel:self.stockDetailModel type:self.guessType amount:self.amount];
    customView.backgroundColor = [UIColor redColor];
    self.customView = customView;
    customView.frame = CGRectMake(0, 0, SCREENWidth - 70, 180.0f) ;
    [self.view addSubview:customView];
    customView.closeClick = ^(){
        if (weakSelf.popViewBlock) {
            weakSelf.popViewBlock();
        }
    };
    
    if (self.praise) {
        PraiseResultView *praiseView = [[PraiseResultView alloc] initWithNumble:self.amount];
        praiseView.backgroundColor = [UIColor redColor];
        praiseView.frame = CGRectMake(0, 0, SCREENWidth - 70, 180.0f) ;
        [self.view addSubview:praiseView];
        praiseView.closeClick = ^(){
            if (weakSelf.popViewBlock) {
                weakSelf.popViewBlock();
            }
        };
    }
    
    [self.popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSelf)]];    
}

-(void)closeSelf{
    if (self.popViewBlock) {
        self.popViewBlock();
    }
}

@end
