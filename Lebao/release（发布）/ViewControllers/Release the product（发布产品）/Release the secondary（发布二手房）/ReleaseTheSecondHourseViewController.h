//
//  ReleaseTheSecondHourseViewController.h
//  Lebao
//
//  Created by David on 16/4/11.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"
#import "TheSecondaryHouseModal.h"
@interface ReleaseTheSecond :NSObject
@property(nonatomic,strong)NSString *documentID;
@property(nonatomic,strong)NSString *estatename;
@property(nonatomic,strong)NSString *total;
@property(nonatomic,strong)NSString *acreage;
@property(nonatomic,strong)NSString *room;
@property(nonatomic,strong)NSString *hall;
@property(nonatomic,strong)NSString *toilet;
@property(nonatomic,strong)NSString *square;
@property(nonatomic,strong)NSString *floorgrade;
@property(nonatomic,strong)NSString *floor;
@property(nonatomic,strong)NSString *face;

@property(nonatomic,strong)NSMutableArray *images;

@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *abbre_cover;
@property(nonatomic,assign)BOOL iscollect;
@property(nonatomic,assign)BOOL isgetclue;
@property(nonatomic,assign)BOOL isreward;
@property(nonatomic,assign)BOOL iscross;
@property(nonatomic,strong)NSString *reward;
@property(nonatomic,strong)NSString *amount;
@property(nonatomic,strong)NSString *cover;
@property(nonatomic,strong)NSMutableArray *salespoint;
@property(nonatomic,strong)NSMutableArray *labels;

@property(nonatomic,assign)BOOL isEdit;
@end


@interface ReleaseTheSecondHourseViewController : BaseViewController
@property(nonatomic,strong)TheSecondaryHouseModal *modal;
@property(nonatomic,strong)ReleaseTheSecond *data;
@property(nonatomic,strong)UIScrollView *mainScrollView;
@end
