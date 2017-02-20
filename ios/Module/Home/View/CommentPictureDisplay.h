//
//  CommentPictureDisplay.h
//  Puzzle
//
//  Created by huipay on 2016/10/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CommentPicture : UIControl
@property(assign,nonatomic) BOOL defaultBtn ;
@property(assign,nonatomic) NSUInteger index ;

@property(copy,nonatomic)ItemClickParamBlock delBlock;
@property(copy,nonatomic)ItemClickParamBlock broswerBlock;
-(instancetype)initWithImage:(UIImage*)image isDefault:(BOOL)defaultBtn index:(NSUInteger)index;
@end

@interface CommentPictureDisplay : UIView

-(instancetype)initWithMargin:(CGFloat)margin padding:(CGFloat)padding rowCount:(NSUInteger)count;
-(void)removeImageAt:(NSUInteger)index;
-(void)updateImages:(NSArray *)images;

@property(copy,nonatomic)ItemClickParamBlock delBlock;
@property(copy,nonatomic)ItemClickParamBlock addBlock;
@property(copy,nonatomic)ItemClickParamBlock broswerBlock;

@end
