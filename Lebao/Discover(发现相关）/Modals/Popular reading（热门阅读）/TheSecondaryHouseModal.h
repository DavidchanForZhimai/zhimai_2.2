//
//  TheSecondaryHouseModal.h
//  Lebao
//
//  Created by David on 16/4/13.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TheSecondaryDatas,TheSecondEstatepics;
@interface TheSecondaryHouseModal : NSObject

@property (nonatomic, assign) NSInteger rtcode;

@property (nonatomic, copy) NSString *rtmsg;

@property (nonatomic, strong) TheSecondaryDatas *datas;

@end
@interface TheSecondaryDatas : NSObject
@property (nonatomic, strong) NSString *acid;
@property (nonatomic, assign) NSInteger isreward;

@property (nonatomic, copy) NSString *reward;

@property (nonatomic, copy) NSString *labels;

@property (nonatomic, copy) NSString *toilet;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *amount;

@property (nonatomic, assign) NSInteger iscollect;

@property (nonatomic, assign) NSInteger isgetclue;

@property(nonatomic,assign) NSInteger iscross;

@property (nonatomic, copy) NSString *total;

@property (nonatomic, assign) NSInteger square;

@property (nonatomic, copy) NSString *imgurl;

@property (nonatomic, copy) NSString *abbre_cover;

@property (nonatomic, copy) NSString *acreage;

@property (nonatomic, copy) NSString *cover;

@property (nonatomic, copy) NSString *hall;

@property (nonatomic, copy) NSString *salespoint;

@property (nonatomic, copy) NSString *room;

@property (nonatomic, assign) NSInteger floorgrade;

@property (nonatomic, copy) NSString *face;

@property (nonatomic, copy) NSString *estatename;

@property (nonatomic, strong) NSArray<TheSecondEstatepics *> *estatepics;

@property (nonatomic, copy) NSString *author;

@property (nonatomic, copy) NSString *floor;

@end

@interface TheSecondEstatepics : NSObject

@property (nonatomic, copy) NSString *imgurl;

@property (nonatomic, copy) NSString *abbre_imgurl;

@property (nonatomic, copy) NSString *typekey;

@end