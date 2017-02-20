//
//  UIImage+image.h
//  weibo
//
//  Created by apple on 13-8-28.
//  Copyright (c) 2013年 niu mu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)
+ (UIImage *)fullscreenImageWithName:(NSString *)name;

/**
 *  返回一张已经经过拉伸处理的图片
 *
 *  @param name 图片的名字
 *
 *  @return 经过拉伸的图片
 */
+ (UIImage *)stretchImageWithName:(NSString *)name;

/** 根据颜色产生一张图片*/
+ (UIImage *)createImageWithColor:(UIColor *)color;

/** 纠正图片的方向 */
+ (UIImage *) scaleImage: (UIImage *)image scaleFactor:(float)scaleBy ;


+ (UIImage *)getLaunchImage;

//裁剪图片
+(UIImage *)cutImage:(UIImage*)image;
@end
