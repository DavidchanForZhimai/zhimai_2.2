//
//  NSString+Extend.m
//  CoreCategory
//
//  Created by 成林 on 15/4/6.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import "NSString+Extend.h"

@implementation NSString (Extend)


/*
 *  时间戳对应的NSDate
 */
- (NSString *)timeformatString:(NSString *)formatString{
    
    
    NSTimeInterval timeInterval=[self floatValue];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formatString];
    NSString *dateString = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    return dateString;
}

- (NSDate *)date
{
      NSTimeInterval timeInterval=[self floatValue];
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}

- (NSString *)countdownFormTimeInterval
{                                     
    NSString *time;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self intValue]];
    NSDate *dateNow = [NSDate  date];
    int countdown = [date timeIntervalSinceDate:dateNow];
    
    if (countdown<0) {
        
        time = @"-1";
    }
    else
    {
       
        int fen;
        int shi;
        shi = countdown/3600;
        fen = (countdown%3600)/60;
        time = [NSString stringWithFormat:@"%.2i:%.2i",shi,fen];
    }
    return time;

}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
/** , 返回更新时间 */
- (NSString *)updateTime{
    // 获取当前时时间戳
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳
    NSTimeInterval createTime = self.floatValue;
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    if (time<0) {
        time =-time;
    }
    // 秒转秒钟
    NSInteger seconds = time;
    if (seconds<60) {
//        return [NSString stringWithFormat:@"%ld秒前",seconds];
        return @"刚刚";
    }
    // 秒转分钟
    NSInteger mins = time/60;
    if (mins<60) {
      return [NSString stringWithFormat:@"%ld分钟前",mins];
    }
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%ld小时前",hours];
    }
    //秒转天数
    NSInteger days = time/3600/24;
    if (days <= 3) {
        return [NSString stringWithFormat:@"%ld天前",days];
    }
    //转时间格式
    return [self timeformatString:@"yyyy-MM-dd"];
//    //秒转月
//    NSInteger months = time/3600/24/30;
//    if (months < 12) {
//        return [NSString stringWithFormat:@"%ld月前",months];
//    }
//    //秒转年
//    NSInteger years = time/3600/24/30/12;
//    return [NSString stringWithFormat:@"%ld年前",years];
}@end
