//
//  JNQPresentStoreView.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PresentStoreTopBlock)(UIButton *button, NSString *tagString, int sales, int priceSort);

@interface JNQPresentStoreView : UIView

@end



@interface JNQPresentStoreTopView : UIView

@property (nonatomic, strong) UIButton *recommondBtn;
@property (nonatomic, strong) UIButton *salesBtn;
@property (nonatomic, strong) UIButton *priceBtn;
@property (nonatomic, strong) UIButton *taBColBtn;
@property (nonatomic, strong) UIView *upDownBtnBackView;
@property (nonatomic, strong) UIButton *upImgBtn;
@property (nonatomic, strong) UIButton *downImgBtn;
@property (nonatomic, strong) PresentStoreTopBlock topBlock;

@end
