//
//  DiscoverModel.m
//  Lebao
//
//  Created by David on 16/1/6.
//  Copyright © 2016年 David. All rights reserved.
//

#import "DiscoverModel.h"

@implementation DiscoverModel
+ (NSDictionary *)mj_objectClassInArray
{
    
    return @{
             @"datas":@"DiscoverDataModel",
              @"upimg":@"DiscoverImageDataModel",
             };
    
}
@end
@implementation DiscoverDataModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}

@end

@implementation DiscoverImageDataModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}

@end