//
//  FBShareOrderCell.h
//  Puzzle
//
//  Created by huibei on 16/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FBShareOrderModel ;
@interface FBShareOrderCell : UITableViewCell
@property(nonatomic,copy)ItemClickBlock goInfoBlock;
@property(nonatomic,strong)FBShareOrderModel *model;
@end
