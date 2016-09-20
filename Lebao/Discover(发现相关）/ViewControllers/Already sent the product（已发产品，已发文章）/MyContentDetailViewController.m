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

#import "MyProductDetailViewController.h"
#import "TheSecondaryHouseViewController.h"
#import "TheSecondCarHomeViewController.h"
#define Readdetail [NSString stringWithFormat:@"%@release/detail",HttpURL]
@interface MyContentDetailViewController ()<UIActionSheetDelegate>
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
  
//    UIButton *rightBtn =[UIButton createButtonWithfFrame:frame(APPWIDTH - 50, StatusBarHeight, 50, NavigationBarHeight) title:nil backgroundImage:nil iconImage:[UIImage imageNamed:@"icon_exhibition_mycontent_add"] highlightImage:nil tag:ButtonActionTagAdd];
//        [rightBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
//        [self navViewTitleAndBackBtn:@"文章详情" rightBtn:rightBtn];
    [self navViewTitleAndBackBtn:@"文章详情"];
    

}
- (void)addMainView:(NSMutableDictionary *)parame
{
    
    __weak MyContentDetailViewController *weakSelf =self;
    
    articleDetailView = [[MyArticleDetailView alloc]initWithFrame:frame(0, NavigationBarHeight + StatusBarHeight + 10, APPWIDTH, APPHEIGHT - (60 + NavigationBarHeight + StatusBarHeight)) postWithUrl:Readdetail param:parame];
    articleDetailView.ishasNextPage = NO;
    articleDetailView.editBlock = ^(MyArticleDetailModal *modal)
    {
     
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
    articleDetailView.modalBlock = ^(MyArticleDetailModal *modal)
    {
         weakSelf.modal =modal;
        [weakSelf addBotoomView:weakSelf];
    };
   
    articleDetailView.isEdit = !_isNoEdit;
    [self.view addSubview:articleDetailView];
}
- (void)addBotoomView:(MyContentDetailViewController *)weakSelf
{
  
    if (weakSelf.modal.datas.productid &&[weakSelf.modal.datas.productid intValue]>0) {
        UIView *_botoomView = allocAndInitWithFrame(UIView, frame(0, APPHEIGHT - 50, APPWIDTH, 50));
        _botoomView.backgroundColor = hexColorAlpha(575757, 1);
        [_botoomView setBorder:LineBg width:0.5];
        [self.view addSubview:_botoomView];
        
        _imageView = allocAndInitWithFrame(UIImageView, frame(10, 10, 50, 30));
        [[ToolManager shareInstance] imageView:_imageView setImageWithURL:weakSelf.modal.datas.product_imgurl placeholderType:PlaceholderTypeImageProcessing];
        [_botoomView addSubview:_imageView];
        
        UILabel *title =  [UILabel createLabelWithFrame:frame(CGRectGetMaxX(_imageView.frame) + 5, 0, frameWidth(_botoomView) - CGRectGetMaxX(_imageView.frame) -70, frameHeight(_botoomView)) text:weakSelf.modal.datas.product_title fontSize:24*SpacedFonts textColor:WhiteColor textAlignment:NSTextAlignmentLeft inView:_botoomView];
        title.numberOfLines = 0;
        
        weakSelf.next = [[BaseButton alloc]initWithFrame:frame(frameWidth(_botoomView) - 60, 10, 50, 30) setTitle:@"查看" titleSize:24*SpacedFonts titleColor:WhiteColor textAlignment:NSTextAlignmentCenter backgroundColor:AppMainColor inView:_botoomView];
        [weakSelf.next setRadius:8];
        
        weakSelf.next.didClickBtnBlock = ^{
            
        if([self.modal.datas.product_industry isEqualToString:@"insurance"]||[self.modal.datas.product_industry isEqualToString:@"finance"]||[self.modal.datas.product_industry isEqualToString:@"other"])
            {
                MyProductDetailViewController *detail = allocAndInit(MyProductDetailViewController);
                detail.shareImage = _imageView.image;
                detail.ID =self.modal.datas.productid;
                detail.uid =self.modal.datas.product_uid;
                detail.imageurl = self.modal.datas.product_imgurl;
                PushView(self, detail);
                
            }
            //这是房产的产品
            else if([self.modal.datas.product_industry isEqualToString:@"property"])
            {
                
                BaseButton *rightBtn = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 50, StatusBarHeight, 50, NavigationBarHeight) setTitle:@"选项" titleSize:28*SpacedFonts titleColor:BlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] inView:nil];
                rightBtn.didClickBtnBlock = ^
                {
                    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"编辑",@"分享", nil];
                    actionSheet.tag =1;
                    [actionSheet showInView:self.view];
                    
                    
                };
                
                [[ToolManager shareInstance] loadWebViewWithUrl:[NSString stringWithFormat:@"%@show/estate?acid=%@",HttpURL,self.modal.datas.productid] title:@"产品详情" pushView:self rightBtn:rightBtn];
                
            }
            
            //这是车行的产品
            else if([self.modal.datas.product_industry isEqualToString:@"car"])
            {
                
                BaseButton *rightBtn = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 50, StatusBarHeight, 50, NavigationBarHeight) setTitle:@"选项" titleSize:28*SpacedFonts titleColor:BlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] inView:nil];
                rightBtn.didClickBtnBlock = ^
                {
                    
                    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"编辑",@"分享", nil];
                    actionSheet.tag =2;
                    [actionSheet showInView:self.view];
                    
                    
                };
                
                [[ToolManager shareInstance] loadWebViewWithUrl:[NSString stringWithFormat:@"%@show/car?acid=%@",HttpURL,self.modal.datas.productid] title:@"产品详情" pushView:self rightBtn:rightBtn];
                
            }

        };
    }
    else
    {
        articleDetailView.frame = frame(frameX(articleDetailView), frameY(articleDetailView), frameWidth(articleDetailView),APPHEIGHT - ( NavigationBarHeight + StatusBarHeight) );
    }
    

    
    BaseButton *share = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 50, StatusBarHeight, 50, NavigationBarHeight) backgroundImage:nil iconImage:[UIImage imageNamed:@"icon_widelyspreaddetail_share"] highlightImage:nil inView:self.view];
    
    share.didClickBtnBlock = ^{

     [[WetChatShareManager shareInstance] shareToWeixinApp:weakSelf.modal.datas.title desc:@"" image:weakSelf.shareImage  shareID:weakSelf.modal.datas.ID isWxShareSucceedShouldNotice:NO isAuthen:weakSelf.modal.datas.isgetclue];
    };

}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        if (actionSheet.tag ==1) {
            TheSecondaryHouseViewController *theSecondaryHouseViewController =  allocAndInit(TheSecondaryHouseViewController);
            theSecondaryHouseViewController.isEdit = YES;
            theSecondaryHouseViewController.acid = self.modal.datas.productid;
            theSecondaryHouseViewController.uid = self.modal.datas.product_uid;
            PushView(self, theSecondaryHouseViewController);
        }
        else
        {
            TheSecondCarHomeViewController *theSecondCarHomeViewController =  allocAndInit(TheSecondCarHomeViewController);
            theSecondCarHomeViewController.isEdit = YES;
            theSecondCarHomeViewController.acid = self.modal.datas.productid;
            theSecondCarHomeViewController.uid = self.modal.datas.product_uid;
            PushView(self, theSecondCarHomeViewController);
        }
        
        
    }else if (buttonIndex == 1) {
        
        [[WetChatShareManager shareInstance] shareToWeixinApp: self.modal.datas.product_title desc:@"" image:_imageView.image  shareID: self.modal.datas.productid isWxShareSucceedShouldNotice:NO isAuthen: self.modal.datas.product_isgetclue];
    }
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
