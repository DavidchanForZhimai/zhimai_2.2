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
#import "GzHyViewController.h"//关注行业
@interface MyConnectionsVC ()<UITableViewDelegate,UITableViewDataSource,EjectViewDelegate,MeettingTableViewDelegate,UIAlertViewDelegate>
{
    BOOL audioMark;
}
@property (nonatomic,strong)UITableView *yrTab;
@property (nonatomic,assign)int page;
@property (nonatomic,strong)NSMutableArray *nearByManArr;
@property (nonatomic,strong)NSMutableArray *CellSouceArr;
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
-(NSMutableArray *)CellSouceArr
{
    if (!_CellSouceArr) {
        _CellSouceArr=[[NSMutableArray alloc]init];
        
    }
    return _CellSouceArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //新版本提示
    [[ToolManager shareInstance]update];
    
    [self navViewTitleAndBackBtn:@"我的人脉"];
    
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
    
    //    [[LoCationManager shareInstance] creatLocationManager];
    //    [LoCationManager shareInstance].callBackLocation = ^(CLLocationCoordinate2D location)
    //    {
    //测试用,要删掉
    
    
    
    
    CLLocationCoordinate2D location;
    location.latitude=24.491534;
    location.longitude=118.180851;
    NSMutableDictionary *param = [Parameter parameterWithSessicon];
    
    [param setObject:[NSString stringWithFormat:@"%.6f",location.latitude] forKey:@"latitude"];
    [param setObject:[NSString stringWithFormat:@"%.6f",location.longitude] forKey:@"longitude"];
    [param setObject:@(_page) forKey:@"page"];
    
    [XLDataService putWithUrl:MeetMainURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        NSLog(@"param====%@",param);
        if (isRefresh) {
            
            
            [[ToolManager shareInstance] endHeaderWithRefreshing:_yrTab];
        }
        if (isMoreLoadMoreData) {
            [[ToolManager shareInstance] endFooterWithRefreshing:_yrTab];
        }
        if (isShouldClearData) {
            [self.nearByManArr removeAllObjects];
            [self.CellSouceArr removeAllObjects];
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
                    
                    
                    [self.CellSouceArr addObject:data];
                    [self.nearByManArr addObject:[[MeetingCellLayout alloc]initCellLayoutWithModel:data]];
                    
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
    
    //    };
    
    
    
}

-(void)addTabView
{
    _yrTab=[[UITableView alloc]init];
    //    [_yrTab registerClass:[MeetingTVCell class] forCellReuseIdentifier:@"yrCell"];
    _yrTab.frame=CGRectMake(0,StatusBarHeight + NavigationBarHeight+10, APPWIDTH, APPHEIGHT-(StatusBarHeight + NavigationBarHeight + TabBarHeight-10));
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
    MeetingData *data=self.CellSouceArr[indexPath.row];
    
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
#pragma mark - MeettingTableViewCellDelegate 约见按钮地点击
- (void)tableViewCellDidSeleteMeetingBtn:(UIButton *)btn andIndexPath:(NSIndexPath *)indexPath
{
    //do something
    
    CGFloat dilX = 25;
    CGFloat dilH = 250;
    EjectView *alertV = [[EjectView alloc] initAlertViewWithFrame:CGRectMake(dilX, 0, 250, dilH) andSuperView:self.navigationController.view];
    alertV.center = CGPointMake(APPWIDTH/2, APPHEIGHT/2-30);
    alertV.delegate = self;
    alertV.titleStr = @"提示";
    alertV.title2Str=@"您需要打赏一定的约见费";
    alertV.indexth=indexPath;
}


#pragma mark - YXCustomAlertViewDelegate
- (void) customAlertView:(EjectView *) customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0) {
        audioMark=NO;
        [customAlertView dissMiss];
        customAlertView = nil;
        
        NSLog(@"取消");
        
    }else
    {
        NSLog(@"确认");
        
        MeetPaydingVC * payVC = [[MeetPaydingVC alloc]init];
        MeetingData *model=_CellSouceArr[customAlertView.indexth.row];
        NSLog(@"model=%@",model);
        NSMutableDictionary *param=[Parameter parameterWithSessicon];
        [param setObject:model.userid forKey:@"userid"];
        [param setObject:@"1" forKey:@"reward"];
        [param setObject:@"" forKey:@"audio"];
        [param setObject:@"" forKey:@"remark"];
        [param setObject:model.distance forKey:@"distance"];
        [param setObject:@"wallet" forKey:@"paytype"];
        payVC.param=param;
        //                payVC.zfymType = FaBuZhiFu;
        //                payVC.qwjeStr = _bcTex.text;
        //                payVC.titStr = _titTex.text;
        //                payVC.content = _contTex.text;
        //                payVC.industry = induStr;
        payVC.jineStr = @"1";
        payVC.isAudio=audioMark;
        [self.navigationController pushViewController:payVC animated:YES];
        
        
        //        [XLDataService putWithUrl:MeetyouURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        //            if(dataObj){
        //
        //                MeetingModel *model=[MeetingModel mj_objectWithKeyValues:dataObj];
        //
        //
        //                if (model.rtcode==1) {
        //                    UIAlertView *successAlertV=[[UIAlertView alloc]initWithTitle:@"恭喜您,约见成功!" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"对话",@"电话联系",@"继续约见他人", nil];
        //                    successAlertV.cancelButtonIndex=2;
        //
        //                    [successAlertV show];
        //
        //                }
        //
        //                else
        //                {
        //                    [[ToolManager shareInstance] showAlertMessage:model.rtmsg];
        //                }
        //                NSLog(@"model.rtmsg=========dataobj=%@",model.rtmsg);
        //            }else
        //            {
        //                [[ToolManager shareInstance] showInfoWithStatus];
        //                [_yrBtn setBackgroundImage:[UIImage imageNamed:@"youkong"] forState:UIControlStateNormal];
        //            }
        //
        //        }];
        
        [customAlertView dissMiss];
        customAlertView = nil;
        
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
