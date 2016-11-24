//
//  MyContentDetailViewController.m
//  Lebao
//
//  Created by David on 16/2/18.
//  Copyright © 2016年 David. All rights reserved.
//
#import "MyContentDetailViewController.h"
#import "EditArticlesViewController.h"//编辑文章
#import "MyArticleDetailView.h"
#import "XLDataService.h"
#import "WetChatShareManager.h"//分享

#define Readdetail [NSString stringWithFormat:@"%@release/detail",HttpURL]
@interface MyContentDetailViewController ()
@property(nonatomic,strong)MyArticleDetailModal *modal;
@property(nonatomic,strong)BaseButton *next;
@property(nonatomic,strong)UIImageView *imageView;
@end
typedef enum{
    
    ButtonActionTagAdd =2,
    
    
}ButtonActionTag;

@implementation MyContentDetailViewController
{
    
    MyArticleDetailView *articleDetailView;
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navView];

    NSMutableDictionary *parame = [Parameter parameterWithSessicon];
    [parame setObject:_uid forKey:@"uid"];
    [parame setObject:_ID forKey:@"acid"];
    [self addMainView:parame];
    
    
}
#pragma mark - Navi_View
- (void)navView
{
  
    [self navViewTitleAndBackBtn:@"详情"];
     __weak MyContentDetailViewController *weakSelf =self;
    BaseButton *share = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 40, StatusBarHeight, 40, NavigationBarHeight) backgroundImage:nil iconImage:[UIImage imageNamed:@"icon_widelyspreaddetail_share"] highlightImage:nil inView:self.view];
    
    share.didClickBtnBlock = ^{
        if (_isNoEdit) {
            [[WetChatShareManager shareInstance] shareToWeixinApp:weakSelf.modal.datas.title desc:@"" image:weakSelf.shareImage  shareID:weakSelf.modal.datas.ID isWxShareSucceedShouldNotice:weakSelf.modal.datas.isreward isAuthen:weakSelf.modal.datas.isgetclue];
        }
        else
        {
        [[WetChatShareManager shareInstance] shareToWeixinAndLocalApp:weakSelf.modal.datas.title desc:@"" image:weakSelf.shareImage  shareID:weakSelf.modal.datas.ID isWxShareSucceedShouldNotice:NO isAuthen:weakSelf.modal.datas.isgetclue InView:weakSelf];
        }
    };
    
    BaseButton *edit = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 80, StatusBarHeight, 40, NavigationBarHeight) backgroundImage:nil iconImage:[UIImage imageNamed:@"icon_widelyspreaddetail_edit"] highlightImage:nil inView:self.view];
    
    edit.didClickBtnBlock = ^{
        
        EditArticlesViewController *edit =allocAndInit(EditArticlesViewController);
        EditArticlesData *data = allocAndInit(EditArticlesData);
        data.content = weakSelf.modal.datas.content;
        data.documentID = weakSelf.modal.datas.ID;
        data.isAddress = weakSelf.modal.datas.isaddress ;
        data.isgetclue = weakSelf.modal.datas.isgetclue;
        data.isRanking = weakSelf.modal.datas.isranking;
        data.title =weakSelf.modal.datas.title;
        data.author =weakSelf.modal.datas.author;
        data.isreward =weakSelf.modal.datas.isreward;
        data.reward = weakSelf.modal.datas.reward;
        data.imageurl = weakSelf.imageurl;
        data.amount = weakSelf.modal.datas.amount;
        
        data.product = weakSelf.modal.product;
        data.productID = weakSelf.modal.datas.productid;
        data.product_imgurl = weakSelf.modal.datas.product_imgurl;
        data.product_isgetclue = weakSelf.modal.datas.product_isgetclue;
        data.product_uid = weakSelf.modal.datas.product_uid;
        data.product_actype = weakSelf.modal.datas.product_actype;
        data.product_industry = weakSelf.modal.datas.product_industry;
        edit.data = data;
        
        PushView(weakSelf, edit);
    };

    edit.hidden = _isNoEdit;
    

}
- (void)addMainView:(NSMutableDictionary *)parame
{
    
    articleDetailView = [[MyArticleDetailView alloc]initWithFrame:frame(0, NavigationBarHeight + StatusBarHeight + 10, APPWIDTH, APPHEIGHT - (NavigationBarHeight + StatusBarHeight)) postWithUrl:Readdetail param:parame modalBlcok:^(MyArticleDetailModal *modal) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
