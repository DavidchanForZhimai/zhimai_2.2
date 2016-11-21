//
//  ToolManager.m
//  Lebao
//
//  Created by David on 15/11/27.
//  Copyright © 2015年 David. All rights reserved.
//

#import "ToolManager.h"
#import "AppDelegate.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import "SelectedLoginViewController.h"
//第三方框架 懒加载
#import <SVProgressHUD.h>
//上下拉刷新
#import <MJRefresh.h>
#import "DWWebViewController.h"
#import <CoreLocation/CoreLocation.h>//定位
#import "BHBPopView.h"//弹出
#import "FabuKuaJieVC.h"//发布跨界
#import "ReleaseDocumentsPackagetViewController.h"//封装链接
#import "EditArticlesViewController.h"//发布文
#import "ReleaseProductViewController.h"//发布产品
#import "TheSecondaryHouseViewController.h"//二手房源
#import "TheSecondCarHomeViewController.h"//二手车缘
#import "DWActionSheetView.h"//选择照片
#import "DXAlertView.h"//提示
#import "UIDevice+Extend.h"
#import "CALayer+Transition.h"
#import "CoreArchive.h"

#import "MMExampleDrawerVisualStateManager.h"
#import "MeViewController.h"
#import "XLDataService.h"
#import <AVFoundation/AVFoundation.h>
#define ShowWithStatus  @"加载数据..."
#define ShowInfoWithStatus @"亲，请求失败，重试！"
#define ShowSuccessWithStatus  @"Great Success!"
#define ShowErrorWithStatus @"亲，没网络！"
#define BaseIphone5Width 640.0
#define BaseIphone6Width 750.0
#define Bang  1.0/2.0f

@interface ToolManager()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSString *updataUrl; //定位
@end

@implementation ToolManager

static ToolManager *toolManager = nil;
static dispatch_once_t once;

