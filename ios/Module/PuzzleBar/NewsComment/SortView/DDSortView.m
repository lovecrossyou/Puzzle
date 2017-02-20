//
//  DDSortView.m
//  DDNews
//
//  Created by Dvel on 16/4/15.
//  Copyright © 2016年 Dvel. All rights reserved.
//

#import "DDSortView.h"
#import "PZNewsCategoryModel.h"
#import "DDSortCell.h"
#import "DDSortCell_first.h"

#import "LXReorderableCollectionViewFlowLayout.h"
#import "UIView+Extension.h"

static NSString * const reuseID1 = @"ShouYeCell";
static NSString * const reuseID2 = @"OthersCell";

@interface DDSortView () <LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray *channelList;

@property(weak,nonatomic)UICollectionView *collectionView ;
@end

@implementation DDSortView

- (instancetype)initWithFrame:(CGRect)frame channelList:(NSMutableArray *)channelList leftTitle:(NSString *)left rightTitle:(NSString *)right
{
	_channelList = channelList.mutableCopy;
	self = [super initWithFrame:frame];
	if (self) {
		UILabel *label = [[UILabel alloc] init];
		label.text = left;
		label.font = [UIFont systemFontOfSize:14];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithHexString:@"999999"];
		[label sizeToFit];
		[self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(24);
        }];
        
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.text = right;
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.textColor = [UIColor colorWithHexString:@"999999"];
        leftLabel.font = [UIFont systemFontOfSize:14];
        [leftLabel sizeToFit];
        [self addSubview:leftLabel];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(24);
        }];
        
		// 中间的排序collectionView,
        CGFloat topOffset = 24+12 ;
		LXReorderableCollectionViewFlowLayout *flowLayout = [LXReorderableCollectionViewFlowLayout new];
		UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,topOffset,frame.size.width,frame.size.height-topOffset)
															  collectionViewLayout:flowLayout];
        self.collectionView = collectionView ;
		collectionView.backgroundColor = [UIColor whiteColor];
		collectionView.dataSource = self;
		collectionView.delegate = self;
		[collectionView registerClass:[DDSortCell_first class] forCellWithReuseIdentifier:reuseID1];
		[collectionView registerClass:[DDSortCell class] forCellWithReuseIdentifier:reuseID2];
		[self addSubview:collectionView];
		
		// 设置cell的大小和细节,每排4个
		CGFloat margin = 20.0;
		CGFloat width  = (SCREENWidth - margin * 5) / 4.f;
		CGFloat height = width * 3.f / 7.f; // 按图片比例来的
		flowLayout.sectionInset = UIEdgeInsetsMake(5, margin, 10, margin);
		flowLayout.itemSize = CGSizeMake(width, height);
		flowLayout.minimumInteritemSpacing = margin;
		flowLayout.minimumLineSpacing = 20;
		
		// 下面49高度的箭头（覆盖tabbar）
		UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(collectionView.frame),
																	 frame.size.width, 49)];
		button.backgroundColor = [UIColor whiteColor];
		[button setImage:[UIImage imageNamed:@"up_arrow"] forState:UIControlStateNormal];
		button.layer.shadowColor = [UIColor whiteColor].CGColor;
		button.layer.shadowRadius = 5;
		button.layer.shadowOffset = CGSizeMake(0, -10);
		button.layer.shadowOpacity = 1;
		[button addTarget:self action:@selector(arrowButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:button];
	}
	return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return _channelList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.haveVIP) {
        if (indexPath.row == 0) {
            DDSortCell_first *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID1 forIndexPath:indexPath];
            PZNewsCategoryModel *first = _channelList[0];
            [cell.button setTitle:first.name forState:UIControlStateNormal];
            return cell;
        } else {
            PZNewsCategoryModel* model = _channelList[indexPath.row];
            DDSortCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID2 forIndexPath:indexPath];
            [cell.button setTitle:model.name forState:UIControlStateNormal];
            // 在每个cell下面生成一个虚线的框框
//            UIButton *placeholderBtn = [[UIButton alloc] initWithFrame:cell.frame];
//            [placeholderBtn setBackgroundImage:[UIImage imageNamed:@"channel_sort_placeholder"] forState:UIControlStateNormal];
//            placeholderBtn.width  -= 1;		placeholderBtn.centerX = cell.centerX;
//            placeholderBtn.height -= 1;		placeholderBtn.centerY = cell.centerY;
//            [collectionView insertSubview:placeholderBtn atIndex:0];
            return cell;
        }
    }
    else{
        PZNewsCategoryModel* model = _channelList[indexPath.row];
        DDSortCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID2 forIndexPath:indexPath];
        [cell.button setTitle:model.name forState:UIControlStateNormal];
          // 在每个cell下面生成一个虚线的框框
//        UIButton *placeholderBtn = [[UIButton alloc] initWithFrame:cell.frame];
//        [placeholderBtn setBackgroundImage:[UIImage imageNamed:@"channel_sort_placeholder"] forState:UIControlStateNormal];
//        placeholderBtn.width  -= 1;		placeholderBtn.centerX = cell.centerX;
//        placeholderBtn.height -= 1;		placeholderBtn.centerY = cell.centerY;
//        [collectionView insertSubview:placeholderBtn atIndex:0];
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PZNewsCategoryModel* model = _channelList[indexPath.row];
    self.cellButtonClick(model);
    //删除频道
    [_channelList removeObjectAtIndex:indexPath.row];
    [collectionView reloadData];
}

#pragma mark LXReorderableCollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
	PZNewsCategoryModel *model = _channelList[fromIndexPath.item];
	[_channelList removeObjectAtIndex:fromIndexPath.item];
	[_channelList insertObject:model atIndex:toIndexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath
{
	if (self.sortCompletedBlock) {
		self.sortCompletedBlock(_channelList);
	}
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0&&self.haveVIP) {return NO;}
	return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    if (self.haveVIP) {
        if (fromIndexPath.row == 0 || toIndexPath.row == 0) {return NO;}
    }
	return YES;
}

#pragma mark 点击事件
/** 箭头按钮点击事件 */
- (void)arrowButtonClick
{
	self.arrowBtnClickBlock();
}


-(void)update:(PZNewsCategoryModel *)model{
    [self.channelList addObject:model];
    [self.collectionView reloadData];
    
}

@end
