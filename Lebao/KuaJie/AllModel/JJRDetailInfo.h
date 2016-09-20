//
//  JJRDetailInfo.h
//  KuaJie
//
//  Created by 严文斌 on 16/5/26.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^JjrDetailCallbackType1)(BOOL issucced, NSString* info, NSArray* jsonArr);
typedef void (^JjrDetailCallbackType2)(BOOL issucced, NSString* info, NSDictionary* jsonDic);
@interface JJRDetailInfo : NSObject
+ (JJRDetailInfo*) shareInstance;
//按条件查找经纪人列表
-(void)lookForjjrWithType:(NSString *)type andPage:(int)pageNub andcityID:(int)city_ID andCallback:(JjrDetailCallbackType1)callback;
//经纪人详情
-(void)getJJRDetailWithJjrId:(NSString *)jjrID andCallBack:(JjrDetailCallbackType2)callback;
//经纪人服务列表
-(void)getMoreFuwuWithID:(NSString *)jjrid andPage:(int)page andCallBack:(JjrDetailCallbackType1)callback;
//经纪人线索列表
-(void)getMoreXianSuoWithID:(NSString *)jjrid andPage:(int)page andCallBack:(JjrDetailCallbackType1)callback;
@end
