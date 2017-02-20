//
//  FBSharePanel.h
//  Puzzle
//
//  Created by huibei on 16/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBSharePanel : UIView
@property(copy,nonatomic) void(^itemClickBlock)(int index);
@property(copy,nonatomic) void(^cancelBlock)();

@end
