//
//  ConnectionsRequestVC.m
//  Lebao
//
//  Created by adnim on 16/9/20.
//  Copyright © 2016年 David. All rights reserved.
//

#import "ConnectionsRequestVC.h"
#import "MJRefresh.h"
#import "MeettingTableViewCell.h"
#import "CoreArchive.h"
#import "ViewController.h"
#import "XLDataService.h"
#import "Parameter.h"
#import "LoCationManager.h"
#import "EjectView.h"
#import "MeetPaydingVC.h"
#import "NSString+Extend.h"
@interface ConnectionsRequestVC ()<UITableViewDelegate,UITableViewDataSource,MeettingTableViewDelegate,UIAlertViewDelegate>
{
    BOOL audioMark;
}
@property (nonatomic,strong)UITableView *yrTab;
@property (nonatomic,assign)int page;
@property (nonatomic,strong)NSMutableArray *nearByManArr;
@property (nonatomic,assign)BOOL isopen;
@end

@implementation ConnectionsRequestVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    audioMark=NO;
    
}

-(NSMutableArray *)nearByManArr
{
    if (!_nearByManArr) {
        _nearByManArr=[[NSMutableArray alloc]init];
    }
    return _nearByManArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //新版本提示
    [[ToolManager shareInstance]update];
    
    [self navViewTitleAndBackBtn:@"人脉请求"];
    
    self.view.backgroundColor=AppViewBGColor;
    [self addTabView];
    _page = 1;
    _isopen=NO;
    
    [self netWorkRefresh:NO andIsLoadMoreData:NO isShouldClearData:NO];
    
    
}
- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
}
- (void)netWorkRefresh:(BOOL)isRefresh andIsLoadMoreData:(BOOL)isMoreLoadMoreData isShouldClearData:(BOOL)isShouldClearData//加载数据
{
    
    NSMutableDictionary *param = [Parameter parameterWithSessicon];
    [param setObject:@(_page) forKey:@"page"];
    NSLog(@"param====%@",param);
    [XLDataService putWithUrl:requestcountConnectionsURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        
        if (isRefresh) {
            
            
            [[ToolManager shareInstance] endHeaderWithRefreshing:_yrTab];
        }
        if (isMoreLoadMoreData) {
            [[ToolManager shareInstance] endFooterWithRefreshing:_yrTab];
        }
        if (isShouldClearData) {
            [self.nearByManArr removeAllObjects];
        }
        if (dataObj) {
            NSLog(@"meetObj====%@",dataObj);
            MeetingModel *modal = [MeetingModel mj_objectWithKeyValues:dataObj];
            if (_page ==1) {
                [[ToolManager shareInstance] moreDataStatus:_yrTab];
            }
            if (!modal.datas||modal.datas.count==0) {
                
                [[ToolManager shareInstance] noMoreDataStatus:_yrTab];
                
            }
            
            if (modal.rtcode ==1) {
                
                for (MeetingData *data in modal.datas) {
                    [self.nearByManArr addObject:[[MeetingCellLayout alloc]initCellLayoutWithModel:data andMeetBtn:NO andMessageBtn:NO andOprationBtn:YES andTime:NO]];
                    
                }
                
                
                [_yrTab reloadData];
                
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

-(void)addTabView
{
    _yrTab=[[UITableView alloc]initWithFrame:CGRectMake(0,StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT-(StatusBarHeight + NavigationBarHeight)) style:UITableViewStyleGrouped];
    _yrTab.delegate=self;
    _yrTab.dataSource=self;
    _yrTab.backgroundColor=[UIColor clearColor];
    _yrTab.tableFooterView=[[UIView alloc]init];
    _yrTab.separatorStyle=UITableViewCellSeparatorStyleNone;//去掉cell间的白线
    [[ToolManager shareInstance] scrollView:_yrTab headerWithRefreshingBlock:^{
         _page =1;
        [self netWorkRefresh:YES andIsLoadMoreData:NO isShouldClearData:YES];
    }];
    [[ToolManager shareInstance] scrollView:_yrTab footerWithRefreshingBlock:^{
        _page ++;
        [self netWorkRefresh:NO andIsLoadMoreData:YES isShouldClearData:NO];
     }];
    [self.view addSubview:_yrTab];
}
#pragma mark
#pragma mark -MeetHeadV 代理方法
- (void)pushView:(UIViewController *)viewC userInfo:(id)userInfo
{
    PushView(self, viewC);
    
}
#pragma mark----tableview代理

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return allocAndInit(UIView);
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    MeetingCellLayout*layout =(MeetingCellLayout*)_nearByManArr[indexPath.row];
    
    return layout.cellHeight;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.nearByManArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellID =@"MeettingTableViewCellID";
    
    MeettingTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[MeettingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor=[UIColor clearColor];
        
    }
    
    MeetingCellLayout *layout=self.nearByManArr[indexPath.row];
    [cell setCellLayout:layout];
    [cell setIndexPath:indexPath];
    MeetingData *data=layout.model;
    
    if(data.isappoint==1){
        [cell.meetingBtn setTitle:@"等待中" forState:UIControlStateNormal];
        cell.meetingBtn.titleLabel.font=[UIFont systemFontOfSize:13];
        [cell.meetingBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        cell.meetingBtn.backgroundColor=AppViewBGColor;
        cell.meetingBtn.userInteractionEnabled=NO;
    }else{
        cell.meetingBtn.backgroundColor=AppMainColor;
        [cell.meetingBtn setTitle:@"约见" forState:UIControlStateNormal];
        [cell.meetingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cell.meetingBtn.userInteractionEnabled=YES;
        cell.meetingBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    }
    
    [cell setDelegate:self];
    
    return cell;
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath//高亮
{
    return NO;
}
#pragma mark
#pragma mark - MeettingTableViewCellDelegate 同意和拒绝按钮地点击
//同意和拒绝按钮
- (void)tableViewCellDidSeleteAgreeAndRefuseBtn:(UIButton *)btn layout:(MeetingCellLayout *)layout andIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath * clickRow;
    NSLog(@"btn=====%ld",btn.tag);
    for (int i =0; i<self.nearByManArr.count; i++) {
        if ([layout isEqual:(MeetingCellLayout*)self.nearByManArr[i]]) {
            clickRow = [NSIndexPath indexPathForRow:i inSection:0];
        }
    }
    NSMutableDictionary *param = [Parameter parameterWithSessicon];
    if(btn.tag==2221){
        [param setObject:@"agree" forKey:@"conduct"];
    }else if (btn.tag==2222){
        [param setObject:@"refuse" forKey:@"conduct"];
    }
    MeetingCellLayout *layout1=self.nearByManArr[indexPath.row];
    MeetingData *data=layout1.model;
    [param setObject:data.meetId forKey:@"id"];
    NSLog(@"param====%@",param);

    [XLDataService putWithUrl:conductConnectionsURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        NSLog(@"conductObj=%@",dataObj);
        if (dataObj) {
            MeetingModel *model=[MeetingModel mj_objectWithKeyValues:dataObj];
            
            if (model.rtcode==1) {
                NSString *str;
                if(btn.tag==2222){
                    str=@"您已拒绝";
                }else if (btn.tag==2221){
                    str=@"您已同意";
                }

                UIAlertView *successAlertV=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"对话",@"电话联系",@"继续操作", nil];
                [self.nearByManArr removeObjectAtIndex:clickRow.row];
                [self.yrTab deleteRowsAtIndexPaths:[NSArray arrayWithObjects:clickRow, nil] withRowAnimation:UITableViewRowAnimationRight];
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
