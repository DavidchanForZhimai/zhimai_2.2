//
//  WidelySpreadDetailViewController.m
//  Lebao
//
//  Created by David on 16/3/2.
//  Copyright © 2016年 David. All rights reserved.
//

#import "WidelySpreadDetailViewController.h"
#import "MyArticleDetailView.h"
#import "WetChatShareManager.h"
//首页传播最广详情
#define ReaddetailURL [NSString stringWithFormat:@"%@release/detail-hot",HttpURL]
@interface WidelySpreadDetailViewController ()
@property(nonatomic,strong)MyArticleDetailModal *modal;
@end

@implementation WidelySpreadDetailViewController
{
    MyArticleDetailView *articleDetailView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self navView];
    
    NSMutableDictionary *parame = [Parameter parameterWithSessicon];
//    [parame setObject:@"read" forKey:Conduct];
    [parame setObject:_ID forKey:@"acid"];
    [self addMainView:parame];
 
}
#pragma mark - Navi_View
- (void)navView
{
    
   [self navViewTitleAndBackBtn:@"热门阅读"];
   
   
}
- (void)addMainView:(NSMutableDictionary *)parame
{

    articleDetailView = [[MyArticleDetailView alloc]initWithFrame:frame(0, NavigationBarHeight + StatusBarHeight + 10, APPWIDTH, APPHEIGHT - ( NavigationBarHeight + StatusBarHeight)) postWithUrl:ReaddetailURL param:parame];
    articleDetailView.isEdit = NO;
    articleDetailView.isNextAcid = YES;
    articleDetailView.ishasNextPage  = NO;
    __weak WidelySpreadDetailViewController *weakSelf = self;
    articleDetailView.modalBlock = ^(MyArticleDetailModal *modal)
    {
         weakSelf.modal = modal;
        [weakSelf twoBtn:weakSelf];
        
    };
    [self.view addSubview:articleDetailView];
}
#pragma mark
#pragma mark - 
- (void)twoBtn:(WidelySpreadDetailViewController *)weakSelf
{
    BaseButton *share = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 50, StatusBarHeight, 50, NavigationBarHeight) backgroundImage:nil iconImage:[UIImage imageNamed:@"icon_widelyspreaddetail_share"] highlightImage:nil inView:self.view];
    share.didClickBtnBlock = ^
    {
        NSArray *arrays =[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"显示自己微名片",@"title",@"1",@"item", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"是否参与排名",@"title",@"1",@"item", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"是否显示原作者",@"title",@"1",@"item", nil], nil];
        
        [[WetChatShareManager shareInstance] showLocalShareView:arrays otherParamer:[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"acid",@"key",weakSelf.modal.datas.ID,@"value", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"iswechat",@"key",@"1",@"value", nil], nil] title: _modal.datas.title desc: @"" image:_shareImage shareID:_modal.datas.ID isWxShareSucceedShouldNotice:NO isAuthen:YES];
        
    };
//    BaseButton *collect = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 80, StatusBarHeight, 40, NavigationBarHeight) backgroundImage:nil iconImage:[UIImage imageNamed:@"icon_widelyspreaddetail_collect"] highlightImage:nil inView:self.view];
//    collect.didClickBtnBlock = ^
//    {
//        
//    };
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
