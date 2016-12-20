//
//  MeViewController.h
//  Lebao
//
//  Created by David on 15/12/4.
//  Copyright © 2015年 David. All rights reserved.
//

#import "BaseViewController.h"

@interface MeViewController : BaseViewController

@end

typedef NS_ENUM(int,AuthenType) {
    
    AuthenTypeNo =1,
    AuthenTypeIng,
    AuthenTypeYes,
    AuthenTypeOther = 9,
};

@interface MeViewModal : NSObject
@property(nonatomic,copy)NSString *amount;
@property(nonatomic,assign)AuthenType authen;//认证
@property(nonatomic,copy)NSString *imgurl;
@property(nonatomic,copy)NSString *realname;
@property(nonatomic,copy)NSString *rtmsg;
@property(nonatomic,assign)int rtcode;
@property(nonatomic,assign)BOOL newmsg;
@property(nonatomic,copy)NSString *invitednum;
@property(nonatomic,copy)NSString *dynamicnum;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *demandline;
@property(nonatomic,copy)NSString *vip;
@end
