//
//  ProvinceModel.h
//  GWLCustomPiker
//
//  Created by 高万里 on 15/6/26.
//  Copyright (c) 2015年 高万里. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProvinceModel : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *citys;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)provinceModelWithDict:(NSDictionary *)dict;

@end
