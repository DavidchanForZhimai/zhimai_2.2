//
//  NotificationViewController.m
//  Lebao
//
//  Created by David on 15/12/10.
//  Copyright © 2015年 David. All rights reserved.
//

#import "NotificationViewController.h"
#import "MeCell.h"
#import "XLDataService.h"
#import "MessageCell.h"
#import "CommunicationViewController.h"
#import "NotificationDetailViewController.h"
#import "NotificationSettingViewController.h"
#import "CustomerServiceViewController.h"
#import "CoreArchive.h"
#import "MyConnectionsVC.h"
#define cellH  40
#define MessageURL [NSString stringWithFormat:@"%@message/index",HttpURL]
@interface NotificationViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong)UITableView *notificationView;
@property(nonatomic,strong)NSMutableArray *notificationArray;
@property(nonatomic,strong)NSMutableArray *secondNotificationArray;
@property(nonatomic,assign)int nowPage;
@property(nonatomic,assign)int page;

@property(nonatomic,strong)BaseButton *headerView;
@end

@implementation NotificationViewController
{
    NotificationModal *modal;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([CoreArchive strForKey:@"isread"]) {
        [self.homePageBtn setImage:[UIImage imageNamed:@"icon_dicover_me_selected"] forState:UIControlStateNormal];
    }
    else
    {
        
        [self.homePageBtn setImage:[UIImage imageNamed:@"icon_dicover_me"] forState:UIControlStateNormal];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTabbarIndex:2];
    _page = 1;
    [self navView];
    [self netWork:NO isFooter:NO isShouldClear:NO];
}
- (void)setIsRefresh:(BOOL)isRefresh
{
    if (isRefresh) {
        _page =1;
        [self netWork:YES isFooter:NO isShouldClear:YES];
    }
}
#pragma mark - Navi_View
- (void)navView
{
    [self navViewTitle:@"消息"];
    _notificationArray = allocAndInit(NSMutableArray);
    _secondNotificationArray = allocAndInit(NSMutableArray);
     NSArray *_sectionOne =[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"系统消息",@"name",@"icon_message_xitongxiaoxi",@"image",@"1",@"show",@"",@"viewController",nil],[NSDictionary dictionaryWithObjectsAndKeys:@"知脉头条",@"name",@"icon_message_toutiao",@"image" ,@"1",@"show",@"",@"viewController",nil] ,[NSDictionary dictionaryWithObjectsAndKeys:@"我的人脉",@"name",@"icon_message_woderenmai",@"image" ,@"0",@"show",@"MyConnectionsVC",@"viewController",nil],nil];
    [_notificationArray addObject:_sectionOne];
    [_notificationArray addObject:_secondNotificationArray];
    
    _notificationView = [[UITableView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, frameWidth(self.view), APPHEIGHT -(StatusBarHeight + NavigationBarHeight + TabBarHeight) ) style:UITableViewStyleGrouped];
    _notificationView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _notificationView.backgroundColor = [UIColor clearColor];
    _notificationView.delegate = self;
    _notificationView.dataSource = self;
    [[ToolManager shareInstance] scrollView:_notificationView footerWithRefreshingBlock:^{
        _page =_nowPage + 1;
        [self netWork:NO isFooter:YES isShouldClear:NO];
    }];
    [[ToolManager shareInstance] scrollView:_notificationView headerWithRefreshingBlock:^{
        _page =1;
        [self netWork:YES isFooter:NO isShouldClear:YES];
    }];
    _notificationView.tableHeaderView = self.headerView;
    [self.view addSubview:_notificationView];
    
