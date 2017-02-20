//
//  PersonManager.h
//  Puzzle
//
//  Created by 朱理哲 on 2017/2/8.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@protocol PersonManagerDelegate <NSObject>
-(void)shareTo:(NSString*)platform;
-(void)reportClick;
-(void)blackList;
@end


@interface PersonManager : NSObject<RCTBridgeModule>
@property(strong,nonatomic) id<PersonManagerDelegate> delegate;
@end
