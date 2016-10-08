//
//  meetSucceedVC.m
//  Lebao
//
//  Created by adnim on 16/9/20.
//  Copyright © 2016年 David. All rights reserved.
//

#import "MeetSucceedVC.h"
#import "MJRefresh.h"
#import "WantMeetTabCell.h"
#import "Parameter.h"
#import "XLDataService.h"
#import "MP3PlayerManager.h"
#import "GJGCChatFriendViewController.h"
#import "AppraiseVC.h"
#import "MyDetialViewController.h"
@interface MeetSucceedVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate,WantMeettingTableViewDelegate>
{
    UIScrollView * buttomScr;
    NSIndexPath * clickRow;
}
@property (strong,nonatomic)UITableView *meetMeTab;
@property (strong,nonatomic)UITableView *iMeetTab;
@property (strong,nonatomic)UIButton *meetMeBtn;
@property (strong,nonatomic)UIButton *iMeetBtn;
@property (nonatomic,strong)UIView *underLineV;//下划线v
@property (nonatomic,assign)int meetMePage;
@property (nonatomic,assign)int iMeetPage;
@property (nonatomic,strong)NSString *state;
@property (nonatomic,strong)NSMutableArray *meetMeArr;
@property (nonatomic,strong)NSMutableArray *iMeetArr;

@end

@implementation MeetSucceedVC


-(NSMutableArray *)iMeetArr
{
    if (!_iMeetArr) {
        _iMeetArr=[[NSMutableArray alloc]init];
    }
    return _iMeetArr;
}
-(NSMutableArray *)meetMeArr
{
    if (!_meetMeArr) {
        _meetMeArr=[[NSMutableArray alloc]init];
    }
    return _meetMeArr;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reflashRow:) name:@"EVALUATE" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self navViewTitleAndBackBtn:@"约见成功"];
    _iMeetPage=1;
    _meetMePage=1;
    _state=@"20";
    [self setButtomScr];
    [self addTheBtnView];
    [self netWorkRefresh:NO andIsLoadMoreData:NO isShouldClearData:NO withState:_state andTabView:_meetMeTab andArr:self.meetMeArr andPage:_meetMePage];
}

