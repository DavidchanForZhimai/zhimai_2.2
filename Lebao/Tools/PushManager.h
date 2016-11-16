//
//  PushManager.h
//  Lebao
//
//  Created by David on 2016/11/15.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>

//推送类型
typedef NS_ENUM(NSInteger,ApplicationState) {
    
    ApplicationStateActive, //应用在前台，不跳转页面，让用户选择。
    ApplicationStateInactive,//杀死状态下，直接跳转到跳转页面。
    ApplicationStateBackground  //杀死状态下，直接跳转到跳转页面。
    
};
/**
 推送管理类
 */
@interface PushManager : NSObject

@property(assign)int firstPageBageCount;
@property(assign)int secondPageBageCount;
@property(assign)int thridPageBageCount;
@property(assign)int fourPageBageCount;

//单例模式
+ (PushManager *)shareInstace;

//推送数据
- (void)pushData:(NSDictionary *)notifacion andApplicationState:(ApplicationState)applicationState;

@end
