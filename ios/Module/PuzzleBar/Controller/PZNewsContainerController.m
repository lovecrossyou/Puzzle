//
//  PZNewsContainerController.m
//  Puzzle
//
//  Created by huibei on 16/12/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZNewsContainerController.h"
#import "PZNewsController.h"
#import "PZAccessInfo.h"
#import "PZParamTool.h"
#import "PZHttpTool.h"
#import "PZWebController.h"
#import "PZNewsCategoryModel.h"
#import "HBLoadingView.h"
#import "BonusPaperSortPanel.h"
#import "UIView+Extension.h"
@interface PZNewsContainerController ()<WMPageControllerDelegate, WMPageControllerDataSource,WMMenuViewDataSource,WMMenuViewDelegate>
@property(strong,nonatomic) NSArray* lists ;

@property(strong,nonatomic)BonusPaperSortPanel* sortView ;

/** 频道数据模型 */
@property (nonatomic, strong) NSArray *channelList;
/** 当前要展示频道 */
@property (nonatomic, strong) NSMutableArray *list_now; // 功能待完善
/** 已经删除的频道 */
@property (nonatomic, strong) NSMutableArray *list_del; // 功能待完善



@end

@implementation PZNewsContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lists = @[];
    self.titleSizeSelected = 18;
    self.pageAnimatable = YES;
    self.titleColorSelected = [UIColor darkGrayColor];
    self.titleColorNormal = [UIColor lightGrayColor];
    self.menuView.dataSource = self ;
    self.delegate = self;
    self.dataSource = self;
    
    [HBLoadingView showCircleView:self.view];
    [self requestNewsCategory];
}

-(void)didLoadMenuView{
    UIWindow* rootView = [UIApplication sharedApplication].keyWindow ;
    WEAKSELF
    //添加按钮
    UIButton* btnAdd = [UIButton new];
    [btnAdd setImage:[UIImage imageNamed:@"news_plus"] forState:UIControlStateNormal];
    btnAdd.frame = CGRectMake(0, 0, 44, 44);
    [self.menuView setRightView:btnAdd];
    [[btnAdd rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        [weakSelf setNeedsStatusBarAppearanceUpdate];
        //显示编辑频道
       	[rootView addSubview:weakSelf.sortView];
        weakSelf.sortView.y = -SCREENWidth;
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.sortView.y = 0 ;
        }];

    }];
}

- (BonusPaperSortPanel *)sortView
{
    if (_sortView == nil) {
        _sortView = [[BonusPaperSortPanel alloc] initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 SCREENWidth,
                                                                 SCREENHeight) data:self.lists];
        __block typeof(self) weakSelf = self;
        // 箭头点击回调
        _sortView.arrowBtnClickBlock = ^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            [weakSelf setNeedsStatusBarAppearanceUpdate];
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.sortView.y = -ScrH;
            } completion:^(BOOL finished) {
                [weakSelf.sortView removeFromSuperview];
            }];
        };
        // 排序完成回调
        _sortView.sortCompletedBlock = ^(NSMutableArray *channelList){
            weakSelf.list_now = channelList;
        };
        // cell按钮点击回调
        _sortView.cellButtonClick = ^(UIButton *button){
            
        };
    }
    return _sortView;
}


-(void)requestNewsCategory{
    WEAKSELF
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject]
                            };
    //newmessage/category/list
    NSString* pathUrl = @"http://114.251.53.22/xitengweixinopen/newMessage/type";
    [PZHttpTool postRequestFullUrl:pathUrl parameters:param successBlock:^(id json) {
        PZNewsCategoryListModel* model = [PZNewsCategoryListModel yy_modelWithJSON:json];
        NSArray* categories = model.content ;
        weakSelf.lists = categories ;
        [weakSelf reloadData];
        [HBLoadingView dismiss];
    } fail:^(id json) {
        [HBLoadingView dismiss];
    }];
}

-(NSInteger)numbersOfTitlesInMenuView:(WMMenuView *)menu{
    return self.lists.count ;
}

-(NSString *)menuView:(WMMenuView *)menu titleAtIndex:(NSInteger)index{
    PZNewsCategoryModel* model = self.lists[index];
    return model.name ;
}



- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.lists.count ;
}


- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    PZNewsCategoryModel* model = self.lists[index];
    PZNewsController* newsVC = [[PZNewsController alloc]init];
    newsVC.model = model ;
    return newsVC;
}




@end
