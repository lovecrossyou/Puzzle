//
//  NotificateMsgUtil.m
//  Puzzle
//
//  Created by huipay on 2016/10/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "NotificateMsgUtil.h"
#import "NotificateMsgModel.h"
#import "RRFMessageNoticeListModel.h"

@implementation NotificateMsgUtil
+(void)saveMsg:(id)msg type:(int)type{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    NotificateMsgModel* msgModel = [[NotificateMsgModel alloc]initWithValue:@{@"content":msg,@"type":@(type),@"read":@(0)}];
    [realm addObject:msgModel];
    [realm commitWriteTransaction];
}

+(NSArray *)loadCircleAll{
    NSMutableArray* messges = [NSMutableArray array];
    NSString* sql = [NSString stringWithFormat:@"type >=21"];
    RLMResults<NotificateMsgModel*> *results = [NotificateMsgModel objectsWhere:sql];
    for (NotificateMsgModel* m in results) {
        NSDictionary* d = [self dictionaryWithJsonString:m.content];
        RRFMessageNoticeListModel* model = [RRFMessageNoticeListModel yy_modelWithJSON:d];
        model.type = [m.type intValue];
        [messges insertObject:model atIndex:0];
    }
    return messges;
}

+(NSArray *)loadCircleVerifyUnRead{
    NSMutableArray* messges = [NSMutableArray array];
    NSString* sql = [NSString stringWithFormat:@"type == 21 or type ==22"];
    RLMResults<NotificateMsgModel*> *results = [NotificateMsgModel objectsWhere:sql];
    for (NotificateMsgModel* m in results) {
        NSDictionary* d = [self dictionaryWithJsonString:m.content];
        RRFMessageNoticeListModel* model = [RRFMessageNoticeListModel yy_modelWithJSON:d];
        model.type = [m.type intValue];
        [messges insertObject:model atIndex:0];
    }
    return messges;
}

+(NSArray *)loadCircleAll:(BOOL)unread{
    NSMutableArray* messges = [NSMutableArray array];
    NSString* sql = [NSString stringWithFormat:@"type >= 21"];
    if (unread) {
        sql = [NSString stringWithFormat:@"read==0 and type >= 21"];
    }
    RLMResults<NotificateMsgModel*> *results = [NotificateMsgModel objectsWhere:sql];
    for (NotificateMsgModel* m in results) {
        NSDictionary* d = [self dictionaryWithJsonString:m.content];
        RRFMessageNoticeListModel* model = [RRFMessageNoticeListModel yy_modelWithJSON:d];
        model.type = [m.type intValue];
        [messges insertObject:model atIndex:0];
    }
    return messges;
}

+(NSArray *)loadMsgUnRead{
    NSMutableArray* messges = [NSMutableArray array];
    NSString* sql = [NSString stringWithFormat:@"read == 0 and type <21"];
    RLMResults<NotificateMsgModel*> *results = [NotificateMsgModel objectsWhere:sql];
    for (NotificateMsgModel* m in results) {
        NSDictionary* d = [self dictionaryWithJsonString:m.content];
            RRFMessageNoticeListModel* model = [RRFMessageNoticeListModel yy_modelWithJSON:d];
            model.type = [m.type intValue];
            [messges insertObject:model atIndex:0];
    }
    return messges;
}


+(NSArray *)loadAllMsg{
    NSMutableArray* messges = [NSMutableArray array];
    NSString* sql = [NSString stringWithFormat:@"type <21"];
    RLMResults<NotificateMsgModel*> *results = [NotificateMsgModel objectsWhere:sql];
    for (NotificateMsgModel* m in results) {
        NSDictionary* d = [self dictionaryWithJsonString:m.content];
        RRFMessageNoticeListModel* model = [RRFMessageNoticeListModel yy_modelWithJSON:d];
        model.type = [m.type intValue];
        [messges insertObject:model atIndex:0];
    }
    return messges;
}

+(void)updateMsg:(NotificateMsgModel*)msg{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    msg.read = @(1);
    [realm commitWriteTransaction];
}

+(NSUInteger)unReadMsgCount{
    return  [[self loadMsgUnRead] count];
}

+(void)setAllCicleUnread{
    NSString* sql = [NSString stringWithFormat:@"type >=21"];
    RLMResults<NotificateMsgModel*> *results = [NotificateMsgModel objectsWhere:sql];
    for (NotificateMsgModel* m in results) {
        NSInteger type = [m.type intValue];
        if (type != 21 && type!=22) {
            [self updateMsg:m];
        }
    }
}


+(void)clearAllSLData
{
    NSString* sql = [NSString stringWithFormat:@"type <21"];
    RLMResults<NotificateMsgModel*> *results = [NotificateMsgModel objectsWhere:sql];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObjects:results];
    [realm commitWriteTransaction];
}

+(void)clearAllCircleData{
    NSString* sql = [NSString stringWithFormat:@"type >=21"];
    RLMResults<NotificateMsgModel*> *results = [NotificateMsgModel objectsWhere:sql];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObjects:results];
    [realm commitWriteTransaction];
}

#pragma mark - 沙龙未读
+(void)setAllUnread{
    RLMResults<NotificateMsgModel*> *results = [NotificateMsgModel allObjects];
    for (NotificateMsgModel* m in results) {
        [self updateMsg:m];
    }
}


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return @{};
    }
    return dic;
}

//清除验证朋友数据
+(void)clearVerifyFriendData{
    NSString* sql = [NSString stringWithFormat:@"type ==21"];
    RLMResults<NotificateMsgModel*> *results = [NotificateMsgModel objectsWhere:sql];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    for (NotificateMsgModel* m in results) {
        [realm deleteObject:m];
    }
    
    sql = [NSString stringWithFormat:@"type ==22"];
    results = [NotificateMsgModel objectsWhere:sql];
    for (NotificateMsgModel* m in results) {
        [realm deleteObject:m];
    }
    [realm commitWriteTransaction];
}
@end
