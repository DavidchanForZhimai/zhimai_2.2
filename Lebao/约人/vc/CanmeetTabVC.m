//
//  CanmeetTabVC.m
//  Lebao
//
//  Created by adnim on 16/9/1.
//  Copyright © 2016年 David. All rights reserved.
//

#import "CanmeetTabVC.h"
#import "MeettingTableViewCell.h"
#import "MJRefresh.h"
#import "SearchAndAddTagsViewController.h"
#import "XLDataService.h"
#import "EjectView.h"
#import "MeetPaydingVC.h"
#import "MyDetialViewController.h"
#import "AddConnectionView.h"
@interface CanmeetTabVC ()<UITableViewDelegate,UITableViewDataSource,MeettingTableViewDelegate,UIAlertViewDelegate,EjectViewDelegate,AddConnectionViewDelegate>
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSMutableArray *allMeetArr;
@end

@implementation CanmeetTabVC

-(NSMutableArray*)allMeetArr
{
    if (!_allMeetArr) {
        _allMeetArr=[[NSMutableArray alloc]init];
    }
    return _allMeetArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _page=1;
    [self navViewTitleAndBackBtn:@""];
    //搜索按钮
    BaseButton *search = [[BaseButton alloc]initWithFrame:frame(60*ScreenMultiple, StatusBarHeight + 7, APPWIDTH - 120*ScreenMultiple, NavigationBarHeight - 14) setTitle:@"搜索" titleSize:28*SpacedFonts titleColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] inView:self.view];
    [search setRoundWithfloat:search.height/2.0];
    [search setBorder:LineBg width:0.5];
    __weak typeof(self) weakSelf= self;
    search.didClickBtnBlock = ^{
        
        PushView(weakSelf, allocAndInit(SearchAndAddTagsViewController));
        
    };
    [self addTabView];

     [self netWorkRefresh:NO andIsLoadMoreData:NO isShouldClearData:NO];
}

- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [param setObject:@(_page) forKey:@"page"];
    [param setObject:@"" forKey:@"keyword"];
    [param setObject:@"" forKey:@"industrys"];
     NSLog(@"param====%@",param);
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
            NSLog(@"meetObj====%@",dataObj);
            MeetingModel *modal = [MeetingModel mj_objectWithKeyValues:dataObj];
            if (_page ==1) {
                [[ToolManager shareInstance] moreDataStatus:self.tableView];
            }
            if (!modal.datas||modal.datas.count==0) {
                
                [[ToolManager shareInstance] noMoreDataStatus:self.tableView];
                
            }
            
            if (modal.rtcode ==1) {
                        for (MeetingData *data in modal.datas) {
                    [self.allMeetArr addObject:[[MeetingCellLayout alloc]initCellLayoutWithModel:data andMeetBtn:NO andMessageBtn:NO andOprationBtn:NO]];
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
    
    MeetingCellLayout*layout =(MeetingCellLayout*)_allMeetArr[indexPath.row];
    
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
    
    MeettingTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MtCell"];
    if(!cell){
       cell=[[MeettingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MtCell"];
    cell.backgroundColor=[UIColor clearColor];
    }
    MeetingCellLayout *layout=self.allMeetArr[indexPath.row];
    [cell setCellLayout:layout];
    [cell setIndexPath:indexPath];
   
    [cell.messageBtn setImage:[UIImage imageNamed:@"keyuejianjiarenmai"] forState:UIControlStateNormal];
    
    [cell setDelegate:self];
    
    return cell;

}
#pragma mark
#pragma mark - MeettingTableViewCellDelegate 添加人脉按钮地点击
- (void)tableViewCellDidSeleteMessageBtn:(UIButton *)btn andIndexPath:(NSIndexPath *)indexPath
{
    CGFloat dilX = 25;
    CGFloat dilH = 250;
    AddConnectionView *alertV = [[AddConnectionView alloc] initAlertViewWithFrame:CGRectMake(dilX, 0, 250, dilH) andSuperView:self.navigationController.view];
    alertV.center = CGPointMake(APPWIDTH/2, APPHEIGHT/2-30);
    alertV.delegate = self;
    alertV.titleStr = @"提示";
    alertV.title2Str=@"打赏让加人脉更顺畅!";

}
#pragma mark - YXCustomAlertViewDelegate
- (void) customAlertView:(AddConnectionView *) customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     MeetingCellLayout *layout=self.allMeetArr[customAlertView.indexth.row];
     MeetingData *model=layout.model;
    if (buttonIndex==0) {
        NSMutableDictionary *param=[Parameter parameterWithSessicon];
        [param setObject:model.userid forKey:@"beinvited"];
        [param setObject:customAlertView.money forKey:@"reward"];
        [XLDataService putWithUrl:addConnectionsURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
            if(dataObj){
                MeetingModel *model=[MeetingModel mj_objectWithKeyValues:dataObj];
                if (model.rtcode==1) {
                    UIAlertView *successAlertV=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"添加人脉请求已发出,请耐心等待" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    successAlertV.cancelButtonIndex=2;
                    [successAlertV show];
                }
                else
                {
                    [[ToolManager shareInstance] showAlertMessage:model.rtmsg];
                }
                NSLog(@"model.rtmsg=========dataobj=%@",model.rtmsg);
            }else
            {
                [[ToolManager shareInstance] showInfoWithStatus];
                
            }
            
        }];
        [customAlertView dissMiss];
        customAlertView = nil;
        
        
    }else
    {
        MeetPaydingVC * payVC = [[MeetPaydingVC alloc]init];
        NSMutableDictionary *param=[Parameter parameterWithSessicon];
        [param setObject:model.userid forKey:@"beinvited"];
        [param setObject:customAlertView.money forKey:@"reward"];
        
        payVC.param=param;
        payVC.jineStr = customAlertView.money;
        payVC.whatZfType=1;
        [self.navigationController pushViewController:payVC animated:YES];
        [customAlertView dissMiss];
        customAlertView = nil;
        
    }
}

-(void)tableViewCellDidSeleteHeadImg:(LWImageStorage *)imageStoragen andIndexPath:(NSIndexPath *)indexPath
{
    MyDetialViewController *myDetialViewCT=allocAndInit(MyDetialViewController);
    myDetialViewCT.isOther=YES;
    MeetingCellLayout *layout=self.allMeetArr[indexPath.row];
    MeetingData *data=layout.model;
    myDetialViewCT.userID=data.userid;
    [self.navigationController pushViewController:myDetialViewCT animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath//高亮
{
    return NO;
}


@end
