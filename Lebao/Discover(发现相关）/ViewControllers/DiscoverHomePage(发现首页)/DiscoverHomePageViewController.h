//
//  DiscoverHomePageViewController.h
//  Lebao
//
//  Created by David on 16/5/12.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseModal.h"
@interface DiscoverHomePageModal : BaseModal
@property(nonatomic,assign)BOOL isdefault; //是否默认地址=0 显示datas ，=1显示imgurl
@property(nonatomic,strong)NSString *imgurl;//默认图片

@property(nonatomic,assign)int rid;
@end
@interface DiscoverHomePageData : NSObject
@property(nonatomic,strong)NSString *foundimg;//图片地址
@property(nonatomic,assign)BOOL istitle;//是否显示标题 =1显示
@property(nonatomic,strong)NSString *foundtitle;//标题
@property(nonatomic,strong)NSString *foundlink;//网页链接，完整URL地址
@end

@interface DiscoverHomePageViewController : BaseViewController

@end
