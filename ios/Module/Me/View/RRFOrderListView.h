//
//  RRFOrderListHeadView.h
//  Puzzle
//
//  Created by huibei on 16/8/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRFOrderListModel;
@interface RRFOrderListSectionFooterView : UIControl
@property(nonatomic,weak)UIButton *totalBtn;
@property(nonatomic,weak)UIButton *clickBtn;
@end
@interface RRFOrderListSectionHeaderView : UIView
@property(nonatomic,strong)RRFOrderListModel *model;
@end


@interface RRFOrderListView : UIView

@end
