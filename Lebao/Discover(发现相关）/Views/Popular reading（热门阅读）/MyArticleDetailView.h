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
@interface MyArticleDetailView : UIScrollView<IMYWebViewDelegate>
{
    MyArticleDetailModal *modal;
}
@property(nonatomic,strong)IMYWebView *webView;
@property(nonatomic,assign)BOOL isEdit;
@property(nonatomic,assign)BOOL isNextAcid;
@property(nonatomic,assign)BOOL ishasNextPage; //default Yes
@property(nonatomic,strong)NSString *postWithUrl;
@property(nonatomic,strong)NSMutableDictionary *param;
@property(nonatomic,copy)EditBlock editBlock;
@property(nonatomic,copy)ContributionBlock contributionBlock;
@property(nonatomic,copy)ModalBlock modalBlock;
- (instancetype)initWithFrame:(CGRect)frame postWithUrl:(NSString*)postWithUrl param:(NSMutableDictionary*)param ;

@end
