//
//  myCollectionModal.m
//  Lebao
//
//  Created by David on 16/2/16.
//  Copyright © 2016年 David. All rights reserved.
//

#import "myCollectionModal.h"

@implementation myCollectionModal
+ (NSDictionary *)mj_objectClassInArray
{
    
    return @{
             @"datas":@"myCollectionDataModal",
             };
    
}

@end
@implementation myCollectionDataModal
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}

@end