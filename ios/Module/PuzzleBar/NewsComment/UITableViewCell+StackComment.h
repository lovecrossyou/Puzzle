//
//  PZNewsContainerController.m
//  Puzzle
//
//  Created by huibei on 16/12/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UITableViewCell (StackComment)

+ (CGFloat)widthForStackAtIndex:(NSInteger)index TotalCount:(NSInteger)total;
+ (CGFloat)offsetForStackAtIndex:(NSInteger)index TotalCount:(NSInteger)total;
+ (NSInteger)levelForIndex:(NSInteger)index TotalCount:(NSInteger)total;
@end
