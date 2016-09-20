//
//  AppDelegate+Introduce.m
//  Lebao
//
//  Created by David on 16/7/1.
//  Copyright © 2016年 David. All rights reserved.
//

#import "AppDelegate+CoreNewFeature.h"
#import "CoreNewFeatureVC.h" //启动页
#import "CoreArchive.h"
#define once @"once"
@implementation AppDelegate (CoreNewFeature)
- (void)showView
{
    
    //判断是否需要显示：（内部已经考虑版本及本地版本缓存）
    BOOL canShow = [CoreNewFeatureVC canShowNewFeature];
    
    //测试代码，正式版本应该删除
    //    canShow = YES;
    if(canShow){ // 初始化新特性界面
        self.window.rootViewController = [CoreNewFeatureVC newFeatureVCWithImageNames:@[@"new_feature_1_736h",@"new_feature_2_736h",@"new_feature_3_736h"] enterBlock:^{
            
            [self enter];
            
        } configuration:^(UIButton *enterButton) { // 配置进入按钮
            [enterButton setImage: [UIImage imageNamed:@"btn_nor"] forState:UIControlStateNormal];
            [enterButton setImage:[UIImage imageNamed:@"btn_pressed"] forState:UIControlStateHighlighted];
            enterButton.bounds = CGRectMake(0, 0, 212/2.0, 48.0/2.0);
            enterButton.center = CGPointMake(APPWIDTH * 0.5, APPHEIGHT* 0.92);
        }];
        
    }else{
        
        [self enter];
    }
    
    
}
// 进入主页面
-(void)enter{
    
    if (![CoreArchive strForKey:@"once"]) {
        [CoreArchive removeStrForKey:KuserName];
        [CoreArchive removeStrForKey:passWord];
        
    }
    //没有登录
    if (![Parameter isSession]) {
        
        
        [[ToolManager shareInstance]enterLoginView];
        
    }
    else
    {
        [[ToolManager shareInstance] LoginmianView];
    }
    
}

@end
