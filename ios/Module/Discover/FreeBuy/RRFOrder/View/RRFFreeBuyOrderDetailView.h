//
//  RRFFreeBuyOrderDetailView.h
//  Puzzle
//
//  Created by huipay on 2016/12/21.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRFFreeBuyOrderModel;
@interface RRFFreeBuyOrderDetailView : UIView
@property(nonatomic,copy)ItemClickBlock seeAllBlock;
@property(nonatomic,copy)ItemClickBlock productBtnBlock;
@property(nonatomic,copy)ItemClickBlock operationBlock;
@property(nonatomic,strong)RRFFreeBuyOrderModel *model;
@end
