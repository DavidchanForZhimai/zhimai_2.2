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
@property(nonatomic,strong)NSString *amount;
@property(nonatomic,assign)AuthenType authen;
@property(nonatomic,strong)NSString *imgurl;
@property(nonatomic,strong)NSString *realname;
@property(nonatomic,strong)NSString *rtmsg;
@property(nonatomic,assign)int rtcode;
@property(nonatomic,assign)BOOL newmsg;
@property(nonatomic,strong)NSString *follownum;
@property(nonatomic,strong)NSString *fansnum;
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *demandline;
@end