//  0元夺宝商品页
//  JNQFBComViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/12/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQFBComViewController.h"
#import "JNQBidRecordViewController.h"
#import "JNQPastWinnerViewController.h"
#import "JNQBookFBOrderViewController.h"
#import "JNQFBComContentPageController.h"
#import "JNQPartInDetailViewController.h"
#import "JNQCalculateDetailViewController.h"

#import "JNQFBStateModel.h"
#import "PZCommonCellModel.h"
#import "FBProductListModel.h"

#import "JNQComView.h"
#import "CommonTableViewCell.h"
#import "FBShareOrderController.h"
#import "JNQHttpTool.h"
#import "FBPublicListController.h"
#import "PZWeakTimer.h"
#import "HBLoadingView.h"
#import "ZFModalTransitionAnimator.h"
@interface JNQFBComViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) FBProductModel *fbProductM;
@property (nonatomic, strong) JNQFBStateModel *stateModel;
@property (nonatomic, strong) PZWeakTimer *m_timer;

@property(weak,nonatomic)    JNQComHeaderView *fbHeaderV;
@property(weak,nonatomic)    UITableView *fbComTableV;

@property(assign,nonatomic) BOOL proMComplete ;
@property(assign,nonatomic) BOOL stateMComplete ;
@property(strong,nonatomic)NSArray *fbDataA;

@property (nonatomic, strong) ZFModalTransitionAnimator *animator;

@end

@implementation JNQFBComViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stateMComplete = NO;
    self.proMComplete = NO;
    [self buildFBComUI];
    [self loadFBComData];
}

- (void)buildFBComUI {
    WEAKSELF
    UITableView *fbComTableV = [[UITableView alloc] init];
    [self.view addSubview:fbComTableV];
    self.fbComTableV = fbComTableV ;
    [fbComTableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 50, 0));
    }];
    fbComTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    fbComTableV.backgroundColor = HBColor(245, 245, 245);
    fbComTableV.delegate = self;
    fbComTableV.dataSource = self;
    

    JNQComHeaderView* fbHeaderV = [[JNQComHeaderView alloc] init];
    self.fbHeaderV = fbHeaderV ;
    _fbHeaderV.buttonBlock = ^(UIButton *button) {
        if (button.tag == 1003) {
            JNQBookFBOrderViewController *bookFBOrderVC = [[JNQBookFBOrderViewController alloc] init];
            bookFBOrderVC.navigationItem.title = @"夺宝订单";
            bookFBOrderVC.productM = weakSelf.fbProductM;
            [weakSelf.navigationController pushViewController:bookFBOrderVC animated:YES];
        } else if (button.tag == 1004) {
            JNQBidRecordViewController *bidRecordVC = [[ JNQBidRecordViewController alloc] init];
            bidRecordVC.bidRecordA = [NSMutableArray arrayWithArray:weakSelf.stateModel.bidRecords];
            bidRecordVC.purchaseGameCount = (int)weakSelf.stateModel.bidRecords.count;
            bidRecordVC.modalPresentationStyle = UIModalPresentationCustom;
            weakSelf.animator = [[ZFModalTransitionAnimator alloc]initWithModalViewController:bidRecordVC];
            weakSelf.animator.dragable = NO;
            weakSelf.animator.bounces = NO;
            weakSelf.animator.behindViewAlpha = 1.0f;
            weakSelf.animator.behindViewScale = 1.0f;
            weakSelf.animator.direction = ZFModalTransitonDirectionBottom;
            bidRecordVC.transitioningDelegate = weakSelf.animator;
            [weakSelf presentViewController:bidRecordVC animated:YES completion:^{}];
        } else {
            JNQCalculateDetailViewController *calculateDetailVC = [[JNQCalculateDetailViewController alloc] init];
            calculateDetailVC.navigationItem.title = @"计算详情";
            calculateDetailVC.purchaseGameId = weakSelf.fbPurchaseGameId;
            calculateDetailVC.bidStatus = _fbProductM.purchaseGameStatus;
            [weakSelf.navigationController pushViewController:calculateDetailVC animated:YES];
        }
    };
    [fbComTableV setTableHeaderView:fbHeaderV];

    
    UIView *fbFooterV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 15)];
    [fbComTableV setTableFooterView:fbFooterV];
}

- (void)loadData {
    [self loadComData];
    [self loadFbStateData];
}

- (void)loadFBComData {
    PZCommonCellModel *inDetail = [PZCommonCellModel cellModelWithIcon:@"orderdetail_icon_canyuxiangqing" title:@"参与详情" subTitle:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:nil];
    PZCommonCellModel *pastList = [PZCommonCellModel cellModelWithIcon:@"orderdetail_icon_wangqijiexiao" title:@"往期揭晓" subTitle:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:nil];
    PZCommonCellModel *show = [PZCommonCellModel cellModelWithIcon:@"orderdetail_icon_shaidan" title:@"晒单" subTitle:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:nil];
    
    self.fbDataA = @[inDetail, pastList, show];
}

