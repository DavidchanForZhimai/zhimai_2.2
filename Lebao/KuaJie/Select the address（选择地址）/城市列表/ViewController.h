//
//  ViewController.h
//  AddressInfo
//
//  Created by Alesary on 16/1/6.
//  Copyright © 2016年 Mr.Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef void(^ReturnCityName)(NSString *cityname,NSString *citynameID);

@interface ViewController : BaseViewController

@property (nonatomic, copy) ReturnCityName returnBlock;

- (void)returnText:(ReturnCityName)block;
@end

