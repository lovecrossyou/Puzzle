//
//  PZBarContainerController.m
//  Puzzle
//
//  Created by huibei on 16/12/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZBarContainerController.h"
#import "PZNewsContainerController.h"
#import "RRFCommentController.h"
#import "PZAccessInfo.h"
#import "PZParamTool.h"
#import "PZHttpTool.h"
#import "PZNewsCategoryModel.h"
#import "PZNewsController.h"
@interface PZBarContainerController ()<WMPageControllerDelegate, WMPageControllerDataSource,WMMenuViewDelegate>
@property(strong,nonatomic) NSArray* newsTitles ;
@end

@implementation PZBarContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *viewControllers = @[[PZNewsController class],[RRFCommentController class]];
    self.viewControllerClasses = viewControllers;
    self.titleSizeSelected = 18;
    self.pageAnimatable = YES;
    
    UIView* titleView = self.navigationItem.titleView ;
    UIView* titleBgView = [[UIView alloc]init];
    titleBgView.layer.masksToBounds = YES ;
    titleBgView.layer.cornerRadius = 14 ;
    [titleView insertSubview:titleBgView atIndex:0];
    [titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(titleView.mas_centerX);
        make.centerY.mas_equalTo(titleView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(120, 28.0f));
    }];
    titleBgView.backgroundColor = [UIColor colorWithHexString:@"354ee9"];
    
    self.navigationItem.titleView.backgroundColor = [UIColor clearColor];
    self.menuView.delegate = self ;
    self.delegate = self;
    self.dataSource = self;
    [self requestNewsCategory];
}

-(void)requestNewsCategory{
    WEAKSELF
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject]
                            };
    NSString* pathUrl = @"http://114.251.53.22/xitengweixinopen/newMessage/type";
    [PZHttpTool postRequestFullUrl:pathUrl parameters:param successBlock:^(id json) {
        PZNewsCategoryListModel* model = [PZNewsCategoryListModel yy_modelWithJSON:json];
        NSArray* categories = model.content ;
        NSMutableArray* titles = [NSMutableArray arrayWithCapacity:categories.count];
        for (PZNewsCategoryModel* m in categories) {
            [titles addObject:m.name];
        }
        weakSelf.newsTitles = titles ;
        [weakSelf reloadData];
    } fail:^(id json) {
        
    }];
}


-(CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{
    return 0.0f;
}


- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 2;
}


- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    if (index == 1) {
        RRFCommentController *friendVC = [[RRFCommentController alloc] init];
        return friendVC ;
    }
//
//    PZNewsContainerController* newsVC = [[PZNewsContainerController alloc]init];
//    newsVC.menuViewStyle = WMMenuViewStyleDefault;
//    newsVC.progressViewIsNaughty = YES ;
//    newsVC.menuHeight = 40.0f ;
//    newsVC.titles = self.newsTitles ;
//    UIView* rightView = [UIView new];
//    rightView.backgroundColor = [UIColor redColor];
//    rightView.frame = CGRectMake(0, 0, 44, 44);
//    newsVC.menuView.rightView = rightView ;
//    newsVC.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
    PZNewsController* newsVC = [[PZNewsController alloc]init];
    PZNewsCategoryModel* model = [[PZNewsCategoryModel alloc]init];
    model.type = @"caijing" ;
    newsVC.model = model;
    return newsVC;
}



@end
