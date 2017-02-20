//
//  JNQBidRecordViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/12/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQBidRecordViewController.h"
#import "FBProductListModel.h"
#import "JNQHttpTool.h"
#import "MJRefresh.h"
@interface JNQBidRecordColCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *bidCodeL;
@property (nonatomic, strong) FBBidRecordModel *bidRecordM;

@end

@implementation JNQBidRecordColCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _bidCodeL = [[UILabel alloc] init];
        [self.contentView addSubview:_bidCodeL];
        [_bidCodeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.width.height.mas_equalTo(self.contentView);
        }];
        _bidCodeL.backgroundColor = [UIColor whiteColor];
        _bidCodeL.font = PZFont(11.5);
        _bidCodeL.textColor = HBColor(51, 51, 51);
        _bidCodeL.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setBidRecordM:(FBBidRecordModel *)bidRecordM {
    _bidRecordM = bidRecordM;
    _bidCodeL.text = [NSString stringWithFormat:@"%ld", bidRecordM.purchaseCode];
}

@end


@interface JNQBidRecordViewController () <UICollectionViewDelegate, UICollectionViewDataSource> {
    int _pageNo;
}

@property (nonatomic, strong) UICollectionView *bidColV;

@end

@implementation JNQBidRecordViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-228)];
    [self.view addSubview:returnBtn];
    returnBtn.backgroundColor = [UIColor clearColor];
    [[returnBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf dismissViewControllerAnimated:YES completion:^{}];
    }];
    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHeight-228, SCREENWidth, 228)];
    [self.view addSubview:backV];
    backV.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    [flowLayout setItemSize:CGSizeMake((SCREENWidth-45)/4, 25)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.headerReferenceSize = CGSizeMake(SCREENWidth, 55);
    _bidColV = [[UICollectionView alloc] initWithFrame:CGRectMake(22.5, 0, SCREENWidth-45, 228) collectionViewLayout:flowLayout];
    [backV addSubview:_bidColV];
    _bidColV.backgroundColor = [UIColor whiteColor];
    [_bidColV registerClass:[JNQBidRecordColCell class] forCellWithReuseIdentifier:@"JNQBidRecordColCell"];
    _bidColV.delegate = self;
    _bidColV.dataSource = self;
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth-45, 55)];
    headerV.backgroundColor = [UIColor whiteColor];
    UILabel *attenL = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, SCREENWidth-45, 25)];
    [headerV addSubview:attenL];
    attenL.font = PZFont(14);
    attenL.textColor = HBColor(102, 102, 120);
    attenL.textAlignment = NSTextAlignmentCenter;
    attenL.text = [NSString stringWithFormat:@"您已参与%d份，以下是所有夺宝号码", _purchaseGameCount];
    NSMutableAttributedString *countString = [[NSMutableAttributedString alloc] initWithString:attenL.text];
    [countString addAttribute:NSForegroundColorAttributeName value:BasicRedColor range:[attenL.text rangeOfString:[NSString stringWithFormat:@"%d", _purchaseGameCount]]];
    attenL.attributedText = countString;
    [_bidColV addSubview:headerV];
    if (_isCompleteV) {
        _bidRecordA = [NSMutableArray array];
        [self loadBidRecordsData:nil];
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadBidRecordsData:)];
        footer.triggerAutomaticallyRefreshPercent = 1;
        footer.automaticallyHidden = YES;
        footer.automaticallyRefresh = YES;
        footer.stateLabel.textColor = HBColor(135, 135, 135);
        _bidColV.mj_footer = footer;
    } else {
        [_bidColV reloadData];
    }
}


- (void)loadBidRecordsData:(UIView *)sender {
    if (_pageNo == 0) {
        [MBProgressHUD show];
    }
    NSDictionary *param = @{
                            @"bidOrderId" : @(_bidOrderId),
                            @"size"       : @(28),
                            @"pageNo"     : @(_pageNo)
                            };
    [JNQHttpTool JNQHttpRequestWithURL:@"bidRecord/list" requestType:@"post" showSVProgressHUD:NO parameters:param successBlock:^(id json) {
        NSArray *array = json[@"content"];
        for (NSDictionary *dict in array) {
            FBBidRecordModel *model = [FBBidRecordModel yy_modelWithJSON:dict];
            [_bidRecordA addObject:model];
        }
        [MBProgressHUD dismiss];
        [_bidColV.mj_footer endRefreshing];
        [_bidColV reloadData];
        _bidColV.mj_footer.hidden = [json[@"last"] boolValue];
        _pageNo ++;
    } failureBlock:^(id json) {
        
    }];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _bidRecordA.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JNQBidRecordColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JNQBidRecordColCell" forIndexPath:indexPath];
    [cell sizeToFit];
    FBBidRecordModel *model = _bidRecordA[indexPath.item];
    cell.bidRecordM = model;
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

@end
