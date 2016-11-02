//
//  FnyApplyForVC.m
//  Lebao
//
//  Created by adnim on 16/11/2.
//  Copyright © 2016年 David. All rights reserved.
//

#import "FnyApplyForVC.h"
#import "FnyApplyForCell.h"
//#import "MJRefresh.h"
#import "XLDataService.h"
#import "MyDetialViewController.h"
#import "CoreArchive.h"
//#import "ViewController.h"
@interface FnyApplyForVC ()<UITableViewDelegate,UITableViewDataSource,FnyApplyForCellDelegate,UIAlertViewDelegate>

@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSMutableArray *allMeetArr;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation FnyApplyForVC


-(NSMutableArray*)allMeetArr
{
    if (!_allMeetArr) {
        _allMeetArr=[[NSMutableArray alloc]init];
    }
    return _allMeetArr;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reflash:) name:@"KReflashCanMeet" object:nil];
    
}
-(void)reflash:(NSNotification *)notification
{
    for (int i=0;i<self.allMeetArr.count;i++) {
        FnyApplyForCellLayout *layout=self.allMeetArr[i];
        if ([layout.model.userid isEqualToString:notification.object[@"userid"]]) {
            if ([notification.object[@"relation"] isEqualToString:@"1"]) {
                layout.model.relation=1;
                [self.allMeetArr replaceObjectAtIndex:i withObject:layout];
                [self.tableView reloadRowsAtIndexPaths: @[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:NO];
            }
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page=1;
    [self navViewTitleAndBackBtn:@"我的申请"];
    //搜索按钮
    
    [self addTabView];
    
    [self netWorkRefresh:NO andIsLoadMoreData:NO isShouldClearData:YES];
}
- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
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
    if (self.allMeetArr.count==0) {
        [[ToolManager shareInstance] showWithStatus];
    }
    [param setObject:@(_page) forKey:@"page"];
    [param setObject:@"" forKey:@"industrys"];
    //    NSLog(@"param====%@",param);
    [XLDataService putWithUrl:canseeURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        
        if (isRefresh) {
            
            [[ToolManager shareInstance] endHeaderWithRefreshing:self.tableView];
        }
        if (isMoreLoadMoreData) {
            [[ToolManager shareInstance] endFooterWithRefreshing:self.tableView];
        }
        if (isShouldClearData) {
            [self.allMeetArr removeAllObjects];
        }
        if (dataObj) {
            //            NSLog(@"meetObj====%@",dataObj);
            MeetingModel *modal = [MeetingModel mj_objectWithKeyValues:dataObj];
            if (_page ==1) {
                [[ToolManager shareInstance] moreDataStatus:self.tableView];
            }
            if (!modal.datas||modal.datas.count==0) {
                
                [[ToolManager shareInstance] noMoreDataStatus:self.tableView];
                
            }
            
            if (modal.rtcode ==1) {
                [[ToolManager shareInstance]dismiss];
                for (MeetingData *data in modal.datas) {
                    [self.allMeetArr addObject:[[FnyApplyForCellLayout alloc]initCellLayoutWithModel:data]];
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
    
    FnyApplyForCellLayout*layout =(FnyApplyForCellLayout *)_allMeetArr[indexPath.row];
    
    return layout.cellHeight;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allMeetArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FnyApplyForCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MtCell"];
    if(!cell){
        cell=[[FnyApplyForCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MtCell"];
        cell.backgroundColor=[UIColor clearColor];
    }
    FnyApplyForCellLayout *layout=self.allMeetArr[indexPath.row];
    [cell setCellLayout:layout];
    
    [cell setDelegate:self];
    
    return cell;
    
}
#pragma mark
#pragma mark - MeettingTableViewCellDelegate 添加人脉按钮地点击
- (void)tableViewCellDidSeleteCancelBtn:(UIButton *)btn layout:(FnyApplyForCellLayout *)layout
{
    [[ToolManager shareInstance] showWithStatus];
    NSMutableDictionary *param=[Parameter parameterWithSessicon];
    [param setObject:@"connection_add" forKey:@"type"];
    NSLog(@"param===%@",param);
    [XLDataService putWithUrl:connetionCheckedURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if(dataObj){
            [[ToolManager shareInstance] dismiss];
            NSLog(@"dataobj===%@",dataObj);
            if ([dataObj[@"rtcode"] intValue]==1) {
                
               
            }
            else if ([dataObj[@"rtcode"] intValue]==4001){
                [[ToolManager shareInstance]dismiss];
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"去身份认证吗?" message:@"身份认证后才能添加人脉哦" delegate:self cancelButtonTitle:@"不去" otherButtonTitles:@"走起", nil];
                alertView.tag=22221;
                alertView.delegate=self;
                [alertView show];
                
            }
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus];
            
        }
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==22221) {
        if (buttonIndex==0) {
            
        }else if(buttonIndex==1){
            
        }
    }
}
-(void)tableViewCellDidSeleteHeadImg:(LWImageStorage *)imageStoragen layout:(FnyApplyForCellLayout *)layout{
    MyDetialViewController *myDetialViewCT=allocAndInit(MyDetialViewController);
    MeetingData *data=layout.model;
    myDetialViewCT.userID=data.userid;
    [self.navigationController pushViewController:myDetialViewCT animated:YES];
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath//高亮
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
