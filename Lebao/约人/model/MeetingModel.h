//
//  MeetingModel.h
//  Lebao
//
//  Created by adnim on 16/8/26.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModal.h"
@interface MeetingModel : BaseModal

@end

@interface MeetingData : NSObject
@property(nonatomic,strong)NSString *authen;
@property(nonatomic,strong)NSString *distance;
@property(nonatomic,strong)NSString *imgurl;
@property(nonatomic,strong)NSString *industry;
@property(nonatomic,strong)NSString *realname;
@property(nonatomic,strong)NSString *synopsis;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *userid;
@property(nonatomic,strong)NSString *workyears;
@property(nonatomic,strong)NSString *service;
@property(nonatomic,strong)NSString *match;
@property(nonatomic,strong)NSString *resource;

@property(nonatomic,strong)NSString *remark;//文字备注
@property(nonatomic,strong)NSString *audio;//语音备注
@property(nonatomic,strong)NSString *reward;//悬赏金额
@property(nonatomic,strong)NSString *state;//约见状态
@property(nonatomic,strong)NSString *update_time;//最后操作时间
@property(nonatomic,strong)NSString *meetId;
@property(nonatomic,assign)int isappoint;//是否邀请了
@property(nonatomic,strong)NSString* tel;//是否邀请了
@end
