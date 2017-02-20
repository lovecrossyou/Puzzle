//
//  JNQPresentStoreViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQPresentAwardViewController.h"
#import "JNQShoppingCartViewController.h"
#import "JNQProductDetailViewController.h"
#import "JNQSearchClassifyViewController.h"
#import "JNQPresentClassifyViewController.h"

#import "JNQAwardModel.h"
#import "JNQPresentModel.h"
#import "JNQProductListModel.h"

#import "HBVerticalBtn.h"
#import "JNQFailFooterView.h"
#import "JNQPresentStoreView.h"
#import "JNQPresentStoreCell.h"
#import "JNQPresentStoreColCell.h"

#import "JNQHttpTool.h"
#import "PZParamTool.h"
#import "PZNavController.h"
#import "ShoppingCartTool.h"

#import "MJRefresh.h"


@interface JNQPresentHeaderView : UIView

@property (nonatomic, strong) UIButton *searBtn;
@property (nonatomic, strong) HBVerticalBtn *classifyBtn;
@property (nonatomic, assign) NSInteger amountCount;

@end

@implementation JNQPresentHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = HBColor(245, 245, 245);
        
        UILabel *declaretion = [[UILabel alloc] init];
        [declaretion sizeToFit];
        [self addSubview:declaretion];
        [declaretion mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(6);
            make.left.mas_equalTo(12);
            make.height.mas_equalTo(15);
        }];
        declaretion.font = PZFont(11);
        declaretion.textColor = [UIColor redColor];
        declaretion.text = DeclarationInfo;
        
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(declaretion.mas_bottom).offset(6);
            make.left.mas_equalTo(8);
            make.width.mas_equalTo(SCREENWidth-44-8);
            make.height.mas_equalTo(28);
        }];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderColor = HBColor(231, 231, 231).CGColor;
        view.layer.borderWidth = 0.5;
        view.layer.cornerRadius = 2;
        
        _searBtn = [[UIButton alloc] init];
        [view addSubview:_searBtn];
        [_searBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.height.right.mas_equalTo(view);
            make.left.mas_equalTo(view).offset(28);
        }];
        _searBtn.titleLabel.font = PZFont(13);
        [_searBtn setTitleColor:HBColor(153, 153, 153) forState:UIControlStateNormal];
        [_searBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [_searBtn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
        
        _classifyBtn = [[HBVerticalBtn alloc] initWithIcon:@"btn_sort" title:@"分类"];
        [self addSubview:_classifyBtn];
        [_classifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(21);
            make.left.mas_equalTo(view.mas_right);
            make.width.mas_equalTo(44);
            make.height.mas_equalTo(35);
        }];
        
        
    }
    return self;
}

- (void)setAmountCount:(NSInteger)amountCount {
    _amountCount = amountCount;
    //[_amountBtn setTitle:[NSString stringWithFormat:@" %ld", (long)amountCount] forState:UIControlStateNormal];
}

@end

@interface JNQPresentAwardViewController () <UICollectionViewDelegate, UICollectionViewDataSource> {
    NSMutableArray *_presentDataArray;
    NSMutableArray *_awardDataArray;
    BOOL _istableView;
    int _priceSort;
}
@property (nonatomic, strong) JNQPresentHeaderView *headerView;
@property (nonatomic, strong) JNQProductListModel *productListModel;
@property (nonatomic, strong) JNQPresentStoreTopView *topView;
@property (nonatomic, strong) UICollectionView *psCollectionView;
@property (nonatomic, strong) JNQFailFooterView *failFooterView;
@property (nonatomic, strong) HBVerticalBtn *shoppingCartBtn;

@end

