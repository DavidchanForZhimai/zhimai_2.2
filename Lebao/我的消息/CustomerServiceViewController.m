//
//  CustomerServiceViewController.m
//  Lebao
//
//  Created by David on 16/5/27.
//  Copyright © 2016年 David. All rights reserved.
//

#import "CustomerServiceViewController.h"
#import "XLDataService.h"
#import "MessageCell.h"
#import "CommunicationViewController.h"
#define CustomerlistURL [NSString stringWithFormat:@"%@message/customerlist",HttpURL]
@interface CustomerServiceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *customerServiceView;
@property(nonatomic,strong)NSMutableArray *customerServiceArray;
@property(nonatomic,assign)int nowPage;
@property(nonatomic,assign)int page;
@end

@implementation CustomerServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _page = 1;
    [self navView];
    [self netWork:NO isFooter:NO isShouldClear:NO];
}
- (void)setIsRefresh:(BOOL)isRefresh
{
    if (isRefresh) {
        _page = 1;
         [self netWork:NO isFooter:NO isShouldClear:NO];
    }
}
#pragma mark - Navi_View
- (void)navView
{
    
    [self navViewTitleAndBackBtn:@"知脉客服"];
    _customerServiceArray = allocAndInit(NSMutableArray);
    
    _customerServiceView = [[UITableView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, frameWidth(self.view), APPHEIGHT -(StatusBarHeight + NavigationBarHeight) ) style:UITableViewStyleGrouped];
    _customerServiceView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _customerServiceView.backgroundColor = [UIColor clearColor];
    _customerServiceView.delegate = self;
    _customerServiceView.dataSource = self;
    [[ToolManager shareInstance] scrollView:_customerServiceView footerWithRefreshingBlock:^{
        _page =_nowPage + 1;
        [self netWork:NO isFooter:YES isShouldClear:NO];
    }];
    [[ToolManager shareInstance] scrollView:_customerServiceView headerWithRefreshingBlock:^{
        _page =1;
        
        [self netWork:YES isFooter:NO isShouldClear:YES];
    }];
    [self.view addSubview:_customerServiceView];
    

}

#pragma mark
#pragma mark - netWork-
- (void)netWork:(BOOL)isRefresh isFooter:(BOOL)isFooter isShouldClear:(BOOL)isShouldClear
{
    
    NSMutableDictionary *param = [Parameter parameterWithSessicon];
    [param setObject:@(_page) forKey:@"page"];
    
    if (_customerServiceArray.count==0) {
        [[ToolManager shareInstance] showWithStatus];
    }
    [XLDataService postWithUrl:CustomerlistURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
       // NSLog(@"dataObj =%@",dataObj);
        if (isRefresh) {
            [[ToolManager shareInstance]endHeaderWithRefreshing
             :_customerServiceView];
        }
        if (isFooter) {
            [[ToolManager shareInstance]endFooterWithRefreshing:_customerServiceView];
        }
        
        if (dataObj) {
            
            NotificationModal *modal=[NotificationModal mj_objectWithKeyValues:dataObj];
            if (modal.rtcode ==1) {
                _nowPage = modal.page;
                if (_nowPage ==1) {
                    [[ToolManager shareInstance] moreDataStatus:_customerServiceView];
                }
                if (_nowPage ==modal.allpage) {
                    [[ToolManager shareInstance] noMoreDataStatus:_customerServiceView];;
                }
                [[ToolManager shareInstance] dismiss];
                if (isShouldClear) {
                    [_customerServiceArray removeAllObjects];
                    
                }
                
                for (NotificationData *data  in  modal.datas) {
                    
                    [_customerServiceArray addObject:data];
                    
                }
                if (_customerServiceArray.count==0) {
                    [self isShowEmptyStatus:YES];
                }
                else
                {
                    [self isShowEmptyStatus:NO];
                }
                [_customerServiceView reloadData];
                
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
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _customerServiceArray.count;
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

        return 54;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID =@"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:54 cellWidth:frameWidth(_customerServiceView)];
        
        cell.backgroundColor = WhiteColor;
    }
    NotificationData *data=  _customerServiceArray[indexPath.row];
    cell.message.hidden = ![data.num boolValue];
    cell.message.text =data.num;
    [cell setData:data];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
        CommunicationViewController *community = allocAndInit(CommunicationViewController);
        NotificationData *data=   _customerServiceArray[indexPath.row];
        community.senderid = data.senderid;
        community.sourcetype = @"customer";
         community.chatType = ChatCustomerTpye;
        PushView(self, community);
    
    MessageCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.message.hidden = YES;
    
    
}
#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag ==NavViewButtonActionNavLeftBtnTag ) {
        PopView(self);
    }
    
}
@end
