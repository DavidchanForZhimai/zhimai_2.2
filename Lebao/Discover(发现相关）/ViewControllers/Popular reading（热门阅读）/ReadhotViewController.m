//
//  ReadhotViewController.m
//  Lebao
//
//  Created by David on 16/5/13.
//  Copyright © 2016年 David. All rights reserved.
//

#import "ReadhotViewController.h"
#import "XLDataService.h"
#import "WidelySpreadDetailViewController.h"
#import "ExhibitionIndustryCell.h"
#define ReadHot [NSString stringWithFormat:@"%@release/hot",HttpURL]
#define cellH 153.0/2
@interface ReadhotViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ReadhotViewController
{
    UITableView *_exhibitionReadHotView;
    NSMutableArray *_exhibitionReadHotArray;
    int page;
    int nowPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    page = 1;
    [self navViewTitleAndBackBtn:@"热门阅读"];
    [self addTableView];
    [self netWorkIsRefresh:NO isLoadMore:NO shouldClearData:YES];
    
    
}
- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
}
#pragma mark
#pragma mark - addTableView -
- (void)addTableView
{
    _exhibitionReadHotArray = [NSMutableArray new];
    
    _exhibitionReadHotView =[[UITableView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)) style:UITableViewStyleGrouped];
    _exhibitionReadHotView.delegate = self;
    _exhibitionReadHotView.dataSource = self;
    _exhibitionReadHotView.backgroundColor =[UIColor clearColor];
    
    [[ToolManager shareInstance] scrollView:_exhibitionReadHotView headerWithRefreshingBlock:^{
        page =nowPage;
        [self netWorkIsRefresh:YES isLoadMore:NO shouldClearData:YES];
    }];
    [[ToolManager shareInstance] scrollView:_exhibitionReadHotView footerWithRefreshingBlock:^{
        
        page =nowPage+ 1;
        [self netWorkIsRefresh:NO isLoadMore:YES shouldClearData:NO];
        
        
    }];
    [self.view addSubview:_exhibitionReadHotView];
}
#pragma mark
#pragma mark - netWork
- (void)netWorkIsRefresh:(BOOL)isRefresh isLoadMore:(BOOL)isLoadMore shouldClearData:(BOOL)shouldClearData
{
    
    if (_exhibitionReadHotArray.count==0) {
        
        [[ToolManager shareInstance] showWithStatus:@"加载数据..."];
        
    }
    
    NSMutableDictionary *param = [Parameter parameterWithSessicon];
    [param setObject:@(page) forKey:@"page"];
//    NSLog(@"%@ =%@",param,ReadHot);
    [XLDataService postWithUrl:ReadHot param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (isRefresh) {
            [[ToolManager shareInstance] endHeaderWithRefreshing:_exhibitionReadHotView];
        }
        if (isLoadMore) {
            [[ToolManager shareInstance] endFooterWithRefreshing:_exhibitionReadHotView];
        }
        if (dataObj) {
            
            if ([dataObj[@"rtcode"] integerValue]==1) {
                [[ToolManager shareInstance] dismiss];
                if (shouldClearData) {
                    [_exhibitionReadHotArray removeAllObjects];
                }
                nowPage =[dataObj[@"page"] intValue];
                if (nowPage ==1) {
                    [[ToolManager shareInstance] moreDataStatus:_exhibitionReadHotView];
                }
                if (nowPage ==[dataObj[@"allpage"] intValue]) {
                    
                    [[ToolManager shareInstance] noMoreDataStatus:_exhibitionReadHotView];
                }
                
                for (NSDictionary *datas in dataObj[@"datas"]) {
                    ExhibitionIndustryReadmost *data = [ExhibitionIndustryReadmost mj_objectWithKeyValues:datas];
                    [_exhibitionReadHotArray addObject:data];
                }
                [_exhibitionReadHotView reloadData];
                if (_exhibitionReadHotArray.count==0) {
                    
                    [self isShowEmptyStatus:YES];
                }
                else
                {
                    [self isShowEmptyStatus:NO];
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
#pragma mark
#pragma mark - TableViewDelegate TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _exhibitionReadHotArray.count;
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *footer = allocAndInitWithFrame(UIView, frame(0, 0,0,0));
    
    return footer;
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
    
    static NSString *cellID =@"ExhibitionIndustryCell";
    ExhibitionIndustryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ExhibitionIndustryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:cellH cellWidth:frameWidth(_exhibitionReadHotView)];
        
        
    }
    ExhibitionIndustryReadmost *data = _exhibitionReadHotArray[indexPath.row];
    [cell setData:data];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ExhibitionIndustryReadmost *data = _exhibitionReadHotArray[indexPath.row];
    WidelySpreadDetailViewController *widelySpreadDetailViewController = allocAndInit(WidelySpreadDetailViewController);
    ExhibitionIndustryCell *cell = [_exhibitionReadHotView cellForRowAtIndexPath:indexPath];
    widelySpreadDetailViewController.ID= [NSString stringWithFormat:@"%i",(int)data.ID
                                          ];
    widelySpreadDetailViewController.shareImage =cell.icon.image;
    PushView(self, widelySpreadDetailViewController);
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