+ (instancetype)shareInstance
{
    if (!toolManager) {
        dispatch_once(&once, ^{
            
            toolManager = allocAndInit(ToolManager);
            //配置SvPProgress
            
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
            [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
            [SVProgressHUD setMinimumDismissTimeInterval:1.0f];
        });
    }
    
    return toolManager;
    
}
//图片url拼接
- (NSString *)urlAppend:(NSString *)url
{
    if (!url) {
        return ImageURLS;
    }
    NSString * imageURL = url;
    if (![imageURL hasPrefix:@"http"]) {
        imageURL = [NSString stringWithFormat:@"%@%@",ImageURLS,imageURL];
    }
    return imageURL;
}
#pragma mark
#pragma mark 加载网络图片
- (void)imageView:(id)imageView setImageWithURL:(NSString *)imageURL placeholderType:(PlaceholderType)placeholderType
{
    //头像设置圆形
    if (placeholderType ==PlaceholderTypeUserHead) {
        
        [imageView setRound];
        
    }
    NSString * url = [self urlAppend:imageURL];
    
    if ([imageView isKindOfClass:[UIImageView class]]) {
        
        UIImageView *  image =(UIImageView *)imageView;
        UIImage *placeholderImage = nil;
        switch (placeholderType) {
            case PlaceholderTypeUserBg:
                placeholderImage = [UIImage imageNamed:@"ditu"];
                break;
            case PlaceholderTypeUserHead:
                placeholderImage = [UIImage imageNamed:@"defaulthead"];
                image.contentMode = UIViewContentModeScaleAspectFill;
                
                break;
            case PlaceholderTypeUserHeadNv:
                placeholderImage = [UIImage imageNamed:@"defaulthead_nv"];
                image.contentMode = UIViewContentModeScaleAspectFill;
                
                break;
            case PlaceholderTypeOther:
                placeholderImage =[UIImage imageNamed:@"icon_placeholder"];
                image.contentMode = UIViewContentModeScaleAspectFill;
                image.clipsToBounds = YES;
                break;
                
            case PlaceholderTypeImageUnProcessing:
                placeholderImage =[UIImage imageNamed:@"icon_placeholder"];
                image.contentMode =UIViewContentModeScaleToFill;
                break;
                
            default:
                break;
        }
        
        [image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholderImage];
        
    }
    else if ([imageView isKindOfClass:[UIButton class]])
    {
        UIButton * button =(UIButton *)imageView;
        
        UIImage *placeholderImage = nil;
        switch (placeholderType) {
            case PlaceholderTypeUserBg:
                placeholderImage = [UIImage imageNamed:@"ditu"];
                break;
            case PlaceholderTypeUserHead:
                placeholderImage = [UIImage imageNamed:@"defaulthead"];
                button.imageView.contentMode = UIViewContentModeScaleAspectFill;
                break;
            case PlaceholderTypeOther:
                placeholderImage =[UIImage imageNamed:@"icon_placeholder"];
                button.imageView.contentMode = UIViewContentModeScaleToFill;
                break;
                
            case PlaceholderTypeImageUnProcessing:
                placeholderImage =[UIImage imageNamed:@"icon_placeholder"];
                button.imageView.contentMode =UIViewContentModeScaleToFill;
                break;
            default:
                break;
        }
        
        [button sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:placeholderImage];
    }
    
}
#pragma mark
#pragma mark 加号视图

- (void)addReleseDctView:(UIViewController *)view
{
    
    //  添加popview
    [BHBPopView showToView:[UIApplication sharedApplication].keyWindow  andImages:@[@"iconfont-fabukuajie",@"iconfont-chanpin",@"iconfont-lianjie",@"iconfont-wenzhang"] andTitles:@[@"发布线索",[NSString stringWithFormat:@"发布%@",[CoreArchive strForKey:Industry]],@"封装链接",@"发布文章"] andSelectBlock:^(BHBItem *item, NSInteger index) {
        
        switch (index) {
            case 0:
                
                [view.navigationController pushViewController:allocAndInit(FabuKuaJieVC) animated:NO];
                break;
            case 1:
            {
                IndustryCode code=  [Parameter industryCode:[CoreArchive strForKey:Industry]];
                if (code ==IndustryCodeother) {
                    ReleaseProductViewController *release =  allocAndInit(ReleaseProductViewController);
                    ReleaseProduct *data = allocAndInit(ReleaseProduct);
                    data.content = @"";
                    data.isAddress = YES ;
                    data.isgetclue = YES;
                    data.iscollect = NO;
                    data.amount = @"0.00";
                    release.data = data;
                    [view.navigationController pushViewController:release animated:NO];
                }
                else if (code ==IndustryCodeproperty)
                {
                    [view.navigationController pushViewController:allocAndInit(TheSecondaryHouseViewController) animated:NO];
                }
                else if (code ==IndustryCodecar)
                {
                    [view.navigationController pushViewController:allocAndInit(TheSecondCarHomeViewController) animated:NO];
                }
                
                break;
            }
                
            case 2:
                [view.navigationController pushViewController:allocAndInit(ReleaseDocumentsPackagetViewController) animated:NO];
                
                break;
            case 3:
            {
                EditArticlesViewController *release =allocAndInit(EditArticlesViewController);
                EditArticlesData *data = allocAndInit(EditArticlesData);
                data.content = @"";
                data.isAddress = YES ;
                data.isgetclue = YES;
                data.isRanking = YES;
                data.amount = @"0.00";
                data.isReleseArticle =YES;
                release.data = data;
                
                [view.navigationController pushViewController:release animated:NO];
            }
                break;
                
                
            default:
                break;
        }
        
    }];
    
}
#pragma mark
#pragma mark 选择相机
- (void)seleteImageFormSystem:(UIViewController *)view seleteImageFormSystemBlcok:(SeleteImageFormSystemBlcok )block
{
    _seleteImageFormSystemBlcok = block;
    
    DWActionSheetView *_actionSheetView = [DWActionSheetView showActionSheetWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从手机相册选择"] handler:^(DWActionSheetView *actionSheetView, NSInteger buttonIndex) {
        
        if (buttonIndex>-1) {
            NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            if (buttonIndex ==0) {
                
                //来源:相机
                
                if (![self captureDeviceStatus]) {
                    return;
                }
                sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            else if (buttonIndex ==1)
            {
                
                if (![self assetsLibraryStatus]) {
                    
                    return;
                }
                
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
            }
            
            // 跳转到相机或相册页面
            UIImagePickerController *imagePickerController = allocAndInit(UIImagePickerController);
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = NO;
            imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            imagePickerController.sourceType = sourceType;
            Modal(view, imagePickerController);
        }
        
        
    }];
    
    [_actionSheetView show];
}
//判断相机的
- (BOOL)captureDeviceStatus
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        [[[UIAlertView alloc] initWithTitle:@"无法打开相机" message:@"请在“设置-隐私-相机”选项中允许访问你的相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return NO;
        
    } else {
        
        return YES;
        
    }
}
//判断相册的
- (BOOL)assetsLibraryStatus
{
    if (!iOS9) {
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        
        if (status == ALAuthorizationStatusDenied || ALAuthorizationStatusRestricted) {
            [[[UIAlertView alloc] initWithTitle:@"无法打开照片" message:@"请在“设置-隐私-照片”选项中允许访问你的照片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            return NO;
            
        } else {
            
            return YES;
            
        }
    }
    return YES;
}
#pragma mark
#pragma mark 提示选择
- (void)showAlertViewTitle:(NSString *)title contentText:(NSString *)contentText  showAlertViewBlcok:(ShowAlertViewBlcok )block
{
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:title contentText:contentText leftButtonTitle:nil rightButtonTitle:@"确定"];
    [alert show];
    alert.rightBlock =block;
}

#pragma mark
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    Dismiss(picker);
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    if (_seleteImageFormSystemBlcok) {
        _seleteImageFormSystemBlcok(image);
    }
    
}

#pragma mark
#pragma mark enterLoginView
- (void)enterLoginView
{
    if (getAppDelegate().window.rootViewController) {
        [getAppDelegate().window.rootViewController removeFromParentViewController];
    }
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:allocAndInit(SelectedLoginViewController)];
    getAppDelegate().window.rootViewController = nav;
    
}
- (void)LoginmianView
{
    if (getAppDelegate().window.rootViewController) {
        [getAppDelegate().window.rootViewController removeFromParentViewController];
    }
    //设置App底栏
    getAppDelegate().mainTab = allocAndInit(MPHomeViewController);
    
    //设置消息未读数(动态消息未读数)
    [[PushManager shareInstace] getMsgCountSucceed:^(int dynamicCount, int msgcount) {
        
        if (dynamicCount>0) {
             [getAppDelegate().mainTab.tabBar.items objectAtIndex:1].badgeValue = [NSString stringWithFormat:@"%i",dynamicCount];
        }
        else
        {
            [getAppDelegate().mainTab.tabBar.items objectAtIndex:1].badgeValue = nil;
        }
        if (msgcount>0) {
            [getAppDelegate().mainTab.tabBar.items objectAtIndex:2].badgeValue = [NSString stringWithFormat:@"%i",msgcount];
        }
        else
        {
             [getAppDelegate().mainTab.tabBar.items objectAtIndex:2].badgeValue = nil;
        }
        
        //应用图标数目
        [UIApplication sharedApplication].applicationIconBadgeNumber = dynamicCount + msgcount;
        
    }];

    
    UINavigationController * rightSideNavController = [[UINavigationController alloc] initWithRootViewController:allocAndInit(MeViewController)];
    [rightSideNavController setRestorationIdentifier:@"MMExampleRightNavigationControllerRestorationKey"];
    _drawerController = [[MMDrawerController alloc]
                         initWithCenterViewController:getAppDelegate().mainTab
                         rightDrawerViewController:rightSideNavController];
    [_drawerController setRestorationIdentifier:@"MMDrawer"];
    [_drawerController setShowsShadow:NO];
    [_drawerController setMaximumRightDrawerWidth:APPWIDTH - 60*ScreenMultiple];
    [_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [_drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    
    
    getAppDelegate().window.rootViewController = _drawerController;
    
    [getAppDelegate().window.layer transitionWithAnimType:TransitionAnimTypeRippleEffect subType:TransitionSubtypesFromRight curve:TransitionCurveEaseInEaseOut duration:1.0f];
}
#pragma mark
#pragma mark push
- (void)pushViewAnimation:(UIViewController *)viewController1 toViewController:(UIViewController *)viewController2
{
    [viewController1.navigationController pushViewController:viewController2 animated:YES];
    
    if ([viewController1.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        viewController1.navigationController.interactivePopGestureRecognizer.delegate =nil;
    }
    
    
}
- (void)popViewAnimation:(UIViewController *)viewController1
{
    [viewController1.navigationController popViewControllerAnimated:YES];
    
    //    if ([viewController1.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    //
    //        viewController1.navigationController.interactivePopGestureRecognizer.delegate =nil;
    //    }
    
}
- (void)popToRootViewAnimation:(UIViewController *)viewController1
{
    [viewController1.navigationController popToRootViewControllerAnimated:YES];
    
    //    if ([viewController1.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    //
    //        viewController1.navigationController.interactivePopGestureRecognizer.delegate =nil;
    //    }
}
- (void)popToPointViewAnimation:(UIViewController *)viewController1 toViewController:(NSString *)viewControllerStr
{
    
    for (UIViewController * controller in  viewController1.navigationController.childViewControllers) {
        
        if ([viewControllerStr isEqualToString:NSStringFromClass([controller class])]) {
            [viewController1 .navigationController popToViewController:
             controller animated:YES];
        }
    }
    
    if ([viewController1.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        viewController1.navigationController.interactivePopGestureRecognizer.delegate =nil;
    }
    
}
#pragma mark
#pragma mark model
- (void)modelViewAnimation:(UIViewController *)viewController1 toViewController:(UIViewController *)viewController2
{
    [viewController1 presentViewController:viewController2 animated:YES completion:nil];
    
}
- (void)dismissViewAnimation:(UIViewController *)viewController1
{
    [viewController1 dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark
#pragma mark 适配iPhone5与6，6plus的不同分辨率
- (float)screenMultiple
{
    if (APPWIDTH<=320.0) {
        
        return 1.0;
    }
    else
        return APPWIDTH/320.0;
}

- (float)spacedFonts
{
    //    if (iphone6Plus_5_5) {
    //
    //        return [self bandFonts]*APPWIDTH/BaseIphone6Width;
    //    }
    //    else
    //    {
    return [self bandFonts];
    //    }
    
}
- (float)bandFonts
{
    
    return  Bang;
}
#pragma mark - Dismiss Methods Sample
- (void)show
{
    
    [SVProgressHUD show];
    
}
- (void)showAlertMessage:(NSString *)str
{
    [SVProgressHUD showInfoWithStatus:str];
}

- (void)showWithStatus
{
    
    [SVProgressHUD showWithStatus:ShowWithStatus];
}
- (void)showInfoWithStatus
{
    [SVProgressHUD showInfoWithStatus:ShowInfoWithStatus];
}
- (void)showSuccessWithStatus
{
    
    [SVProgressHUD showSuccessWithStatus:ShowSuccessWithStatus];
    
}
- (void)showErrorWithStatus
{
    
    [SVProgressHUD showErrorWithStatus:ShowErrorWithStatus];
}
- (void)showWithStatus:(NSString *)text
{
    
    [SVProgressHUD showWithStatus:text];
    
}
- (void)showInfoWithStatus:(NSString *)text
{
    
    [SVProgressHUD showInfoWithStatus:text];
}
- (void)showSuccessWithStatus:(NSString *)text
{
    
    [SVProgressHUD showSuccessWithStatus:text];
}
- (void)showErrorWithStatus:(NSString *)text
{
    [SVProgressHUD showErrorWithStatus:text];
}

- (void)dismiss
{
    [SVProgressHUD dismiss];
}


#pragma mark
#pragma mark - Pull up and down the refresh
- (void)scrollView:(UIScrollView *)scrollView headerWithRefreshingBlock:(RefreshComponentRefreshingBlock)refreshingBlock
{
    scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        refreshingBlock();
    }];
    //    //系统
    //
    //    _refreshingBlock = refreshingBlock;
    //    UIRefreshControl *control = allocAndInit(UIRefreshControl);
    //    control.tintColor = AppMainColor;
    //    [scrollView addSubview:control];
    //    NSLog(@"control =%@",control);
    //
    //    [control addTarget:self action:@selector(refreshingBlock:) forControlEvents:UIControlEventValueChanged];
    
}
- (void)scrollView:(UIScrollView *)scrollView footerWithRefreshingBlock:(RefreshComponentRefreshingBlock)refreshingBlock
{
    
    //    mj
    scrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        refreshingBlock();
    }];
    
}
#pragma mark
#pragma mark － 系统自带刷新
- (void)refreshingBlock:(UIRefreshControl *)sender
{
    if (_refreshingBlock) {
        [sender beginRefreshing];
        _refreshingBlock();
    }
}
- (void)noMoreDataStatus:(UIScrollView *)scrollView;
{
    scrollView.mj_footer.state =MJRefreshStateNoMoreData;
}
- (void)moreDataStatus:(UIScrollView *)scrollView
{
    scrollView.mj_footer.state =MJRefreshStateIdle;
}
- (void)endHeaderWithRefreshing:(UIScrollView *)scrollView{
    
    [scrollView.mj_header endRefreshing];
    //    for (UIView *view in scrollView.subviews) {
    //        if ([view isKindOfClass:[UIRefreshControl class]]) {
    //            UIRefreshControl*  refreshView = (UIRefreshControl*)view;
    //            [refreshView endRefreshing];
    ////             NSLog(@"isRefresh");
    //            NSLog(@"refreshView =%@",refreshView);
    //        }
    //    }
    
    
}

- (void)endFooterWithRefreshing:(UIScrollView *)scrollView
{
    [scrollView.mj_footer endRefreshing];
}


- (void)loadWebViewWithUrl:(NSString *)url title:(NSString *)title pushView:(UIViewController *)view rightBtn:(UIButton *)rightBt
{
    NSString *urlStr;
    if ([url hasPrefix:@"http"]) {
        urlStr = url;
    }
    else
    {
        urlStr = [NSString stringWithFormat:@"%@%@",HttpURL,url];
    }
    //    NSLog(@"urlStr =%@",urlStr);
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    DWWebViewController *webContro =allocAndInit(DWWebViewController);
    //     NSLog(@"urlStr =%@",urlStr);
    webContro.homeUrl = [NSURL URLWithString:urlStr];
    webContro.title = title;
    
    if (rightBt) {
        
        [webContro.view addSubview:rightBt];
        
    }
    
    [view.navigationController pushViewController:webContro animated:YES];
}

//新版本提示
- (void)update {
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    
    NSString *oldVersion = infoDict[@"CFBundleShortVersionString"];
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@common/updateios",HttpURL];
    
    [XLDataService putWithUrl:url param:[Parameter parameterWithSessicon] modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        NSLog(@"dataObj =%@",dataObj);
        if ([dataObj[@"rtcode"] integerValue]==1) {
            
            NSString *newVersion =dataObj[@"version"];
            _updataUrl =dataObj[@"url"];
            NSArray *newArray = [newVersion componentsSeparatedByString:@"."];
            NSArray *oldArray = [oldVersion componentsSeparatedByString:@"."];
            int count=(int)newArray.count;
            if (oldArray.count<newArray.count) {
                count = (int) oldArray.count;
            }
            BOOL sure = NO;
            for (int i =0; i<count; i++) {
                
                if ([oldArray[i] integerValue]==[newArray[i] integerValue]) {
                    continue;
                }
                
                if ([oldArray[i] integerValue]<[newArray[i] integerValue]) {
                    sure = YES;
                    break;
                }
                else
                {
                    sure = NO;
                    break;
                }
                
            }
            if (sure) {
                UIAlertView *view = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"检测到新版本(%@),是否更新?",newVersion] message:[NSString stringWithFormat:@"%@",dataObj[@"info"]] delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"更新", nil];
                view.tag = 888;
                [view show];
            }
            
        }
        
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==888) {
        if (buttonIndex ==1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_updataUrl]];
        }
    }
}
@end
