//
//  StatusModel.m
//  Lebao
//
//  Created by David on 16/8/1.
//  Copyright © 2016年 David. All rights reserved.
//

#import "StatusModel.h"

@implementation StatusModel


+ (NSDictionary *)objectClassInArray{
    return @{@"datas" : [StatusDatas class]};
}
@end
@implementation StatusDatas

+ (NSDictionary *)objectClassInArray{
    return @{@"pic" : [StatusPic class], @"comment" : [StatusComment class], @"like" : [StatusLike class]};
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",@"me" : @"self"
             };
}


@end


@implementation StatusPic

@end


@implementation StatusComment
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{ @"ID" : @"id",@"me" : @"self"
             };
}

@end


@implementation StatusInfo

@end


@implementation StatusLike

@end


