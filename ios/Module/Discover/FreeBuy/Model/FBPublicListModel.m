//
//  FBPublicListModel.m
//  Puzzle
//
//  Created by huibei on 16/12/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "FBPublicListModel.h"
@implementation FBPublicModel


- (void)countDown {
    
    _m_countNum -= 1;
}

- (NSString*)currentTimeString {
    
    if (_m_countNum <= 0) {
        
        return @"00:00:00";
        
    } else {
        
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)_m_countNum/3600,(long)_m_countNum%3600/60,(long)_m_countNum%60];
    }
}
@end

@implementation FBPublicListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"content" : [FBPublicModel class]
             };
}
@end
