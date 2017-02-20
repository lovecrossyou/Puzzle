//
//  HomePostCommentContent.h
//  Puzzle
//
//  Created by huipay on 2016/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentPictureDisplay;
@interface HomePostCommentContent : UIView
@property(strong,nonatomic) NSString* content ;
@property(strong,nonatomic) NSString* placeHolder ;

@property(weak,nonatomic) CommentPictureDisplay* picListPanel ;
@property(weak,nonatomic) UITextView* textView ;
@property(assign,nonatomic) BOOL firendCircle;
@property(assign,nonatomic) BOOL hiddenPhoto;

@property(copy,nonatomic) TapPhotoHandler tapPhotoHandler ;
@property(copy,nonatomic) ItemClickParamBlock delItemHandler ;
-(void)updateImages:(NSArray *)images;
@end
