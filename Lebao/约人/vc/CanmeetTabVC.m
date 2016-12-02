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
#import "CoreArchive.h"
#import "ViewController.h"
#import "AuthenticationHomeViewController.h"
#import "VIPPrivilegeVC.h"
@interface CanmeetTabVC ()<UITableViewDelegate,UITableViewDataSource,MeettingTableViewDelegate,UIAlertViewDelegate,EjectViewDelegate,AddConnectionViewDelegate,UIScrollViewDelegate>
{
    AddConnectionView *connectionView;
    UIScrollView *bottomScrV;
}
@property(nonatomic,copy)NSString *keyword;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,assign)int authenPage;
@property(nonatomic,assign)int noAuthenPage;
@property (nonatomic,strong)UIView *underLineV;//下划线v
@property(nonatomic,strong)NSMutableArray *authenMeetArr;
@property(nonatomic,strong)NSMutableArray *noAuthenMeetArr;
@property(nonatomic, strong)BaseButton *selectedAddress;
@property(nonatomic, strong)BaseButton  *search;
@property(nonatomic,strong)UIButton *authenBtn;//认证按钮
@property(nonatomic,strong)UIButton *noAuthenBtn;//未认证按钮

@end

@implementation CanmeetTabVC

-(NSMutableArray*)authenMeetArr
{
    if (!_authenMeetArr) {
        _authenMeetArr=[[NSMutableArray alloc]init];
    }
    return _authenMeetArr;
}
-(NSMutableArray*)noAuthenMeetArr
{
    if (!_noAuthenMeetArr) {
        _noAuthenMeetArr=[[NSMutableArray alloc]init];
    }
    return _noAuthenMeetArr;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reflash:) name:@"KReflashCanMeet" object:nil];
    
}
-(void)reflash:(NSNotification *)notification
{
    NSMutableArray *arr;
    UITableView *tab;
    if (_authenBtn.selected) {
        arr=_authenMeetArr;
        tab=_authenTableView;
    }
    else if (_noAuthenBtn.selected){
        arr=_noAuthenMeetArr;
        tab=_noAuthenTableView;
    }
    for (int i=0;i<arr.count;i++) {
        MeetingCellLayout *layout=arr[i];
        if ([layout.model.userid isEqualToString:notification.object[@"userid"]]) {
            if ([notification.object[@"relation"] isEqualToString:@"1"]) {
                layout.model.relation=1;
                [arr replaceObjectAtIndex:i withObject:layout];
                [tab reloadRowsAtIndexPaths: @[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:NO];
            }
        }
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    _keyword =@"";
    _city = @"";
    _authenPage=1;
    _noAuthenPage=1;
    _state=@"3";
    [self navViewTitleAndBackBtn:@""];
        //搜索按钮
    
        _search = [[BaseButton alloc]initWithFrame:frame(80, StatusBarHeight + 7,APPWIDTH-160, NavigationBarHeight - 14) setTitle:@"搜索" titleSize:28*SpacedFonts titleColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] inView:self.view];
        [_search setRoundWithfloat:_search.height/2.0];
        [_search setBorder:LineBg width:0.5];
   
        __weak typeof(self) weakSelf= self;
         _search.didClickBtnBlock = ^{
            SearchAndAddTagsViewController * search  =  allocAndInit(SearchAndAddTagsViewController);
            search.searchResultBlock = ^(NSString *str)
            {
                [weakSelf.search setTitle:str forState:UIControlStateNormal];
                 weakSelf.keyword = str;
                [weakSelf.authenMeetArr removeAllObjects];
                [weakSelf.noAuthenMeetArr removeAllObjects];
                [weakSelf.authenTableView reloadData];
                [weakSelf.noAuthenTableView reloadData];
                weakSelf.authenPage = 1;
                weakSelf.noAuthenPage = 1;
                
                NSMutableArray *arr;
                UITableView *tab;
                if (weakSelf.authenBtn.selected) {
                    arr=weakSelf.authenMeetArr;
                    tab=weakSelf.authenTableView;
                }
                else if (weakSelf.noAuthenBtn.selected){
                    arr=weakSelf.noAuthenMeetArr;
                    tab=weakSelf.noAuthenTableView;
                }
                [weakSelf netWorkRefresh:NO andIsLoadMoreData:NO isShouldClearData:YES withState:weakSelf.state andTabView:tab andArr:arr andPage:1];
            };

             [weakSelf.navigationController pushViewController:search animated:NO];
    
        };
    
    UIImage *upImage =[UIImage imageNamed:@"exhibition_up"];
    UILabel *lbUp = allocAndInit(UILabel);
    CGSize sizeUp = [lbUp sizeWithContent:@"全国过" font:[UIFont systemFontOfSize:28*SpacedFonts]];
    float sizeW = sizeUp.width;
//    if (sizeUp.width>=140*SpacedFonts) {
//        sizeW = 160*SpacedFonts;
//    }
   
    self.selectedAddress  =[[BaseButton alloc]initWithFrame:frame(APPWIDTH-(sizeW + 5 + upImage.size.width)-10, StatusBarHeight, sizeW + 5 + upImage.size.width , NavigationBarHeight) setTitle:@"   全国" titleSize:28*SpacedFonts titleColor:BlackTitleColor backgroundImage:nil iconImage:upImage highlightImage:nil setTitleOrgin:CGPointMake( (NavigationBarHeight -28*SpacedFonts)/2.0 ,- upImage.size.width) setImageOrgin:CGPointMake((NavigationBarHeight - upImage.size.height)/2.0,sizeW + 5) inView:self.view];
    
    _selectedAddress.didClickBtnBlock =^
    {
        ViewController *vc=[[ViewController alloc]init];
        
        [vc returnText:^(NSString *cityname,NSString *cityID) {
            NSLog(@"cityID =%@",cityID);
             weakSelf.city = cityID;
            
            NSString *str = cityname;
            
            if (cityname.length>3) {
                str = [NSString stringWithFormat:@"%@...",[cityname substringWithRange:NSMakeRange(0, 2)]];
            }
            if (cityname.length==2) {
                str = [NSString stringWithFormat:@"   %@",[cityname substringWithRange:NSMakeRange(0, 2)]];
            }
            [weakSelf.selectedAddress setTitle:str forState:UIControlStateNormal];
            [weakSelf resetSeletedAddressFrameWithTitle:cityname];
            [weakSelf.authenMeetArr removeAllObjects];
            [weakSelf.noAuthenMeetArr removeAllObjects];
             [weakSelf.authenTableView reloadData];
            [weakSelf.noAuthenTableView reloadData];
             weakSelf.authenPage = 1;
            weakSelf.noAuthenPage = 1;
            
            NSMutableArray *arr;
            UITableView *tab;
            if (weakSelf.authenBtn.selected) {
                arr=weakSelf.authenMeetArr;
                tab=weakSelf.authenTableView;
            }
            else if (weakSelf.noAuthenBtn.selected){
                arr=weakSelf.noAuthenMeetArr;
                tab=weakSelf.noAuthenTableView;
            }
            [weakSelf netWorkRefresh:NO andIsLoadMoreData:NO isShouldClearData:YES withState:weakSelf.state andTabView:tab andArr:arr andPage:1];
            
        }];
        
        [weakSelf.navigationController pushViewController:vc animated:NO];
    };
    
    
    [self.view addSubview:_selectedAddress];
    
    [self addBottomSrollView];
    [self addTheBtnView];
    [self netWorkRefresh:NO andIsLoadMoreData:NO isShouldClearData:YES withState:_state andTabView:_authenTableView andArr:self.authenMeetArr andPage:_authenPage ];
}
//选择地址重新设置frame
- (void)resetSeletedAddressFrameWithTitle:(NSString *)title
{

    UILabel *lbUp =allocAndInit(UILabel);
    UIImage *upImage =[UIImage imageNamed:@"exhibition_up"];
    CGSize sizeUp = [lbUp sizeWithContent:[self.selectedAddress titleForState:UIControlStateNormal] font:Size(28)];
    float sizeW = sizeUp.width;
    if (sizeW>((APPWIDTH - self.selectedAddress.x - 10)- 5 - upImage.size.width)) {
        sizeW =((APPWIDTH - self.selectedAddress.x - 10)- 5 - upImage.size.width);
    }
    self.selectedAddress.frame = frame(self.selectedAddress.x, self.selectedAddress.y, sizeW +  5+ upImage.size.width , self.selectedAddress.height);

    self.selectedAddress.titlePoint = CGPointMake( (NavigationBarHeight -28*SpacedFonts)/2.0 ,- upImage.size.width);
    self.selectedAddress.imagePoint = CGPointMake((NavigationBarHeight - upImage.size.height)/2.0,sizeW + 5);
}
- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addBottomSrollView
{
    bottomScrV=[[UIScrollView alloc]initWithFrame:CGRectMake(0,StatusBarHeight + NavigationBarHeight + 36, SCREEN_WIDTH, SCREEN_HEIGHT-(StatusBarHeight + NavigationBarHeight + 36))];
    bottomScrV.contentSize = CGSizeMake(SCREEN_WIDTH*2, frameHeight(bottomScrV));
    bottomScrV.backgroundColor = [UIColor clearColor];
    bottomScrV.scrollEnabled = YES;
    bottomScrV.delegate = self;
    bottomScrV.alwaysBounceHorizontal = NO;
    bottomScrV.alwaysBounceVertical = NO;
    bottomScrV.showsHorizontalScrollIndicator = NO;
    bottomScrV.showsVerticalScrollIndicator = NO;
    bottomScrV.pagingEnabled = YES;
    bottomScrV.bounces = NO;
    
    [self.view addSubview:bottomScrV];
    [self addTabView];


}
/**
 *  上面的3个按钮
 */
-(void)addTheBtnView
{
    _authenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _authenBtn.frame = CGRectMake(0, 65, SCREEN_WIDTH/2, 35);
    [_authenBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_authenBtn setTitle:@"认证" forState:UIControlStateNormal];
    [_authenBtn setTitleColor:[UIColor colorWithRed:0.298 green:0.627 blue:0.996 alpha:1.000] forState:UIControlStateSelected];
    [_authenBtn setTitleColor:[UIColor colorWithWhite:0.514 alpha:1.000] forState:UIControlStateNormal];
    _authenBtn.backgroundColor = [UIColor whiteColor];
    _authenBtn.selected = YES;
    [_authenBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_authenBtn addTarget:self action:@selector(authenBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_authenBtn];
    
    _noAuthenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _noAuthenBtn.frame = CGRectMake(SCREEN_WIDTH/2, 65, SCREEN_WIDTH/2, 35);
    [_noAuthenBtn setTitle:@"未认证" forState:UIControlStateNormal];
    [_noAuthenBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_noAuthenBtn setTitleColor:[UIColor colorWithRed:0.298 green:0.627 blue:0.996 alpha:1.000] forState:UIControlStateSelected];
    [_noAuthenBtn setTitleColor:[UIColor colorWithWhite:0.514 alpha:1.000] forState:UIControlStateNormal];
    _noAuthenBtn.backgroundColor = [UIColor whiteColor];
    [_noAuthenBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_noAuthenBtn addTarget:self action:@selector(noAuthenBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_noAuthenBtn];
    
    _underLineV = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2-50)/2, 65+35-2, 50, 2)];
    _underLineV.backgroundColor = [UIColor colorWithRed:0.298 green:0.627 blue:0.996 alpha:1.000];
    [self.view addSubview:_underLineV];

}
#pragma mark - 头部2个按钮点击切换事件
-(void)authenBtn:(UIButton *)sender//认证
{
    sender.selected = YES;
    _noAuthenBtn.selected = NO;
    _state=@"3";
    [UIView animateWithDuration:0.3f animations:^{
        [_underLineV setFrame:CGRectMake((SCREEN_WIDTH/2-50)/2, 65+35-2, 50, 2)];
        [bottomScrV setContentOffset:CGPointMake(0, 0)];
    }];
    if (_authenMeetArr.count==0) {
        [self netWorkRefresh:NO andIsLoadMoreData:NO isShouldClearData:NO withState:_state andTabView:_authenTableView andArr:self.authenMeetArr andPage:_authenPage];
    }
   
}
-(void)noAuthenBtn:(UIButton *)sender//未认证
{
    sender.selected = YES;
    _authenBtn.selected = NO;
    _state=@"1";
    [UIView animateWithDuration:0.3f animations:^{
        [_underLineV setFrame:CGRectMake((SCREEN_WIDTH/2-50)/2+SCREEN_WIDTH/2, 65+35-2, 50, 2)];
        [bottomScrV setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    }];
    if (_noAuthenMeetArr.count==0) {
        [self netWorkRefresh:NO andIsLoadMoreData:NO isShouldClearData:NO withState:_state andTabView:_noAuthenTableView andArr:self.noAuthenMeetArr andPage:_noAuthenPage];
    }
   
}
-(void)addTabView
{
    self.authenTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, bottomScrV.frame.size.height) style:UITableViewStyleGrouped];
    self.authenTableView.delegate=self;
    self.authenTableView.dataSource=self;
    self.authenTableView.backgroundColor=[UIColor clearColor];
    self.authenTableView.tableFooterView=[[UIView alloc]init];
    self.authenTableView.separatorStyle=UITableViewCellSeparatorStyleNone;//去掉cell间的白线
    [[ToolManager shareInstance] scrollView:self.authenTableView headerWithRefreshingBlock:^{
        _authenPage =1;
        [self netWorkRefresh:YES andIsLoadMoreData:NO isShouldClearData:YES withState:_state andTabView:self.authenTableView andArr:self.authenMeetArr andPage:self.authenPage];
    }];
    [[ToolManager shareInstance] scrollView:self.authenTableView footerWithRefreshingBlock:^{
        _authenPage ++;
        [self netWorkRefresh:NO andIsLoadMoreData:YES isShouldClearData:NO withState:_state andTabView:_authenTableView andArr:self.authenMeetArr andPage:_authenPage];
    }];
    self.authenTableView.delegate = self;
    self.authenTableView.dataSource=self;
    [bottomScrV addSubview:self.authenTableView];
    
    self.noAuthenTableView=[[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH,0, SCREEN_WIDTH, bottomScrV.frame.size.height) style:UITableViewStyleGrouped];
    self.noAuthenTableView.delegate=self;
    self.noAuthenTableView.dataSource=self;
    self.noAuthenTableView.backgroundColor=[UIColor clearColor];
    self.noAuthenTableView.tableFooterView=[[UIView alloc]init];
    self.noAuthenTableView.separatorStyle=UITableViewCellSeparatorStyleNone;//去掉cell间的白线
    [[ToolManager shareInstance] scrollView:self.noAuthenTableView headerWithRefreshingBlock:^{
        _noAuthenPage =1;
        [self netWorkRefresh:YES andIsLoadMoreData:NO isShouldClearData:YES withState:_state andTabView:self.noAuthenTableView andArr:self.noAuthenMeetArr andPage:_noAuthenPage];
    }];
    [[ToolManager shareInstance] scrollView:self.noAuthenTableView footerWithRefreshingBlock:^{
        _noAuthenPage ++;
        [self netWorkRefresh:NO andIsLoadMoreData:YES isShouldClearData:NO withState:_state andTabView:self.noAuthenTableView andArr:self.noAuthenMeetArr andPage:_noAuthenPage];
    }];
    self.noAuthenTableView.delegate = self;
    self.noAuthenTableView.dataSource=self;
    [bottomScrV addSubview:self.noAuthenTableView];
    
    
    
}

