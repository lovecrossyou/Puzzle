//
//  RRFCacheManager.m
//  Puzzle
//
//  Created by huibei on 16/8/3.
//  Copyright © 2016年 HuiBei. All rights reserved.
//
#define SDWebImageCachePath @"default/com.hackemist.SDWebImageCache.default"
#import "RRFCacheManager.h"

@implementation RRFCacheManager
static RRFCacheManager *_cacheManger;
+(RRFCacheManager *)sharedCacheManger
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _cacheManger = [[RRFCacheManager alloc]init];
    });
    return _cacheManger;
}
-(CGFloat)checkTmpSize
{
    float totalSize = 0;
    
    NSArray *pathcaches = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *diskCachePath = [pathcaches objectAtIndex:0];
    diskCachePath = [NSString stringWithFormat:@"%@/%@",diskCachePath,SDWebImageCachePath];
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:diskCachePath];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [diskCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        unsigned long long length = [attrs fileSize];
        totalSize += length / 1024.0 / 1024.0;
    }
    return totalSize;
}
-(NSString *)getFileSize
{
    float size = [self checkTmpSize];
    if (size > 1024) {
        return [NSString stringWithFormat:@"%.2f GB",size/1024.0];
    }else {
        return [NSString stringWithFormat:@"%.2f MB",size];
    }
}
- (BOOL)clearCache
{
    NSArray *pathcaches=NSSearchPathForDirectoriesInDomains(NSCachesDirectory
                                                            , NSUserDomainMask
                                                            , YES);
    NSString* diskCachePath  = [pathcaches objectAtIndex:0];
    diskCachePath  = [NSString stringWithFormat:@"%@/%@",diskCachePath,SDWebImageCachePath];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if ([fileManage fileExistsAtPath:diskCachePath]) {
        NSError *error;
        [fileManage removeItemAtPath:diskCachePath error:&error];
        if (error) {
            return NO;
        } else {
            return YES;
        }
    }
    return YES;
}
@end
