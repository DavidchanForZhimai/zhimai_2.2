//
//  MeetingVC.m
//  Lebao
//
//  Created by adnim on 16/8/25.
//  Copyright © 2016年 David. All rights reserved.
//
#import "MyDetialViewController.h"
#import "MeetingVC.h"
#import "MJRefresh.h"
#import "MeettingTableViewCell.h"
#import "MeetHeadV.h"
#import "CoreArchive.h"
#import "ViewController.h"
#import "XLDataService.h"
#import "Parameter.h"
#import "LoCationManager.h"
#import "EjectView.h"
#import "MeetNumModel.h"
#import "MeetPaydingVC.h"
#import "NSString+Extend.h"
#import "GzHyViewController.h"//关注行业
#import "BasicInformationViewController.h"
#import "AuthenticationHomeViewController.h"//身份认证
#import "DateHelper.h"
#import "VIPPrivilegeVC.h"
@interface MeetingVC ()<UITableViewDelegate,UITableViewDataSource,MeetHeadVDelegate,EjectViewDelegate,MeettingTableViewDelegate,UIAlertViewDelegate>
{
    float OffsetY;
}
@property (nonatomic,strong)UITableView *yrTab;
@property (nonatomic,strong)MeetHeadV *headView;
@property (nonatomic,assign)int page;
@property (nonatomic,strong)NSMutableArray *nearByManArr;
@property (nonatomic,strong)NSMutableArray *headimgArr;
@property (nonatomic,strong)NSMutableArray *headUserIdArr;
@property (nonatomic,strong)NSMutableArray *nearByManUserIdArr;
@property (nonatomic,assign)BOOL isopen;//是否给未认证提醒
@end
@implementation MeetingVC
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshRow:) name:@"KRefreshMeetingViewNotifation" object:nil];
    [self netWorkHearViewIsShouldClearData:YES];
    if (_headView) {
        [self.headView shakeToShow:self.headView.vlayer1];
        [self.headView shakeToShow:self.headView.vlayer2];
        [self.headView shakeToShow:self.headView.vlayer3];
    }
}
-(void)refreshRow:(NSNotification *)notification
{
    for (int i =0;i<_nearByManArr.count;i++) {
        
        MeetingCellLayout *layout =_nearByManArr[i];
        if ([layout.model.userid isEqualToString:notification.object[@"userid"]]) {
            if([notification.object[@"operation"] isEqualToString:@"cancel"]){
                layout.model.isappoint = 0;
            }else if([notification.object[@"operation"] isEqualToString:@"meet"]){
                layout.model.isappoint = 1;
            }
            [_nearByManArr replaceObjectAtIndex:i withObject:layout];
            [_yrTab reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}
-(NSMutableArray *)nearByManArr
{
    if (!_nearByManArr) {
        _nearByManArr=[[NSMutableArray alloc]init];
    }
    return _nearByManArr;
}
-(NSMutableArray *)nearByManUserIdArr{
    if (!_nearByManUserIdArr) {
        _nearByManUserIdArr=[[NSMutableArray alloc]init];
    }
    return _nearByManUserIdArr;
}
-(NSMutableArray *)headimgArr
{
    if (!_headimgArr) {
        _headimgArr=[[NSMutableArray alloc]init];
    }
    return _headimgArr;
}
-(NSMutableArray *)headUserIdArr
{
    if (!_headUserIdArr) {
        _headUserIdArr=[[NSMutableArray alloc]init];
    }
    return _headUserIdArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //新版本提示
    [[ToolManager shareInstance]update];
    self.view.backgroundColor=AppViewBGColor;
    [self addTabView];
    [self navViewTitle:@"约见"];
    _page = 1;
    _isopen=YES;
    OffsetY=0;
    [self _yrNetWorkAndMessage:_isopen];//打开app,请求有空
    [self netWorkRefresh:NO andIsLoadMoreData:NO  isShouldClearData:NO];
}
- (void)netWorkHearViewIsShouldClearData:(BOOL)isShouldClearData//加载头部数据
{
    NSMutableDictionary *param = [Parameter parameterWithSessicon];
    [XLDataService putWithUrl:WantURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (dataObj) {
            MeetNumModel *modal = [MeetNumModel mj_objectWithKeyValues:dataObj];
            //            NSLog(@"dataonj==%@",dataObj);
            if (modal.rtcode==1) {
                if (isShouldClearData) {
                    [self.headimgArr removeAllObjects];
                    [self.headUserIdArr removeAllObjects];
                }
                if (modal.realname.length==0&&modal.realname) {
                    UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您没填写姓名哦" delegate:self cancelButtonTitle:nil otherButtonTitles:@"走起", nil];
                    alerView.tag=3333;
                    alerView.delegate=self;
                    [alerView show];
                }
                NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%d\n我想约见",modal.invited]];
                [text1 addAttribute:NSFontAttributeName value:Size(40) range:[[NSString stringWithFormat:@"%d\n我想约见",modal.invited] rangeOfString:[NSString stringWithFormat:@"%d",modal.invited]]];
                [_headView.meWantBtn setAttributedTitle:text1 forState:UIControlStateNormal];
                _headView.meWantBtn.titleLabel.numberOfLines = 0;
                
                NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%d\n想约见我",modal.beinvited]];
                [text addAttribute:NSFontAttributeName value:Size(40) range:[[NSString stringWithFormat:@"%d\n想约见我",modal.beinvited] rangeOfString:[NSString stringWithFormat:@"%d",modal.beinvited]]];
                [_headView.wantMeBtn setAttributedTitle:text forState:UIControlStateNormal];
                _headView.wantMeBtn.titleLabel.numberOfLines = 0;
                
                _headView.midBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
                NSMutableAttributedString *str=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"可添加\n%d\n位人脉",modal.cansee]];
                [str addAttribute:NSFontAttributeName value:Size(60) range:[[NSString stringWithFormat:@"可添加\n%d\n位人脉",modal.cansee] rangeOfString:[NSString stringWithFormat:@"%d",modal.cansee]]];
                [_headView.midBtn setAttributedTitle:str forState:UIControlStateNormal];
                _headView.midBtn.titleLabel.numberOfLines=0;
                
                for (canseeDatas *data in modal.cansee_datas) {
                    if (data.imgurl!=nil) {
                        [self.headimgArr addObject:data.imgurl];
                        [self.headUserIdArr addObject:data.userid];
                    }
                }
                _headView.headimgsArr=[NSArray arrayWithArray:self.headimgArr];
                _headView.userIdArr=[NSArray arrayWithArray:self.headUserIdArr];
                [_headView addEightImgView];
            }
        }
    }];
}
- (void)netWorkRefresh:(BOOL)isRefresh andIsLoadMoreData:(BOOL)isMoreLoadMoreData isShouldClearData:(BOOL)isShouldClearData//加载数据
{
    [[LoCationManager shareInstance] creatLocationManager:self callBackLocation:^(CLLocationCoordinate2D location) {
        //            测试用,要删掉
//                                    CLLocationCoordinate2D location;
//                                    location.latitude=24.491534;
//                                    location.longitude=118.180851;
        if (location.latitude<=0&&location.longitude<=0) {
            if (isRefresh) {
                [[ToolManager shareInstance] endHeaderWithRefreshing:_yrTab];
            }
            if (isMoreLoadMoreData) {
                [[ToolManager shareInstance] endFooterWithRefreshing:_yrTab];
            }
            return ;
        }
        if (self.nearByManArr.count==0) {
            [[ToolManager shareInstance] showWithStatus];
        }
    
        NSMutableDictionary *param = [Parameter parameterWithSessicon];
        [param setObject:[NSString stringWithFormat:@"%.6f",location.latitude] forKey:@"latitude"];
        [param setObject:[NSString stringWithFormat:@"%.6f",location.longitude] forKey:@"longitude"];
        [param setObject:@(_page) forKey:@"page"];
        
        [XLDataService putWithUrl:MeetMainURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
            //        NSLog(@"param====%@",param);
            if (isRefresh) {
                [[ToolManager shareInstance] endHeaderWithRefreshing:_yrTab];
            }
            if (isMoreLoadMoreData) {
                [[ToolManager shareInstance] endFooterWithRefreshing:_yrTab];
            }
            if (dataObj) {
//                         NSLog(@"meetObj====%@",dataObj);
                MeetingModel *modal = [MeetingModel mj_objectWithKeyValues:dataObj];
                
                
                
                
                if (_page ==1) {
                    [[ToolManager shareInstance] moreDataStatus:_yrTab];
                }
                if (!modal.datas||modal.datas.count==0) {
                    [[ToolManager shareInstance] noMoreDataStatus:_yrTab];
                }
                if (modal.rtcode ==1) {
                    [[ToolManager shareInstance] dismiss];
                    if (isShouldClearData) {
                        [self.nearByManArr removeAllObjects];
                        [self.nearByManUserIdArr removeAllObjects];
                    }
                    for (MeetingData *data in modal.datas) {
                            if (![self.nearByManUserIdArr containsObject:data.userid]) {
                                data.isSelf = [data.userid  isEqualToString:modal.userid];
                                [self.nearByManUserIdArr addObject:data.userid];
                                 [self.nearByManArr addObject:[[MeetingCellLayout alloc]initCellLayoutWithModel:data andMeetBtn:YES andMessageBtn:NO andOprationBtn:NO andTime:YES andReward:NO]];
                            }
                    }
                    _headView.nearManLab.text=[NSString stringWithFormat:@"附近可约 %d人",modal.count];
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
    }];
}
-(void)addTabView
{
    _yrTab=[[UITableView alloc]init];
    _yrTab.frame=CGRectMake(0,NavigationBarHeight, APPWIDTH, APPHEIGHT-( NavigationBarHeight + TabBarHeight));
    _yrTab.delegate=self;
    _yrTab.dataSource=self;
    _yrTab.backgroundColor=[UIColor clearColor];
    _yrTab.tableFooterView=[[UIView alloc]init];
    _yrTab.separatorStyle=UITableViewCellSeparatorStyleNone;//去掉cell间的白线
    [[ToolManager shareInstance] scrollView:_yrTab headerWithRefreshingBlock:^{
        _page =1;
        [self netWorkRefresh:YES andIsLoadMoreData:NO isShouldClearData:YES];
        [self _yrNetWorkAndMessage:_isopen];
        [self netWorkHearViewIsShouldClearData:YES];
    }];
    [[ToolManager shareInstance] scrollView:_yrTab footerWithRefreshingBlock:^{
        _page ++;
        [self netWorkRefresh:NO andIsLoadMoreData:YES isShouldClearData:NO];
    }];
    [self.view addSubview:_yrTab];
    _headView=[[MeetHeadV alloc]initWithFrame:CGRectMake(0, 0, APPWIDTH, 255)];
    _headView.delegate = self;
    self.yrTab.tableHeaderView=_headView;
}
#pragma mark
#pragma mark -MeetHeadV 代理方法
- (void)pushView:(UIViewController *)viewC userInfo:(id)userInfo
{
    PushView(self, viewC);
}
#pragma mark 有空网络请求
-(void)_yrNetWorkAndMessage:(BOOL)message
{
    NSMutableDictionary *param = [Parameter parameterWithSessicon];
    [param setObject:@"append" forKey:@"type"];
    [XLDataService putWithUrl:meetCheckedURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        //                        NSLog(@"param====%@",param);
        if (dataObj) {
            //                                NSLog(@"meetObj====%@",dataObj);
            _isopen=NO;
            MeetingModel *modal = [MeetingModel mj_objectWithKeyValues:dataObj];
            if (modal.rtcode ==1) {
                [[LoCationManager shareInstance] creatLocationManager:self callBackLocation:^(CLLocationCoordinate2D location) {
                    if (location.latitude<=0&&location.longitude<=0) {
                        return ;
                    }
                    NSMutableDictionary *param = [Parameter parameterWithSessicon];
                    [param setObject:[NSString stringWithFormat:@"%.6f",location.latitude] forKey:@"latitude"];
                    [param setObject:[NSString stringWithFormat:@"%.6f",location.longitude] forKey:@"longitude"];
                    //                        NSLog(@"param====%@",param);
                    [XLDataService putWithUrl:MeetAppendURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
                    }];
                }];
            }else if (modal.rtcode ==4002){
                if (message) {
                    UIAlertController *alertC=[UIAlertController  alertControllerWithTitle:@"去身份认证吗?" message:modal.rtmsg preferredStyle:UIAlertControllerStyleAlert];
                    [alertC addAction:[UIAlertAction actionWithTitle:@"走起" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        PushView(self, allocAndInit(AuthenticationHomeViewController));
                    }]];
                    [alertC addAction:[UIAlertAction actionWithTitle:@"不去" style:UIAlertActionStyleCancel handler:nil]];
                    [self.navigationController presentViewController:alertC animated:YES completion:nil];
                }
            }
            else if (modal.rtcode ==4001){
                if (message) {
                    UIAlertController *alertC=[UIAlertController  alertControllerWithTitle:@"去完善资料吗?" message:[NSString stringWithFormat:@"完善资料后才能约见他人哦\n(%@)",modal.rtmsg] preferredStyle:UIAlertControllerStyleAlert];
                    [alertC addAction:[UIAlertAction actionWithTitle:@"走起" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        PushView(self, allocAndInit(BasicInformationViewController));
                    }]];
                    [alertC addAction:[UIAlertAction actionWithTitle:@"不去" style:UIAlertActionStyleCancel handler:nil]];
                    [self.navigationController presentViewController:alertC animated:YES completion:nil];
                }
            }
        }
    }];
}

