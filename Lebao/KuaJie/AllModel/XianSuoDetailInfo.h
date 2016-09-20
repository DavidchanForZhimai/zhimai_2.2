//
//  XianSuoDetailInfo.h
//  KuaJie
//
//  Created by 严文斌 on 16/5/26.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^xianSuoDetailCallbackType1)(BOOL issucced, NSString* info, NSArray* jsonArr);
typedef void (^xianSuoDetailCallbackType2)(BOOL issucced, NSString* info, NSDictionary* jsonDic);
@interface XianSuoDetailInfo : NSObject
+ (XianSuoDetailInfo*) shareInstance;
//获取线索详情
-(void)getDetailXianSuoWithID:(NSString *)xs_id andCallBack:(xianSuoDetailCallbackType2)callBack;
//获取可用余额
-(void)getAmountWith:(xianSuoDetailCallbackType2)callBack;
//发布跨界
-(void)faBuKuaJieWithTitle:(NSString *)title andContent:(NSString *)content andIndustry:(NSString *)industry andCost:(NSString *)cost andPaytype:(NSString *)paytype audiosUrl:(NSString *)audiosUrl andCallBack:(xianSuoDetailCallbackType2)callBack;
//线索领取
-(void)lqxsWithID:(NSString *)xiansuoID andRadio:(NSString *)radio andDeposit:(NSString *)deposit andPaytype:(NSString *)paytype andCallBack:(xianSuoDetailCallbackType2)callback;
//支付尾款
-(void)zfwkWithID:(NSString *)xiansuoID andFee:(NSString *)fee andPaytype:(NSString *)paytype andCallBack:(xianSuoDetailCallbackType2)callback;
//线索举报
-(void)xsjbWithID:(NSString *)xiansuoID andTitle:(NSString *)title andType:(NSString *)type andAuthorID:(NSString *)authorID andCallBack:(xianSuoDetailCallbackType2)callback;
@end
