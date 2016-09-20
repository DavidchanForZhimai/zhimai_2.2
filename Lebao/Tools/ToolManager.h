//
//  ToolManager.h
//  Lebao
//
//  Created by David on 15/11/27.
//  Copyright © 2015年 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMDrawerController.h"
//请求参数
#import "Parameter.h"
//页面跳转
#define PushView(a,b)  [[ToolManager shareInstance] pushViewAnimation:a toViewController:b]

#define PopView(a)  [[ToolManager shareInstance] popViewAnimation:a]
#define PopRootView(a)  [[ToolManager shareInstance] popToRootViewAnimation:a]
#define PopToPointView(a,b)  [[ToolManager shareInstance] popToPointViewAnimation:a toViewController:b]

#define Modal(a,b)   [[ToolManager shareInstance] modelViewAnimation:a toViewController:b]

#define Dismiss(a)   [[ToolManager shareInstance] dismissViewAnimation:a]

//屏幕比例
#define ScreenMultiple     [[ToolManager shareInstance] screenMultiple]

//字体比例
#define SpacedFonts        [[ToolManager shareInstance] spacedFonts]
#define BandFonts        [[ToolManager shareInstance] bandFonts]

typedef NS_ENUM(NSUInteger,PlaceholderType) {
    PlaceholderTypeUserHead =0,
    PlaceholderTypeUserBg = 1,
    PlaceholderTypeImageUnProcessing = 2,
    PlaceholderTypeOther =3,
    PlaceholderTypeImageProcessing = PlaceholderTypeOther,
};

typedef void (^RefreshComponentRefreshingBlock)();/** 进入刷新状态的回调 */
typedef void (^LocationPositionBlock)(NSString *locate);//地址回调
typedef void (^SeleteImageFormSystemBlcok) (UIImage *image);//选择系统相册
typedef void (^ShowAlertViewBlcok) (void);//提示选择

@interface ToolManager : NSObject

@property(nonatomic,strong)MMDrawerController *drawerController;
//单例
+ (instancetype)shareInstance;
//登录界面
- (float)screenMultiple;//屏幕比例
- (float)spacedFonts; //字体比例
- (float)bandFonts; //字体换算
//加载网络图片
- (void)imageView:(id)imageView setImageWithURL:(NSString *)imageURL placeholderType:(PlaceholderType)placeholderType;
//图片url拼接
- (NSString *)urlAppend:(NSString *)url;
//加号视图
- (void)addReleseDctView:(UIViewController *)view;

@property(copy,nonatomic)SeleteImageFormSystemBlcok seleteImageFormSystemBlcok;
//选择相机
- (void)seleteImageFormSystem:(UIViewController *)view seleteImageFormSystemBlcok:(SeleteImageFormSystemBlcok )block;

//提示选择
- (void)showAlertViewTitle:(NSString *)title contentText:(NSString *)contentText  showAlertViewBlcok:(ShowAlertViewBlcok )block;


- (void)enterLoginView;
- (void)LoginmianView;
//push
- (void)pushViewAnimation:(UIViewController *)viewController1 toViewController:(UIViewController *)viewController2;

- (void)popViewAnimation:(UIViewController *)viewController1;
- (void)popToRootViewAnimation:(UIViewController *)viewController1;
- (void)popToPointViewAnimation:(UIViewController *)viewController1 toViewController:(NSString *)viewControllerStr;
//model
- (void)modelViewAnimation:(UIViewController *)viewController1 toViewController:(UIViewController *)viewController2;

- (void)dismissViewAnimation:(UIViewController *)viewController1;

#pragma mark - Dismiss Methods Sample
- (void)show;
- (void)showAlertMessage:(NSString *)str;
- (void)showWithStatus;
- (void)showInfoWithStatus;
- (void)showSuccessWithStatus;
- (void)showErrorWithStatus;
- (void)showWithStatus:(NSString *)text;
- (void)showInfoWithStatus:(NSString *)text;
- (void)showSuccessWithStatus:(NSString *)text;
- (void)showErrorWithStatus:(NSString *)text;
- (void)dismiss;


#pragma mark - Pull up and down the refresh
@property(nonatomic,copy)RefreshComponentRefreshingBlock refreshingBlock;
- (void)scrollView:(UIScrollView *)scrollView headerWithRefreshingBlock:(RefreshComponentRefreshingBlock)refreshingBlock;
- (void)endHeaderWithRefreshing:(UIScrollView *)scrollView;

- (void)noMoreDataStatus:(UIScrollView *)scrollView;
- (void)moreDataStatus:(UIScrollView *)scrollView;

- (void)scrollView:(UIScrollView *)scrollView footerWithRefreshingBlock:(RefreshComponentRefreshingBlock)refreshingBlock;

- (void)endFooterWithRefreshing:(UIScrollView *)scrollView ;


#pragma mark Webview
- (void)loadWebViewWithUrl:(NSString *)url title:(NSString *)title pushView:(UIViewController *)view rightBtn:(UIButton *)rightBt;


#pragma mark
#pragma mark 定位
//@property(nonatomic,copy)LocationPositionBlock locationPositionBlock;
//- (void)locationPositionBlock:(LocationPositionBlock)locationPositionBlock;
#pragma mark
#pragma mark 新版本提示
- (void)update;
@end


