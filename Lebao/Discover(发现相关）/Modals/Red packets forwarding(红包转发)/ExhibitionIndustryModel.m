//
//  ExhibitionIndustryModel.m
//  Lebao
//
//  Created by David on 15/12/3.
//  Copyright © 2015年 David. All rights reserved.
//

#import "ExhibitionIndustryModel.h"

@implementation ExhibitionIndustryModel


+ (NSDictionary *)mj_objectClassInArray
{
    
    return @{
             @"rewarddatas":@"ExhibitionIndustryRewarddatas",
             @"readmost":@"ExhibitionIndustryReadmost",
             };
    
}
@end


@implementation ExhibitionIndustryUserinfo
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}
@end


@implementation ExhibitionIndustryRewarddatas
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}
@end


@implementation ExhibitionIndustryReadmost
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
};
}
@end