@implementation JNQPresentAwardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HBColor(245, 245, 245);
    WEAKSELF
    _productListModel = [[JNQProductListModel alloc] init];
    _presentDataArray = [NSMutableArray array];
    _awardDataArray = [NSMutableArray array];
    _istableView = YES;
    _priceSort = 1;
    [self setNav];
    [self buildUI];
    _failFooterView = [[JNQFailFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
    [self.view addSubview:_failFooterView];
    _failFooterView.hidden = YES;
    _failFooterView.reloadBlock = ^() {
        [weakSelf loadPresentData:nil];
        [weakSelf loadAccountData];
    };

    [self loadPresentData:nil];
//    [self loadAccountData];
}

- (void)setNav {
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    navTitle.font = PZFont(10);
    navTitle.textColor = [UIColor whiteColor];
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.numberOfLines = 2;
    navTitle.text = @"礼品商城\n(本商城所有商品来自京东)";
    NSMutableAttributedString *navTitleString = [[NSMutableAttributedString alloc] initWithString:navTitle.text];
    [navTitleString addAttribute:NSFontAttributeName value:PZFont(15) range:[navTitle.text rangeOfString:@"礼品商城"]];
    navTitle.attributedText = navTitleString;
    self.navigationItem.titleView = navTitle;
    
    _shoppingCartBtn = [[HBVerticalBtn alloc] initWithIcon:@"jnq_shopping-cart" title:@""];
    _shoppingCartBtn.frame = CGRectMake(0, 10, 30, 30);
    [_shoppingCartBtn setBadgeWidth:10];
    [_shoppingCartBtn setTitle:@""];
    [[_shoppingCartBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        JNQShoppingCartViewController *shoppingCartVC = [[JNQShoppingCartViewController alloc] init];
        shoppingCartVC.navigationItem.title = @"购物车";
        [self.navigationController pushViewController:shoppingCartVC animated:YES];
    }];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -5;
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:_shoppingCartBtn];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, right];
}

- (void)buildUI {
    WEAKSELF
    _headerView = [[JNQPresentHeaderView alloc] init];
    [self.view addSubview:_headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(63);
    }];
    [[_headerView.searBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        JNQSearchClassifyViewController *searchVC = [[JNQSearchClassifyViewController alloc] init];
        searchVC.productListModel = [[JNQProductListModel alloc] init];
        PZNavController *nav = [[PZNavController alloc]initWithRootViewController:searchVC];
        [weakSelf presentViewController:nav animated:YES completion:nil];
    }];
    [[_headerView.classifyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        JNQPresentClassifyViewController *classifyVC = [[JNQPresentClassifyViewController alloc] init];
        classifyVC.title = @"分类";
        classifyVC.productListModel = weakSelf.productListModel;
        [self.navigationController pushViewController:classifyVC animated:YES];
    }];
    
    _topView = [[JNQPresentStoreTopView alloc] init];
    [self.view addSubview:_topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headerView.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    _topView.layer.borderColor = HBColor(231, 231, 231).CGColor;
    _topView.layer.borderWidth = 0.5;
    [self topViewBlock:_topView];
    
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    [flowLayout setItemSize:CGSizeMake((SCREENWidth-15)/2, ADAPTHeight(255))];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    _psCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    [self.view addSubview:_psCollectionView];
    [_psCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topView.mas_bottom);
        make.left.width.bottom.mas_equalTo(self.view);
    }];
    _psCollectionView.backgroundColor = HBColor(245, 245, 245);
    _psCollectionView.delegate = self;
    _psCollectionView.dataSource = self;
    [_psCollectionView registerClass:[JNQPresentStoreColCell class] forCellWithReuseIdentifier:@"JNQPresentStoreColCell"];
    
    MJRefreshNormalHeader *colheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadPresentData:)];
    colheader.tag = 10010;
    colheader.lastUpdatedTimeLabel.hidden = YES;
    colheader.stateLabel.textColor = HBColor(135, 135, 135);
    colheader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _psCollectionView.mj_header = colheader;
    
    MJRefreshAutoNormalFooter *colfooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadPresentData:)];
    colfooter.triggerAutomaticallyRefreshPercent = 1;
    colfooter.automaticallyHidden = YES;
    colfooter.automaticallyRefresh = YES;
    colfooter.stateLabel.textColor = HBColor(135, 135, 135);
    _psCollectionView.mj_footer = colfooter;
}

