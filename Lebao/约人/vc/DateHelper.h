//
//  DateHelper.h
//  YaJu
//
//  Created by qianfeng on 16/3/23.
//  Copyright © 2016年 fny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject

/**
 *  计算当前时间与指定时间的时间差
 *
 *  @param expireDatetime 指定时间
 *
 *  @return 计算好的时间差字符串格式为 时:分:秒
 */
+ (NSDateComponents *)calculatorExpireDatetimeWithData:(NSDate *)expireDatetime;

@end
