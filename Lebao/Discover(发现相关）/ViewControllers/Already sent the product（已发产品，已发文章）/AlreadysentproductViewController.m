//
//  AlreadysentproductViewController.m
//  Lebao
//
//  Created by David on 16/5/13.
//  Copyright © 2016年 David. All rights reserved.
//

#import "AlreadysentproductViewController.h"
#import "MyContentsArticleCell.h"
#import "XLDataService.h"
#import "MyContentDetailViewController.h"
#import "MyProductDetailViewController.h"
#import "TheSecondaryHouseViewController.h"
#import "TheSecondCarHomeViewController.h"
#import "WetChatShareManager.h"


#define ReleaseCollectURL [NSString stringWithFormat:@"%@release/collect",HttpURL]
//路径
#define ReadrouteURL [NSString stringWithFormat:@"%@release/readroute",HttpURL]

#define ProductURL [NSString stringWithFormat:@"%@product/index",HttpURL]
#define ProductDelURL [NSString stringWithFormat:@"%@product/del",HttpURL]

#define ArticleURL [NSString stringWithFormat:@"%@release/list",HttpURL]
#define ArticleDelURL [NSString stringWithFormat:@"%@release/del",HttpURL]
#define cellH 114
@interface AlreadysentproductViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@end

@implementation AlreadysentproductViewController
{
    UITableView *_productView;
    NSMutableArray *_productArray;
    int _page;
    MyContentsArticleCell *_cell ;
    MyContentDataModal *_modal;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_isArticle) {
        [self navViewTitleAndBackBtn:@"已发文章"];
    }
    else
    {
       [self navViewTitleAndBackBtn:@"已发产品"];
    }
    
    _page =1;
    [self addTableView];
    [self netWork:NO isFooter:NO isShouldClear:NO];
    
    
}
- (void)buttonAction:(UIButton *)sender
{
    if (_ispopToRoot) {
        PopRootView(self);
    }
    else
    PopView(self);
}
#pragma mark
#pragma mark - addTableView -
- (void)addTableView
{
    _productArray = allocAndInit(NSMutableArray);
    _productView =[[UITableView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)) style:UITableViewStyleGrouped];
    _productView.delegate = self;
    _productView.dataSource = self;
    _productView.backgroundColor =[UIColor clearColor];
    _productView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_productView];
    
    
    __weak AlreadysentproductViewController *weakSelf =self;
    [[ToolManager shareInstance] scrollView:_productView headerWithRefreshingBlock:^{
        _page = 1;
        [[ToolManager shareInstance] moreDataStatus:_productView];
        [weakSelf netWork:YES isFooter:NO isShouldClear:YES];
        
    }];
    
    [[ToolManager shareInstance] scrollView:_productView footerWithRefreshingBlock:^{
        
        _page ++;
        [weakSelf netWork:NO isFooter:YES isShouldClear:NO];
        
        
    }];
    
}
#pragma mark
#pragma mark - netWork-
- (void)netWork:(BOOL)isRefresh isFooter:(BOOL)isFooter isShouldClear:(BOOL)isShouldClear
{
    
    NSMutableDictionary *parame = [Parameter parameterWithSessicon];
    [parame setObject:@(_page) forKey:Page];
    
    if (_productArray.count==0) {
        [[ToolManager shareInstance] showWithStatus];
    }
    NSString *url;
    if (_isArticle) {
        url = ArticleURL;
    }
    else
    {
        url = ProductURL;
    }
    [XLDataService postWithUrl:url param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        [[ToolManager shareInstance] dismiss];
        //        NSLog(@"data =%@",dataObj);
        if (isRefresh) {
            [[ToolManager shareInstance]endHeaderWithRefreshing
             :_productView];
        }
        if (isFooter) {
            
            [[ToolManager shareInstance]endFooterWithRefreshing:_productView];
        }
        if (dataObj) {
            if (isShouldClear) {
                [_productArray removeAllObjects];
            }
                MyContentModal *modal = [MyContentModal mj_objectWithKeyValues:dataObj];
                if (modal.allpage <= _page) {
                    [[ToolManager shareInstance] noMoreDataStatus:_productView];
                }
                if (modal.rtcode) {
                    
                    for (MyContentDataModal *data in modal.datas) {
                        
                        [_productArray addObject:data];
                    }
                    
                    
                }
                else
                {
                    [[ToolManager shareInstance] showInfoWithStatus:modal.rtmsg];
                }
                
            
            if (_productArray.count==0) {
                [self isShowEmptyStatus:YES];
            }
            else
            {
                [self isShowEmptyStatus:NO];
                
            }
            
            [_productView reloadData];
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus];
        }
        
    }];
    
    
    
}

