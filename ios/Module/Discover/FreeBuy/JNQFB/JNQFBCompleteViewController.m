//  0元夺宝支付完成页
//  JNQFBCompleteViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/12/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQFBCompleteViewController.h"
#import "JNQBidRecordViewController.h"
#import "JNQFBComContentPageController.h"

#import "JNQFBCompleteView.h"
#import "ZFModalTransitionAnimator.h"
#import "JNQHttpTool.h"
@interface JNQFBCompleteViewController () {
    JNQFBCompleteHeaderView *_fbCompleteHeaderV;
    JNQFBCompleteFooterView *_fbCompleteFooterV;
    
}
@property (nonatomic, assign) BOOL loadComplete;
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;

@end

@implementation JNQFBCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFBCompleteNav];
    [self buildFBCompleteUI];
}

- (void)setFBCompleteNav {
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    rightBtn.titleLabel.font = PZFont(14);
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateComData" object:nil];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-4] animated:YES];
    }];
    UIBarButtonItem *navRight = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = navRight;
    
    UIBarButtonItem *navLeft = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem = navLeft;
}

- (void)buildFBCompleteUI {
    WEAKSELF
    _fbCompleteHeaderV = [[JNQFBCompleteHeaderView alloc] init];
    _fbCompleteHeaderV.frame = CGRectMake(0, 0, SCREENWidth, 299.5);
    _fbCompleteHeaderV.productM = _productM;
    [self.tableView setTableHeaderView:_fbCompleteHeaderV];
    _fbCompleteHeaderV.buttonBlock = ^(UIButton *buttonBlock) {
        if (weakSelf.loadComplete) {
            [weakSelf turnToBidRecords];
            return;
        }
        [weakSelf loadBidRecordsDataBlock:^(NSNumber* totalCount) {//1000
            BOOL loadComplete = [totalCount intValue] >5 || weakSelf.productM.purchaseGameCount <=5;
            _loadComplete = loadComplete;
            if (loadComplete) {
                [weakSelf turnToBidRecords];
            }
        }];
    };
    
    _fbCompleteFooterV = [[JNQFBCompleteFooterView alloc] init];
    _fbCompleteFooterV.frame = CGRectMake(0, 0, SCREENWidth, SCREENHeight-64-299.5);
    [self.tableView setTableFooterView:_fbCompleteFooterV];
    [[_fbCompleteFooterV.fbContinueBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateComData" object:nil];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-4] animated:YES];
    }];
}

- (void)loadBidRecordsDataBlock:(PZRequestSuccess)complete {
    WEAKSELF
    [MBProgressHUD showMessage:@"正在生成您的夺宝号码，请稍等" toView:self.view];
    NSDictionary *param = @{
                            @"bidOrderId" : @(self.productM.bidOrderId),
                            @"size"       : @(28),
                            @"pageNo"     : @(0)
                            };
    [JNQHttpTool JNQHttpRequestWithURL:@"bidRecord/list" requestType:@"post" showSVProgressHUD:NO parameters:param successBlock:^(id json) {
        NSArray *array = json[@"content"];
        NSInteger count = array.count ;
        complete(@(count));
    } failureBlock:^(id json) {
       [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}

- (void)turnToBidRecords {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    JNQBidRecordViewController *bidRecordVC = [[ JNQBidRecordViewController alloc] init];
    bidRecordVC.bidOrderId = self.productM.bidOrderId;
    bidRecordVC.purchaseGameCount = self.productM.purchaseGameCount;
    bidRecordVC.isCompleteV = YES;
    bidRecordVC.modalPresentationStyle = UIModalPresentationCustom;
    self.animator = [[ZFModalTransitionAnimator alloc]initWithModalViewController:bidRecordVC];
    self.animator.dragable = NO;
    self.animator.bounces = NO;
    self.animator.behindViewAlpha = 1.0f;
    self.animator.behindViewScale = 1.0f;
    self.animator.direction = ZFModalTransitonDirectionBottom;
    bidRecordVC.transitioningDelegate = self.animator;
    [self presentViewController:bidRecordVC animated:YES completion:^{}];
}


@end
