//
//  LoCationManager.m
//  Lebao
//
//  Created by adnim on 16/7/22.
//  Copyright © 2016年 David. All rights reserved.
//

#import "LoCationManager.h"
#import "XLDataService.h"
static  CLLocationCoordinate2D coordinate2D;
static LoCationManager *locationManager;
@implementation LoCationManager


+(LoCationManager *)shareInstance
{
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationManager =[[super alloc]init];
    });
    return locationManager;
    
}

-(void)creatLocationManager
{
   
    _locationMNG=[[CLLocationManager alloc]init];
    if (iOS8) {

    if ([CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse) {
        //授权,在使用app的时候开启定位服务
        [_locationMNG requestWhenInUseAuthorization];
    }
    
        if ([CLLocationManager locationServicesEnabled]&&[CLLocationManager authorizationStatus]!= kCLAuthorizationStatusDenied) {
//        NSLog(@"![CLLocationManager locationServicesEnabled]=%d",[CLLocationManager locationServicesEnabled]);
    }else{
        [[ToolManager shareInstance] showAlertViewTitle:@"温馨提示" contentText:@"请到设置-隐私-定位-开启知脉定位" showAlertViewBlcok:^{
            
        }];
        return;
    }

    //设置定位的精度
    _locationMNG.desiredAccuracy=kCLLocationAccuracyBest;
     //设置定位更新的最小距离(米)
    _locationMNG.distanceFilter=100.0f;
   
    }
    
     _locationMNG.delegate = self;
    [_locationMNG startUpdatingLocation];
}


#pragma mark - CLLocationManagerDelegate
#pragma mark - 定位跟新的回调函数
#pragma mark - 根据之前设置的最小更新距离，当移动距离超过的这个值就回调
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //locations,返回的一个位置,可能包含几个位置信息
    
    //获取其中第一个位置
    CLLocation *cllocation=[locations firstObject];
    
    coordinate2D=cllocation.coordinate;
    //测试用,要删掉
    coordinate2D.latitude=24.491534;
    coordinate2D.longitude=118.180851;
    if (_callBackLocation) {
        _callBackLocation(coordinate2D);
    }
//    NSLog(@"````````````````````纬度: %f, ````````````````````````经度: %lf", coordinate2D.latitude, coordinate2D.longitude);
    
    
//    NSMutableDictionary *param = [Parameter parameterWithSessicon];

//    [param setObject:@(1) forKey:@"source"];
//    [param setObject:[NSString stringWithFormat:@"%.6f",coordinate2D.latitude] forKey:@"latitude"];
//    [param setObject:[NSString stringWithFormat:@"%.6f",coordinate2D.longitude] forKey:@"longitude"];

    
//    [XLDataService postWithUrl:[NSString stringWithFormat:@"%@user/locationlog",HttpURL] param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
////        NSLog(@"dataObj=%@",dataObj);
////        NSLog(@"定位上传error=%@",error);
//        
//    }];
//
    
    //如果不需要反复的定位， 可以停止定位服务
    [_locationMNG stopUpdatingLocation];
    
    _locationMNG=nil;
    
}




@end