#pragma mark
#pragma mark - TableViewDelegate TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _productArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return allocAndInit(UIView);
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    return allocAndInit(UIView);
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return cellH;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    static NSString *cellID =@"MyContentsArticleCell";
    MyContentsArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MyContentsArticleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:cellH cellWidth:frameWidth(_productView)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    MyContentDataModal *modal = _productArray[indexPath.section];
    [cell dataModal:modal deleBlock:^(MyContentDataModal *modal) {
        
        [[ToolManager shareInstance] showAlertViewTitle:@"您确定要删除该内容吗?"  contentText:nil showAlertViewBlcok:^{
            NSMutableDictionary *parame = [Parameter parameterWithSessicon];
            [parame setObject:modal.ID forKey:@"acid"];
            NSString *url;
            if (_isArticle) {
                url = ArticleDelURL;
            }
            else
            {
                url = ProductDelURL;
            }

            [XLDataService postWithUrl:url param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
                //                NSLog(@"data =%@",dataObj);
                if (dataObj) {
                    if ([dataObj[@"rtcode"] integerValue] ==1) {
                        NSMutableArray *array = _productArray;
                        for (int i = 0; i<array.count; i++) {
                            MyContentDataModal *modalData = array[i];
                            if ([modalData.ID isEqualToString:modal.ID]) {
                                
                                [_productArray removeObjectAtIndex:i];
                                [_productView reloadData];
                            }
                        }
                        
                    }
                    else
                    {
                        [[ToolManager shareInstance] showInfoWithStatus:dataObj[@"rtmsg"]];
                    }
                }
                else
                {
                    [[ToolManager shareInstance] showInfoWithStatus];
                }
                
                
            }];
            
        }];
        
        
    } pathBlock:^(MyContentDataModal *modal) {
        
        NSMutableDictionary *parame = [Parameter parameterWithSessicon];
        [parame setObject:modal.ID forKey:@"acid"];
        [[ToolManager shareInstance] showWithStatus:@"读取数据中..."];
        [XLDataService postWithUrl:ReadrouteURL param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
            //            NSLog(@"data =%@",dataObj);
            if (dataObj) {
                if ([dataObj[@"rtcode"] integerValue] ==1) {
                    [[ToolManager shareInstance] dismiss];
                    
                    [[ToolManager shareInstance] loadWebViewWithUrl:dataObj[@"url"] title:@"阅读路径" pushView:self rightBtn:nil];
                }
                else
                {
                    [[ToolManager shareInstance] showInfoWithStatus:dataObj[@"rtmsg"]];
                }
            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus];
            }
            
        }];
        
    } myfluence:^(MyContentDataModal *modal) {
        NSMutableDictionary *parame = [Parameter parameterWithSessicon];
        [parame setObject:modal.ID forKey:@"acid"];
        [[ToolManager shareInstance] showWithStatus:@"读取数据中..."];
        [XLDataService postWithUrl:ReleaseCollectURL param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
            //            NSLog(@"data =%@",dataObj);
            if (dataObj) {
                if ([dataObj[@"rtcode"] integerValue] ==1) {
                    [[ToolManager shareInstance] dismiss];
                    
                    [[ToolManager shareInstance] loadWebViewWithUrl:dataObj[@"url"] title:@"我的影响" pushView:self rightBtn:nil];
                }
                else
                {
                    [[ToolManager shareInstance] showInfoWithStatus:dataObj[@"rtmsg"]];
                }
            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus];
            }
            
        }];
 
    }];
   
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     __weak AlreadysentproductViewController *weakSelf = self;
        _cell = [tableView cellForRowAtIndexPath:indexPath];
        _modal = _productArray[indexPath.section];
    if (_isArticle) {
        MyContentDetailViewController *detail = allocAndInit(MyContentDetailViewController);
        detail.shareImage = _cell.icon.image;
        detail.ID =_modal.ID;
        detail.uid =_modal.uid;
        detail.imageurl = _modal.imgurl;
        PushView(self, detail);
    }
    else
    {
        if ([_modal.actype isEqualToString:@"article"]) {
            MyContentDetailViewController *detail = allocAndInit(MyContentDetailViewController);
            detail.shareImage = _cell.icon.image;
            detail.ID =_modal.ID;
            detail.uid =_modal.uid;
            detail.imageurl = _modal.imgurl;
            PushView(self, detail);
        }
        else if([_modal.industry isEqualToString:@"insurance"]||[_modal.industry isEqualToString:@"finance"]||[_modal.industry isEqualToString:@"other"])
        {
            MyProductDetailViewController *detail = allocAndInit(MyProductDetailViewController);
            detail.shareImage = _cell.icon.image;
            detail.ID =_modal.ID;
            detail.uid =_modal.uid;
            detail.imageurl = _modal.imgurl;
            PushView(self, detail);
            
        }
        //这是房产的产品
        else if([_modal.industry isEqualToString:@"property"])
        {
           
            BaseButton *rightBtn = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 50, StatusBarHeight, 50, NavigationBarHeight) setTitle:@"选项" titleSize:28*SpacedFonts titleColor:BlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] inView:nil];
            rightBtn.didClickBtnBlock = ^
            {
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"编辑",@"分享", nil];
                actionSheet.tag =1;
                [actionSheet showInView:self.view];
                
                
            };
            
            [[ToolManager shareInstance] loadWebViewWithUrl:[NSString stringWithFormat:@"%@show/estate?acid=%@",HttpURL,_modal.ID] title:@"产品详情" pushView:self rightBtn:rightBtn];
            
            
            
        }
        
        //这是车行的产品
        else if([_modal.industry isEqualToString:@"car"])
        {
            
            BaseButton *rightBtn = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 50, StatusBarHeight, 50, NavigationBarHeight) setTitle:@"选项" titleSize:28*SpacedFonts titleColor:BlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] inView:nil];
            rightBtn.didClickBtnBlock = ^
            {
                
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"编辑",@"分享", nil];
                actionSheet.tag =2;
                [actionSheet showInView:self.view];
                
                
            };
            
            [[ToolManager shareInstance] loadWebViewWithUrl:[NSString stringWithFormat:@"%@show/car?acid=%@",HttpURL,_modal.ID] title:@"Ta的服务" pushView:self rightBtn:rightBtn];
            
        }
        
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    
    if (buttonIndex == 0) {
        
        if (actionSheet.tag ==1) {
            TheSecondaryHouseViewController *theSecondaryHouseViewController =  allocAndInit(TheSecondaryHouseViewController);
            theSecondaryHouseViewController.isEdit = YES;
            theSecondaryHouseViewController.acid = _modal.ID;
            theSecondaryHouseViewController.uid = _modal.uid;
            PushView(self, theSecondaryHouseViewController);
        }
        else
        {
            TheSecondCarHomeViewController *theSecondCarHomeViewController =  allocAndInit(TheSecondCarHomeViewController);
            theSecondCarHomeViewController.isEdit = YES;
            theSecondCarHomeViewController.acid = _modal.ID;
            theSecondCarHomeViewController.uid = _modal.uid;
            PushView(self, theSecondCarHomeViewController);
        }
        
        
    }else if (buttonIndex == 1) {
        
        [[WetChatShareManager shareInstance] shareToWeixinApp:_modal.title desc:@"" image:_cell.icon.image  shareID:_modal.ID isWxShareSucceedShouldNotice:NO isAuthen:_modal.isgetclue];
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
