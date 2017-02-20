//
//  TimeLineCellOperationMenu.h
//  Puzzle
//
//  Created by huibei on 16/12/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineCellOperationMenu : UIView
@property (nonatomic, assign, getter = isShowing) BOOL show;

@property (nonatomic, copy) void (^likeButtonClickedOperation)();
@property (nonatomic, copy) void (^commentButtonClickedOperation)();
@property (nonatomic, copy) void (^awardButtonClickedOperation)();
-(void)isShowAwardButton:(BOOL)isShow;
-(void)settingIsLikeSelected:(BOOL)isSelected;
@end