-(void)reflashRow:(NSNotification *)notification
{
   
    NSMutableArray *arr;
    UITableView *tab;
    if (_meetMeBtn.selected==YES) {
        arr=_meetMeArr;
        tab=_meetMeTab;
    }else {
        arr=_iMeetArr;
        tab=_iMeetTab;
    }

    for (int i =0;i<arr.count;i++) {
        
        WantMeetLayout *layout =arr[i];
        if ([layout.model.meetId isEqualToString:notification.object[@"meetid"]]) {
            if([notification.object[@"operation"] isEqualToString:@"yes"]){
                layout.model.evaluate=@"1";
            }
            [arr replaceObjectAtIndex:i withObject:layout];
            [tab reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }

}

/**
 *  最下层的scrollview
 */
-(void)setButtomScr
{
    buttomScr = [[UIScrollView alloc]initWithFrame:CGRectMake(0,StatusBarHeight + NavigationBarHeight + 36, SCREEN_WIDTH, SCREEN_HEIGHT-(StatusBarHeight + NavigationBarHeight + 36))];
    buttomScr.contentSize = CGSizeMake(SCREEN_WIDTH*3, frameHeight(buttomScr));
    buttomScr.backgroundColor = [UIColor clearColor];
    buttomScr.scrollEnabled = YES;
    buttomScr.delegate = self;
    buttomScr.alwaysBounceHorizontal = NO;
    buttomScr.alwaysBounceVertical = NO;
    buttomScr.showsHorizontalScrollIndicator = NO;
    buttomScr.showsVerticalScrollIndicator = NO;
    buttomScr.pagingEnabled = YES;
    buttomScr.bounces = NO;
    
    [self.view addSubview:buttomScr];
    [self addTheTab];
    
}
/**
 *  上面的2个按钮
 */
-(void)addTheBtnView
{
    _meetMeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _meetMeBtn.frame = CGRectMake(0, 65, SCREEN_WIDTH/2, 35);
    [_meetMeBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_meetMeBtn setTitle:@"约我的" forState:UIControlStateNormal];
    [_meetMeBtn setTitleColor:[UIColor colorWithRed:0.298 green:0.627 blue:0.996 alpha:1.000] forState:UIControlStateSelected];
    [_meetMeBtn setTitleColor:[UIColor colorWithWhite:0.514 alpha:1.000] forState:UIControlStateNormal];
    _meetMeBtn.backgroundColor = [UIColor whiteColor];
    _meetMeBtn.selected = YES;
    [_meetMeBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_meetMeBtn addTarget:self action:@selector(oprationBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_meetMeBtn];
    
    _iMeetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _iMeetBtn.frame = CGRectMake(SCREEN_WIDTH/2, 65, SCREEN_WIDTH/2, 35);
    [_iMeetBtn setTitle:@"我约的" forState:UIControlStateNormal];
    [_iMeetBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_iMeetBtn setTitleColor:[UIColor colorWithRed:0.298 green:0.627 blue:0.996 alpha:1.000] forState:UIControlStateSelected];
    [_iMeetBtn setTitleColor:[UIColor colorWithWhite:0.514 alpha:1.000] forState:UIControlStateNormal];
    _iMeetBtn.backgroundColor = [UIColor whiteColor];
    [_iMeetBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_iMeetBtn addTarget:self action:@selector(agreeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_iMeetBtn];
    
    _underLineV = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2-50)/2, 65+35-2, 50, 2)];
    _underLineV.backgroundColor = [UIColor colorWithRed:0.298 green:0.627 blue:0.996 alpha:1.000];
    [self.view addSubview:_underLineV];
}
#pragma mark----2个tableview写在这里
-(void)addTheTab
{
    _meetMeTab = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, buttomScr.frame.size.height) style:UITableViewStyleGrouped];
    _meetMeTab.dataSource = self;
    _meetMeTab.delegate = self;
    _meetMeTab.tableFooterView = [[UIView alloc]init];
    _meetMeTab.backgroundColor = [UIColor clearColor];
    _meetMeTab.tag = 1;
    _meetMeTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[ToolManager shareInstance] scrollView:_meetMeTab headerWithRefreshingBlock:^{
        
        _meetMePage =1;
        [self netWorkRefresh:YES andIsLoadMoreData:NO isShouldClearData:YES withState:@"20" andTabView:_meetMeTab andArr:_meetMeArr andPage:_meetMePage];
        
    }];
    [[ToolManager shareInstance] scrollView:_meetMeTab footerWithRefreshingBlock:^{
        _meetMePage ++;
        [self netWorkRefresh:NO andIsLoadMoreData:YES isShouldClearData:NO withState:@"20" andTabView:_meetMeTab andArr:_meetMeArr andPage:_meetMePage];
        
    }];
    
    
    [buttomScr addSubview:_meetMeTab];
    
    _iMeetTab = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH,0, SCREEN_WIDTH, buttomScr.frame.size.height) style:UITableViewStyleGrouped];
    _iMeetTab.dataSource = self;
    _iMeetTab.delegate = self;
    _iMeetTab.tableFooterView = [[UIView alloc]init];
    _iMeetTab.backgroundColor = [UIColor clearColor];
    _iMeetTab.tag = 2;
    _iMeetTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[ToolManager shareInstance] scrollView:_iMeetTab headerWithRefreshingBlock:^{
        
        _iMeetPage =1;
        [self netWorkRefresh:YES andIsLoadMoreData:NO isShouldClearData:YES withState:@"20" andTabView:_iMeetTab andArr:_iMeetArr andPage:_iMeetPage];
        
    }];
    [[ToolManager shareInstance] scrollView:_iMeetTab footerWithRefreshingBlock:^{
        _iMeetPage ++;
        [self netWorkRefresh:NO andIsLoadMoreData:YES isShouldClearData:NO withState:@"20" andTabView:_iMeetTab andArr:_iMeetArr andPage:_iMeetPage];
        
    }];
    
    
    [buttomScr addSubview:_iMeetTab];
    
    
    
}

