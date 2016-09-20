//
//  NotificationModal.h
//  Lebao
//
//  Created by David on 15/12/25.
//  Copyright © 2015年 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModal.h"
@interface NotificationModal :BaseModal
@property(nonatomic,copy) NSString *  syscount;//=1 有未读系统消息
@property(nonatomic,copy) NSString *  corsscount;//=1 有未读跨界消息
@property(nonatomic,copy) NSString *  cuscount;//=1 有未读客服消息
@end

@interface NotificationData : NSObject
@property(nonatomic,copy) NSString *  imgurl;
@property(nonatomic,copy) NSString *  createtime;
@property(nonatomic,assign) int sex;
@property(nonatomic,assign) BOOL authen;
@property(nonatomic,copy) NSString *num;
@property(nonatomic,copy) NSString *realname;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *senderid;

@end