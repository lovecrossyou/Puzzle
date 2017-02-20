//
//  NSString+TimeConvert.m
//  HuiBeiWaterMerchant
//
//  Created by huibei on 16/5/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "NSString+TimeConvert.h"

@implementation NSString (TimeConvert)
-(NSString *)timestamp2Normal{
    NSTimeInterval time = (self.doubleValue + 28000)/1000 ;
    NSDate* detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss" ;
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    return [dateFormatter stringFromDate:detaildate] ;
}

-(NSString *)localized60Time{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm:ss" ;
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    NSDate* d = [[dateFormatter dateFromString:self] dateByAddingTimeInterval:60*60*8];
    NSDate* now = [[NSDate date] dateByAddingTimeInterval:60*60*8];
    NSTimeInterval delta = [now timeIntervalSinceDate:d];
    
    if (delta <60 ) {
        return @"刚刚" ;
    }
    else if (delta<60*60){
        return @"刚刚" ;
    }
    else if (delta<60*60*24){
        return [NSString stringWithFormat:@"%.0f小时前",delta/60/60];
    }
    else if (60*60.0*24< delta <60*60.0*48){
        NSRange range = NSMakeRange(self.length - 8,5);
        NSString* shortTime = [self substringWithRange:range];
        return [NSString stringWithFormat:@"昨天%@",shortTime];
    }
    return self ;
}


-(NSString *)localizedTime{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm:ss" ;
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    NSDate* d = [[dateFormatter dateFromString:self] dateByAddingTimeInterval:60*60*8];
    NSDate* now = [[NSDate date] dateByAddingTimeInterval:60*60*8];
    NSTimeInterval delta = [now timeIntervalSinceDate:d];
    
    
    //天数
    NSInteger days = delta/60/60/24 ;
    if (delta <60 ) {
        return @"刚刚" ;
    }
    else if (delta<60*60){
        return [NSString stringWithFormat:@"%.0f分钟前",delta/60];
    }
    else if (delta<60*60*24){
        return [NSString stringWithFormat:@"%.0f小时前",delta/60/60];
    }
    else if (days < 2){
        NSRange range = NSMakeRange(self.length - 8,8);
        NSString* shortTime = [self substringWithRange:range];
        return [NSString stringWithFormat:@"昨天%@",shortTime];
    }
    return self ;
}

//waiting(0, "等待开奖"),
//lose(1, "未中奖"),
//win(2, "已中奖"),
//accept(3, "已领奖"),
//send(4, "已发货"),
//finish(5, "已签收"),
//evaluate(6, "已晒单");
-(BOOL)isLuck
{
    if ([self isEqualToString:@"miss"]) {
        return NO;
    }else{
        return YES;
    }
  
}
-(BOOL)hiddenLuck
{
    if ([self isEqualToString:@"waiting"]) {
        return YES;
    }else{
        return NO;
    }

}
//waiting(0, "等待开奖"),
//miss(1, "未中奖"),
//win(2, "已中奖"),
//evaluate(4, "已晒单"),
//waitEvaluate(7, "待晒单");
-(NSString *)bidOrderStatusOperationBtnStr
{
    if([self isEqualToString:@"waiting"]) {
        // 等待揭晓
        return @"等待揭晓";
    }else if([self isEqualToString:@"win" ]){
        // 已中奖
        return @"去领奖";
    }else if([self isEqualToString:@"evaluate" ]){
        // 已晒单
        return @"查看晒单";
    }else if([self isEqualToString:@"miss" ]){
        // 未中奖
        return @"再次参与";
    }else if([self isEqualToString:@"waitEvaluate" ]){
        
        return @"去晒单";
    }else{
        return @"为获取到";
    }
}
-(NSString *)operationBtnStr
{
    if([self isEqualToString:@"waiting"]) {
//        等待揭晓
        return @"等待揭晓";
    }else if([self isEqualToString:@"win" ]){
//        已中奖
        return @"去领奖";
    }else if([self isEqualToString:@"accept" ]||[self isEqualToString:@"send"]||[self isEqualToString:@"finish" ]){
//        已签收 || 已领奖 || 已发货
        return @"去晒单";
    }else if([self isEqualToString:@"miss" ] ||[self isEqualToString:@"evaluate" ]){
//        未中奖 || 已晒单
        return @"查看晒单";
    }else{
        return @"未获取到";
    }
}
-(NSString *)orderState
{
    if ([self isEqualToString:@"0"]) {
        return @"提醒发货";
    }else if ([self isEqualToString:@"1"]) {
        return @"签收";
    }else if([self isEqualToString:@"2" ]){
        return @"去晒单";
    }else if([self isEqualToString:@"3" ]){
        return @"查看晒单";
    }else{
        return @"";
    }
}

-(NSString *)clientOrderState
{
    if ([self isEqualToString:@"4"] || [self isEqualToString:@"1"]) {
        return @"待付款";
    }else if([self isEqualToString:@"2" ]){
        return @"待收货";
    }else if([self isEqualToString:@"3" ]){
        return @"待评价";
    }else{
        return @"已完成";
    }
}

-(NSString *)winingOrderListCellOpentionStatus
{
    if ([self isEqualToString:@"create"]) {
        return @"去领奖";
    }else if([self isEqualToString:@"acceptPrize" ]){
        return @"签收";
    }else if([self isEqualToString:@"send" ]){
        return @"签收";
    }else if([self isEqualToString:@"finish" ]){
        return @"去晒单";
    }else{
        return @"查看晒单";
    }
}
-(NSString *)payWay
{
    if ([self isEqualToString:@"13"] || [self isEqualToString:@"WeixinPay"] ) {
        return @"微信支付";
    }else if([self isEqualToString:@"10"]){
        return @"支付宝支付";
    }else if([self isEqualToString:@"4" ]){
        return @"银联支付";
    }else{
        return @"";
    }
}

-(NSString *)resultPayWay
{
    if ([self isEqualToString:@"13"] ) {
        return @"微信支付";
    }else if([self isEqualToString:@"4"]){
        return @"支付宝支付";
    }else if([self isEqualToString:@"10" ]){
        return @"银联支付";
    }else{
        return @"";
    }
}



@end
