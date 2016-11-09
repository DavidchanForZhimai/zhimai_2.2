//
//  MyConnectionsVC.m
//  Lebao
//
//  Created by adnim on 16/9/19.
//  Copyright © 2016年 David. All rights reserved.
//

#import "MyConnectionsVC.h"
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
#import "GJGCChatFriendViewController.h"
#import "MyDetialViewController.h"
#import "FnyApplyForVC.h"//我的申请
@interface MyConnectionsVC ()<UITableViewDelegate,UITableViewDataSource,MeettingTableViewDelegate,UIAlertViewDelegate>
{
    BOOL audioMark;
}
@property (nonatomic,strong)UITableView *yrTab;
@property (nonatomic,assign)int page;
@property (nonatomic,strong)NSMutableArray *nearByManArr;
@property (nonatomic,assign)BOOL isopen;
@end

@implementation MyConnectionsVC
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
    [self navViewTitleAndBackBtn:@"我的人脉"];
    self.view.backgroundColor=AppViewBGColor;
    [self addTabView];
    _page = 1;
    _isopen=NO;
    [[ToolManager shareInstance]showWithStatus];
    [self netWorkRefresh:NO andIsLoadMoreData:NO isShouldClearData:NO];
    
    UIButton *applyForBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    applyForBtn.frame=CGRectMake(APPWIDTH-60, StatusBarHeight, 50, NavigationBarHeight);
    [applyForBtn setTitle:@"申请" forState:UIControlStateNormal];
    applyForBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [applyForBtn setTitleColor:BlackTitleColor forState:UIControlStateNormal];
    [applyForBtn addTarget:self action:@selector(applyForBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applyForBtn];
    
}
//我的申请人脉点击事件
-(void)applyForBtnClicked:(UIButton *)sender
{
    PushView(self, allocAndInit(FnyApplyForVC));
}
- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
}
- (void)netWorkRefresh:(BOOL)isRefresh andIsLoadMoreData:(BOOL)isMoreLoadMoreData isShouldClearData:(BOOL)isShouldClearData//加载数据
{
    NSMutableDictionary *param = [Parameter parameterWithSessicon];
    [param setObject:@(_page) forKey:@"page"];

    [XLDataService putWithUrl:myConnectionsURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (isRefresh) {
            [[ToolManager shareInstance] endHeaderWithRefreshing:_yrTab];
        }
        if (isMoreLoadMoreData) {
            [[ToolManager shareInstance] endFooterWithRefreshing:_yrTab];
        }
       

        if (dataObj) {
//            NSLog(@"Mydataobj====%@",dataObj);
            MeetingModel *modal = [MeetingModel mj_objectWithKeyValues:dataObj];
            if (_page ==1) {
                [[ToolManager shareInstance] moreDataStatus:_yrTab];
            }
            if (!modal.datas||modal.datas.count==0) {
                
                [[ToolManager shareInstance] noMoreDataStatus:_yrTab];
            }
            if (modal.rtcode ==1) {
                if (isShouldClearData) {
                    [self.nearByManArr removeAllObjects];
                }
                for (MeetingData *data in modal.datas) {
                    [self.nearByManArr addObject:[[MeetingCellLayout alloc]initCellLayoutWithModel:data andMeetBtn:NO andMessageBtn:YES andOprationBtn:NO andTime:NO]];
                    
                                  }
                [_yrTab reloadData];
                [[ToolManager shareInstance] dismiss];
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
- (void) shakeToShow:(UIView*)aView//放大缩小动画
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

#pragma mark----tableview代理
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
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

#pragma mark - MeettingTableViewCellDelegate 头像按钮点击
-(void)tableViewCellDidSeleteHeadImg:(LWImageStorage *)imageStoragen layout:(MeetingCellLayout *)layout
{
    MyDetialViewController *myDetialViewCT=allocAndInit(MyDetialViewController);
    MeetingData *data = layout.model;
    myDetialViewCT.userID=data.userid;
    [self.navigationController pushViewController:myDetialViewCT animated:YES];
}

//对话按钮的点击
- (void)tableViewCellDidSeleteMessageBtn:(UIButton *)btn andIndexPath:(NSIndexPath *)indexPath{
    GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc]init];
    talk.talkType = GJGCChatFriendTalkTypePrivate;
    MeetingCellLayout *layout=self.nearByManArr[indexPath.row];
    MeetingData *data =layout.model;
    
    talk.toId = data.userid;
    talk.toUserName = data.realname;
    
    GJGCChatFriendViewController *privateChat = [[GJGCChatFriendViewController alloc]initWithTalkInfo:talk];
    privateChat.type = MessageTypeNormlPage;
    [self.navigationController pushViewController:privateChat animated:YES];

}
#pragma mark - 删除人脉
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableDictionary *param = [Parameter parameterWithSessicon];
            [param setObject:@"relivev" forKey:@"conduct"];
        MeetingCellLayout *layout1=self.nearByManArr[indexPath.row];
        MeetingData *data=layout1.model;
        [param setObject:data.meetId forKey:@"id"];
        [[ToolManager shareInstance] showWithStatus];
        [XLDataService putWithUrl:conductConnectionsURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
            if (dataObj) {
                MeetingModel *model=[MeetingModel mj_objectWithKeyValues:dataObj];
                
                if (model.rtcode==1) {
                    
                    [self.nearByManArr removeObjectAtIndex:indexPath.row];
                    // Delete the row from the data source.
                    [_yrTab deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [[ToolManager shareInstance] showAlertMessage:@"删除人脉成功"];
                }
                else
                {
                    [[ToolManager shareInstance] showAlertMessage:model.rtmsg];
                }
            }else
            {
                [[ToolManager shareInstance] showInfoWithStatus];
                
            }
            
            
        }];

        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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
