//
//  MyKuaJieInfo.h
//  KuaJie
//
//  Created by 严文斌 on 16/5/27.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^MyKuaJieCallbackType1)(BOOL issucced, NSString* info, NSArray* jsonArr);
typedef void (^MyKuaJieCallbackType2)(BOOL issucced, NSString* info, NSDictionary* jsonDic);
@interface MyKuaJieInfo : NSObject
+ (MyKuaJieInfo*) shareInstance;
//获取发布线索详情
-(void)getFaBuDetailXianSuoWithID:(NSString *)xs_id andCallBack:(MyKuaJieCallbackType2)callBack;
//获取领取线索详情
-(void)getLinQuDetailXianSuoWithID:(NSString *)xs_id andCallBack:(MyKuaJieCallbackType2)callBack;
//我的发布线索列表
-(void)faBuLieBiaoWithPage:(int)pageNub andCallBack:(MyKuaJieCallbackType1)callback;
//我的领取线索列表
-(void)lingQuLieBiaoWithPage:(int)pageNub andCallBack:(MyKuaJieCallbackType1)callback;
//取消领取
-(void)quxiaolquWithID:(NSString *)xiansuoID andCallBack:(MyKuaJieCallbackType2)callBack;
//选择合作
-(void)xuanzeHeZuoWithID:(NSString *)hezuoID andCallBack:(MyKuaJieCallbackType2)callBack;

//领取人满意评价
-(void)pingJiaWithID:(NSString *)coopid andScord:(int)scord andContent:(NSString *)content andType:(int)type andCallBack:(MyKuaJieCallbackType2)callBack;
//发布人申诉
-(void)shensuWithID:(NSString *)coopid andContent:(NSString *)content andCallBack:(MyKuaJieCallbackType2)callBak;
//不申诉
-(void)buShensuWithID:(NSString *)coopid  andCallBack:(MyKuaJieCallbackType2)callBak;
//获取领取人列表
-(void)getLQRWithID:(NSString *)xsID andPage:(int)page andCallBack:(MyKuaJieCallbackType1)callback;
//关注列表
-(void)getGuanZhuLieBiaoWithPage:(int)page andCallBack:(MyKuaJieCallbackType1)callback;
//粉丝列表
-(void)getFansLieBiaoWithPage:(int)page andCallBack:(MyKuaJieCallbackType1)callback;
//通知他
-(void)getNotificationAtOtherWithId:(NSString *)userid  andDemandid:(NSString *)demandid andCallBack:(MyKuaJieCallbackType2)callback;
@end
