//
//  AuthenticationHomeViewController.h
//  Lebao
//
//  Created by David on 16/9/19.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"

@class AuthenDatas,AuthenIndustry;
@interface AuthenticationModal : NSObject

@property (nonatomic, copy) NSString *rtmsg;

@property (nonatomic, strong) AuthenIndustry *industry;

@property (nonatomic, assign) NSInteger rtcode;

@property (nonatomic, strong) AuthenDatas *datas;

@end

@interface AuthenDatas : NSObject

@property (nonatomic, copy) NSString *userid;

@property (nonatomic, copy) NSString *examine;

@property (nonatomic, copy) NSString *idcard;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *realname;

@property (nonatomic, copy) NSString *applytime;

@property (nonatomic, copy) NSString *cardpic;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *industry;

@property(copy,nonatomic)NSString *sex;
@property(copy,nonatomic)NSString *address;
@property(copy,nonatomic)NSString *position;
@property(copy,nonatomic)NSString *imgurl;
@property(copy,nonatomic)NSString *workyears;
@property(copy,nonatomic)NSString *tel;
@property(copy,nonatomic)NSString *remark;
@property(assign,nonatomic)int authen;
@end

@interface AuthenIndustry : NSObject

@property (nonatomic, copy) NSString *insurance;

@property (nonatomic, copy) NSString *finance;

@property (nonatomic, copy) NSString *property;

@property (nonatomic, copy) NSString *other;

@end

@interface AuthenticationHomeViewController : BaseViewController
//@property(nonatomic,assign) int authen;
@end
