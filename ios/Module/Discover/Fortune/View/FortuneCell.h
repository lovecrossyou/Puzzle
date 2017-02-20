//
//  FortuneCell.h
//  Puzzle
//
//  Created by 朱理哲 on 2016/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FortuneCell : UITableViewCell
-(void)configTitle:(NSString *)title icon:(NSString *)icon data:(NSString*)data;
-(void)refreshData:(NSString*)data;
@end
