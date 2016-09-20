//
//  MyContentModal.m
//  Lebao
//
//  Created by David on 16/2/17.
//  Copyright © 2016年 David. All rights reserved.
//

#import "MyContentModal.h"

@implementation MyContentModal

+ (NSDictionary *)mj_objectClassInArray
{
    
    return @{
             @"datas":@"MyContentDataModal",
             };
    
}

@end
@implementation MyContentDataModal
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}
@end
