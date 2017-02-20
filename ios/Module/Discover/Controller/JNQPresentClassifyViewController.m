//
//  JNQPresentClassifyViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/12/27.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQPresentClassifyViewController.h"
#import "JNQUserAddComViewController.h"
#import "JNQSearchClassifyViewController.h"
#import "JNQProductListModel.h"
#import "JNQPresentClassifyCell.h"
#import "JNQHttpTool.h"
#import "PZNavController.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

@interface JNQPresentClassifyViewController () <UICollectionViewDelegate, UICollectionViewDataSource> {
    int _pageNo;
}

@property (nonatomic, strong) UICollectionView *classifyColV;
@property (nonatomic, strong) NSMutableArray *classifyA;
@property (nonatomic, strong) JNQPresentClassifyModel *lastM;
@property (nonatomic, strong) UIButton *searchBtn;

@end

@implementation JNQPresentClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HBColor(245, 245, 245);
    _classifyA = [NSMutableArray array];
    [self buildClassifyUI];
    [self loadClassifyData:nil];
}

- (void)buildClassifyUI {
    WEAKSELF
    UIView *topV = [[UIView alloc] init];
    [self.view addSubview:topV];
    [topV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.mas_equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    topV.backgroundColor = HBColor(245, 245, 245);
    
    _searchBtn = [[UIButton alloc] init];
    [topV addSubview:_searchBtn];
    [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(topV);
        make.size.mas_equalTo(CGSizeMake(SCREENWidth-24, 27.5));
    }];
    _searchBtn.backgroundColor = [UIColor whiteColor];
    _searchBtn.layer.borderColor = HBColor(231, 231, 231).CGColor;
    _searchBtn.layer.borderWidth = 0.5;
    _searchBtn.layer.cornerRadius = 2;
    _searchBtn.titleLabel.font = PZFont(13);
    [_searchBtn setTitleColor:HBColor(153, 153, 153) forState:UIControlStateNormal];
    [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [_searchBtn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    [[_searchBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        JNQSearchClassifyViewController *searchVC = [[JNQSearchClassifyViewController alloc] init];
        searchVC.productListModel = [[JNQProductListModel alloc] init];
        PZNavController *nav = [[PZNavController alloc]initWithRootViewController:searchVC];
        [weakSelf presentViewController:nav animated:NO completion:nil];
    }];
    
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    [flowLayout setItemSize:CGSizeMake(90, 120)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _classifyColV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    [self.view addSubview:_classifyColV];
    [_classifyColV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topV.mas_bottom);
        make.left.width.bottom.mas_equalTo(self.view);
    }];
    _classifyColV.backgroundColor = [UIColor whiteColor];
    _classifyColV.delegate = self;
    _classifyColV.dataSource = self;
    [_classifyColV registerClass:[JNQPresentClassifyCell class] forCellWithReuseIdentifier:@"JNQPresentClassifyCell"];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadClassifyData:)];
    header.tag = 10010;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.textColor = HBColor(135, 135, 135);
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _classifyColV.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadClassifyData:)];
    footer.triggerAutomaticallyRefreshPercent = 1;
    footer.automaticallyHidden = YES;
    footer.automaticallyRefresh = YES;
    footer.stateLabel.textColor = HBColor(135, 135, 135);
    _classifyColV.mj_footer = footer;
}

- (void)loadClassifyData:(UIView *)sender {
    _pageNo = sender.tag == 10010 ? 0 : _pageNo;
    NSDictionary *param = @{
                            @"categoryName" : @"",
                            @"size"         :@(16),
                            @"pageNo"       :@(_pageNo)
                            };
    [JNQHttpTool JNQHttpRequestWithURL:@"category/list" requestType:@"post" showSVProgressHUD:NO parameters:param successBlock:^(id json) {
        NSArray *data = json[@"content"];
        if (_classifyA.count>0) {
            [_classifyA removeLastObject];
        }
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in data) {
            JNQPresentClassifyModel *classifyM = [JNQPresentClassifyModel yy_modelWithJSON:dict];
            [array addObject:classifyM];
        }
        if (_pageNo) {
            [_classifyA addObjectsFromArray:array];
        } else {
            _classifyA = array;
        }
        [_classifyA addObject:self.lastM];
        [_classifyColV.mj_header endRefreshing];
        [_classifyColV.mj_footer endRefreshing];
        [_classifyColV reloadData];
        _pageNo ++;
        _classifyColV.mj_footer.hidden = [json[@"last"] boolValue];
    } failureBlock:^(id json) {
        
    }];
}

- (void)addProductByUser {
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _classifyA.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JNQPresentClassifyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JNQPresentClassifyCell" forIndexPath:indexPath];
    [cell sizeToFit];
    JNQPresentClassifyModel *classifyM = [_classifyA objectAtIndex:indexPath.item];
    cell.classifyM = classifyM;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row<_classifyA.count-1) {
        JNQPresentClassifyModel *classifyM = [_classifyA objectAtIndex:indexPath.item];
        JNQSearchClassifyViewController *searchVC = [[JNQSearchClassifyViewController alloc] init];
        searchVC.productListModel = [[JNQProductListModel alloc] init];
        searchVC.productListModel.categoryId = classifyM.categoryId;
        searchVC.categoryName = classifyM.categoryName;
        PZNavController *nav = [[PZNavController alloc]initWithRootViewController:searchVC];
        [self presentViewController:nav animated:YES completion:nil];
    } else {
        JNQUserAddComViewController *userAddComVC = [[JNQUserAddComViewController alloc] init];
        userAddComVC.navigationItem.title = @"添加商品";
        PZNavController *nav = [[PZNavController alloc]initWithRootViewController:userAddComVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (JNQPresentClassifyModel *)lastM {
    if (!_lastM) {
        _lastM = [[JNQPresentClassifyModel alloc] init];
        _lastM.categoryName = @"添加商品";
        _lastM.picture = @"btn_add-goods";
    }
    return _lastM;
}

@end



