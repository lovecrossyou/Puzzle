//
//  HBShareTool.h
//  HuiBeiWaterMerchant
//
//  Created by 朱理哲 on 16/5/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBShareTool : NSObject
+(HBShareTool *)sharedInstance;
-(void)shareSingleSNSWithType:(NSString*)type title:(NSString*)title image:(UIImage*)image url:(NSString*)url msg:(NSString*)content presentedController:(UIViewController *)presentedController;


-(void)shareInView:(UIViewController *)view title:(NSString *)title shareText:(NSString *)text shareImage:(UIImage *)image url:(NSString*)url type:(NSString*)type;

//图片分享
-(void)shareImage:(UIImage *)image imageUrl:(NSString *)imageUrl platForm:(NSString *)platForm;

@end
