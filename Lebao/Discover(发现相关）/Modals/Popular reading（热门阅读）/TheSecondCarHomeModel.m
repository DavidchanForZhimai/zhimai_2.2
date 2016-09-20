//
//  TheSecondCarHomeModel.m
//  Lebao
//
//  Created by David on 16/4/15.
//  Copyright © 2016年 David. All rights reserved.
//

#import "TheSecondCarHomeModel.h"

@implementation TheSecondCarHomeModel

@end


@implementation TheSecondCarDatas

+ (NSDictionary *)objectClassInArray{
    return @{@"carpics" : [TheSecondCarCarpics class]};
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"des" : @"description",
             };
}
@end


@implementation TheSecondCarCarpics

@end


