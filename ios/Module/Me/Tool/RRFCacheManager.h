//
//  RRFCacheManager.h
//  Puzzle
//
//  Created by huibei on 16/8/3.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRFCacheManager : NSObject
+(RRFCacheManager *)sharedCacheManger;
-(NSString *)getFileSize;
- (BOOL)clearCache;
@end
