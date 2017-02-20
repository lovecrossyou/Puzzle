//
//  PZNewsContainerController.m
//  Puzzle
//
//  Created by huibei on 16/12/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewsCommentModel ;
@interface StackTableViewCell : UITableViewCell
@property(copy,nonatomic)void(^commentClickBlock)(NSInteger commentId);
-(void)setupCellWithModel:(NewsCommentModel*)model;
+ (CGFloat)heightForCellWith:(NSArray*)array;

@end
