//
//  MyCollectionDetailViewController.m
//  Lebao
//
//  Created by David on 16/2/16.
//  Copyright © 2016年 David. All rights reserved.
//

#import "MyCollectionDetailViewController.h"
#import "MyArticleDetailView.h"
#import "WetChatShareManager.h"
//收藏
#define CollectionURL [NSString stringWithFormat:@"%@collection/detail",HttpURL]
@interface MyCollectionDetailViewController ()
@property(nonatomic,strong)MyArticleDetailModal *modal;
@property(nonatomic,strong)BaseButton *next;
@property(nonatomic,strong)MyArticleDetailView *articleDetailView;
@end
typedef enum{
    
    ButtonActionTagAdd =2,
    
    
}ButtonActionTag;

@implementation MyCollectionDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navView];
    NSMutableDictionary *parame = [Parameter parameterWithSessicon];
    [parame setObject:_acid forKey:@"acid"];
    [self addMainView:parame];
    
}
#pragma mark - Navi_View
- (void)navView
{
    if (_isAdd) {
//        UIButton *rightBtn =[UIButton createButtonWithfFrame:frame(APPWIDTH - 50, StatusBarHeight, 50, NavigationBarHeight) title:nil backgroundImage:nil iconImage:[UIImage imageNamed:@"icon_exhibition_mycontent_add"] highlightImage:nil tag:ButtonActionTagAdd];
//        [rightBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
//        [self navViewTitleAndBackBtn:@"收藏详情" rightBtn:rightBtn];
        [self navViewTitleAndBackBtn:@"收藏详情"];
    }
    else
    {
        [self navViewTitleAndBackBtn:@"收藏详情"];
    }
    
    
}
- (void)addMainView:(NSMutableDictionary *)parame
{
    
    __weak MyCollectionDetailViewController *weakself =self;
    _articleDetailView = [[MyArticleDetailView alloc]initWithFrame:frame(0, NavigationBarHeight + StatusBarHeight + 10, APPWIDTH, APPHEIGHT - (60 + NavigationBarHeight + StatusBarHeight)) postWithUrl:CollectionURL param:parame];
    _articleDetailView.modalBlock = ^(MyArticleDetailModal *modal)
    {
        weakself.modal = modal;
        [weakself addBotoomView:weakself];
    };
    _articleDetailView.isEdit = NO;
    _articleDetailView.ishasNextPage = NO;
    [self.view addSubview:_articleDetailView];
    
}
- (void)addBotoomView:(MyCollectionDetailViewController *)weakSelf
{
    UIView *_botoomView = allocAndInitWithFrame(UIView, frame(0, APPHEIGHT - 50, APPWIDTH, 50));
    _botoomView.backgroundColor = WhiteColor;
    [_botoomView setBorder:LineBg width:0.5];
    [self.view addSubview:_botoomView];
    
//    BaseButton *_share = [[BaseButton alloc]initWithFrame:frame(12*ScreenMultiple, 8, 115*ScreenMultiple, 34) setTitle:@"分享" titleSize:26*SpacedFonts titleColor:AppMainColor textAlignment:NSTextAlignmentCenter backgroundColor:WhiteColor inView:_botoomView];
//    [_share setBorder:AppMainColor width:0.5];
//    [_share setRoundWithfloat:frameWidth(_share)/8.0];
    
    _next = [[BaseButton alloc]initWithFrame:frame((frameWidth(_botoomView) - 115*ScreenMultiple)/2.0, 8, 115*ScreenMultiple, 34) setTitle:@"分享" titleSize:26*SpacedFonts titleColor:BlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:WhiteColor inView:_botoomView];
    [_next setBorder:LightBlackTitleColor width:0.5];
    [_next setRoundWithfloat:frameWidth(_next)/8.0];
    _next.didClickBtnBlock = ^
    {
//        if ([weakSelf.modal.datas.next_id intValue] ==0) {
//            
//        [[ToolManager shareInstance] showInfoWithStatus:@"没有下一篇了"];
//            return ;
//        }
//        [weakSelf.articleDetailView setContentOffset:CGPointMake(0, 0) animated:YES];
//        NSMutableDictionary *parame = [Parameter parameterWithSessicon];
//        [parame setObject:@"next" forKey:Conduct];
//        [parame setObject:weakSelf.modal.datas.next_id forKey:ConductID];
//        [parame setObject:weakSelf.modal.datas.next_acid forKey:@"acid"];
//        [weakSelf addMainView:parame];
//       [[WetChatShareManager shareInstance] shareToWeixinApp:weakSelf.modal.datas.title desc:@"" image:weakSelf.shareImage  shareID:weakSelf.modal.datas.ID isWxShareSucceedShouldNotice:NO isAuthen:YES];
        
        NSArray *arrays =[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"显示自己微名片",@"title",@"1",@"item", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"是否参与排名",@"title",@"1",@"item", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"是否显示原作者",@"title",@"1",@"item", nil], nil];
        
        [[WetChatShareManager shareInstance] showLocalShareView:arrays otherParamer:[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"acid",@"key",weakSelf.modal.datas.ID,@"value", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"iswechat",@"key",@"1",@"value", nil], nil] title: weakSelf.modal.datas.title desc: @"" image:weakSelf.shareImage shareID:weakSelf.modal.datas.ID isWxShareSucceedShouldNotice:NO isAuthen:YES];
    };
}
#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag ==NavViewButtonActionNavLeftBtnTag ) {
        PopView(self);
    }
    else if (sender.tag ==ButtonActionTagAdd)
    {
        [[ToolManager shareInstance] addReleseDctView:self];
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

@implementation MyCollectionDetailModal


@end
