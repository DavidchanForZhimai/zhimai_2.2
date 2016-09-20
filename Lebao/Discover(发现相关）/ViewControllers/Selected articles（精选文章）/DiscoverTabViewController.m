//
//  DiscoverTabViewController.m
//  Lebao
//
//  Created by David on 15/12/7.
//  Copyright © 2015年 David. All rights reserved.
//

#import "DiscoverTabViewController.h"
#import "DiscoverCell.h"
#import "XLDataService.h"
#import "DiscoverDetailViewController.h"
#define cellH 86.0
//发现 URL:appinterface/articlelib
#define ArticlelibURL [NSString stringWithFormat:@"%@library/index",HttpURL]

@interface DiscoverTabViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DiscoverTabViewController
{
    UITableView *_discoverTable;
    NSMutableArray *_upDiscoverArray;
    NSMutableArray *_discoverArray;
    int _page;
    int _nowpage;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _page = 1;
    [self addTableView];
    [self netWork:NO isFooter:NO isShouldClear:NO];
}

#pragma mark
#pragma mark - addTableView -
- (void)addTableView
{
    _discoverArray = [NSMutableArray new];
    _upDiscoverArray = [NSMutableArray new];

    _discoverTable =[[UITableView alloc]initWithFrame:frame(0, 0, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight  + 40)) style:UITableViewStyleGrouped];
    _discoverTable.delegate = self;
    _discoverTable.dataSource = self;
    _discoverTable.backgroundColor =[UIColor clearColor];
   _discoverTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_discoverTable];
    
    __weak DiscoverTabViewController *weakSelf =self;
    [[ToolManager shareInstance] scrollView:_discoverTable headerWithRefreshingBlock:^{
        
        _page = 1;
        [[ToolManager shareInstance] moreDataStatus:_discoverTable];
        [weakSelf netWork:YES isFooter:NO isShouldClear:YES];
        
    }];
    
    [[ToolManager shareInstance] scrollView:_discoverTable footerWithRefreshingBlock:^{
        
        _page =_nowpage+1;
        [weakSelf netWork:NO isFooter:YES isShouldClear:NO];
        
        
    }];

}
#pragma mark
#pragma mark - netWork-
- (void)netWork:(BOOL)isRefresh isFooter:(BOOL)isFooter isShouldClear:(BOOL)isShouldClear
{
    if (![Parameter isSession]) {
        if (isRefresh) {
            [[ToolManager shareInstance]endHeaderWithRefreshing
             :_discoverTable];
        }
        if (isFooter) {
            
            [[ToolManager shareInstance]endFooterWithRefreshing:_discoverTable];
        }
        
        return;
    }
    
    if (_discoverArray.count ==0&&_upDiscoverArray.count==0) {
        [[ToolManager shareInstance] showWithStatus];
        
    }
    
    NSMutableDictionary *param = [Parameter parameterWithSessicon];
    NSString *_industry =@"";
    if (_selected == IndustryTagInsurance) {
        _industry =@"insurance";
        
    }
    else if (_selected == IndustryTagFinance) {
        _industry =@"finance";
        
    }
    else if (_selected == IndustryTagProperty) {
       _industry =@"property";
       
   }
    else if (_selected == IndustryTagOther) {
       _industry =@"car";
       
   }
    [param setObject:_industry forKey:Industry];
    [param setObject:@(_page) forKey:Page];
    [XLDataService postWithUrl:ArticlelibURL
            param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
                [[ToolManager shareInstance] dismiss];
                
                if (isRefresh) {
                [[ToolManager shareInstance]endHeaderWithRefreshing
                    :_discoverTable];
                }
                if (isFooter) {
                                 [[ToolManager shareInstance]endFooterWithRefreshing:_discoverTable];
                             }
                             if (dataObj) {
                                
                                 if (isShouldClear) {
                                     [_discoverArray removeAllObjects];
                                     [_upDiscoverArray removeAllObjects];
                                 }
                                 DiscoverModel *model = [DiscoverModel mj_objectWithKeyValues:dataObj];
                                 _nowpage =model.page;
                                 
                                 if (_nowpage ==1) {
                                     [[ToolManager shareInstance] moreDataStatus:_discoverTable];
                                 }
                                 if (model.allpage ==_nowpage) {
                                     [[ToolManager shareInstance] noMoreDataStatus:_discoverTable];
                                 }
                                
                                
                                 if (model.rtcode) {
                                     
                                     for (DiscoverDataModel *data in model.datas) {
                                        
                                             [_discoverArray addObject:data];
                                             
                                         
                                     }
                                     _upDiscoverArray = model.upimg;
                                     
                                     [_discoverTable reloadData];
                                     if (_upDiscoverArray.count==0&&_discoverArray.count==0) {
                                         [self isShowEmptyStatus:YES];
                                     }
                                     else
                                     {
                                         [self isShowEmptyStatus:NO];
                                         
                                     }

                                 }
                                 else
                                 {
                                     [[ToolManager shareInstance] showInfoWithStatus:model.rtmsg];
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
   
    if (_upDiscoverArray.count==0) {
        
        
        return _discoverArray.count;
        
    }
    else
    {
    
        if (section ==1) {
            
            return _discoverArray.count;
            
        }
        else
        {
            return 1;
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_upDiscoverArray.count==0) {
        
        return 1;
    }
    else
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return allocAndInit(UIView);
    
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_upDiscoverArray.count!=0) {
        return 10;
    }
    return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    return allocAndInit(UIView);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0&&_upDiscoverArray.count!=0) {
        
        return 125.0*ScreenMultiple;
    }

    else {
        return cellH;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&_upDiscoverArray.count!=0) {
        static NSString *cellID =@"DiscoverFirstCell";
        DiscoverFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            
            cell = [[DiscoverFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:125.0*ScreenMultiple cellWidth:frameWidth(_discoverTable) datas:_upDiscoverArray
                    ];
            UIView *view = allocAndInit(UIView);
            view.backgroundColor = self.view
            .backgroundColor;
            cell.selectedBackgroundView =view;
            
        }
        __weak DiscoverTabViewController *weakSelf =self;
        [cell.banner setDidClickImageBlock:^(UIImageView *imageView, NSString *url, NSInteger index) {
            DiscoverImageDataModel *modal = _upDiscoverArray[index];
            DiscoverDetailViewController *detail = allocAndInit(DiscoverDetailViewController);
                detail.ID = modal.ID;
                detail.tag = _selected;
                detail.shareImage = imageView.image;
                PushView(weakSelf, detail);
            

        }];

        return cell;
    }
    
    else {
        static NSString *cellID =@"DiscoverCell";
        DiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[DiscoverCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:cellH cellWidth:frameWidth(_discoverTable)];
            UIView *view = allocAndInit(UIView);
            view.backgroundColor = self.view
            .backgroundColor;
            cell.selectedBackgroundView =view;
            
        }
        [cell setModel:_discoverArray[indexPath.row]];
        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DiscoverCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    DiscoverDetailViewController *detail = allocAndInit(DiscoverDetailViewController);
    DiscoverDataModel *modal;
    
    if (indexPath.section ==0&&_upDiscoverArray.count>0) {
        modal = _upDiscoverArray[indexPath.row];
    }
    else
    {
       modal = _discoverArray[indexPath.row];
    }
    detail.ID = modal.ID;
    detail.tag = _selected;
    detail.shareImage= cell.icon.image;
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