#pragma mark----tableview代理
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
    static NSString* cellIdentifier = @"MeettingTableViewCellID";
    MeettingTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MeettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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
    if (data.isSelf) {
        cell.meetingBtn.hidden=YES;
    }else{
        cell.meetingBtn.hidden=NO;
    }
    [cell setDelegate:self];
    
    return cell;
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath//高亮
{
    return NO;
}
#pragma mark
#pragma mark - MeettingTableViewCellDelegate 约见按钮地点击
- (void)tableViewCellDidSeleteMeetingBtn:(UIButton *)btn andIndexPath:(NSIndexPath *)indexPath
{
    [[ToolManager shareInstance] showWithStatus];
    NSMutableDictionary *param = [Parameter parameterWithSessicon];
    [param setObject:@"invited" forKey:@"type"];
    [XLDataService putWithUrl:meetCheckedURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        //        NSLog(@"dataObj====%@",dataObj);
        if (dataObj) {
            MeetingModel *modal = [MeetingModel mj_objectWithKeyValues:dataObj];
            if (modal.rtcode ==1) {
                [[ToolManager shareInstance] dismiss];
                CGFloat dilX = 25;
                CGFloat dilH = 250;
                EjectView *alertV = [[EjectView alloc] initAlertViewWithFrame:CGRectMake(dilX, 0, 250, dilH) andSuperView:self.view];
                alertV.center = CGPointMake(APPWIDTH/2, APPHEIGHT/2-30);
                alertV.delegate = self;
                alertV.titleStr = @"温馨提示";
                alertV.title2Str=@"意思一下,打赏让“约”来的正式一点";
                alertV.indexth=indexPath;
            }else if (modal.rtcode ==4002){
                [[ToolManager shareInstance]dismiss];
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"去身份认证吗?" message:modal.rtmsg delegate:self cancelButtonTitle:nil otherButtonTitles:@"不去",@"走起", nil];
                alertView.tag=22221;
                alertView.delegate=self;
                [alertView show];
            }
            else if (modal.rtcode ==4001){
                [[ToolManager shareInstance]dismiss];
                
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"去完善资料吗?" message:[NSString stringWithFormat:@"完善资料后才能约见他人哦\n(%@)",modal.rtmsg] delegate:self cancelButtonTitle:nil otherButtonTitles:@"不去",@"走起", nil];
                alertView.tag=22222;
                alertView.delegate=self;
                [alertView show];
            }else if (modal.rtcode ==4005){
                [[ToolManager shareInstance]dismiss];
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"知脉君温馨提示" message:[NSString stringWithFormat:@"%@",modal.rtmsg] delegate:self cancelButtonTitle:nil otherButtonTitles:@"再看看",@"马上开通", nil];
                alertView.tag=22223;
                alertView.delegate=self;
                [alertView show];
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
#pragma mark - MeettingTableViewCellDelegate 头像按钮点击
-(void)tableViewCellDidSeleteHeadImg:(LWImageStorage *)imageStoragen layout:(MeetingCellLayout *)layout
{
    MyDetialViewController *myDetialViewCT=[MyDetialViewController new];
    myDetialViewCT.userID=((MeetingData *)layout.model).userid;
    [self.navigationController pushViewController:myDetialViewCT animated:YES];
}

#pragma mark - YXCustomAlertViewDelegate
- (void) customAlertView:(EjectView *) customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [customAlertView dissMiss];
        customAlertView = nil;
    }else
    {
        if ([customAlertView.money floatValue]>=1) {
            
            MeetPaydingVC * payVC = [[MeetPaydingVC alloc]init];
            MeetingCellLayout *layout=(MeetingCellLayout *)self.nearByManArr[customAlertView.indexth.row];
            MeetingData *model = layout.model;
            //        NSLog(@"model=%@",model);
            NSMutableDictionary *param=[Parameter parameterWithSessicon];
            [param setObject:model.userid forKey:@"userid"];
            [param setObject:[NSString stringWithFormat:@"%.2f",[customAlertView.money floatValue]] forKey:@"reward"];
            [param setObject:customAlertView.logField.text forKey:@"remark"];
            [param setObject:model.distance forKey:@"distance"];
            payVC.realname=model.realname;
            payVC.tel=model.tel;
            payVC.param=param;
            payVC.jineStr =[NSString stringWithFormat:@"%.2f",[customAlertView.money floatValue]];
            payVC.audioData=customAlertView.audioData;
            payVC.whatZfType=0;
            [self.navigationController pushViewController:payVC animated:YES];
            [customAlertView dissMiss];
            customAlertView = nil;
        }else{
            [[ToolManager shareInstance] showAlertMessage:@"金额格式不正确,最低1元"];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==22221) {
        if (buttonIndex==0) {
            
        }else if(buttonIndex==1){
            PushView(self, allocAndInit(AuthenticationHomeViewController));
        }
    }else if (alertView.tag==22222) {
        if (buttonIndex==0) {
            
        }else if(buttonIndex==1){
            PushView(self, allocAndInit(BasicInformationViewController));
        }
    }
    else if (alertView.tag==22223) {
        if (buttonIndex==0) {
            
        }else if(buttonIndex==1){
            PushView(self, allocAndInit(VIPPrivilegeVC));
        }
}else if(alertView.tag==3333){
    PushView(self, allocAndInit(BasicInformationViewController));
}
}

