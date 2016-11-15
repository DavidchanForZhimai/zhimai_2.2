//
//  StatusModel.h
//  Lebao
//
//  Created by David on 16/8/1.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 动态类型
**/
typedef NS_ENUM(NSUInteger,DTDataType) {
    
     DTDataTypeNormal = 1,//普通，常规类型
     DTDataTypeArticle = 2,//文章类型
     DTDataTypeClue = 3,//线索类型
};

@class StatusDatas,StatusPic,StatusComment,StatusInfo,StatusLike,Typeinfo,Message;
@interface StatusModel : NSObject

@property (nonatomic, copy) NSString *rtmsg;

@property (nonatomic, strong) NSArray<StatusDatas *> *datas;

@property (nonatomic, assign) NSInteger allpage;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) NSInteger rtcode;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) Message *message;

@end
@interface StatusDatas : NSObject

@property (nonatomic, copy) NSString *shareurl;

@property (nonatomic, copy) NSString *sharetitle;

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

@property (nonatomic, assign) int workyear;

@property (nonatomic, strong) NSMutableArray<StatusPic *> *pic;

@property (nonatomic, assign) NSInteger more;

@property (nonatomic, assign) BOOL islike;

@property (nonatomic, copy) NSString * createtime;

@property (nonatomic, strong) NSMutableArray<StatusComment *> *comment;

@property (nonatomic, copy) NSString *headimg;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) DTDataType type;//新增动态类型
@property (nonatomic, strong) Typeinfo *typeinfo;//新增类型数据

@property (nonatomic, copy) NSString *ac_title;//文章标题
@property (nonatomic, copy) NSString *acid;//文章id
@property (nonatomic, assign) BOOL  isshow_title;
@property (nonatomic, copy) NSString *cooperation_benefit;

@property(nonatomic,strong)NSString *position;//职位
@property(nonatomic,assign)BOOL vip;//vip

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

@interface Typeinfo : NSObject

@property (nonatomic, copy) NSString *count;//线索：领取次数

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *imgurl;//文章，显示图片

@property (nonatomic, assign) BOOL iscoop;

@property (nonatomic, assign) BOOL isself;
@end

@interface Message : NSObject

@property (nonatomic, assign) int count;

@property (nonatomic, copy) NSString *imgurl;

@property (nonatomic, copy) NSString *realname;


@end

