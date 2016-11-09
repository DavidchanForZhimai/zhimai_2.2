//
//  EvaluateVC.m
//  Lebao
//
//  Created by adnim on 16/10/26.
//  Copyright © 2016年 David. All rights reserved.
//

#import "EvaluateVC.h"
#import "XLDataService.h"
#import "MeetingModel.h"
#import "EvaluateLayout.h"
#import "EvaluateCell.h"
#import "MyDetialViewController.h"
@interface EvaluateVC ()<UITableViewDelegate,UITableViewDataSource>
{
    int _page;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *evaluateArr;
@end

@implementation EvaluateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navViewTitleAndBackBtn:@"约见评价"];
    _page=1;
    [self addTabView];
    [self netWorkRefresh:NO andIsLoadMoreData:NO isShouldClearData:YES];
}
-(NSMutableArray *)evaluateArr
{
    if (!_evaluateArr) {
        _evaluateArr=[[NSMutableArray alloc]init];
    }
    return _evaluateArr;
}
-(void)addTabView
{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT-(StatusBarHeight + NavigationBarHeight) ) style:UITableViewStyleGrouped];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;//去掉cell间的白线
    [[ToolManager shareInstance] scrollView:self.tableView headerWithRefreshingBlock:^{
        
        _page =1;
        [self netWorkRefresh:YES andIsLoadMoreData:NO isShouldClearData:YES];
        
    }];
    [[ToolManager shareInstance] scrollView:self.tableView footerWithRefreshingBlock:^{
        _page ++;
        [self netWorkRefresh:NO andIsLoadMoreData:YES isShouldClearData:NO];
        
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    
    
}

- (void)netWorkRefresh:(BOOL)isRefresh andIsLoadMoreData:(BOOL)isMoreLoadMoreData isShouldClearData:(BOOL)isShouldClearData//加载数据
{
    
    NSMutableDictionary *param = [Parameter parameterWithSessicon];
    if (self.evaluateArr.count==0) {
        [[ToolManager shareInstance] showWithStatus];
    }
    [param setObject:@(_page) forKey:@"page"];
    [param setObject:_userid forKey:@"id"];
        NSLog(@"param====%@",param);
    [XLDataService putWithUrl:evaluatelistURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        
        if (isRefresh) {
            
            [[ToolManager shareInstance] endHeaderWithRefreshing:self.tableView];
        }
        if (isMoreLoadMoreData) {
            [[ToolManager shareInstance] endFooterWithRefreshing:self.tableView];
        }
        
        if (dataObj) {
                        NSLog(@"meetObj====%@",dataObj);
            MeetingModel *modal = [MeetingModel mj_objectWithKeyValues:dataObj];
            if (_page ==1) {
                [[ToolManager shareInstance] moreDataStatus:self.tableView];
            }
            if (!modal.datas||modal.datas.count==0) {
                
                [[ToolManager shareInstance] noMoreDataStatus:self.tableView];
                
            }
            
            if (modal.rtcode ==1) {
                [[ToolManager shareInstance]dismiss];
                if (isShouldClearData) {
                    [self.evaluateArr removeAllObjects];
                }
                for (MeetingData *data in modal.datas) {
                    [self.evaluateArr addObject:[[EvaluateLayout alloc]initCellLayoutWithModel:data]];
                }
                [self.tableView reloadData];
            }
            else
            {
                [[ToolManager shareInstance] showAlertMessage:modal.rtmsg];
            }
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus];
        }
        
    }];
    
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EvaluateLayout*layout =(EvaluateLayout*)_evaluateArr[indexPath.row];
    
    return layout.cellHeight;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.evaluateArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EvaluateCell *cell=[tableView dequeueReusableCellWithIdentifier:@"EvaluateCell"];
    if(!cell){
        cell=[[EvaluateCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EvaluateCell"];
        cell.backgroundColor=[UIColor clearColor];
    }
    EvaluateLayout *layout=self.evaluateArr[indexPath.row];
    [cell setEvaluateLayout:layout];
    [cell setIndexPath:indexPath];
    
//    cell.delegat=self;
    return cell;
    
}
//-(void)tableViewCellDidSeleteHeadImg:(LWImageStorage *)imageStoragen layout:(EvaluateLayout *)layout{
//    MyDetialViewController *myDetialViewCT=allocAndInit(MyDetialViewController);
//    MeetingData *data=layout.model;
//    myDetialViewCT.userID=data.meetId;
//    [self.navigationController pushViewController:myDetialViewCT animated:YES];
//}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath//高亮
{
    return NO;
}
- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
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
