//
//  TheSecondCarResultViewController.h
//  Lebao
//
//  Created by David on 16/4/15.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"
#import "TheSecondCarHomeModel.h"
@interface TheSecondCarResult :NSObject
@property(nonatomic,strong)NSString *documentID;
@property(nonatomic,strong)NSString *amount;

@property(nonatomic,strong)NSMutableArray *images;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *abbre_cover;
@property(nonatomic,assign)BOOL iscollect;
@property(nonatomic,assign)BOOL isgetclue;
@property(nonatomic,assign)BOOL isreward;
@property(nonatomic,assign)BOOL iscross;
@property(nonatomic,strong)NSString *reward;
@property(nonatomic,strong)NSString *cover;
@property(nonatomic,strong)NSMutableArray *labels;
@property(nonatomic,strong)NSString *keyid;
@property(nonatomic,strong)NSString *model_id;
@property(nonatomic,strong)NSString *color;
@property(nonatomic,strong)NSString *cartime;
@property(nonatomic,strong)NSString *carvenue;
@property(nonatomic,strong)NSString *mileage;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *buyprice;

@property(nonatomic,strong)NSString *series_id;

@property(nonatomic,strong)NSString *pinpaiTitle;
@property(nonatomic,assign)BOOL isEdit;
@end


@interface TheSecondCarResultViewController : BaseViewController
@property(nonatomic,strong)TheSecondCarHomeModel *modal;
@property(nonatomic,strong)TheSecondCarResult *data;
@property(nonatomic,strong)UIScrollView *mainScrollView;
@end