//    //设置
//    UIImage *image = [UIImage imageNamed:@"iconfont-shezhi"];
//    BaseButton *set =  [[BaseButton alloc]initWithFrame:frame(frameWidth(self.view) - 30, StatusBarHeight + (NavigationBarHeight - 15)/2.0, 15, 15) backgroundImage:image iconImage:nil highlightImage:nil inView:self.view];
//    set.didClickBtnBlock = ^
//    {
//        PushView(self, allocAndInit(NotificationSettingViewController));
//    };

}
- (BaseButton *)headerView
{
    if (_headerView) {
        return _headerView;
    }
    UIImage *image = [UIImage imageNamed:@"icon_message_toingzhi"];
    
    _headerView = [[BaseButton alloc]initWithFrame:CGRectMake(0, 0, APPWIDTH, 30) setTitle:@"人脉添加请求 +3" titleSize:22*SpacedFonts titleColor:WhiteColor backgroundImage:nil iconImage:image highlightImage:image setTitleOrgin:CGPointMake((30 - 22*SpacedFonts)/2.0, APPWIDTH/3.0 + 10) setImageOrgin:CGPointMake((30 - image.size.height)/2.0, APPWIDTH/3.0) inView:nil];
    _headerView.backgroundColor = [UIColor colorWithRed:0.9922 green:0.5961 blue:0.2 alpha:1.0];
    _headerView.shouldAnmial = NO;
    return _headerView;
}
#pragma mark
#pragma mark - netWork-
- (void)netWork:(BOOL)isRefresh isFooter:(BOOL)isFooter isShouldClear:(BOOL)isShouldClear
{
    
    NSMutableDictionary *param = [Parameter parameterWithSessicon];
    [param setObject:@(_page) forKey:@"page"];
    
    if (_secondNotificationArray.count==0) {
        [[ToolManager shareInstance] showWithStatus];
    }
    [XLDataService postWithUrl:MessageURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
//        NSLog(@"%@",dataObj);
        if (isRefresh) {
            [[ToolManager shareInstance]endHeaderWithRefreshing
             :_notificationView];
        }
        if (isFooter) {
            [[ToolManager shareInstance]endFooterWithRefreshing:_notificationView];
        }
        
        if (dataObj) {
          
            modal=[NotificationModal mj_objectWithKeyValues:dataObj];
            if (modal.rtcode ==1) {
                _nowPage = modal.page;
                if (_nowPage ==1) {
                    [[ToolManager shareInstance] moreDataStatus:_notificationView];
                }
                if (_nowPage ==modal.allpage) {
                    [[ToolManager shareInstance] noMoreDataStatus:_notificationView];;
                }
                [[ToolManager shareInstance] dismiss];
                if (isShouldClear) {
                    [_secondNotificationArray removeAllObjects];
            
                }
                
                for (NotificationData *data  in  modal.datas) {
                    
                    [_secondNotificationArray addObject:data];
                    
                }
                
                
                [_notificationArray replaceObjectAtIndex:1 withObject:_secondNotificationArray];
                
                [_notificationView reloadData];
                
            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus:modal.rtmsg];
            }
            
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus];
        }
        
    }];
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _notificationArray.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
  NSArray * array = _notificationArray[section];
  return array.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}
- (CGFloat) tableView:(UITableView *)tableView  heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
    return cellH;
    }
    else
    return 54;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *cellID =@"MeCell";
        MeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[MeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:cellH cellWidth:frameWidth(_notificationView)];
            
            cell.backgroundColor = WhiteColor;
        }
        NSArray * _sectionArray = _notificationArray[indexPath.section];
        NSDictionary *dict = _sectionArray[indexPath.row];
        [cell setLeftImage:dict[@"image"] Title:dict[@"name"] isShowLine:[dict[@"show"] boolValue]];
        if (indexPath.row==0) {
            cell.message.hidden =![modal.syscount boolValue];
        }
        if (indexPath.row==1) {
            cell.message.hidden =![modal.corsscount boolValue];
        }
        if (indexPath.row==2) {
            cell.message.hidden =![modal.cuscount boolValue];
        }
        
        return cell;

    }
    static NSString *cellID =@"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:54 cellWidth:frameWidth(_notificationView)];
        
        cell.backgroundColor = WhiteColor;
    }
    
    NSArray * _sectionArray = _notificationArray[indexPath.section];
    NotificationData*data = _sectionArray[indexPath.row];
    cell.message.hidden = ![data.num boolValue];
    cell.message.text =data.num;
    [cell setData:data];
    

    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0&&indexPath.row!=2) {
        NotificationDetailViewController *detail = allocAndInit(NotificationDetailViewController);
        detail.isSystempagetype =indexPath.row==1?NO:YES;
        PushView(self, detail);
//        MeCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
//        cell.message.hidden = YES;
    }
    if (indexPath.section==0&&indexPath.row==2) {
        MyConnectionsVC *detail = allocAndInit(MyConnectionsVC);
        PushView(self, detail);
        MeCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
        cell.message.hidden = YES;
        
    }
    if (indexPath.section==1) {
        CommunicationViewController *community = allocAndInit(CommunicationViewController);
        NSArray * _sectionArray = _notificationArray[indexPath.section];
        NotificationData *data=   _sectionArray[indexPath.row];
        community.senderid = data.senderid;
        community.chatType = ChatMessageTpye;
        PushView(self, community);
        MessageCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
        cell.message.hidden = YES;
    }
    
    
}
#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag ==NavViewButtonActionNavLeftBtnTag ) {
        PopView(self);
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
