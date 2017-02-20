//
//  RRFWiningOrderListCell.h
//  Puzzle
//
//  Created by huipay on 2017/1/17.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRFWiningOrderModel;
@interface RRFWiningOrderListCell : UITableViewCell
@property(nonatomic,strong)RRFWiningOrderModel *model;
@property(nonatomic,copy)ItemClickBlock winingOrderListCellBlock;
@end