#pragma mark 请求数据
-(void)netWorkRefresh:(BOOL)isRefresh andIsLoadMoreData:(BOOL)isMoreLoadMoreData isShouldClearData:(BOOL)isShouldClearData withState:(NSString *)state andTabView:(UITableView *)tabView andArr:(NSMutableArray *)arr andPage:(int)page//加载数据
{
    
    NSMutableDictionary *param=[Parameter parameterWithSessicon];
    [param setObject:state forKey:@"state"];
    [param setObject:@(page) forKey:@"page"];
    NSString *url;
    if (tabView==_meetMeTab) {
        url=WantMeetMeURL;
    }if (tabView==_iMeetTab) {
        url=IWantMeetURL;
    }
    if (arr.count==0) {
        [[ToolManager shareInstance] showWithStatus];
    }
    [XLDataService putWithUrl:url param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (isRefresh) {
            [[ToolManager shareInstance]endHeaderWithRefreshing:tabView];
            
        }if (isMoreLoadMoreData) {
            [[ToolManager shareInstance]endFooterWithRefreshing:tabView];
        }if (isShouldClearData) {
            [arr removeAllObjects];

        }
        if (dataObj) {
            
            MeetingModel *modal = [MeetingModel mj_objectWithKeyValues:dataObj];
            if (page ==1) {
                [[ToolManager shareInstance] moreDataStatus:tabView];
            }
            if (!modal.datas||modal.datas.count==0) {
                
                [[ToolManager shareInstance] noMoreDataStatus:tabView];
                
            }
            
            if (modal.rtcode ==1) {
                [[ToolManager shareInstance]dismiss];
                for (MeetingData *data in modal.datas) {
                    
                    [arr addObject:[[WantMeetLayout alloc]initCellLayoutWithModel:data andMeetBtn:YES andTelBtn:NO]];
                    
                }
                [tabView reloadData];
                
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


#pragma mark - 头部2个按钮点击切换事件
-(void)oprationBtn:(UIButton *)sender//待操作
{
    sender.selected = YES;
    _iMeetBtn.selected = NO;
    _state=@"20";
    [UIView animateWithDuration:0.3f animations:^{
        [_underLineV setFrame:CGRectMake((SCREEN_WIDTH/2-50)/2, 65+35-2, 50, 2)];
        [buttomScr setContentOffset:CGPointMake(0, 0)];
    }];
    if (_meetMeArr==nil) {
        [self netWorkRefresh:NO andIsLoadMoreData:NO isShouldClearData:NO withState:_state andTabView:_meetMeTab andArr:self.meetMeArr andPage:_meetMePage];
    }
    
    
}

-(void)agreeBtn:(UIButton *)sender//已同意
{
    sender.selected = YES;
    _meetMeBtn.selected = NO;
    _state=@"20";
    [UIView animateWithDuration:0.3f animations:^{
        [_underLineV setFrame:CGRectMake((SCREEN_WIDTH/2-50)/2+SCREEN_WIDTH/2, 65+35-2, 50, 2)];
        [buttomScr setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    }];
    if (_iMeetArr==nil) {
        [self netWorkRefresh:NO andIsLoadMoreData:NO isShouldClearData:NO withState:_state andTabView:_iMeetTab andArr:self.iMeetArr andPage:_iMeetPage];
        
    }
    
    
}
#pragma mark----tableview代理和资源方法
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _meetMeTab) {
        WantMeetLayout*layout =(WantMeetLayout*)_meetMeArr[indexPath.row];
        
        return layout.cellHeight;
    }else  if (tableView==_iMeetTab) {
        
        WantMeetLayout*layout =(WantMeetLayout*)_iMeetArr[indexPath.row];
        
        return layout.cellHeight;
    }    return 170;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _meetMeTab) {
        return _meetMeArr.count;
    }else  if (tableView==_iMeetTab) {
        
        return _iMeetArr.count;
    }
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10;
    
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WantMeetTabCell *cell=[tableView dequeueReusableCellWithIdentifier:@"WMCell"];
    if (!cell) {
        cell=[[WantMeetTabCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WMCell"];
        cell.backgroundColor=[UIColor clearColor];
    }
    WantMeetLayout *layout;
    if (tableView == _meetMeTab) {
        layout =self.meetMeArr[indexPath.row];
        
    }else  if (tableView==_iMeetTab) {
        
        layout =self.iMeetArr[indexPath.row];
        
    }
    if([layout.model.evaluate isEqualToString:@"0"]){
        [cell.meetingBtn setTitle:@"待评价" forState:UIControlStateNormal];
        [cell.meetingBtn setBackgroundColor:AppMainColor];
    }else{
        [cell.meetingBtn setTitle:@"已评价" forState:UIControlStateNormal];
        [cell.meetingBtn setBackgroundColor:[UIColor lightGrayColor]];
    }
    [cell setCellLayout:layout];
    [cell setIndexPath:indexPath];
    [cell setDelegate:self];
    
    return cell;
}
- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
}

#pragma mark- scrollview代理方法
/**
 *  @param scrollView <#scrollView description#>
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGPoint point = buttomScr.contentOffset;
    
    [UIView animateWithDuration:0.3f animations:^{
        if ((int)point.x % (int)SCREEN_WIDTH == 0) {
            if (point.x/SCREEN_WIDTH ==0) {
                [self oprationBtn:_meetMeBtn];
            }else if(point.x/SCREEN_WIDTH ==1) {
                [self agreeBtn:_iMeetBtn];
            }
            
        }
    }];
    
}
#pragma mark 评价按钮点击事件
- (void)tableViewCellDidSeleteMeetingBtn:(UIButton *)btn layout:(WantMeetLayout *)layout andIndexPath:(NSIndexPath *)indexPath
{
    clickRow=indexPath;
    MeetingData *data=layout.model;
    AppraiseVC *appraiseVC=[[AppraiseVC alloc]init];
    appraiseVC.meetId=data.meetId;
    appraiseVC.headImg=data.imgurl;
    PushView(self, appraiseVC);
    
}
#pragma mark 语音按钮点击事件
-(void)tableViewCellDidSeleteAudioBtn:(UIButton *)btn layout:(WantMeetLayout *)layout andIndexPath:(NSIndexPath *)indexPath
{
    //    _url = @"http://pic.lmlm.cn/record/201607/22/146915727469518.mp3";
    MeetingData *data=layout.model;
    NSString *url=[NSString stringWithFormat:@"%@%@",ImageURLS,data.audio];
    NSArray *pathArrays = [url componentsSeparatedByString:@"/"];
    NSString *topath;
    if (pathArrays.count>0) {
        topath = pathArrays[pathArrays.count-1];
    }
    if (btn.tag==1110) {
        [[MP3PlayerManager shareInstance] downLoadAudioWithUrl:url  finishDownLoadBloak:^(BOOL succeed) {
            if (succeed) {
                [(UIImageView *)btn startAnimating];
                btn.tag=1111;
                
                [[MP3PlayerManager shareInstance] audioPlayerWithURl:topath];
                [MP3PlayerManager shareInstance].playFinishBlock = ^(BOOL succeed)
                {
                    if (succeed) {
                        btn.tag=1110;
                        [(UIImageView *)btn stopAnimating];
                    }
                    
                };
                
            }
            
        }];
        
    }else if (btn.tag==1111){
        btn.tag=1110;
        [[MP3PlayerManager shareInstance] pausePlayer];
        [(UIImageView *)btn stopAnimating];
    }
    
    
    
}
#pragma mark 头像按钮点击事件
-(void)tableViewCellDidSeleteHeadImg:(LWImageStorage *)imageStoragen andIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arr;
    if (_meetMeBtn.selected==YES) {
        arr=_meetMeArr;
    }else {
        arr=_iMeetArr;
    }
    MyDetialViewController *myDetialViewCT=allocAndInit(MyDetialViewController);
    WantMeetLayout *layout=(WantMeetLayout *)arr[indexPath.row];
    MeetingData *data = layout.model;
    myDetialViewCT.userID=data.userid;
    [self.navigationController pushViewController:myDetialViewCT animated:YES];
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
