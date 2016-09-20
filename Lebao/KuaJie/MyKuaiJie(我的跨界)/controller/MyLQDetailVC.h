//
//  MyLQDetailVC.h
//  KuaJie
//
//  Created by 严文斌 on 16/5/23.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import "XianSuoDetailVC.h"

@interface MyLQDetailVC : UIViewController
typedef enum {
    weixz_Type=0,//未合作类型的view
    yihezuo_Type,
    weiPingJia_Type,//已选合作,还未评价类型的veiw
    dengdai_Type,//等待发布者选择
    xzmanYi_Type,//已选合作,满意
    xzBMY_Type,//不满意
} State_LQViewType;
@property (nonatomic,assign) NSInteger viewType;
@property (nonatomic,strong) NSString * xiansuoID;
@end
