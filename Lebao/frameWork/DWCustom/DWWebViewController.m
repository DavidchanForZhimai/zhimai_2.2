//
//  DWWebViewController.m
//  Lebao
//
//  Created by David on 16/1/21.
//  Copyright © 2016年 David. All rights reserved.
//

#import "DWWebViewController.h"
#import <WebKit/WebKit.h>
#import "UIDevice+Extend.h"
@interface DWWebViewController ()<UIWebViewDelegate,UIActionSheetDelegate,WKNavigationDelegate>
@property (assign, nonatomic) NSUInteger loadCount;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) WKWebView *wkWebView;


@end

@implementation DWWebViewController
{
    NSMutableArray *newArr;
}


/** 传入控制器、url、标题 */
+ (void)showWithContro:(UIViewController *)contro withUrlStr:(NSString *)urlStr withTitle:(NSString *)title {
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    DWWebViewController *webContro =allocAndInit(DWWebViewController );
    
    webContro.homeUrl = [NSURL URLWithString:urlStr];
 
    webContro.title = title;
    [contro.navigationController pushViewController:webContro animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
//    [self configBackItem];
//    [self configMenuItem];
}

- (void)configUI {
    [self navViewTitleAndBackBtn:self.title rightBtn:_rightBtn];
    // 进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0,StatusBarHeight + NavigationBarHeight -2, self.view.frame.size.width, 0)];
    progressView.tintColor = AppMainColor;
    progressView.trackTintColor =WhiteColor;
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    // 网页
    if (ios8x) {
        WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:  frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight))];
        wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        wkWebView.backgroundColor = [UIColor whiteColor];
        wkWebView.navigationDelegate = self;
        [self.view addSubview:wkWebView];
        
        [wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        
        [wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        NSURLRequest *request = [NSURLRequest requestWithURL:_homeUrl];
        [wkWebView loadRequest:request];
        self.wkWebView = wkWebView;
    }else {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:  frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight))];
        webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        webView.scalesPageToFit = YES;
        webView.backgroundColor = [UIColor whiteColor];
        webView.delegate = self;
        [self.view addSubview:webView];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:_homeUrl];
        [webView loadRequest:request];
        self.webView = webView;
    }
}

//- (void)configBackItem {
//    
//    // 导航栏的返回按钮
//    UIImage *backImage = [UIImage imageNamed:@"cc_webview_back"];
//    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 22)];
//    [backBtn setTintColor:WhiteColor];
//    [backBtn setBackgroundImage:backImage forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *colseItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = colseItem;
//}
//
//- (void)configMenuItem {
//    
//    // 导航栏的菜单按钮
//    UIImage *menuImage = [UIImage imageNamed:@"cc_webview_menu"];
//    menuImage = [menuImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
//    [menuBtn setTintColor:WhiteColor];
//    [menuBtn setImage:menuImage forState:UIControlStateNormal];
//    [menuBtn addTarget:self action:@selector(menuBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
//    self.navigationItem.rightBarButtonItem = menuItem;
//}
//
- (void)configColseItem {
    
    // 导航栏的关闭按钮
    
    BaseButton *colseItem = [[BaseButton alloc]initWithFrame:frame(40, StatusBarHeight, 2*26*SpacedFonts, NavigationBarHeight) setTitle:@"关闭" titleSize:26*SpacedFonts titleColor:WhiteColor textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] inView:self.view];
    
    colseItem.didClickBtnBlock = ^
    {
        PopView(self);
    };
    newArr = [NSMutableArray arrayWithObjects:self.navigationItem.leftBarButtonItem,colseItem, nil];

}

#pragma mark - 普通按钮事件

// 返回按钮点击
- (void)buttonAction:(UIButton *)sender {
    if (ios8x) {
        if (self.wkWebView.canGoBack) {
            [self.wkWebView goBack];
            if (!newArr) {
                [self configColseItem];
            }
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else {
        if (self.webView.canGoBack) {
            [self.webView goBack];
            if (!newArr) {
                [self configColseItem];
            }
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

// 菜单按钮点击
- (void)menuBtnPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"safari打开",@"复制链接",@"分享",@"刷新", nil];
    [actionSheet showInView:self.view];
}



#pragma mark - 菜单按钮事件

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    NSString *urlStr = _homeUrl.absoluteString;
    if (ios8x) urlStr = self.wkWebView.URL.absoluteString;
    else urlStr = self.webView.request.URL.absoluteString;
    if (buttonIndex == 0) {
        
        // safari打开
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }else if (buttonIndex == 1) {
        
        // 复制链接
        if (urlStr.length > 0) {
            [[UIPasteboard generalPasteboard] setString:urlStr];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"已复制链接到黏贴板" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
            [alertView show];
        }
    }else if (buttonIndex == 2) {
        
        // 分享
        //[self.wkWebView evaluateJavaScript:@"这里写js代码" completionHandler:^(id reponse, NSError * error) {
        //NSLog(@"返回的结果%@",reponse);
        //}];
        NSLog(@"这里自己写，分享url：%@",urlStr);
    }else if (buttonIndex == 3) {
        
        // 刷新
        if (ios8x) [self.wkWebView reload];
        else [self.webView reload];
        
    }
}

#pragma mark - wkWebView代理

// 如果不添加这个，那么wkwebview跳转不了AppStore
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.wkWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
    else if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.webView) {
        
            
        }
        else
        {
            
            self.navTitle.text = [change objectForKey:NSKeyValueChangeNewKey];
      
        }
    }
    
}

// 记得取消监听
- (void)dealloc {
    if (ios8x) {
        [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
        [self.wkWebView removeObserver:self forKeyPath:@"title"];
    }
}

#pragma mark - webView代理

// 计算webView进度条
- (void)setLoadCount:(NSUInteger)loadCount {
    _loadCount = loadCount;
    if (loadCount == 0) {
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    }else {
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        CGFloat newP = (1.0 - oldP) / (loadCount + 1) + oldP;
        if (newP > 0.95) {
            newP = 0.95;
        }
        [self.progressView setProgress:newP animated:YES];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    self.loadCount ++;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
   
    if (!self.title||self.title.length==0) {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
    self.loadCount --;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    self.loadCount --;
}
@end
