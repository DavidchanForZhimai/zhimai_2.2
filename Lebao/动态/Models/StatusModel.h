//
//  StatusModel.h
//  Lebao
//
//  Created by David on 16/8/1.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StatusDatas,StatusPic,StatusComment,StatusInfo,StatusLike;
@interface StatusModel : NSObject

@property (nonatomic, copy) NSString *rtmsg;

@property (nonatomic, strong) NSArray<StatusDatas *> *datas;

@property (nonatomic, assign) NSInteger allpage;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) NSInteger rtcode;

@property (nonatomic, assign) NSInteger page;
@end
@interface StatusDatas : NSObject

@property (nonatomic, copy) NSString *shareurl;
@property (nonatomic, copy) NSString *sharetitle;

@property (nonatomic, copy) NSString *type;//自己添加

@property (nonatomic, assign) NSInteger likenum;

@property (nonatomic, assign) BOOL isfollow;

@property (nonatomic, strong) NSMutableArray<StatusLike *> *like;

@property (nonatomic, assign) NSInteger authen;

@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, copy) NSString *imgurl;

@property (nonatomic, assign) NSInteger comnum;

@property (nonatomic, copy) NSString *industry;

@property (nonatomic, assign) BOOL me;

@property (nonatomic, copy) NSString *realname;

@property (nonatomic, assign) NSInteger brokerid;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *workyear;

@property (nonatomic, strong) NSMutableArray<StatusPic *> *pic;

@property (nonatomic, assign) NSInteger more;

@property (nonatomic, assign) BOOL islike;

@property (nonatomic, copy) NSString * createtime;

@property (nonatomic, strong) NSMutableArray<StatusComment *> *comment;

@property (nonatomic, copy) NSString *headimg;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *content;

@end

@interface StatusPic : NSObject

@property (nonatomic, copy) NSString *imgurl;

@property (nonatomic, copy) NSString *abbre_imgurl;

@end

@interface StatusComment : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, strong) StatusInfo *info;

@property (nonatomic, assign) NSInteger me;

@end

@interface StatusInfo : NSObject

@property (nonatomic, assign) NSInteger brokerid;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) NSInteger rep_brokerid;

@property (nonatomic, assign) NSInteger index;//添加索引

@property (nonatomic, copy) NSString *rep_realname;

@property (nonatomic, copy) NSString *realname;


@end

@interface StatusLike : NSObject

@property (nonatomic, copy) NSString *imgurl;

@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, assign) NSInteger brokerid;


@end

