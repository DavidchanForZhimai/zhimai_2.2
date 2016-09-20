//
//  Header.h
//  KuaJie
//
//  Created by 严文斌 on 16/5/11.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#ifndef Header_h
#define Header_h
#import "AFNetworking.h"
#import "ToolManager.h"

#define HOST_URL [NSURL URLWithString:[NSString stringWithFormat:HttpURL]]

#define IMG_URL  [NSString stringWithFormat:ImageURLS]
//录音地址
#define kRecordAudioFile @"myRecord.caf"

#define BACKCOLOR [UIColor colorWithWhite:0.941 alpha:1.000]
//手机屏幕高
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define BAOXIAN [NSString stringWithFormat:@"insurance"] //保险

#define JINRONG [NSString stringWithFormat:@"finance"] //金融

#define FANGCHANG [NSString stringWithFormat:@"property"] //房产

#define CHEHANG [NSString stringWithFormat:@"car"] //车行

//手机屏幕的宽
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

// 判断是否为iOS7
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

// 判断是否为iOS8
#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

//判断是否为iPhone
#define IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define NAV_HEGHT 44

//判断是否为iPad
#define IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//判断是否为iPhone5
#define IPHONE_5_SCREEN [[UIScreen mainScreen] bounds].size.height == 568.0f

//判断是否为iPhone5以下屏幕手机
#define IPHONE_4_SCREEN [[UIScreen mainScreen] bounds].size.height <= 480.0f

//判断是否为iPhone6
#define IPHONE_6_SCREEN [[UIScreen mainScreen] bounds].size.height == 667.0f

//判断是否为iPhone6P
#define IPHONE_6P_SCREEN [[UIScreen mainScreen] bounds].size.height == 736.0f

#define     NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

//RGB颜色转换
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//HUD提示文字
//#define HUDText(text) ({\
//MBProgressHUD *hud=[[MBProgressHUD alloc]initWithView:self.view];\
//hud.mode=MBProgressHUDModeText;\
//hud.yOffset=SCREEN_HEIGHT/2-130;\
//[self.view addSubview:hud];\
//hud.labelText=text;\
//[hud showAnimated:YES whileExecutingBlock:^{\
//sleep(1);\
//}completionBlock:^{\
//[hud removeFromSuperViewOnHide];\
//}];\
//})
//HUD提示文字
#define HUDText(text) [[ToolManager shareInstance]showAlertMessage:text];
//HUD提示文字
#define HUD2(text,controller) ({\
MBProgressHUD *hud=[[MBProgressHUD alloc]initWithView:controller];\
hud.mode=MBProgressHUDModeText;\
hud.yOffset=Screen_Height/2-170;\
[controller addSubview:hud];\
hud.labelText=text;\
[hud showAnimated:YES whileExecutingBlock:^{\
sleep(1);\
}completionBlock:^{\
[hud removeFromSuperViewOnHide];\
}];\
})

#endif /* Header_h */
