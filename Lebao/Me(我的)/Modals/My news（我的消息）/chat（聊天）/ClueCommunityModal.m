//
//  ClueCommunityModal.m
//  Lebao
//
//  Created by David on 16/5/23.
//  Copyright © 2016年 David. All rights reserved.
//

#import "ClueCommunityModal.h"

@implementation ClueCommunityModal
+ (NSDictionary *)mj_objectClassInArray
{
    
    return @{
             @"datas":@"ClueCommunityData",
             };
    
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}
@end

@implementation ClueCommunityData

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}

@end