-(void)netWorkRefresh:(BOOL)isRefresh andIsLoadMoreData:(BOOL)isMoreLoadMoreData isShouldClearData:(BOOL)isShouldClearData withState:(NSString *)state andTabView:(UITableView *)tabView andArr:(NSMutableArray *)arr andPage:(int)page//加载数据
{
    
    NSMutableDictionary *param = [Parameter parameterWithSessicon];
    if (arr.count==0) {
        [[ToolManager shareInstance] showWithStatus];
    }
    [param setObject:@(page) forKey:@"page"];
    [param setObject:_keyword forKey:@"keyword"];
     [param setObject:_city forKey:@"city"];
    [param setObject:@"" forKey:@"industrys"];
    [param setObject:_state forKey:@"authen"];
//    NSLog(@"param====%@",param);
    [XLDataService putWithUrl:canseeURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
//         NSLog(@"param====%@",param);
        if (isRefresh) {
            [[ToolManager shareInstance] endHeaderWithRefreshing:tabView];
        }
        if (isMoreLoadMoreData) {
            [[ToolManager shareInstance] endFooterWithRefreshing:tabView];
        }
        
        if (dataObj) {
//            NSLog(@"meetObj====%@",dataObj);
            MeetingModel *modal = [MeetingModel mj_objectWithKeyValues:dataObj];
            if (page ==1) {
                [[ToolManager shareInstance] moreDataStatus:tabView];
            }
            if (!modal.datas||modal.datas.count==0) {
                
                [[ToolManager shareInstance] noMoreDataStatus:tabView];
                
            }
            
            if (modal.rtcode ==1) {
                [[ToolManager shareInstance]dismiss];
                if (isShouldClearData) {
                    [arr removeAllObjects];
                }
                for (MeetingData *data in modal.datas) {
                    [arr addObject:[[MeetingCellLayout alloc]initCellLayoutWithModel:data andMeetBtn:NO andMessageBtn:YES andOprationBtn:NO andTime:NO andReward:NO]];
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

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_authenTableView) {
        MeetingCellLayout*layout =(MeetingCellLayout*)self.authenMeetArr[indexPath.row];
        
        return layout.cellHeight;
    }else if (tableView==_noAuthenTableView) {
        MeetingCellLayout*layout =(MeetingCellLayout*)self.noAuthenMeetArr[indexPath.row];
        
        return layout.cellHeight;
    }
    return 170;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_authenTableView) {
        return self.authenMeetArr.count;
    }else if (tableView==_noAuthenTableView) {
        return self.noAuthenMeetArr.count;
    }
    return 0;
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
    MeetingCellLayout *layout;
    if (tableView==_authenTableView) {
        layout=self.authenMeetArr[indexPath.row];
    }else if(tableView==_noAuthenTableView){
    layout=self.noAuthenMeetArr[indexPath.row];
    }
    [cell setCellLayout:layout];
    [cell setIndexPath:indexPath];
    
    if (layout.model.relation==0) {
        [cell.messageBtn setImage:[UIImage imageNamed:@"keyuejianjiarenmai"] forState:UIControlStateNormal];
        [cell.messageBtn setTitle:nil forState:UIControlStateNormal];
        cell.messageBtn.layer.cornerRadius=15;
        cell.messageBtn.userInteractionEnabled=YES;
        cell.messageBtn.backgroundColor=[UIColor clearColor];
    }else if (layout.model.relation==1) {
        [cell.messageBtn setImage:nil forState:UIControlStateNormal];
        [cell.messageBtn setTitle:@"请求中" forState:UIControlStateNormal];
        cell.messageBtn.layer.cornerRadius=12;
        cell.messageBtn.userInteractionEnabled=NO;
        cell.messageBtn.backgroundColor=AppViewBGColor;
    }else if (layout.model.relation==3) {
        [cell.messageBtn setImage:nil forState:UIControlStateNormal];
        cell.messageBtn.layer.cornerRadius=12;
        [cell.messageBtn setTitle:@"已添加" forState:UIControlStateNormal];
        cell.messageBtn.userInteractionEnabled=NO;
        cell.messageBtn.backgroundColor=AppViewBGColor;
    }
    
    
    [cell setDelegate:self];
    
    return cell;
    
}
#pragma mark
#pragma mark - MeettingTableViewCellDelegate 添加人脉按钮地点击
- (void)tableViewCellDidSeleteMessageBtn:(UIButton *)btn andIndexPath:(NSIndexPath *)indexPath
{
    [[ToolManager shareInstance] showWithStatus];
    NSMutableDictionary *param=[Parameter parameterWithSessicon];
    [param setObject:@"connection_add" forKey:@"type"];
//    NSLog(@"param===%@",param);
    [XLDataService putWithUrl:connetionCheckedURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if(dataObj){
      
//                            NSLog(@"dataobj===%@",dataObj);
            if ([dataObj[@"rtcode"] intValue]==1) {
          [[ToolManager shareInstance] dismiss];
    CGFloat dilX = 25;
    CGFloat dilH = 250;
    connectionView = [[AddConnectionView alloc] initAlertViewWithFrame:CGRectMake(dilX, 0, 250, dilH) andSuperView:self.view];
    connectionView.center = CGPointMake(APPWIDTH/2, APPHEIGHT/2-30);
    connectionView.delegate = self;
    connectionView.titleStr = @"提示";
    connectionView.indexth=indexPath;
    connectionView.title2Str=@"打赏让加人脉更顺畅!";
            }
            else if ([dataObj[@"rtcode"] intValue]==4001){
                [[ToolManager shareInstance]dismiss];
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"去身份认证吗?" message:dataObj[@"rtmsg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"不去",@"走起", nil];
                alertView.tag=22221;
                alertView.delegate=self;
                [alertView show];
                
            }else if ([dataObj[@"rtcode"] intValue] ==4005){
                [[ToolManager shareInstance]dismiss];
                
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"知脉君温馨提示" message:[NSString stringWithFormat:@"%@",dataObj[@"rtmsg"]] delegate:self cancelButtonTitle:nil otherButtonTitles:@"再看看",@"马上开通", nil];
                alertView.tag=22223;
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

#pragma mark - YXCustomAlertViewDelegate
- (void) customAlertView:(AddConnectionView *) customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    MeetingCellLayout *layout;
    if (_authenBtn.selected) {
         layout=self.authenMeetArr[customAlertView.indexth.row];
    }else if(_noAuthenBtn.selected){
         layout=self.noAuthenMeetArr[customAlertView.indexth.row];
    }
   
    MeetingData *model=layout.model;
    if (buttonIndex==0) {
//        [[ToolManager shareInstance] showWithStatus];
//        NSMutableDictionary *param=[Parameter parameterWithSessicon];
//        [param setObject:model.userid forKey:@"beinvited"];
//        [XLDataService putWithUrl:addConnectionsURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
//            if(dataObj){
////                NSLog(@"dataobj===%@",dataObj);
//                MeetingModel *model=[MeetingModel mj_objectWithKeyValues:dataObj];
//                if (model.rtcode==1) {
//                    [[ToolManager shareInstance] showAlertMessage:@"添加人脉请求已发出,请耐心等待"];
//                    layout.model.relation=1;
//                    [self.allMeetArr replaceObjectAtIndex:customAlertView.indexth.row withObject:layout];
//                    [self.tableView reloadRowsAtIndexPaths: @[[NSIndexPath indexPathForRow:customAlertView.indexth.row inSection:0]] withRowAnimation:NO];
//                    
//                }else if (model.rtcode ==4005){
//                    [[ToolManager shareInstance]dismiss];
//                    
//                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"知脉君温馨提示" message:[NSString stringWithFormat:@"%@",model.rtmsg] delegate:self cancelButtonTitle:nil otherButtonTitles:@"再看看",@"马上开通", nil];
//                    alertView.tag=22223;
//                    alertView.delegate=self;
//                    [alertView show];
//                }
//                else
//                {
//                    [[ToolManager shareInstance] showAlertMessage:model.rtmsg];
//                }
//                
//            }else
//            {
//                [[ToolManager shareInstance] showInfoWithStatus];
//                
//            }
//            
//        }];
        [customAlertView dissMiss];
        customAlertView = nil;
        
    }else
    {
        if ([customAlertView.money floatValue]>=1) {
            MeetPaydingVC * payVC = [[MeetPaydingVC alloc]init];
            NSMutableDictionary *param=[Parameter parameterWithSessicon];
            [param setObject:model.userid forKey:@"beinvited"];
            [param setObject:[NSString stringWithFormat:@"%.2f",[customAlertView.money floatValue]] forKey:@"reward"];
            payVC.param=param;
            payVC.jineStr =[NSString stringWithFormat:@"%.2f",[customAlertView.money floatValue]];
            payVC.whatZfType=1;
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
    }else if (alertView.tag==22223) {
        if (buttonIndex==0) {
            
        }else if(buttonIndex==1){
            PushView(self, allocAndInit(VIPPrivilegeVC));
        }
    }
}
#pragma mark- scrollview代理方法
/**
 *  @param scrollView <#scrollView description#>
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGPoint point = bottomScrV.contentOffset;
    [UIView animateWithDuration:0.3f animations:^{
        if ((int)point.x % (int)SCREEN_WIDTH == 0) {
            if (point.x/SCREEN_WIDTH ==0&&_noAuthenBtn.selected) {
                [self authenBtn:_authenBtn];
            }else if(point.x/SCREEN_WIDTH ==1&&_authenBtn.selected) {
                [self noAuthenBtn:_noAuthenBtn];
            }
                    }
    }];
    
}
-(void)tableViewCellDidSeleteHeadImg:(LWImageStorage *)imageStoragen layout:(MeetingCellLayout *)layout{
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


@end
