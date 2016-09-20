//
//  MoreXianSuoVC.m
//  KuaJie
//
//  Created by 严文斌 on 16/5/23.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import "MoreXianSuoVC.h"
#import "MoreXSCell.h"
#import "MJRefresh.h"
#import "JJRDetailInfo.h"
#import "MyLQDetailVC.h"
#import "MyXSDetailVC.h"
@interface MoreXianSuoVC ()<UITableViewDelegate,UITableViewDataSource>
@property (assign,nonatomic)int page;
@property (strong,nonatomic)NSMutableArray * jsonArr;
@end

@implementation MoreXianSuoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKCOLOR;
    _jsonArr = [[NSMutableArray alloc]init];
    _page = 1;
    _myTab.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    [self setNav];
    [self getJson];
}
-(void)getJson
{
    [[JJRDetailInfo shareInstance]getMoreXianSuoWithID:_jjrID andPage:_page andCallBack:^(BOOL issucced, NSString *info, NSArray *jsonArr) {
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
-(void)loadMore
{
    _page ++;
    [self getJson];
    [_myTab.mj_footer endRefreshing];
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
    titLab.text = @"Ta的线索";
    titLab.font = [UIFont systemFontOfSize:16];
    [navView addSubview:titLab];
    UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0.5)];
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
    MoreXSCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[MoreXSCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr cellHeight:60 cellWidth:APPWIDTH];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_jsonArr.count>indexPath.row) {
        if ([[_jsonArr[indexPath.row] objectForKey:@"iscoop"] intValue] == 1) {
            //跳转我的领取线索详情
            MyLQDetailVC* myLqV =  [[MyLQDetailVC alloc]init];
            myLqV.xiansuoID = [_jsonArr[indexPath.row] objectForKey:@"id"];
            [self.navigationController pushViewController:myLqV animated:YES];
            return;
        }
        if ([[_jsonArr[indexPath.row] objectForKey:@"isself"] intValue] == 1) {
            //跳转我的发布线索详情
            MyXSDetailVC* myxiansuoV =  [[MyXSDetailVC alloc]init];
            myxiansuoV.xiansuoID = [_jsonArr[indexPath.row] objectForKey:@"id"];
            [self.navigationController pushViewController:myxiansuoV animated:YES];
            
            return;
        }
        XianSuoDetailVC * xiansuoV =  [[XianSuoDetailVC alloc]init];
        xiansuoV.xs_id = [_jsonArr[indexPath.row] objectForKey:@"id"];
        [self.navigationController pushViewController:xiansuoV animated:YES];
        
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
