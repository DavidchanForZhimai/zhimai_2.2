//
//  HomeInfo.h
//  KuaJie
//
//  Created by 严文斌 on 16/5/26.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^HomePageCallbackType1)(BOOL issucced, NSString* info, NSArray* jsonArr);
typedef void (^HomePageCallbackType2)(BOOL issucced, NSString* info, NSDictionary* jsonDic);

@interface HomeInfo : NSObject
+ (HomeInfo*) shareInstance;
//跨界线索列表
-(void)getHomePageXianSuo:(int)pageNub andCityID:(int)cityID andhangye:(NSString *)hangye andCallBack:(HomePageCallbackType1)callback;
//跨界经纪人列表
-(void)getHomePageJJR:(int)pageNub andCityID:(int)cityID  andhangye:(NSString *)hangye andcallBack:(HomePageCallbackType1)callback;
//动态列表
-(void)getHomePageDT:(int)pageNub brokerid:(NSString *)brokerid andcallBack:(HomePageCallbackType2)callback;

//动态详情
-(void)getHomePageDTdetailID:(NSString *)ID andcallBack:(HomePageCallbackType2)callback;

//点赞与取消点赞
-(void)dynamicIsLike:(NSString *)ID  islike:(BOOL)islike andcallBack:(HomePageCallbackType2)callback;
//发布、保存动态
-(void)adddynamic:(NSString *)content imgs:(NSString *)imgs andcallBack:(HomePageCallbackType2)callback;

//删除动态
-(void)deleteDynamic:(NSString *)ID  andcallBack:(HomePageCallbackType2)callback;
//删除动态评论
-(void)deleteDynamicComment:(NSString *)ID  andcallBack:(HomePageCallbackType2)callback;
//评论与回复
-(void)addDynamicComment:(NSString *)ID   replayid:(NSString *)replayid type:(NSString *)type content:(NSString *)content andcallBack:(HomePageCallbackType2)callback;


//添加或取消关注
-(void)guanzhuTargetID:(NSInteger)targetID andIsFollow:(int)isfl andcallBack:(HomePageCallbackType2)callback;
@end
