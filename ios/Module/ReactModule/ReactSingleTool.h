//
//  ReactSingleTool.h
//  Puzzle
//
//  Created by huibei on 17/2/23.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ReactSingleTool : NSObject
+(ReactSingleTool *)sharedInstance;
@property(strong,nonatomic)UIViewController* currentCotroller;
@end
