//
//  RRFFreeBuyOrderCell.h
//  Puzzle
//
//  Created by huipay on 2016/12/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRFFreeBuyOrderModel;
@interface RRFFreeBuyOrderCell : UITableViewCell
@property(nonatomic,strong)RRFFreeBuyOrderModel *model;
@property(nonatomic,copy)ItemClickParamBlock FreeBuyOrderCellBlock;
@property(nonatomic,copy)ItemClickBlock productBtnBlock;

@end