#pragma mark - 数据加载与处理
- (void)loadPresentData:(UIView *)sender {
    if (sender.tag == 10010) {
        _productListModel.pageNo = 0;
    }
    NSDictionary *params = [_productListModel yy_modelToJSONObject];
    [JNQHttpTool JNQHttpRequestWithURL:@"product/list" requestType:@"post" showSVProgressHUD:NO parameters:params successBlock:^(id json) {
        _failFooterView.hidden = YES;
        NSArray *data = json[@"datas"];
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in data) {
            JNQPresentModel *model = [JNQPresentModel yy_modelWithJSON:dict];
            [array addObject:model];
        }
        if (_productListModel.pageNo) {
            [_psCollectionView.mj_footer endRefreshing];
            [_presentDataArray addObjectsFromArray:array];
        } else {
            [_psCollectionView.mj_header endRefreshing];
            _presentDataArray = array;
        }
        [_psCollectionView reloadData];
        _productListModel.pageNo++;
        _psCollectionView.mj_footer.hidden = !array.count ? YES : NO;
    } failureBlock:^(id json) {
        _failFooterView.hidden = NO;
    }];
}

- (void)loadAccountData {
    [JNQHttpTool JNQHttpRequestWithURL:@"account/info" requestType:@"post" showSVProgressHUD:YES parameters:@{} successBlock:^(id json) {
        _headerView.amountCount = [json[@"xtbProfitAmount"] integerValue];
    } failureBlock:^(id json) {
        
    }];
}

- (void)topViewBlock:(JNQPresentStoreTopView *)topView {
    WEAKSELF
    topView.topBlock = ^(UIButton *button, NSString *tagString, int sales, int priceSort) {
            for (UIView *sub in weakSelf.topView.subviews) {
                if (sub.tag) {
                    _topView.upImgBtn.selected = NO;
                    _topView.downImgBtn.selected = NO;
                    UIButton *btn = (UIButton *)sub;
                    btn.selected = btn.tag == button.tag ? YES : NO;
                    btn.userInteractionEnabled = btn.tag == button.tag ? NO : YES;
                    if (button.tag < 3) {
                        _priceSort = 0;
                    } else {
                        _priceSort = _priceSort==0 ? 1 : _priceSort;
                        if (btn.tag == 3 && button.tag == btn.tag) {
                            btn.selected = YES;
                            btn.userInteractionEnabled = YES;
                            _priceSort = priceSort == -1 ? -_priceSort : priceSort;
                            _topView.upImgBtn.selected = _priceSort == 1 ? YES : NO;
                            _topView.downImgBtn.selected = !_topView.upImgBtn.selected;
                        }
                    }
                }
            }
            weakSelf.productListModel.tagName = tagString;
            weakSelf.productListModel.salesTag = sales;
            weakSelf.productListModel.priceTag = _priceSort;
            [weakSelf.psCollectionView.mj_header beginRefreshing];
    };
}

#pragma mark - CollectionView Delegate & Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _presentDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JNQPresentStoreColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JNQPresentStoreColCell" forIndexPath:indexPath];
    [cell sizeToFit];
    JNQPresentModel *presentModel = [_presentDataArray objectAtIndex:indexPath.item];
    cell.presentModel = presentModel;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JNQProductDetailViewController *productDetailVC = [[JNQProductDetailViewController alloc] init];
    JNQPresentModel *model = [_presentDataArray objectAtIndex:indexPath.item];
    productDetailVC.productId = model.productId;
    productDetailVC.viewType = ProductDetailViewTypeProduct;
    productDetailVC.navigationItem.title = @"商品详情";
    [self.navigationController pushViewController:productDetailVC animated:YES];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSInteger count = [ShoppingCartTool queryShoppingCarCount];
    [_shoppingCartBtn setBadge:count];
}


@end
