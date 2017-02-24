//
//  ReactSingleTool.h
//  Puzzle
//
//  Created by huibei on 17/2/23.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PersonManagerDelegate <NSObject>
-(void)shareTo:(NSString*)platform;
-(void)reportClick;
-(void)blackList;

//沙龙
-(void)headClick;
@end

@interface ReactSingleTool : NSObject
+(ReactSingleTool *)sharedInstance;
@property(strong,nonatomic)UIViewController* currentCotroller;
@property(strong,nonatomic) id<PersonManagerDelegate> delegate;
@end
