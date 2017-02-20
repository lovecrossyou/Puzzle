
//
//  PZDateUtil.m
//  Puzzle
//
//  Created by huipay on 2016/9/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZDateUtil.h"

@implementation PZDateUtil
//转换为 月-日 -周
+(NSString*)dateToMDW:(NSDate*)d{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM月dd日"];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitWeekday |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:d];
    NSInteger week = [comps weekday];
    return [NSString stringWithFormat:@"%@(%@)",[formatter stringFromDate:d],[self week:week]] ;
}

+(NSString*)dateRemain:(NSString*)startTime endTime:(NSDate*)endTime{
    if (startTime == nil) return @"--:--:--";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date1 = [formatter dateFromString:startTime];
    NSTimeInterval aTimer = [endTime timeIntervalSinceDate:date1];
    
    int hour = (int)(aTimer/3600);
    int minute = (int)(aTimer - hour*3600)/60;
    int second = aTimer - hour*3600 - minute*60;
    NSString *dural = [NSString stringWithFormat:@"%d时%d分%d秒", abs(hour), abs(minute),abs(second)];
    return dural ;
}

//millisecond
+(NSString *)intervalSinceNowMillisecond: (NSString *) theDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d = [formatter dateFromString:theDate];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate date];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    
    NSTimeInterval aTimer=late-now;
    if (aTimer <= 0) {
        return @"已开奖" ;
    }
    int day = (int)(aTimer/(3600*24));
    int hour = (int)(aTimer/3600);
    int minute = (int)(aTimer - hour*3600)/60;
    int second = aTimer - hour*3600 - minute*60;
    int millisec= aTimer*1000-(60*60*1000*hour)-(60*1000*minute)-(second*1000);
    if (day > 0) {
        NSString *dural = [NSString stringWithFormat:@"%d天%d时%d分%d秒",day, hour, minute,second];
        return dural ;
    }
    else if(hour > 0){
        NSString *dural = [NSString stringWithFormat:@"%d时%d分%d秒%d", hour, minute,second,millisec/10];
        return dural ;
    }
    else if(minute > 0){
        NSString *dural = [NSString stringWithFormat:@"%d:%d:%d", minute,second,millisec/10];
        return dural ;
    }
    else if (second > 0){
        NSString *dural = [NSString stringWithFormat:@"00:%d:%d",second,millisec/10];
        return dural ;
    }
    else if (millisec > 0){
        NSString *dural = [NSString stringWithFormat:@"00:00:%d",millisec/10];
        return dural ;
    }
    return @"已开奖" ;
}


+(NSString *)intervalSinceNow: (NSString *) theDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d = [formatter dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate date];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    
    NSTimeInterval aTimer=late-now;
    if (aTimer <= 0) {
        return @"已结束" ;
    }
    int day = (int)(aTimer/(3600*24));
    if (day > 0) {
        int hour = (int)(aTimer - day*3600*24)/3600;
        int minute = (int)(aTimer - hour*3600 - day*3600*24)/60;
        int second = aTimer - hour*3600 - minute*60 - day*3600*24;
        NSString *dural = [NSString stringWithFormat:@"%d天%d时%d分%d秒",day, hour, minute,second];
        return dural ;
    }
    else{
        int hour = (int)(aTimer/3600);
        int minute = (int)(aTimer - hour*3600)/60;
        int second = aTimer - hour*3600 - minute*60;
        NSString *dural = [NSString stringWithFormat:@"%d时%d分%d秒", hour, minute,second];
        return dural ;
    }
    return @"" ;
}




+(NSString*)week:(NSInteger)week
{
    NSString*weekStr=nil;
    if(week==1)
    {
        weekStr=@"周日";
    }else if(week==2){
        weekStr=@"周一";
        
    }else if(week==3){
        weekStr=@"周二";
        
    }else if(week==4){
        weekStr=@"周三";
        
    }else if(week==5){
        weekStr=@"周四";
        
    }else if(week==6){
        weekStr=@"周五";
        
    }else if(week==7){
        weekStr=@"周六";
        
    }
    return weekStr;
}


#pragma mark - 时间处理
+(NSString*)getLocalDate:(NSString*)time{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YY-MM-dd HH:mm:ss"];
    NSDate *date = [[formatter dateFromString:time] dateByAddingTimeInterval:8*60*60];
    [formatter setDateFormat:@"MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}
@end
