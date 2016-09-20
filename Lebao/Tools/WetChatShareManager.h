//
//  WetChatShareManager.h
//  Lebao
//
//  Created by David on 16/3/18.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DWOptionView.h"

@interface WetChatShareManager : NSObject
//单例
+ (instancetype)shareInstance;
//分享图片
- (void)shareImageToWXApp:(UIImage *)image;

//微信分享
- (void)shareToWeixinApp:(NSString *)title desc:(NSString *)desc  image:(UIImage *)image shareID:(NSString *)str isWxShareSucceedShouldNotice:(BOOL)isWxShareSucceedShouldNotice isAuthen:(BOOL)isAuthen;

//本地分享
- (void)showLocalShareView:(NSArray *)arrays otherParamer:(NSArray *)Paramer title:(NSString *)title desc:(NSString *)desc  image:(UIImage *)image shareID:(NSString *)str isWxShareSucceedShouldNotice:(BOOL)isWxShareSucceedShouldNotice isAuthen:(BOOL)isAuthen;

//动态分享
- (void)dynamicShareTo:(NSString *)title desc:(NSString *)desc image:(UIImage *)image shareurl:(NSString *)url;
//分享到微信
@property(nonatomic,assign)BOOL isWxShareSucceedShouldNotice;
@property(nonatomic,strong)NSString *Id;
@property(nonatomic,strong)NSString *uid;
@property(nonatomic,strong)NSString *openId;
@property(nonatomic,strong)NSString *unionid;
@property(nonatomic,assign) BOOL isLocalShare;

@end
