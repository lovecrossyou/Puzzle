//
//  HBLoadingView.h
//  LodingScreen
//
//  Created by huipay on 2016/10/31.
//  Copyright © 2016年 huipay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBLoadingView : UIView
+(void)showCircleView:(UIView *)view;
+(void)showLoading:(UIView *)view;
+(void)hide;
+(void)dismiss ;
+(void)showMsg:(NSString*)content;
+ (void)showCircleView:(UIView *)view Interactive:(BOOL)nteractive;
@end
