//
//  JinJiRenViewController.m
//  Lebao
//
//  Created by adnim on 16/8/1.
//  Copyright © 2016年 David. All rights reserved.
//

#import "JinJiRenViewController.h"
#import "JJRCell.h"
#import "MJRefresh.h"
#import "JJRDetailVC.h"
#import "JingJiRenVC.h"
#import "AppDelegate.h"
#import "MyXSDetailVC.h"
#import "MyLQDetailVC.h"
#import "ToolManager.h"
#import "CoreArchive.h"
#import "CALayer+Transition.h"
#import "LoCationManager.h"
#define jjrTabTag 120
@interface JinJiRenViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{

    UIButton * jjrBtn;

    int jjrpageNumb;
}

@property (strong,nonatomic)NSMutableArray * jjrJsonArr;

@property (strong,nonatomic)UITableView *jjrTab;


@property (strong,nonatomic)NSString  *hyStr;

@end

@implementation JinJiRenViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
   [self navViewTitleAndBackBtn:@"经纪人"];
    _jjrJsonArr = [[NSMutableArray alloc]init];

    self.view.backgroundColor = [UIColor colorWithWhite:0.941 alpha:1.000];
    
    [self getjjrJson];
    [self addTheTab];
}

//经纪人数据加载
-(void)getjjrJson
{
    NSString *cityID =[CoreArchive strForKey:AddressID];
    [[HomeInfo shareInstance]getHomePageJJR:jjrpageNumb andCityID:cityID.intValue andhangye:_hyStr andcallBack:^(BOOL issucced, NSString *info, NSArray *jsonArr) {
        if (issucced == YES) {
            if (jsonArr.count > 0) {
                [[ToolManager shareInstance]dismiss];
                for (NSDictionary * dic in jsonArr) {
                    [_jjrJsonArr addObject:dic];
                }
                [_jjrTab reloadData];
            }else
            {
                [[ToolManager shareInstance] showAlertMessage:@"没有更多数据了"];
                
            }
            
        }else
        {
            [[ToolManager shareInstance] showAlertMessage:info];
            
        }
        
    }];
}


#pragma mark----两个tableview写在这里
-(void)addTheTab
{
    UIView * topV = [[UIView alloc]initWithFrame:CGRectMake(10, 75, APPWIDTH-20, 35)];
    topV.backgroundColor  = [UIColor whiteColor];
    [self.view addSubview:topV];
    UILabel * tuijianLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 25)];
    tuijianLab.backgroundColor = [UIColor clearColor];
    tuijianLab.textAlignment = NSTextAlignmentLeft;
    tuijianLab.font = [UIFont systemFontOfSize:14];
    tuijianLab.text = @"知脉推荐";
    tuijianLab.textColor = [UIColor blackColor];
    [topV addSubview:tuijianLab];
    
    UIButton * chazhaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chazhaoBtn.backgroundColor = [UIColor clearColor];
    [chazhaoBtn setTitle:@"按条件查找" forState:UIControlStateNormal];
    [chazhaoBtn setTitleColor:[UIColor colorWithRed:1.000 green:0.518 blue:0.224 alpha:1.000] forState:UIControlStateNormal];
    chazhaoBtn.frame = CGRectMake(SCREEN_WIDTH-110, 0, 90, 35);
    chazhaoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [chazhaoBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    [chazhaoBtn addTarget:self action:@selector(chazhaoAction) forControlEvents:UIControlEventTouchUpInside];
    [topV addSubview:chazhaoBtn];

 
    
    _jjrTab = [[UITableView alloc]initWithFrame:CGRectMake(0,
                                                           CGRectGetMaxY(topV.frame), APPWIDTH, APPHEIGHT -CGRectGetMaxY(topV.frame))];
    _jjrTab.dataSource = self;
    _jjrTab.delegate = self;
    _jjrTab.tableFooterView = [[UIView alloc]init];
    _jjrTab.backgroundColor = [UIColor clearColor];
    _jjrTab.tag = jjrTabTag;
    _jjrTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    _jjrTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        jjrpageNumb = 1;
        if (_jjrJsonArr.count >0) {
            [_jjrJsonArr removeAllObjects];
        }
        [_jjrTab reloadData];
        [_jjrTab.mj_header endRefreshing];
        
        [self getjjrJson];
    }];
    
    _jjrTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreJJR)];
    _jjrTab.footer.automaticallyHidden = NO;
    [self.view addSubview:_jjrTab];
  
}

/**
 *  此处查找页面跳转
 */
-(void)chazhaoAction
{
    JingJiRenVC * jjr = [JingJiRenVC new];
    [self.navigationController pushViewController:jjr animated:YES];
}

/**
 *  加载更多经纪人
 */
