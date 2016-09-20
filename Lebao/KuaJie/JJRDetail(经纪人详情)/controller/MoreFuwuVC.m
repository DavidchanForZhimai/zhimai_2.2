//
//  MoreFuwuVC.m
//  KuaJie
//
//  Created by 严文斌 on 16/5/23.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import "MoreFuwuVC.h"
#import "MoreFWCell.h"
#import "JJRDetailInfo.h"
#import "MJRefresh.h"

//产品
#import "MyContentDetailViewController.h"
#import "MyProductDetailViewController.h"
#import "TheSecondaryHouseViewController.h"
#import "TheSecondCarHomeViewController.h"
#import "WetChatShareManager.h"
@interface MoreFuwuVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTab;
@property (assign,nonatomic)int page;
@property (strong,nonatomic)NSMutableArray * jsonArr;

@end

@implementation MoreFuwuVC
{
    NSDictionary *fuwuDic;
    UIImageView *fuwuImg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKCOLOR;
    _page = 1;
    _jsonArr = [[NSMutableArray alloc]init];
    _myTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setNav];
    [self addTheTabReflash];
    [self getJson];
  
}
-(void)addTheTabReflash
{
    _myTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        if (_jsonArr.count >0) {
            [_jsonArr removeAllObjects];
        }
        [_myTab reloadData];
        [_myTab.mj_header endRefreshing];
        
        [self getJson];
    }];
    
    _myTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
     _myTab.footer.automaticallyHidden = NO;
}
-(void)loadMore
{
    _page ++;
    [self getJson];
    [_myTab.mj_footer endRefreshing];
}
-(void)getJson
{
    [[JJRDetailInfo shareInstance]getMoreFuwuWithID:_jjrid andPage:_page andCallBack:^(BOOL issucced, NSString *info, NSArray *jsonArr) {
        if (issucced == YES) {
            if (jsonArr.count >0) {
                [[ToolManager shareInstance]dismiss];
                for (NSDictionary * dic in jsonArr) {
                    
                    [_jsonArr addObject:dic];
                }
                [_myTab reloadData];
            }else
            {
                [[ToolManager shareInstance]showAlertMessage:@"没有更多数据了"];
            }
        }else
        {
            [[ToolManager shareInstance]showAlertMessage:info];
        }
    }];
}
-(void)setNav
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = YES;
   
    UIView * navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 60, 44);
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    backBtn.imageView.contentMode = UIViewContentModeLeft;

    [backBtn setImage:[UIImage imageNamed:@"iconfont-fanhui"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    

    
    UILabel * titLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 20, 120, 44)];
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.textColor = [UIColor blackColor];
    titLab.text = @"Ta的服务";
    titLab.font = [UIFont systemFontOfSize:16];
    [navView addSubview:titLab];
    UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 1)];
    hxV.backgroundColor = [UIColor colorWithRed:0.816 green:0.820 blue:0.827 alpha:1.000];
    [self.view addSubview:hxV];
    
}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction
{
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _jsonArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellStr = @"myCell";
    MoreFWCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[MoreFWCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr cellHeight:60 cellWidth:APPWIDTH];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    [cell setModelWithDic:_jsonArr[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (_jsonArr.count>indexPath.row) {
        fuwuDic = _jsonArr[indexPath.row];
        MoreFWCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        fuwuImg=cell.cellImage;
        if ([fuwuDic[@"actype"] isEqualToString:@"article"]) {
            MyContentDetailViewController *detail = allocAndInit(MyContentDetailViewController);
            detail.shareImage = fuwuImg.image;
            detail.ID =fuwuDic[@"id"];
            detail.isNoEdit = YES;
            detail.uid =fuwuDic[@"userid"];
            detail.imageurl = fuwuDic[@"imgurl"];
            PushView(self, detail);
        }
        else if([fuwuDic[@"industry"] isEqualToString:@"insurance"]||[fuwuDic[@"industry"] isEqualToString:@"finance"]||[fuwuDic[@"industry"] isEqualToString:@"other"])
        {
            MyProductDetailViewController *detail = allocAndInit(MyProductDetailViewController);
            detail.shareImage = fuwuImg.image;
            detail.ID =fuwuDic[@"id"];
            detail.isNoEdit = YES;
            detail.uid =fuwuDic[@"userid"];
            detail.imageurl =fuwuDic[@"imgurl"];
            PushView(self, detail);
            
        }
        //这是房产的产品
        else if([fuwuDic[@"industry"] isEqualToString:@"property"])
        {
            
            BaseButton *share = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 50, StatusBarHeight, 50, NavigationBarHeight) backgroundImage:nil iconImage:[UIImage imageNamed:@"icon_widelyspreaddetail_share"] highlightImage:nil inView:self.view];
            
            share.didClickBtnBlock = ^
            {
                
                [[WetChatShareManager shareInstance] shareToWeixinApp:fuwuDic[@"title"] desc:@"" image:fuwuImg.image  shareID:fuwuDic[@"id"] isWxShareSucceedShouldNotice:NO isAuthen:[fuwuDic[@"isgetclue"] boolValue]];
                
                
            };
            
            [[ToolManager shareInstance] loadWebViewWithUrl:[NSString stringWithFormat:@"%@show/estate?acid=%@",HttpURL,[NSString stringWithFormat:@"%@",fuwuDic[@"id"]]] title:@"产品详情" pushView:self rightBtn:share];
        }
        
        //这是车行的产品
        else if([fuwuDic[@"industry"] isEqualToString:@"car"])
        {
            
            BaseButton *share = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 50, StatusBarHeight, 50, NavigationBarHeight) backgroundImage:nil iconImage:[UIImage imageNamed:@"icon_widelyspreaddetail_share"] highlightImage:nil inView:self.view];
            
            share.didClickBtnBlock = ^
            {
                
                
               [[WetChatShareManager shareInstance] shareToWeixinApp:fuwuDic[@"title"] desc:@"" image:fuwuImg.image  shareID:fuwuDic[@"id"] isWxShareSucceedShouldNotice:NO isAuthen:[fuwuDic[@"isgetclue"] boolValue]];
                
                
            };
            
            [[ToolManager shareInstance] loadWebViewWithUrl:[NSString stringWithFormat:@"%@show/car?acid=%@",HttpURL,[NSString stringWithFormat:@"%@",fuwuDic[@"id"]]] title:@"产品详情" pushView:self rightBtn:share];
        }
        
    }
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *)getDateStringWithDate:(NSDate *)date
                         DateFormat:(NSString *)formatString
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formatString];
    NSString *dateString = [dateFormat stringFromDate:date];
    //     NSLog(@"date: %@", dateString);
    
    return dateString;
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
