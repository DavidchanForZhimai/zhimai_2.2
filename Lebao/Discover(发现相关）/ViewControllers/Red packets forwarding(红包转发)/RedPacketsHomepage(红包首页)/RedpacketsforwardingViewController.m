//
//  RedpacketsforwardingViewController.m
//  Lebao
//
//  Created by David on 16/5/13.
//  Copyright © 2016年 David. All rights reserved.
//

#import "RedpacketsforwardingViewController.h"
#import "ExhibitionIndustryCell.h"
#import "XLDataService.h"
#import "CommunicationViewController.h"
#import "CrossBorderTransmissionViewController.h"
#import "WetChatShareManager.h"
#import "MyProductDetailViewController.h"
#import "MyCrossBroderViewController.h"
#import "CoreArchive.h"
#define RID  @"rid"
#define cellH 153.0/2
#define RewardURL [NSString stringWithFormat:@"%@release/reward",HttpURL]
@interface RedpacketsforwardingViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation RedpacketsforwardingViewController
{
    UITableView *_exhibitionRedPaperView;
    NSMutableArray *_exhibitionRedPaperArray;
    int page;
    int nowPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    page = 1;
   [self navViewTitleAndBackBtn:@"红包转发"];
    BaseButton *redpaper = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 50, StatusBarHeight, 50, NavigationBarHeight) backgroundImage:nil iconImage:[UIImage imageNamed:@"icon_red_packets_forwarding"] highlightImage:nil inView:self.view];
    __weak RedpacketsforwardingViewController *weakSelf =self;
    redpaper.didClickBtnBlock = ^
    {
        PushView(weakSelf, allocAndInit(MyCrossBroderViewController));
    };

    [self addTableView];
   [self netWorkIsRefresh:NO isLoadMore:NO shouldClearData:YES];


}
- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
}
#pragma mark
#pragma mark - addTableView -
- (void)addTableView
{
    _exhibitionRedPaperArray = [NSMutableArray new];
    
    _exhibitionRedPaperView =[[UITableView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)) style:UITableViewStyleGrouped];
    _exhibitionRedPaperView.delegate = self;
    _exhibitionRedPaperView.dataSource = self;
    _exhibitionRedPaperView.backgroundColor =[UIColor clearColor];
    
    [[ToolManager shareInstance] scrollView:_exhibitionRedPaperView headerWithRefreshingBlock:^{
        page =nowPage;
        [self netWorkIsRefresh:YES isLoadMore:NO shouldClearData:YES];
    }];
    [[ToolManager shareInstance] scrollView:_exhibitionRedPaperView footerWithRefreshingBlock:^{
        
        page =nowPage+ 1;
        [self netWorkIsRefresh:NO isLoadMore:YES shouldClearData:NO];
        
        
    }];
    [self.view addSubview:_exhibitionRedPaperView];
}
#pragma mark
#pragma mark - netWork
- (void)netWorkIsRefresh:(BOOL)isRefresh isLoadMore:(BOOL)isLoadMore shouldClearData:(BOOL)shouldClearData
{

    if (_exhibitionRedPaperArray.count==0) {
        
        [[ToolManager shareInstance] showWithStatus:@"加载数据..."];
        
    }
    
    NSMutableDictionary *param = [Parameter parameterWithSessicon];
    [param setObject:@(page) forKey:@"page"];
 
    [XLDataService postWithUrl:RewardURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (isRefresh) {
            [[ToolManager shareInstance] endHeaderWithRefreshing:_exhibitionRedPaperView];
        }
        if (isLoadMore) {
            [[ToolManager shareInstance] endFooterWithRefreshing:_exhibitionRedPaperView];
        }
        if (dataObj) {
            
            if ([dataObj[@"rtcode"] integerValue]==1) {
//                NSLog(@"dataObj =%@",dataObj);
                [CoreArchive setStr:dataObj[@"rid"] key:RID];
                [[ToolManager shareInstance] dismiss];
                if (shouldClearData) {
                    [_exhibitionRedPaperArray removeAllObjects];
                }
                nowPage =[dataObj[@"page"] intValue];
                if (nowPage ==1) {
                    [[ToolManager shareInstance] moreDataStatus:_exhibitionRedPaperView];
                }
                if (nowPage ==[dataObj[@"allpage"] intValue]) {
                    
                    [[ToolManager shareInstance] noMoreDataStatus:_exhibitionRedPaperView];
                }
               
                for (NSDictionary *datas in dataObj[@"datas"]) {
                    ExhibitionIndustryRewarddatas *data = [ExhibitionIndustryRewarddatas mj_objectWithKeyValues:datas];
                    [_exhibitionRedPaperArray addObject:data];
                }
                [_exhibitionRedPaperView reloadData];
            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus:dataObj[@"rtmsg"]];
            }
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus];
        }
        
    }];
    
}
#pragma mark
#pragma mark - TableViewDelegate TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    return _exhibitionRedPaperArray.count;
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *footer = allocAndInitWithFrame(UIView, frame(0, 0,0,0));
    
    return footer;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    return allocAndInit(UIView);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        static NSString *cellID =@"ExhibitionRedPaperCell";
        ExhibitionRedPaperCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[ExhibitionRedPaperCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:cellH cellWidth:frameWidth(_exhibitionRedPaperView)];
            
            
        }
        ExhibitionIndustryRewarddatas *data = _exhibitionRedPaperArray[indexPath.row];
        [cell setData:data communityBlock:^(ExhibitionIndustryRewarddatas *data){
            CommunicationViewController *vc = allocAndInit(CommunicationViewController);
            vc.sourceid = [NSString stringWithFormat:@"%i",(int)data.ID];
            vc.sourcetype = @"wallet";
            vc.chatType = ChatRedEnvelopePTpye;
            vc.receiver = data.uid;
            PushView(self, vc);
        }];
        return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
        ExhibitionIndustryRewarddatas *data = _exhibitionRedPaperArray[indexPath.row];
    
        ExhibitionRedPaperCell *cell = [_exhibitionRedPaperView cellForRowAtIndexPath:indexPath];
        if ([data.actype isEqualToString:@"article"]) {
            CrossBorderTransmissionViewController *crossBorderTransmissionViewController = allocAndInit(CrossBorderTransmissionViewController);
            
            crossBorderTransmissionViewController.ID= [NSString stringWithFormat:@"%i",(int)data.ID];
            crossBorderTransmissionViewController.shareImage =cell.icon.image;
            crossBorderTransmissionViewController.nav_title = @"红包转发";
            crossBorderTransmissionViewController.actype = data.actype;
            crossBorderTransmissionViewController.industry = data.industry;
            crossBorderTransmissionViewController.uid = data.uid;
            PushView(self, crossBorderTransmissionViewController);
        }
        else if([data.industry isEqualToString:@"insurance"]||[data.industry isEqualToString:@"finance"]||[data.industry isEqualToString:@"other"])
        {
            MyProductDetailViewController *detail = allocAndInit(MyProductDetailViewController);
            detail.shareImage =cell.icon.image;
            detail.ID = [NSString stringWithFormat:@"%i",(int)data.ID];
            detail.uid =data.uid;
            detail.isNoEdit = YES;
            detail.imageurl = data.imgurl;
            PushView(self, detail);
            
        }
        //这是房产的产品
        else if([data.industry isEqualToString:@"property"])
        {
            //            __weak ExhibitionIndustryViewController *weakSelf = self;
            BaseButton *share = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 50, StatusBarHeight, 50, NavigationBarHeight) backgroundImage:nil iconImage:[UIImage imageNamed:@"icon_widelyspreaddetail_share"] highlightImage:nil inView:self.view];
            
            share.didClickBtnBlock = ^
            {
                
                
                [[WetChatShareManager shareInstance] shareToWeixinApp:data.title desc:@"" image:cell.icon.image  shareID:[NSString stringWithFormat:@"%i",(int)data.ID] isWxShareSucceedShouldNotice:YES isAuthen:data.isgetclue];
                
                
            };
            
            [[ToolManager shareInstance] loadWebViewWithUrl:[NSString stringWithFormat:@"%@show/estate?acid=%@",HttpURL,[NSString stringWithFormat:@"%i",(int)data.ID]] title:@"产品详情" pushView:self rightBtn:share];
            
        }
        
        //这是车行的产品
        else if([data.industry isEqualToString:@"car"])
        {
            
            //            __weak ExhibitionIndustryViewController *weakSelf = self;
            BaseButton *share = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 50, StatusBarHeight, 50, NavigationBarHeight) backgroundImage:nil iconImage:[UIImage imageNamed:@"icon_widelyspreaddetail_share"] highlightImage:nil inView:self.view];
            
            share.didClickBtnBlock = ^
            {
                
                
                [[WetChatShareManager shareInstance] shareToWeixinApp:data.title desc:@"" image:cell.icon.image  shareID:[NSString stringWithFormat:@"%i",(int)data.ID] isWxShareSucceedShouldNotice:YES isAuthen:data.isgetclue];
                
                
            };
            
            [[ToolManager shareInstance] loadWebViewWithUrl:[NSString stringWithFormat:@"%@show/car?acid=%@",HttpURL,[NSString stringWithFormat:@"%i",(int)data.ID]] title:@"产品详情" pushView:self rightBtn:share];
            
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
