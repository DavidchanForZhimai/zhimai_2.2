//
//  BaseViewController.h
//  Lebao
//
//  Created by David on 15/11/27.
//  Copyright © 2015年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
//工具类
#import "ToolManager.h"
#import "BaseButton.h"
#import "UIButton+Extend.h"
#import "UILabel+Extend.h"
typedef enum {
    
    NavViewButtonActionNavLeftBtnTag = 0,
    NavViewButtonActionNavRightBtnTag,
    
}NavViewButtonActionTag;

#define messageCount @"messageCount"

@interface BaseViewController : UIViewController
@property(nonatomic,strong)UIView *navigationBarView;
@property(nonatomic, strong)UILabel *navTitle;
@property(nonatomic,strong) BaseButton *homePageBtn;

//导航栏
- (void)navViewTitle:(NSString *)title;
- (void)navViewTitleAndBackBtn:(NSString *)title;
- (void)navViewTitleAndBackBtn:(NSString *)title rightBtn:(UIButton *)navRightBtn;
- (void)navViewTitle:(NSString *)title leftBtn:(UIButton *)navLeftBtn rightBtn:(UIButton *)navRightBtn;
//设置Tabbar
- (void)setTabbarIndex:(int)index;
- (void)isShowEmptyStatus:(BOOL)isShowEmptyStatus;
@end
