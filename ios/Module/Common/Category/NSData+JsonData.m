//
//  NSData+JsonData.m
//  Puzzle
//
//  Created by huibei on 17/1/22.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "NSData+JsonData.h"

@implementation NSData (JsonData)
-(id)toJsonData{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}
@end
