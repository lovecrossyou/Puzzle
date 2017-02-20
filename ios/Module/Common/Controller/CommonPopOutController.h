//
//  CommonPopOutController.h
//  Puzzle
//
//  Created by huipay on 2016/11/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonPopOutController : UIViewController
@property(copy,nonatomic)ItemClickBlock popViewBlock;
-(void)setTitle:(NSString *)title descInfo:(NSAttributedString*)descInfo;
@end
