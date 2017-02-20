//
//  PZHttpTool.h
//  Puzzle
//
//  Created by huibei on 16/8/3.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PZHttpTool : NSObject
+(void)postRequestFullUrl:(NSString *)fullUrl parameters:(id)params successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
// GET
+(void)getRequestUrl:(NSString *)url parameters:(id)params successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
// GET
+(void)getRequestFullUrl:(NSString *)url parameters:(id)params successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;

// post
+(void)postRequestUrl:(NSString *)url parameters:(id)params successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
// post + isShowHUD
+(void)postRequestUrl:(NSString *)url showSVProgressHUD:(BOOL)show parameters:(id)params successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
// post + urlParam
+(void)postRequestUrl:(NSString *)url urlParam:(NSDictionary *)urlParam parameters:(id)params successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
// put
+(void)putRequestUrl:(NSString *)url parameters:(id)params successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
// GEI_md5Key
+(void)getMd5KeyWithUserName:(NSString*)userName successBlock:(PZRequestSuccess)success  fail:(PZRequestFailure)failBlock;
// 返回的String类型
+(void)postHttpRequestUrl:(NSString *)url parameters:(id)params successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;
// 文件上传
+ (void)postRequestWithUploadFile:(NSString *)url fileName:(NSString*)fileName imageData:(NSArray *)imageDatas parmas:(NSDictionary*)params successBlock:(PZRequestSuccess)succcessBlock;
+(void)getHttpRequestUrl:(NSString *)url parameters:(id)params successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock;

+(BOOL)notificate:(NSError*)error;
@end
