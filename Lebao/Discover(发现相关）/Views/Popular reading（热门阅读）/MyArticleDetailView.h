//
//  MyArticleDetailView.h
//  Lebao
//
//  Created by David on 16/3/2.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyArticleDetailModal.h"
#import "IMYWebView.h"
typedef void (^EditBlock) (MyArticleDetailModal *modal);
typedef void (^ContributionBlock) (BOOL is);
typedef void (^ModalBlock) (MyArticleDetailModal *modal);

typedef void (^EnterDetailBlock) (UIViewController * viewContoller);
@interface MyArticleDetailView : UIScrollView<IMYWebViewDelegate>
{
    MyArticleDetailModal *modal;
}
@property(nonatomic,strong)IMYWebView *webView;
@property(nonatomic,strong)NSString *postWithUrl;
@property(nonatomic,strong)NSMutableDictionary *param;
- (instancetype)initWithFrame:(CGRect)frame postWithUrl:(NSString*)postWithUrl param:(NSMutableDictionary*)param ;

@end
