//
//  PZReactUIManager.h
//  Puzzle
//
//  Created by huibei on 17/2/16.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PZReactUIManager : NSObject
+(UIView*)createWithPage:(NSString*)pageName params:(id)param size:(CGSize)size;

@end
