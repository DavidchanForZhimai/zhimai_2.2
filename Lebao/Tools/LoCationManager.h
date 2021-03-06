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
typedef void (^CallBackLocationCityName)(NSString * cityName);
@interface LoCationManager : NSObject<CLLocationManagerDelegate>

@property(nonatomic,copy)CallBackLocation callBackLocation;
@property(nonatomic,copy)CallBackLocationCityName callBackLocationCityName;

@property (nonatomic,strong)CLLocationManager *locationMNG;
+(LoCationManager *)shareInstance;
-(void)creatLocationManager:(UIViewController *)vc;
-(void)creatLocationManager:(UIViewController *)vc callBackLocation:(CallBackLocation)callBackLocation;

@end