-(void)loadMoreJJR
{
    jjrpageNumb ++;
    [self getjjrJson];
    [_jjrTab.mj_footer endRefreshing];
}
#pragma mark----tableview代理和资源方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        return 98;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
          return _jjrJsonArr.count;
    
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        static NSString * idenfStr = @"jjrCell";
        JJRCell * cell = [tableView dequeueReusableCellWithIdentifier:idenfStr];
        if (!cell) {
            cell = [[JJRCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 98)];
            cell.backgroundColor = [UIColor clearColor];
            NSString * imgUrl;
            if ([[_jjrJsonArr[indexPath.row]objectForKey:@"imgurl"] rangeOfString:@"http"].location != NSNotFound) {
                imgUrl = [_jjrJsonArr[indexPath.row] objectForKey:@"imgurl"];
            }else{
                imgUrl = [NSString stringWithFormat:@"%@%@",IMG_URL,[_jjrJsonArr[indexPath.row]objectForKey:@"imgurl"]];
            }
            cell.renzhImg.image = [[_jjrJsonArr[indexPath.row]objectForKey:@"authen"] intValue]==3?[UIImage imageNamed:@"renzhen"]:[UIImage imageNamed:@"weirenzhen"];
            
            
            [[ToolManager shareInstance] imageView:cell.headImg  setImageWithURL:imgUrl placeholderType:PlaceholderTypeUserHead];
            
            cell.userNameLab.text = [_jjrJsonArr[indexPath.row] objectForKey:@"realname"];
            cell.positionLab.text = [_jjrJsonArr[indexPath.row]objectForKey:@"area"];
            if ([[_jjrJsonArr[indexPath.row]objectForKey:@"industry"] isEqualToString:BAOXIAN]) {
                cell.hanyeLab.text = @"保险";
            }else if ([[_jjrJsonArr[indexPath.row]objectForKey:@"industry"] isEqualToString:JINRONG])
            {
                cell.hanyeLab.text = @"金融";
            }else if ([[_jjrJsonArr[indexPath.row]objectForKey:@"industry"] isEqualToString:FANGCHANG])
            {
                cell.hanyeLab.text = @"房产";
            }else if ([[_jjrJsonArr[indexPath.row]objectForKey:@"industry"] isEqualToString:CHEHANG])
            {
                cell.hanyeLab.text = @"车行";
            }
            
            cell.fuwuLab.text = [NSString stringWithFormat:@"服务:%@",[_jjrJsonArr[indexPath.row]objectForKey:@"servernum"]];
            
            cell.fansLab.text = [NSString stringWithFormat:@"粉丝:%@",[_jjrJsonArr[indexPath.row]objectForKey:@"fansnum"]];
            if ([[_jjrJsonArr[indexPath.row]objectForKey:@"isfollow"] intValue] == 1) {
                cell.guanzhuBtn.selected = YES;
                if ([[_jjrJsonArr[indexPath.row]objectForKey:@"mutual"]intValue] == 1) {
                    [cell.guanzhuBtn setTitle:@"已互关注" forState:UIControlStateSelected];
                }
            }else
            {
                cell.guanzhuBtn.selected = NO;
            }
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jjrAction:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            cell.nextV.tag = 500+indexPath.row;
            [cell.nextV addGestureRecognizer:tap];
            cell.guanzhuBtn.tag = 300+indexPath.row;
            [cell.guanzhuBtn addTarget:self action:@selector(guanzhuAction:) forControlEvents:UIControlEventTouchUpInside];
           
        }
    
    if (![cell.guanzhuBtn.titleLabel.text isEqualToString:@"关注Ta"]) {
        cell.guanzhuBtn.layer.borderColor=[UIColor colorWithWhite:0.651 alpha:1.000].CGColor;
    }

        return cell;
    
}
-(void)jjrAction:(UIGestureRecognizer *)sender
{
    JJRDetailVC * jjrV = [[JJRDetailVC alloc]init];
    jjrV.jjrID = [_jjrJsonArr[sender.view.tag-500] objectForKey:@"id"];
    [self.navigationController pushViewController:jjrV animated:YES];
}
-(void)guanzhuAction:(UIButton *)sender
{
    
    
       NSString * target_id = [_jjrJsonArr[sender.tag-300] objectForKey:@"id"];
    //isfollow:1代表取消关注,0代表关注
    int isfollow;
    if (sender.selected == YES) {
        isfollow = 1;
    }else
    {
        isfollow = 0;
    }
    
    
    
    
    
    
    [[HomeInfo shareInstance]guanzhuTargetID:[target_id intValue] andIsFollow:isfollow andcallBack:^(BOOL issucced, NSString *info, NSDictionary *jsonArr) {
        
       
        
        if (issucced == YES) {
            sender.selected = !sender.selected;
            if (sender.selected == YES) {
                sender.layer.borderColor=[UIColor colorWithWhite:0.651 alpha:1.000].CGColor;
            }
            else if (sender.selected == NO) {
                sender.layer.borderColor=[UIColor colorWithRed:0.239 green:0.553 blue:0.996 alpha:1.000].CGColor;
            }
            
            
        }else
        {
            HUDText(info);
        }
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//转换时间戳
-(NSString *)getDateStringWithDate:(NSDate *)date
                        DateFormat:(NSString *)formatString
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formatString];
    NSString *dateString = [dateFormat stringFromDate:date];
    //     NSLog(@"date: %@", dateString);
    
    return dateString;
}
- (NSString *)intervalSinceNow: (NSString *) theDate
{
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
    
    timeString = [NSString stringWithFormat:@"%f", cha];
    timeString = [timeString substringToIndex:timeString.length-7];
    timeString=[NSString stringWithFormat:@"%@", timeString];
    
    return timeString;
}
- (void)viewWillDisappear:(BOOL)animated

{
    [super viewWillDisappear:animated];
//    [[ToolManager shareInstance].drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
//    [[ToolManager shareInstance].drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];

}
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag ==NavViewButtonActionNavLeftBtnTag ) {
        PopView(self);
    }
    
}
//- (void)viewWillAppear:(BOOL)animated
//
//{
//    [super viewWillAppear:animated];
//    [[ToolManager shareInstance].drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
//    [[ToolManager shareInstance].drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
//
//
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
