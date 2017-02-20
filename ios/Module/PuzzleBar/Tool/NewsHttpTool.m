//
//  NewsHttpTool.m
//  Puzzle
//
//  Created by huibei on 16/12/27.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "NewsHttpTool.h"
#import "PZParamTool.h"
#import "YYModel.h"
#import "PZAccessInfo.h"
#import "PZHttpTool.h"
#import "PZCache.h"
@implementation NewsHttpTool
+(void)postCommentWithId:(NSInteger)commentId content:(NSString*)content successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfoNotLogin];
    NSString* city = @"";
    NSString* county = @"" ;
    NSDictionary* addrInfo = [PZCache sharedInstance].addrInfo ;
    if (addrInfo != nil) {
        city = addrInfo[@"city"] ;
        county = addrInfo[@"county"] ;
    }
    else{
        city = @"火星用户";
    }
    NSString* phoneType = [PZCache sharedInstance].phoneType;
    NSString* area = [NSString stringWithFormat:@"%@%@ %@",city,county,phoneType];
    NSDictionary* params = @{
                             @"accessInfo":[accessInfo yy_modelToJSONObject],
                             @"newMessageId":@(commentId),
                             @"content":content,
                             @"commenterSource":area
                             };
    NSString* pathUrl = [NSString stringWithFormat:@"%@newmessage/addComment",Base_url];
    [PZHttpTool postRequestFullUrl:pathUrl parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

+(void)getNewsCommentListListWithPageNo:(int)no pageSize:(int)size commentId:(NSInteger)commentId successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfoNotLogin];
    NSDictionary* params = @{
                             @"accessInfo":[accessInfo yy_modelToJSONObject],
                             @"commentTypeId":@(commentId),
                             @"pageNo":@(no),
                             @"size":@(size),
                             @"commentType":@"newMessage"
                             };
    NSString* pathUrl = [NSString stringWithFormat:@"%@newmessage/commentList",Base_url];
    [PZHttpTool postRequestFullUrl:pathUrl parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

+(void)postCommentRespWithId:(NSInteger)commentId content:(NSString*)content successBlock:(PZRequestSuccess)success fail:(PZRequestFailure)failBlock{
    PZAccessInfo* accessInfo = [PZParamTool createAccessInfoNotLogin];
    NSString* phoneType = [PZCache sharedInstance].phoneType;
    NSDictionary* addrInfo = [PZCache sharedInstance].addrInfo ;
    NSString* city = addrInfo[@"city"] ;
    NSString* county = addrInfo[@"county"] ;
    NSString* area = [NSString stringWithFormat:@"%@%@ %@",city,county,phoneType];

    NSDictionary* params = @{
                             @"accessInfo":[accessInfo yy_modelToJSONObject],
                             @"commentId":@(commentId),
                             @"content":content,
                             @"commenterSource":area
                             };
    NSString* pathUrl = [NSString stringWithFormat:@"%@newmessage/addCommentResponse",Base_url];
    [PZHttpTool postRequestFullUrl:pathUrl parameters:params successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        failBlock(json);
    }];
}

@end
