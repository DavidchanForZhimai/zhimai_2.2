//
//  TheSecondCarHomeModel.h
//  Lebao
//
//  Created by David on 16/4/15.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TheSecondCarDatas,TheSecondCarCarpics;
@interface TheSecondCarHomeModel : NSObject

@property (nonatomic, assign) NSInteger rtcode;

@property (nonatomic, copy) NSString *rtmsg;

@property (nonatomic, strong) TheSecondCarDatas *datas;

@end
@interface TheSecondCarDatas : NSObject

@property (nonatomic, copy) NSString *des;
@property (nonatomic, copy) NSString *acid;

@property (nonatomic, assign) NSInteger iscollect;

@property (nonatomic, copy) NSString *imgurl;

@property (nonatomic, assign) NSInteger isreward;

@property (nonatomic, copy) NSString *amount;

@property (nonatomic, copy) NSString *abbre_cover;

@property (nonatomic, copy) NSString *labels;

@property (nonatomic, copy) NSString *color;

@property (nonatomic, copy) NSString *cartime;

@property (nonatomic, assign) NSInteger mileage;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *reward;

@property (nonatomic, copy) NSString *carvenue;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *cover;

@property (nonatomic, copy) NSString *buyprice;

@property (nonatomic, assign) NSInteger isgetclue;
@property(nonatomic,assign) NSInteger iscross;

@property (nonatomic, copy) NSString *brand;

@property(nonatomic,strong)NSString *series_id;
@property(nonatomic,strong)NSString *model_id;
@property(nonatomic,strong)NSString *keyid;

@property (nonatomic, strong) NSArray<TheSecondCarCarpics *> *carpics;

@end

@interface TheSecondCarCarpics : NSObject

@property (nonatomic, copy) NSString *imgurl;

@property (nonatomic, copy) NSString *abbre_imgurl;

@property (nonatomic, copy) NSString *typekey;

@end

