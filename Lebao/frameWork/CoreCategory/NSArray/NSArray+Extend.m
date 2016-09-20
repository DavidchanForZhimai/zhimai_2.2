//
//  NSArray+Extend.m
//  Wifi
//
//  Created by muxi on 14/11/27.
//  Copyright (c) 2014年 muxi. All rights reserved.
//

#import "NSArray+Extend.h"

@implementation NSArray (Extend)



#pragma mark  数组转字符串
-(NSString *)string{
    
    if(self==nil || self.count==0) return @"";
    
    NSMutableString *str=[NSMutableString string];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [str appendFormat:@"%@,",obj];
    }];
    
    //删除最后一个','
    NSString *strForRight = [str substringWithRange:NSMakeRange(0, str.length-1)];
    
    return strForRight;
}





#pragma mark  数组比较
-(BOOL)compareIgnoreObjectOrderWithArray:(NSArray *)array{
    
    NSSet *set1=[NSSet setWithArray:self];
    
    NSSet *set2=[NSSet setWithArray:array];
    
    return [set1 isEqualToSet:set2];
}
-(NSString *)maxWithArray
{
    NSString *max = self[0];
    for (NSString *str in self) {
       
        if ([max intValue]<[str intValue]) {
            max = str;
        }
    }
    return max;
}
-(NSString *)minWithArray
{
    NSString *mix = self[0];
    for (NSString *str in self) {
        
        if ([mix intValue]>[str intValue]) {
            mix = str;
        }
    }
    return mix;

    
}

/**
 *  数组计算交集
 */
-(NSArray *)arrayForIntersectionWithOtherArray:(NSArray *)otherArray{
    
    NSMutableArray *intersectionArray=[NSMutableArray array];
    
    if(self.count==0) return nil;
    if(otherArray==nil) return nil;
    
    //遍历
    for (id obj in self) {
        
        if(![otherArray containsObject:obj]) continue;
        
        //添加
        [intersectionArray addObject:obj];
    }
    
    return intersectionArray;
}



/**
 *  数据计算差集
 */
-(NSArray *)arrayForMinusWithOtherArray:(NSArray *)otherArray{
    
    if(self==nil) return nil;
    
    if(otherArray==nil) return self;
    
    NSMutableArray *minusArray=[NSMutableArray arrayWithArray:self];
    
    //遍历
    for (id obj in otherArray) {
        
        if(![self containsObject:obj]) continue;
        
        //添加
        [minusArray removeObject:obj];
        
    }
    
    return minusArray;
}
- (NSMutableDictionary *)dictWithDiffrentArray:(NSArray *)otherArray
{
    NSMutableDictionary *dicArray = allocAndInit(NSMutableDictionary);
    
    for (NSDictionary *dic in otherArray) {
        
        if ([dicArray objectForKey:dic[@"letter"]]) {
            NSMutableArray *array = [dicArray objectForKey:dic[@"letter"]];
            NSMutableDictionary *cityname = allocAndInit(NSMutableDictionary);
            [cityname setValue:dic[@"id"] forKey:@"id"];
             [cityname setValue:dic[@"area"] forKey:@"area"];
            [array addObject:cityname];
             [dicArray setValue:array forKey:dic[@"letter"]];
        }
        else
        {
            NSMutableArray *array = allocAndInit(NSMutableArray);
            
            NSMutableDictionary *cityname = allocAndInit(NSMutableDictionary);
            [cityname setValue:dic[@"id"] forKey:@"id"];
            [cityname setValue:dic[@"area"] forKey:@"area"];
            [array addObject:cityname];
            
            [dicArray setValue:array forKey:dic[@"letter"]];
        }
        
    }
    
    return dicArray;
}

@end
