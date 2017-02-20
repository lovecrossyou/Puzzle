//
//  FreeBuyCell.h
//  Puzzle
//
//  Created by huibei on 16/12/9.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FBProductModel;
@interface FreeBuyCell : UITableViewCell
@property (nonatomic, strong) ItemClickBlock clickBlock;
@property(copy,nonatomic)void (^productDetailBlock)();
-(void)configModel:(FBProductModel*)model;
@end