- (void)loadComData {
    WEAKSELF
    [JNQHttpTool JNQHttpRequestWithURL:@"purchaseGame/detail" requestType:@"post" showSVProgressHUD:NO parameters:@{@"purchaseGameId" : @(self.fbPurchaseGameId)} successBlock:^(id json) {
        [HBLoadingView dismiss];
        weakSelf.proMComplete = YES;
        weakSelf.fbProductM = [FBProductModel yy_modelWithJSON:json[@"content"]];
        weakSelf.fbHeaderV.fbProductModel = weakSelf.fbProductM;
        if (weakSelf.stateMComplete) {
            [weakSelf updateHeadV];
        }
    } failureBlock:^(id json) {
        [HBLoadingView dismiss];
    }];
}

- (void)loadFbStateData {
    WEAKSELF
    [JNQHttpTool JNQHttpRequestWithURL:@"purchaseGame/bidDetail" requestType:@"post" showSVProgressHUD:NO parameters:@{@"purchaseGameId" : @(self.fbPurchaseGameId)} successBlock:^(id json) {
        [HBLoadingView dismiss];
        weakSelf.stateMComplete = YES;
        weakSelf.stateModel = [JNQFBStateModel yy_modelWithJSON:json];
        weakSelf.fbHeaderV.stateM = weakSelf.stateModel;
        if (weakSelf.proMComplete) {
            [weakSelf updateHeadV];
        }
    } failureBlock:^(id json) {
        [HBLoadingView dismiss];
    }];
}

- (void)createTimer {
    self.m_timer = [PZWeakTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerEnd) name:@"countDownEnd" object:nil];
}

- (void)timerEvent {
    [_fbHeaderV updateCountDown];
}

- (void)timerEnd {
    [self.m_timer invalidate];
    self.m_timer = nil;
}

- (void)updateHeadV {
    NSDictionary *nameAttribute = @{NSFontAttributeName:PZFont(15)};
    CGRect nameRect = [self.fbProductM.productName boundingRectWithSize:CGSizeMake(SCREENWidth-70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:nameAttribute context:nil];
    CGFloat nameHeight = CGRectGetHeight(nameRect) >=16 ? CGRectGetHeight(nameRect) : 16;
    
    NSDictionary *attribute = @{NSFontAttributeName:PZFont(12.5)};
    CGRect rect = [self.fbProductM.purchaseGameDescription boundingRectWithSize:CGSizeMake(SCREENWidth-20, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    NSInteger rectH = (NSInteger)rect.size.height;
    NSInteger height = 12+nameHeight+10+rectH+5+10+15+10+20;
    [self.fbHeaderV updateContentHeight:height nameHeight:nameHeight descriptionHeight:rectH+1];
    CGFloat stateHeight = [_stateModel.purchaseGameStatus isEqualToString:@"have_lottery"] ? 237.5 : 134.5;
    self.fbHeaderV.frame = CGRectMake(0, 0, SCREENWidth, SCREENWidth+height+10+stateHeight+10);
    
    if ([_stateModel.purchaseGameStatus isEqualToString:@"finish_bid"]) {
        [self createTimer];
        [self.m_timer fire];
    }
    
    [self.fbComTableV setTableHeaderView:self.fbHeaderV];
    [self.fbComTableV reloadData];
    [HBLoadingView dismiss];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fbDataA.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JNQFBComViewController"];
    PZCommonCellModel *model = self.fbDataA[indexPath.row];
    if (!cell) {
        cell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"JNQFBComViewController"];
        cell.textLabel.font = PZFont(15);
        cell.textLabel.textColor = HBColor(51, 51, 51);
        cell.detailTextLabel.textColor = HBColor(153, 153, 153);
        cell.sepLine.backgroundColor = HBColor(211, 211, 211);
        cell.sepHeight = 0.35;
    }
    cell.accessoryType = model.accessoryType;
    cell.imageView.image = [UIImage imageNamed:model.icon];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.subTitle;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.topLineShow = indexPath.row == 0 ? YES : NO;
    cell.bottomLineSetFlush = indexPath.row == self.fbDataA.count-1 ? YES : NO;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        JNQPartInDetailViewController *partInVC = [[JNQPartInDetailViewController alloc] init];
        partInVC.productM = self.fbProductM;
        partInVC.navigationItem.title = @"参与详情";
        [self.navigationController pushViewController:partInVC animated:YES];
    } else if (indexPath.row == 1) {
        //往期揭晓
        JNQPastWinnerViewController *pastWinnerVC = [[JNQPastWinnerViewController alloc] init];
        pastWinnerVC.title = @"往期揭晓";
        pastWinnerVC.productId = _fbProductM.productId;
        [self.navigationController pushViewController:pastWinnerVC animated:YES];
    }
    else if (indexPath.row == 2){
        //晒单
        FBShareOrderController* orderShow = [[FBShareOrderController alloc]init];
        orderShow.productId = self.fbProductM.productId;
        orderShow.title = @"晒单" ;
        [self.navigationController pushViewController:orderShow animated:YES];
    }
}

- (void)dealloc {
    [self.m_timer invalidate];
    self.m_timer = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
    [HBLoadingView dismiss];
}

@end
