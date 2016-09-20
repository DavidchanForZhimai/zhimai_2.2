//
//  MyXSDetailVC.h
//  KuaJie
//
//  Created by 严文斌 on 16/5/24.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyXSDetailVC : UIViewController
typedef enum {
    weiHeZuo_Type=0,//未合作类型的view
    yiheZuo_Type,//已合作类型的view
    weiCaoZuo_Type,//已选合作,还未评价类型的veiw
    manYi_Type,//已选合作,满意
    BMYWSS_Type,//已选合作,不满意,未申诉
    BMYYSS_Type,//不满意已申诉
} State_ViewType;
@property (nonatomic,assign) NSInteger viewType;
@property (nonatomic,strong) NSString * xiansuoID;
@end
