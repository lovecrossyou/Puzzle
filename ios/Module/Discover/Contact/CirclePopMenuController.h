//
//  CirclePopMenuController.h
//  Puzzle
//
//  Created by huipay on 2016/11/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CirclePopMenuController : UITableViewController
@property(strong,nonatomic)NSArray* menuTitles ;
@property(strong,nonatomic)NSArray* menusImages ;
@property(copy,nonatomic) ItemClickParamBlock itemBlock;
@end
