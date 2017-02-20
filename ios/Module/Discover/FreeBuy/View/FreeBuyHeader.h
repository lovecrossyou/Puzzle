//
//  FreeBuyHeader.h
//  Puzzle
//
//  Created by huibei on 16/12/9.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PurchaseGameActivity ,FBNewWinnerModel;
@interface FreeBuyHeader : UIView
@property(copy,nonatomic)void(^itemClickBlock)(int index);
@property(copy,nonatomic)void(^activityClickBlock)(PurchaseGameActivity* model);
@property(copy,nonatomic)void(^messageClickBlock)(FBNewWinnerModel* model);

-(void)configModel:(NSArray* )activities ;
-(void)configWinners:(NSArray* )winners ;

@end
