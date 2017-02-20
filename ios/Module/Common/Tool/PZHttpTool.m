 //
//  PZHttpTool.m
//  Puzzle
//
//  Created by huibei on 16/8/3.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZHttpTool.h"
#import "AFNetworking.h"
#import "PZMMD5.h"
#import "PZParamTool.h"
#import "NSString+Valid.h"
#import "MBProgressHUD+HBProgresss.h"
@implementation PZHttpTool
+(void)getRequestUrl:(NSString *)url parameters:(id)params successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock
{
    NSString *fullUrlStr = [NSString stringWithFormat:@"%@%@",Base_url,url];
    [self getRequestFullUrl:fullUrlStr parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

+(void)getRequestFullUrl:(NSString *)url parameters:(id)params successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    [MBProgressHUD show];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];

    NSURL *finalUrl = [NSURL URLWithString:url];
    [manager GET:finalUrl.absoluteString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];

}

+(void)postHandleErrRequestUrl:(NSString *)url parameters:(id)params successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@",Base_url,url];
    [manager POST:fullUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
}

+(void)postRequestFullUrl:(NSString *)fullUrl parameters:(id)params successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:fullUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
        [self showErrorInfo:error];
    }];
}

+(void)postRequestUrl:(NSString *)url parameters:(id)params successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@",Base_url,url];
    [manager POST:fullUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
        [self showErrorInfo:error];
    }];
}


+(void)postHttpRequestUrl:(NSString *)url parameters:(id)params successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@",Base_url,url];
    [manager POST:fullUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString* responseString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        success(responseString);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
        [self showErrorInfo:error];
    }];
}
+(void)getHttpRequestUrl:(NSString *)url parameters:(id)params successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@",Base_url,url];
    [manager GET:fullUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString* responseString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        success(responseString);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
        [self showErrorInfo:error];
    }];
}

+(void)postRequestUrl:(NSString *)url showSVProgressHUD:(BOOL)show parameters:(id)params successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@",Base_url,url];
    if (show) {
        [MBProgressHUD show];
    }
    [manager POST:fullUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
        [self showErrorInfo:error];
    }];
}

+(void)postRequestUrl:(NSString *)url urlParam:(NSDictionary *)urlParam parameters:(id)params successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock
{
    NSString *urlParamString = [NSString stringWithFormat:@"%@?",Base_url];
    NSArray *urlParamKeys = [urlParam allKeys];
    for (NSString *key in urlParamKeys) {
        id value = urlParam[key];
        [urlParamString stringByAppendingFormat:@"%@=%@&",key,value];
    }
    NSString* fullUrl = [urlParamString substringToIndex:urlParamString.length - 1];
    [self postRequestUrl:fullUrl parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
    
}
+(void)putRequestUrl:(NSString *)url parameters:(id)params successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@",Base_url,url];
    [manager PUT:fullUrl parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
}

+(BOOL)notificate:(NSError*)error{
    NSData* data = error.userInfo[@"com.alamofire.serialization.response.error.data"] ;
    if (data != nil) {
        NSDictionary* d = [self toArrayOrNSDictionary:data];
        if (d != nil) {
            id msg = d[@"errors"] ;
            NSString* message = d[@"message"];
            if ([message containsString:@"喜腾币"]){
                return YES ;
            }
        }
    }
    return NO ;
}

+(void)showErrorInfo:(NSError*)error{
    NSData* data = error.userInfo[@"com.alamofire.serialization.response.error.data"] ;
    if (data != nil) {
        NSDictionary* d = [self toArrayOrNSDictionary:data];
        if (d != nil) {
            id msg = d[@"errors"] ;
            NSString* message = d[@"message"];
            if (![msg isNull]&&[msg isKindOfClass:[NSString class]]) {
                if ([msg isEqualToString:@"没有权限"]) {
                    BOOL hasLogin = [PZParamTool hasLogin] ;
                    if (!hasLogin) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin" object:nil];
                    }
                }
                else{
                    if ([message containsString:@"available"])return;
                    if ([message containsString:@"No"])return;
                    [MBProgressHUD showInfoWithStatus:msg];
                }
            }
            else if (message != nil)
            {
                //喜腾币不够
                if ([message isEqualToString:@"钻石账户不足"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"BuyDiamond" object:@"去购买钻石"];
                }
                else if ([message containsString:@"喜腾币"]){
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ExchangeXT" object:@"去兑换喜腾币"];
                }else if ([message containsString:@"用户不存在"]){
                    [MBProgressHUD showInfoWithStatus:message];
                }
                else{
                    if ([message containsString:@"no"])return;
                    if ([message containsString:@"测算次数"])return;
                    [MBProgressHUD showInfoWithStatus:message];
                }
            }
            else{
                [MBProgressHUD showInfoWithStatus:@"服务器繁忙！"];
            }
        }
        else{
            NSString* desc = error.userInfo[@"NSLocalizedDescription"];
            if (![desc isNull]) {
//                [MBProgressHUD showInfoWithStatus:@"网络不给力啦"];
            }
        }
    }
}
// 将JSON串转化为字典或者数组
+ (id)toArrayOrNSDictionary:(NSData *)jsonData{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}
+(void)getMd5KeyWithUserName:(NSString*)userName successBlock:(PZRequestSuccess)success  fail:(PZRequestFailure)failBlock
{
    NSString* loginType = userName.length > 11 ? @"weixin" : @"phonenum" ;
    NSDictionary* accessInfo = @{
                                 @"phone_num":userName,
                                 @"app_key":AppKey,
                                 @"loginType":loginType,
                                 @"access_token":@"",
                                 @"signature":[PZMMD5 digest:AppSecret]
                                 };
    NSDictionary *params = @{
                             @"accessInfo":accessInfo
                             };
    [PZHttpTool postRequestUrl:@"userMD5" parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        [MBProgressHUD dismiss];
        failBlock(json);
    }];
}
// 文件上传
+ (void)postRequestWithUploadFile:(NSString *)url fileName:(NSString*)fileName imageData:(NSArray *)imageDatas parmas:(NSDictionary*)p successBlock:(PZRequestSuccess)succcessBlock{
    NSDictionary* accessInfo = @{
                                 @"app_key":AppKey,
                                 @"access_token":@"",
                                 @"signature":[PZMMD5 digest:AppSecret]
                                 };
    NSString* fullPath = [NSString stringWithFormat:@"%@%@",ImageUrl,url];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:fullPath parameters:accessInfo constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSData* d in imageDatas) {
            NSString* imageType = [NSString typeForImageData:d];
            NSString* nameString = [NSString stringWithFormat:@"%d.jpg",arc4random_uniform(10000)];            [formData appendPartWithFileData:d name:fileName fileName:nameString mimeType:imageType];
        }
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    MBProgressHUD* progressHUD = [MBProgressHUD show] ;
    progressHUD.mode = MBProgressHUDModeAnnularDeterminate ;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      progressHUD.progressObject = uploadProgress;
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          [MBProgressHUD showInfoWithStatus:@"上传失败！"];
                      } else {
                          succcessBlock(responseObject);
                          [progressHUD hideAnimated:YES];
                      }
                  }];
    
    [uploadTask resume];
}
@end
