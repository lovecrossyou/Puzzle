//
//  JNQSearchClassifyViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/12/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQSearchClassifyViewController.h"
#import "JNQProductDetailViewController.h"
#import "JNQPresentStoreView.h"
#import "JNQPresentStoreColCell.h"
#import "JNQPresentClassifyCell.h"
#import "JNQHttpTool.h"
#import "MJRefresh.h"
#import "PZNavController.h"

@interface JNQSearchClassifyViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITextField *searchBar;
@property (nonatomic, strong) UICollectionView *searchColV;
@property (nonatomic, strong) NSMutableArray *dataA;
@property (nonatomic, strong) JNQPresentStoreTopView *topView;
@property (nonatomic, assign) int pageNo;
@property (nonatomic, strong) UIView *hiddenV;
@property (nonatomic, assign) BOOL isPresent;
@property (nonatomic, assign) int priceSort;
@property (nonatomic, strong) UILabel *noneL;

@end

@implementation JNQSearchClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self setNav];
    [self buildUI];
    if (_productListModel.categoryId) {
        _searchBar.text = _categoryName;
        [_searchBar resignFirstResponder];
        [_searchColV.mj_header beginRefreshing];
    }
}

- (void)setNav {
    WEAKSELF
    UIView *navBV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 64)];
    [self.view addSubview:navBV];
    navBV.backgroundColor = HBColor(245, 245, 245);
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, SCREENWidth, 0.5)];
    [navBV addSubview:line];
    line.backgroundColor = HBColor(231, 231, 231);
    
    UIButton *navQuitBtn = [[UIButton alloc] init];
    [navBV addSubview:navQuitBtn];
    [navQuitBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(navBV);
        make.right.mas_equalTo(navBV).offset(-12);
        make.size.mas_equalTo(CGSizeMake(50, 44));
    }];
    navQuitBtn.titleLabel.font = PZFont(15);
    [navQuitBtn setTitleColor:HBColor(81, 81, 81) forState:UIControlStateNormal];
    [navQuitBtn setTitle:@"取消" forState:UIControlStateNormal];
    navQuitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [[navQuitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
    }];
    
    UIView *searchBV = [[UIView alloc] init];
    [navBV addSubview:searchBV];
    [searchBV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(navQuitBtn);
        make.left.mas_equalTo(navBV).offset(12);
        make.width.mas_equalTo(SCREENWidth-12-62);
        make.height.mas_equalTo(34);
    }];
    searchBV.backgroundColor = [UIColor whiteColor];
    searchBV.layer.borderColor = HBColor(231, 231, 231).CGColor;
    searchBV.layer.borderWidth = 0.5;
    searchBV.layer.cornerRadius = 2;
    
    UIButton *leftBtn = [[UIButton alloc] init];
    [searchBV addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(searchBV);
        make.width.height.mas_equalTo(34);
    }];
    leftBtn.backgroundColor = [UIColor clearColor];
    [leftBtn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    
    _searchBar = [[UITextField alloc] init];
    [searchBV addSubview:_searchBar];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(searchBV);
        make.right.height.mas_equalTo(searchBV);
        make.left.mas_equalTo(searchBV).offset(34);
    }];
    _searchBar.delegate = self;
    _searchBar.returnKeyType = UIReturnKeySearch;
    [_searchBar becomeFirstResponder];
}