#pragma mark 滑动隐藏导航栏
//滑动隐藏导航栏 LiXingLe
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y>0&&scrollView.contentOffset.y-OffsetY>20&&(scrollView.contentSize.height-scrollView.height)>0)   {
        if (self.tabBarController.tabBar.y==(APPHEIGHT-self.tabBarController.tabBar.height)) {
            _yrTab.frame=CGRectMake(0,StatusBarHeight, APPWIDTH, APPHEIGHT-StatusBarHeight);
            [UIView animateWithDuration:0.5
                             animations:^{
                                 [self.navigationController setNavigationBarHidden:YES animated:YES];
                                 self.tabBarController.tabBar.frame=CGRectMake(self.tabBarController.tabBar.x,APPHEIGHT, self.tabBarController.tabBar.width, self.tabBarController.tabBar.height);
                                 self.navigationBarView.frame=CGRectMake(self.navigationBarView.x, -self.navigationBarView.height, self.navigationBarView.width, self.navigationBarView.height);
                             }completion:^(BOOL finished) {
                             }];
        }
        OffsetY=scrollView.contentOffset.y;
    }
    else if (scrollView.contentOffset.y<(scrollView.contentSize.height-scrollView.height)&&scrollView.contentOffset.y-OffsetY<-20)
    {
        if (self.tabBarController.tabBar.y==APPHEIGHT) {
            
            [UIView animateWithDuration:0.5
                             animations:^{
                                 [self.navigationController setNavigationBarHidden:YES animated:YES];
                                 self.tabBarController.tabBar.frame=CGRectMake(self.tabBarController.tabBar.x,APPHEIGHT- self.tabBarController.tabBar.height, self.tabBarController.tabBar.width, self.tabBarController.tabBar.height);
                                 self.navigationBarView.frame=CGRectMake(self.navigationBarView.x,0, self.navigationBarView.width, self.navigationBarView.height);
                                 _yrTab.frame=CGRectMake(0, NavigationBarHeight, APPWIDTH, APPHEIGHT-( NavigationBarHeight + TabBarHeight));
                             }completion:^(BOOL finished) {
                                 
                             }];
        }
        OffsetY=scrollView.contentOffset.y;
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void) shakeToShow:(UIView*)aView//放大缩小动画
//{
//    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    animation.duration = 0.5;
//
//    NSMutableArray *values = [NSMutableArray array];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
//    animation.values = values;
//    [aView.layer addAnimation:animation forKey:nil];
//}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
