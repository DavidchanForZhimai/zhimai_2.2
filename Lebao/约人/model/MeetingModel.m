//
//  MeetingModel.m
//  Lebao
//
//  Created by adnim on 16/8/26.
//  Copyright © 2016年 David. All rights reserved.
//

#import "MeetingModel.h"

@implementation MeetingModel
+ (NSDictionary *)objectClassInArray{
    return @{@"datas" : [MeetingData class]};
}
@end

@implementation MeetingData

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"meetId" : @"id",
             };
}


@end