//
//  LoCationManager.h
//  Lebao
//
//  Created by adnim on 16/7/22.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
typedef void (^CallBackLocation)(CLLocationCoordinate2D location);
@interface LoCationManager : NSObject<CLLocationManagerDelegate>

@property(nonatomic,copy)CallBackLocation callBackLocation;

@property (nonatomic,strong)CLLocationManager *locationMNG;
+(LoCationManager *)shareInstance;

-(void)creatLocationManager;

@end
