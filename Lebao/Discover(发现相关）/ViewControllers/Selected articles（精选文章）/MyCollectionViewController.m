//
//  MyXCollectionViewController.m
//  Lebao
//
//  Created by David on 16/2/16.
//  Copyright © 2016年 David. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "MyContentsArticleCell.h"
#import "XLDataService.h"
#import "MyCollectionDetailViewController.h"
#define cellH 78
//收藏
#define CollectionURL [NSString stringWithFormat:@"%@collection/index",HttpURL]
@interface MyCollectionViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MyCollectionViewController

{
    UITableView *_articleView;
    NSMutableArray *_articleArray;
    int _page;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navViewTitleAndBackBtn:@"我的收藏"];
    _page =1;
    [self addTableView];
    [self netWork:NO isFooter:NO isShouldClear:NO];
    
    
}
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag ==0) {
        PopView(self);
    }
}
#pragma mark
#pragma mark - addTableView -
- (void)addTableView
{
    _articleArray = allocAndInit(NSMutableArray);
    _articleView =[[UITableView alloc]initWithFrame:frame(0,StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)) style:UITableViewStyleGrouped];
    _articleView.delegate = self;
    _articleView.dataSource = self;
    _articleView.backgroundColor =[UIColor clearColor];
    _articleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_articleView];
    
    
    __weak MyCollectionViewController *weakSelf =self;
    [[ToolManager shareInstance] scrollView:_articleView headerWithRefreshingBlock:^{
        _page = 1;
        [weakSelf netWork:YES isFooter:NO isShouldClear:YES];
        
    }];
    
    [[ToolManager shareInstance] scrollView:_articleView footerWithRefreshingBlock:^{
        
        _page ++;
        [weakSelf netWork:NO isFooter:YES isShouldClear:NO];
        
        
    }];
    
}
#pragma mark
#pragma mark - netWork-
- (void)netWork:(BOOL)isRefresh isFooter:(BOOL)isFooter isShouldClear:(BOOL)isShouldClear
{
    
    if (isRefresh) {
        [[ToolManager shareInstance]endHeaderWithRefreshing
         :_articleView];
    }
    if (isFooter) {
        
        [[ToolManager shareInstance]endFooterWithRefreshing:_articleView];
    }
    
    
    NSMutableDictionary *parame = [Parameter parameterWithSessicon];
    [parame setObject:@(_page) forKey:Page];
    [XLDataService postWithUrl:CollectionURL param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
//        NSLog(@"data =%@",dataObj);
        if (dataObj) {
            if (isShouldClear) {
                [_articleArray removeAllObjects];
            }
            myCollectionModal *modal = [myCollectionModal mj_objectWithKeyValues:dataObj];
            if (modal.rtcode ==1) {
                
                for (myCollectionDataModal *data in modal.datas) {
                    
                    [_articleArray addObject:data];
                }
                
                [_articleView reloadData];
                
                if (_articleArray.count==0) {
                    [self isShowEmptyStatus:YES];
                }
                else
                {
                    [self isShowEmptyStatus:NO];
                    
                }

            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus:modal.rtmsg];
            }

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
    
    return _articleArray.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
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
    
    static NSString *cellID =@"MyContentsCollectionCell ";
    MyContentsCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[MyContentsCollectionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:78 cellWidth:frameWidth(_articleView)];
            UIView *view = allocAndInit(UIView);
            view.backgroundColor = self.view
            .backgroundColor;
            cell.selectedBackgroundView =view;
            
        }
        myCollectionDataModal *modal = _articleArray[indexPath.row];
        [cell dataModal:modal];
        return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyContentsCollectionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
     myCollectionDataModal *modal = _articleArray[indexPath.row];
    MyCollectionDetailViewController *detail = allocAndInit(MyCollectionDetailViewController);
//    detail.isAdd = NO;
    detail.ID =modal.ID;
    detail.acid =modal.acid;
    detail.shareImage = cell.icon.image;
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
