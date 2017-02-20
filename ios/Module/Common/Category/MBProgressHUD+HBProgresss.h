//
//  MBProgressHUD+HBProgresss.h
//  Puzzle
//
//  Created by huipay on 2016/10/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (HBProgresss)
+(void)showInfoWithStatus:(NSString *)content;
+(instancetype)show;
+(void)dismiss;

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;
+ (void)showMessage:(NSString *)text view:(UIView *)view;
@end
