//
//  MyVisitorVC.m
//  Lebao
//
//  Created by adnim on 2016/12/19.
//  Copyright © 2016年 David. All rights reserved.
//

#import "MyVisitorVC.h"
#import "XLDataService.h"
#import "MeetingModel.h"
#import "MyVisitorCell.h"
#import "MyDetialViewController.h"
//我的人脉
#define  visitorslistURL [NSString stringWithFormat:@"%@broker/visitorslist",HttpURL]
@interface MyVisitorVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tabView;
@property (nonatomic,assign)int page;
@property (nonatomic,strong)NSMutableArray *visitorsArr;

@end

@implementation MyVisitorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=AppViewBGColor;
    [self navViewTitleAndBackBtn:@"我的访客"];
    _page=1;
    [self creatTabView];
    [self netWorkRefresh:NO andIsLoadMoreData:NO isShouldClearData:NO];
    
}
-(UITableView *)tabView{
    if (!_tabView) {
        _tabView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigationBarHeight+StatusBarHeight, APPWIDTH, APPHEIGHT-NavigationBarHeight-StatusBarHeight) style:UITableViewStyleGrouped];
    }
    return _tabView;
}
-(NSMutableArray *)visitorsArr{
    if (!_visitorsArr) {
        _visitorsArr=[NSMutableArray new];
    }
    return _visitorsArr;
}
-(void)creatTabView{

    self.tabView.delegate=self;
    self.tabView.dataSource=self;
    self.tabView.backgroundColor=[UIColor clearColor];
    
    [[ToolManager shareInstance]scrollView:self.tabView headerWithRefreshingBlock:^{
        _page =1;
        [self netWorkRefresh:YES andIsLoadMoreData:NO isShouldClearData:YES];

    }];
    [[ToolManager shareInstance] scrollView:self.tabView  footerWithRefreshingBlock:^{
        _page ++;
        [self netWorkRefresh:NO andIsLoadMoreData:YES isShouldClearData:NO];
    }];
    [self.view addSubview:self.tabView];
    if ([self.tabView respondsToSelector:@selector(setSeparatorInset:)]) {//设置cell线宽
        [self.tabView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
}

- (void)netWorkRefresh:(BOOL)isRefresh andIsLoadMoreData:(BOOL)isMoreLoadMoreData isShouldClearData:(BOOL)isShouldClearData//加载数据
{

        if (self.visitorsArr.count==0) {
            [[ToolManager shareInstance] showWithStatus];
        }
        
        NSMutableDictionary *param = [Parameter parameterWithSessicon];
        [param setObject:@(_page) forKey:@"page"];
        
        [XLDataService putWithUrl:visitorslistURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
            //        NSLog(@"param====%@",param);
            if (isRefresh) {
                [[ToolManager shareInstance] endHeaderWithRefreshing:self.tabView];
            }
            if (isMoreLoadMoreData) {
                [[ToolManager shareInstance] endFooterWithRefreshing:self.tabView];
            }
            if (dataObj) {
                NSLog(@"meetObj====%@",dataObj);
                MeetingModel *modal = [MeetingModel mj_objectWithKeyValues:dataObj];
                if (_page ==1) {
                    [[ToolManager shareInstance] moreDataStatus:self.tabView];
                }
                if (!modal.datas||modal.datas.count==0) {
                    [[ToolManager shareInstance] noMoreDataStatus:self.tabView];
                }
                if (modal.rtcode ==1) {
                    [[ToolManager shareInstance] dismiss];
                    if (isShouldClearData) {
                        [self.visitorsArr removeAllObjects];
                    }
                    for (MeetingData *data in modal.datas) {
                        if (![self.visitorsArr containsObject:data.userid]) {
                            [self.visitorsArr addObject:data];
                        }
                    }
                    [self.tabView reloadData];
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
#pragma mark----tableview代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.visitorsArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"MeettingTableViewCellID";
    MyVisitorCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MyVisitorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell configCellWithModel:self.visitorsArr[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyDetialViewController *myDetialViewCT=[MyDetialViewController new];
    MeetingData *data=self.visitorsArr[indexPath.row];
    myDetialViewCT.userID=data.userid;
    [self.navigationController pushViewController:myDetialViewCT animated:YES];
}
//-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath//高亮
//{
//    return NO;
//}

- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
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
