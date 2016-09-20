//
//  NotificationDetailViewController.m
//  Lebao
//
//  Created by David on 16/5/24.
//  Copyright © 2016年 David. All rights reserved.
//

#import "NotificationDetailViewController.h"
#import "XLDataService.h"
#import "NSString+Extend.h"
#import "MyLQDetailVC.h"
#import "MyXSDetailVC.h"
#import "XianSuoDetailVC.h"
#define cellH 94
#define SystemMessageURL [NSString stringWithFormat:@"%@message/system",HttpURL]
#define CorssMessageURL [NSString stringWithFormat:@"%@message/corss",HttpURL]
@interface NotificationDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *notificationDetailView;
@property(nonatomic,strong)NSMutableArray *notificationDetailArray;
@property(nonatomic,assign)int page;
@property(nonatomic,assign)int nowPage;
@end


@implementation SystemMessageModal

+ (NSDictionary *)mj_objectClassInArray
{
    
    return @{
             @"datas":@"SystemMessageData",
             };
    
}
@end
@implementation SystemMessageData

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}
@end
@implementation NotificationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     // Do any additional setup after loading the view.

    [self navViewTitleAndBackBtn:_isSystempagetype?@"系统消息":@"跨界提醒"];
    [self addTableView];
    _page =1;
    [self netWork:NO isFooter:NO isShouldClear:NO];
}
- (void)setIsSystempagetype:(BOOL)isSystempagetype
{
    self.navTitle.text = _isSystempagetype?@"系统消息":@"跨界提醒";
    _page =1;
    [self netWork:NO isFooter:NO isShouldClear:NO];
}
- (void)addTableView
{
    _notificationDetailArray = allocAndInit(NSMutableArray);
 
    _notificationDetailView = [[UITableView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, frameWidth(self.view), APPHEIGHT -(StatusBarHeight + NavigationBarHeight) ) style:UITableViewStyleGrouped];
    _notificationDetailView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _notificationDetailView.backgroundColor = [UIColor clearColor];
    _notificationDetailView.delegate = self;
    _notificationDetailView.dataSource = self;
    [[ToolManager shareInstance] scrollView:_notificationDetailView footerWithRefreshingBlock:^{
        _page =_nowPage + 1;
        [self netWork:NO isFooter:YES isShouldClear:NO];
    }];
    [[ToolManager shareInstance] scrollView:_notificationDetailView headerWithRefreshingBlock:^{
        _page =1;
        
        [self netWork:YES isFooter:NO isShouldClear:YES];
    }];
    [self.view addSubview:_notificationDetailView];
}

#pragma mark
#pragma mark - netWork-
- (void)netWork:(BOOL)isRefresh isFooter:(BOOL)isFooter isShouldClear:(BOOL)isShouldClear
{
    
    NSMutableDictionary *param = [Parameter parameterWithSessicon];
    [param setObject:@(_page) forKey:@"page"];
    
    if (_notificationDetailArray.count==0) {
        [[ToolManager shareInstance] showWithStatus];
    }
    [XLDataService postWithUrl:_isSystempagetype?SystemMessageURL:CorssMessageURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {

        if (isRefresh) {
            [[ToolManager shareInstance]endHeaderWithRefreshing
             :_notificationDetailView];
        }
        if (isFooter) {
            [[ToolManager shareInstance]endFooterWithRefreshing:_notificationDetailView];
        }
        
        if (dataObj) {
            
            SystemMessageModal *modal=[SystemMessageModal mj_objectWithKeyValues:dataObj];
            if (modal.rtcode ==1) {
                _nowPage = modal.page;
                if (_nowPage ==1) {
                    [[ToolManager shareInstance] moreDataStatus:_notificationDetailView];
                }
                if (_nowPage ==modal.allpage) {
                    [[ToolManager shareInstance] noMoreDataStatus:_notificationDetailView];;
                }
                [[ToolManager shareInstance] dismiss];
                if (isShouldClear) {
                    [_notificationDetailArray removeAllObjects];
                    
                }
                
                for (SystemMessageData *data  in  modal.datas) {
                    
                    [_notificationDetailArray addObject:data];
                    
                }
                
                [_notificationDetailView reloadData];
                if (_notificationDetailArray.count==0) {
                    
                    [self isShowEmptyStatus:YES];
                }
                else
                {
                     [self isShowEmptyStatus:NO];
                }
                
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
    return _notificationDetailArray.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
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

    return cellH;
  

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID =@"SystemMessageCell";
    SystemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[SystemMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:cellH cellWidth:frameWidth(_notificationDetailView)];
        
    }

    [cell setData:_notificationDetailArray[indexPath.section] showDetial:_isSystempagetype];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!_isSystempagetype) {
        
      SystemMessageData *data =  _notificationDetailArray[indexPath.section];
        
        if (data.iscoop) {
            //跳转我的领取线索详情
            MyLQDetailVC* myLqV =  [[MyLQDetailVC alloc]init];
            myLqV.xiansuoID = data.ID;
            [self.navigationController pushViewController:myLqV animated:YES];
            return;
        }
        if (data.isself) {
            //跳转我的发布线索详情
            MyXSDetailVC* myxiansuoV =  [[MyXSDetailVC alloc]init];
            myxiansuoV.xiansuoID = data.ID;
            [self.navigationController pushViewController:myxiansuoV animated:YES];
            
            return;
        }
        XianSuoDetailVC * xiansuoV =  [[XianSuoDetailVC alloc]init];
        xiansuoV.xs_id = data.ID;
        [self.navigationController pushViewController:xiansuoV animated:YES];
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

@implementation SystemMessageCell
{

    UILabel *_descripLb;
    UILabel *_time;
    UILabel *_showDetial;
    
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor =[UIColor clearColor];
        UIView *cell= allocAndInitWithFrame(UIView, frame(10, 0, cellWidth - 20, cellHeight));
        cell.backgroundColor = WhiteColor;
        [self addSubview:cell];
        
        _descripLb =[UILabel createLabelWithFrame:frame(10,0,frameWidth(cell) - 20, 63) text:@""fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
        _descripLb.numberOfLines = 0;
        
        UIView *cellBottom= allocAndInitWithFrame(UIView, frame(0, 63, frameWidth(cell), cellHeight - 63));
        cellBottom.backgroundColor = [UIColor colorWithRed:0.9647 green:0.9647 blue:0.9725 alpha:1.0];
        [cell addSubview:cellBottom];
        
        _time =[UILabel createLabelWithFrame:frame(10,0,frameWidth(cell)/2.0, frameHeight(cellBottom)) text:@""fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:cellBottom];
        
        _showDetial =  [UILabel createLabelWithFrame:frame(frameWidth(cell) - 60,0,24*SpacedFonts*4, frameHeight(cellBottom)) text:@"查看详情"fontSize:24*SpacedFonts textColor:[UIColor colorWithRed:0.9686 green:0.4784 blue:0.2784 alpha:1.0]  textAlignment:NSTextAlignmentRight inView:cellBottom];
        
        
    }
    return self;
    
}
- (void)setData:(SystemMessageData *)modal showDetial:(BOOL)showDetial
{
    _descripLb.text = [NSString stringWithFormat:@"[%@] %@",modal.title,modal.content];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_descripLb.text];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:28*SpacedFonts] range:[_descripLb.text rangeOfString:[NSString stringWithFormat:@"[%@]",modal.title]]];
    _descripLb.attributedText =str;
    
    _time.text = [modal.createtime timeformatString:@"yyyy-MM-dd HH:mm"];
    _showDetial.hidden = showDetial;
}
@end