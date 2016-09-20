//
//  DiscoverDetailViewController.h
//  Lebao
//
//  Created by David on 16/2/18.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"


@interface DiscoverDetailViewController : BaseViewController
@property(nonatomic,assign) int tag;
@property(nonatomic,strong) NSString *ID;
@property(nonatomic,strong) UIImage *shareImage;
@end


@interface DiscoverDetailData : NSObject
@property(nonatomic,strong) NSString *createtime;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *ID;
@property(nonatomic,strong) NSString *acid;
@property(nonatomic,strong) NSString *shareurl;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *readcount;
@property(nonatomic,assign) BOOL iscollect;
@end

@interface DiscoverDetailModal : NSObject
@property(nonatomic,strong)DiscoverDetailData *datas;
@property(nonatomic,strong)NSString *rtmsg;
@property(nonatomic,assign)int rtcode;
@end
