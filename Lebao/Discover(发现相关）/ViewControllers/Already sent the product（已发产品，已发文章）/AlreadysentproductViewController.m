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
#import "WetChatShareManager.h"
#import "CooperateView.h"//发布分享文章

#define ReleaseCollectURL [NSString stringWithFormat:@"%@release/collect",HttpURL]
//路径
#define ReadrouteURL [NSString stringWithFormat:@"%@release/readroute",HttpURL]

#define ArticleURL [NSString stringWithFormat:@"%@release/list",HttpURL]
#define ArticleDelURL [NSString stringWithFormat:@"%@release/del",HttpURL]

#define DynamicWriteURL [NSString stringWithFormat:@"%@dynamic/write",HttpURL]
#define cellH 115
@interface AlreadysentproductViewController ()<UITableViewDataSource,UITableViewDelegate>

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
    
    [self navViewTitleAndBackBtn:_isRedActicleAddPush?@"设置红包文章":@"我的文章"];
    
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
    
    [XLDataService postWithUrl:ArticleURL param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        [[ToolManager shareInstance] dismiss];
//                NSLog(@"data =%@",dataObj);
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
    if (section==0) {
        return 10;
    }
    return _isRedActicleAddPush?0.01:10.0;
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
   
    return _isRedActicleAddPush?75:cellH;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID =@"MyContentsArticleCell";
    MyContentsArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MyContentsArticleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:_isRedActicleAddPush?75:cellH cellWidth:frameWidth(_productView) isRedAdd:_isRedActicleAddPush];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    MyContentDataModal *modal = _productArray[indexPath.section];
    [cell dataModal:modal editBlock:^(MyContentDataModal *modal, EditType type) {
        
        if (type == EditDeleType) {
            NSMutableDictionary *parame = [Parameter parameterWithSessicon];
            [parame setObject:modal.ID forKey:@"acid"];
            [XLDataService postWithUrl:ArticleDelURL param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
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
            
            
        }
        else
        {
            
            CooperateView *cooperateView = [[CooperateView alloc]initAlertViewWithFrame:CGRectMake(20, 0, APPWIDTH - 40, APPHEIGHT) LogFieldDefaultText:@"想说点什么吗？" andSuperView:self.view];
            cooperateView.titleStr=@"分享到动态";
            cooperateView.center = self.view.center;
            
            cooperateView.sureblock = ^(CooperateView *customAlertView,NSString *logFieldText)
            {
                NSMutableDictionary *parame = [Parameter parameterWithSessicon];
                [parame setValue:logFieldText forKey:@"content"];
                [parame setValue:@"2" forKey:@"type"];
                [parame setValue:modal.ID forKey:@"acid"];
                
                [[ToolManager shareInstance] showWithStatus];
                [XLDataService postWithUrl:DynamicWriteURL param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
                    if (dataObj) {
                        if ([dataObj[@"rtcode"] integerValue] ==1) {
                            
                            [[ToolManager shareInstance] showSuccessWithStatus:@"分享成功！"];
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
                
                
            };
            
            
            
        }
        
        
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
    _cell = [tableView cellForRowAtIndexPath:indexPath];
    _modal = _productArray[indexPath.section];
    
    MyContentDetailViewController *detail = allocAndInit(MyContentDetailViewController);
    detail.shareImage = _cell.icon.image;
    detail.ID =_modal.ID;
    detail.uid =_modal.uid;
    detail.imageurl = _modal.imgurl;
    detail.nav_title = _modal.title;
    PushView(self, detail);
    
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
