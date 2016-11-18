//
//  PushManager.h
//  Lebao
//
//  Created by David on 2016/11/15.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
  推送数据模型类
*/
@class PushDataApi,PushDataAps,PushDataChat;
@interface PushDataModel : NSObject

@property(nonatomic,strong) PushDataApi *api;
@property(nonatomic,strong) PushDataAps *aps;
@end

@interface PushDataApi : NSObject
@property(nonatomic,copy) NSString *bid;
@property(nonatomic,copy) NSString *type;
@property(nonatomic,strong) PushDataChat *chat;
@end

@interface PushDataChat : NSObject
@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *realname;
@property(nonatomic,copy) NSString *sex;
@property(nonatomic,copy) NSString *imgurl;
@property(nonatomic,copy) NSString *position;
@property(nonatomic,copy) NSString *workyears;
@property(nonatomic,copy) NSString *address;
@property(nonatomic,copy) NSString *authen;
@property(nonatomic,copy) NSString *vip;
@property(nonatomic,copy) NSString *userid;
@property(nonatomic,copy) NSString *content;

//约见成功
@property(nonatomic,copy) NSString *invited_imgurl;
@property(nonatomic,copy) NSString *invited_realname;
@property(nonatomic,copy) NSString *beinvited_imgurl;
@property(nonatomic,copy) NSString *beinvited_realname;
@property(nonatomic,copy) NSString *beinvited_id;
@property(nonatomic,copy) NSString *beinivted_tel;
//聊天

//动态
@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *dynamicid;
@property(nonatomic,copy) NSString *createtime;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *title_img;
//动态点赞

//动态评论
@property(nonatomic,copy) NSString *rep_realname;//被回复人姓名
@property(nonatomic,copy) NSString *rep_brokerid;//被回复人id
//约见
@property(nonatomic,copy) NSString *remark;
@property(nonatomic,copy) NSString *reward;
@property(nonatomic,copy) NSString *audio;
@property(nonatomic,copy) NSString *distance;
@property(nonatomic,copy) NSString *create_at;

//约见请求
@property(nonatomic,copy) NSString *invited_id;
@property(nonatomic,copy) NSString *invited_userid;


//约见拒绝
@property(nonatomic,copy) NSString *invitation_id;
@property(nonatomic,copy) NSString *beinvited_sex;

//人脉添加
@property(nonatomic,copy) NSString *document_id;
@property(nonatomic,copy) NSString *service;
@property(nonatomic,copy) NSString *resource;


//人脉拒绝


//认证
@property(nonatomic,copy) NSString *tel;
@property(nonatomic,copy) NSString *cardpic;
//认证驳回

//认证通过
@end



@interface PushDataAps : NSObject
@property(nonatomic,copy) NSString *alert;
@end

//推送类型
typedef NS_ENUM(NSInteger,ApplicationState) {
    
    
   
    ApplicationStateActive, //应用在前台，不跳转页面，让用户选择。
    ApplicationStateInactive,//杀死状态下，直接跳转到跳转页面。
    ApplicationStateBackground  //应用在后台。当后台设置aps字段里的
    
};

typedef void(^MsgCountSucceed)(int dynamicCount,int msgcount);
/**
 推送管理类
 */
@interface PushManager : NSObject<UIAlertViewDelegate>

//单例模式
+ (PushManager *)shareInstace;

//得到消息数（动态，消息）
- (void)getMsgCountSucceed:(MsgCountSucceed)succeed;

//推送数据
- (void)pushData:(NSDictionary *)notifacion andApplicationState:(ApplicationState)applicationState;

@end
