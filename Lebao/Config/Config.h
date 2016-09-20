
//
//  Config.h
//  FrameWork
//
//  Created by Davidchan on 15/11/24.
//  Copyright © 2015年 陈达伟. All rights reserved.
//

#ifndef Config_h
#define Config_h
//网络请求
//请求URL
//测试
#define ImageURLS @"http://pic.lmlm.cn"
#define HttpURL @"http://api.lmlm.cn/v1/"
//////正式
//#define ImageURLS @"http://pic.any98.com"
//#define HttpURL @"http://api.any98.com/v1/"
//约见接口
#define MeetMainURL [NSString stringWithFormat:@"%@meet/nearby",HttpURL]
//有空按钮
#define MeetAppendURL [NSString stringWithFormat:@"%@meet/append",HttpURL]
//想约见我
#define WantMeetMeURL [NSString stringWithFormat:@"%@meet/beinvitedlist",HttpURL]
//我想约见
#define IWantMeetURL [NSString stringWithFormat:@"%@meet/invitedlist",HttpURL]
//首页我想约见和想约见我的人数
#define WantURL [NSString stringWithFormat:@"%@meet/invitedcount",HttpURL]
//约见请求接口
#define MeetyouURL [NSString stringWithFormat:@"%@meet/invited",HttpURL]
//邀约处理操作接口
#define MeetOperationURL [NSString stringWithFormat:@"%@meet/operation",HttpURL]
//约见取消接口
#define MeetCancelURL [NSString stringWithFormat:@"%@meet/cancel",HttpURL]
//请求参数
#define DeviceToken @"deviceToken"
#define userName @"username"
#define passWord @"password"
#define newpassword @"newpassword"
#define captchaCode @"captchacode"
#define sendType @"sendtype"
#define oldpassword @"oldpassword"
#define Type @"type"
#define Industry @"industry"
#define Area @"area"
#define Page @"page"
#define Keyword @"keyword"
#define Conduct @"conduct"
#define ConductID      @"id"
#define Content      @"content"
#define State      @"state"

//类的封装与扩展
#import "UIColor+Extend.h"
#import "UIView+Extend.h"

//各种宏定义和各种枚举类型和block类型
#define  KWetChat_AppID @"wx37057309fa439183"
#define  KWetChat_AppSecret @"a0d6a7d5b32d360d868d75f402ccfd23"

#define LocationAddress  @"LocationAddress"
#define  AddressID @"AddressID"
#define RecentCityData @"RecentCityData"
#define AddressOldVersion @"AddressOldVersion"
#define AddressNewVersion @"AddressNewVersion"

//本地定位
#define KLocationId @"KLocationId"
#define KLocationName @"KLocationName"
//车版本
#define KCarNewVersion @"KCarNewVersion"
#define KCarOldVersion @"KCarOldVersion"
//状态栏高度
#define StatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define NavigationBarHeight  44
#define TabBarHeight  49
//屏幕宽高
#define APPWIDTH  [[UIScreen mainScreen] bounds].size.width
#define APPHEIGHT [[UIScreen mainScreen] bounds].size.height

//图片
#define ViewContentMode UIViewContentModeRedraw

//常见字体大小
//加粗字体

#define B_Size(a)        [UIFont boldSystemFontOfSize:a*SpacedFonts]

#define Size(a)        [UIFont systemFontOfSize:a*SpacedFonts]

//设置frame
#define frame(x,y,w,h) CGRectMake(x, y, w, h)
#define frameHeight(v) v.frame.size.height
#define frameWidth(v)  v.frame.size.width
#define frameX(v)      v.frame.origin.x
#define frameY(v)      v.frame.origin.y

//alloc
#define allocAndInitWithFrame(Class,frame) [[Class alloc]initWithFrame:frame]
#define allocAndInit(Class) [[Class alloc]init]

//主色调
#define AppMainColor   hexColor(4ca0fe)
#define LineBg         hexColor(c9c9c9)
#define AppViewBGColor hexColor(f1f0f0)
#define BlackTitleColor  hexColor(161616)
#define LightBlackTitleColor  hexColor(838383)
#define WhiteColor         hexColor(ffffff)

#define RedTitleColor  rgb(255.0, 2.0, 2.0)
#define GrayTitleColor  hexColor(acacac)
#define lightGrayTitleColor  hexColor(808080)
#define DDLog(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

//定义枚举
#endif /* Config_h */
