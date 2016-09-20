//
//  CommunityModal.m
//  Lebao
//
//  Created by David on 15/12/28.
//  Copyright © 2015年 David. All rights reserved.
//

#import "CommunityModal.h"

@implementation CommunityModal
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}
+ (NSDictionary *)mj_objectClassInArray
{
    
    return @{
             @"datas":@"CommunityDataModal",
             };
    
}
@end

@implementation CommunityDataModal


@end