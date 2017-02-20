//
//  RRFSelectedAreaView.h
//  Puzzle
//
//  Created by huibei on 16/8/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//
typedef void (^SelectedAreaBlock)(UIButton *btn);
#import <UIKit/UIKit.h>

@interface JNQProcitiesView : UIView
@property(nonatomic,strong)UIScrollView *backScrollView;

@property (nonatomic, strong) UITableView *proTv;
@property (nonatomic, strong) UITableView *cityTv;
@property (nonatomic, strong) UITableView *areaTv;

@property (nonatomic, strong) UIButton *proBtn;
@property (nonatomic, strong) UIButton *cityBtn;
@property (nonatomic, strong) UIButton *areaBtn;
@property (nonatomic, strong) UIView *glideView;

@property (nonatomic, strong) UIButton *quitBtn;
@property (nonatomic, copy) SelectedAreaBlock selectBlock;

@property (nonatomic, strong)id<UITableViewDelegate,UITableViewDataSource>vc;
@end
