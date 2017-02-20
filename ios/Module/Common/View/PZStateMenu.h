//
//  PZStateMenu.h
//  Puzzle
//
//  Created by huibei on 16/12/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PZStateMenuDelegate <NSObject>
-(void)didSelecteItemAt:(NSInteger)index;
@end

@interface PZStateMenuItem :UIView
@property(assign,nonatomic)BOOL selected ;
@property(copy,nonatomic) void(^itemClick)(PZStateMenuItem* sender, NSInteger index);
-(instancetype)initWithTitle:(NSString*)title icon:(NSString*)icon iconSel:(NSString*)iconSel;
@end

@interface PZStateMenu : UIView

@property(weak,nonatomic)id<PZStateMenuDelegate> delegate ;
-(instancetype)initWithTitles:(NSArray*)titles;
@end