- (void)buildUI {
    _topView = [[JNQPresentStoreTopView alloc] init];
    [self.view addSubview:_topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(64);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    _topView.layer.borderColor = HBColor(231, 231, 231).CGColor;
    _topView.layer.borderWidth = 0.5;
    [self topViewBlock:_topView];
    
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setItemSize:CGSizeMake((SCREENWidth-15)/2, ADAPTHeight(255))];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    _searchColV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    [self.view addSubview:_searchColV];
    [_searchColV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(SCREENHeight-64-50);
    }];
    _searchColV.backgroundColor = HBColor(245, 245, 245);
    _searchColV.delegate = self;
    _searchColV.dataSource = self;
    [_searchColV registerClass:[JNQPresentStoreColCell class] forCellWithReuseIdentifier:@"JNQPresentStoreColCell"];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadProductData:)];
    header.tag = 10010;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.textColor = HBColor(135, 135, 135);
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _searchColV.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadProductData:)];
    footer.triggerAutomaticallyRefreshPercent = 1;
    footer.automaticallyHidden = YES;
    footer.automaticallyRefresh = YES;
    footer.stateLabel.textColor = HBColor(135, 135, 135);
    _searchColV.mj_footer = footer;
    
    _hiddenV = [[UIView alloc] init];
    [self.view addSubview:_hiddenV];
    [_hiddenV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.width.mas_equalTo(self.view);
        make.height.mas_equalTo(SCREENHeight-64);
    }];
    _hiddenV.backgroundColor = [UIColor whiteColor];
    
    _noneL = [[UILabel alloc] init];
    [self.view addSubview:_noneL];
    [_noneL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(-10);
        make.width.mas_equalTo(SCREENWidth-30);
    }];
    _noneL.font = PZFont(13);
    _noneL.textColor = HBColor(153, 153, 153);
    _noneL.textAlignment = NSTextAlignmentCenter;
    _noneL.text = @"没有找到相关商品，请试试别的";
    _noneL.hidden = YES;
}

- (void)loadProductData:(UIView *)sender {
    _productListModel.pageNo = sender.tag == 10010 ? 0 : _productListModel.pageNo;
    if (_productListModel.pageNo == 0) {
        _noneL.hidden = YES;
        [MBProgressHUD show];
    }
    _productListModel.productName = _searchBar.text;
    NSDictionary *params = [_productListModel yy_modelToJSONObject];
    [JNQHttpTool JNQHttpRequestWithURL:@"product/list" requestType:@"post" showSVProgressHUD:NO parameters:params successBlock:^(id json) {
        [MBProgressHUD dismiss];
        _hiddenV.hidden = YES;
        NSArray *data = json[@"datas"];
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in data) {
            JNQPresentModel *model = [JNQPresentModel yy_modelWithJSON:dict];
            [array addObject:model];
        }
        if (_productListModel.pageNo) {
            [_dataA addObjectsFromArray:array];
        } else {
            _dataA = array;
        }
        if (!_dataA.count) {
            _noneL.hidden = NO;
        }
        [_searchColV.mj_footer endRefreshing];
        [_searchColV.mj_header endRefreshing];
        [_searchColV reloadData];
        _productListModel.pageNo++;
        _searchColV.mj_footer.hidden = [json[@"last"] boolValue] ? YES : NO;
    } failureBlock:^(id json) {
        //_failFooterView.hidden = NO;
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
        [weakSelf.searchColV.mj_header beginRefreshing];
    };
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _hiddenV.hidden = NO;
    _noneL.hidden = YES;
    _productListModel.categoryId = 0;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        [MBProgressHUD showInfoWithStatus:@"搜索内容不能为空"];
        return NO;
    } else {
        _productListModel.productName = textField.text;
        [_searchColV.mj_header beginRefreshing];
        [_searchBar resignFirstResponder];
        return YES;
    }
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataA.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JNQPresentStoreColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JNQPresentStoreColCell" forIndexPath:indexPath];
    [cell sizeToFit];
    JNQPresentModel *presentModel = [_dataA objectAtIndex:indexPath.item];
    cell.presentModel = presentModel;
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JNQPresentModel *presentModel = [_dataA objectAtIndex:indexPath.item];
    JNQProductDetailViewController *productDetailVC = [[JNQProductDetailViewController alloc] init];
    productDetailVC.navigationItem.title = @"商品详情";
    productDetailVC.viewType = ProductDetailViewTypeProduct;
    productDetailVC.productId = presentModel.productId;
    [self.navigationController pushViewController:productDetailVC animated:YES];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


@end
