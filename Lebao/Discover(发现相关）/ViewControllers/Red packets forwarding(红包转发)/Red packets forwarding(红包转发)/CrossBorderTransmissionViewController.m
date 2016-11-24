//
//  CrossBorderTransmissionViewController.m
//  Lebao
//
//  Created by David on 16/3/18.
//  Copyright © 2016年 David. All rights reserved.
//

#import "CrossBorderTransmissionViewController.h"
#import "MyArticleDetailView.h"
#import "WetChatShareManager.h"//分享
#import "EditArticlesViewController.h"
//首页传播最广详情
#define ReaddetailURL [NSString stringWithFormat:@"%@release/detail",HttpURL]
@interface CrossBorderTransmissionViewController ()
@property(nonatomic,strong)MyArticleDetailModal *modal;
@end

@implementation CrossBorderTransmissionViewController
{
    MyArticleDetailView *articleDetailView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navView];
    
    NSMutableDictionary *parame = [Parameter parameterWithSessicon];
    //    [parame setObject:@"read" forKey:Conduct];
    [parame setObject:_ID forKey:@"acid"];
    [parame setObject:_actype forKey:@"actype"];
    [parame setObject:_industry forKey:@"industry"];
    [parame setObject:_uid forKey:@"uid"];
    [self addMainView:parame];
    
}
#pragma mark - Navi_View
- (void)navView
{
    
    [self navViewTitleAndBackBtn:_nav_title];
     __weak CrossBorderTransmissionViewController *weakSelf = self;
    BaseButton *share = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 40, StatusBarHeight, 40, NavigationBarHeight) backgroundImage:nil iconImage:[UIImage imageNamed:@"icon_widelyspreaddetail_share"] highlightImage:nil inView:self.view];
    
    share.didClickBtnBlock = ^{
        
       [[WetChatShareManager shareInstance] shareToWeixinApp:weakSelf.modal.datas.title desc:@"" image:weakSelf.shareImage  shareID:weakSelf.modal.datas.ID isWxShareSucceedShouldNotice:weakSelf.modal.datas.isreward isAuthen:weakSelf.modal.datas.isgetclue];
    };
    
    
}
- (void)addMainView:(NSMutableDictionary *)parame
{
    
    articleDetailView = [[MyArticleDetailView alloc]initWithFrame:frame(0, NavigationBarHeight + StatusBarHeight + 10, APPWIDTH, APPHEIGHT - ( NavigationBarHeight + StatusBarHeight)) postWithUrl:ReaddetailURL param:parame modalBlcok:^(MyArticleDetailModal *modal) {
        _modal = modal;
    }];
  
    [self.view addSubview:articleDetailView];
}
#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag ==NavViewButtonActionNavLeftBtnTag ) {
        PopView(self);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
