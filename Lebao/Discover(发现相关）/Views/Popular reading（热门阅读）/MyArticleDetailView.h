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

typedef void (^ModalBlock) (MyArticleDetailModal *modal);

typedef void (^EnterDetailBlock) (UIViewController * viewContoller);
@interface MyArticleDetailView : UIScrollView<IMYWebViewDelegate>
{
    MyArticleDetailModal *modal;
}
@property(nonatomic,strong)IMYWebView *webView;
@property(nonatomic,strong)NSString *postWithUrl;
@property(nonatomic,strong)NSMutableDictionary *param;
@property(nonatomic,copy) ModalBlock modalBlcok;
- (instancetype)initWithFrame:(CGRect)frame postWithUrl:(NSString*)postWithUrl param:(NSMutableDictionary*)param modalBlcok:(ModalBlock)modalBlcok;

@end
