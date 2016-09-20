//
//  WBHomePageVC.m
//  KuaJie
//
//  Created by 严文斌 on 16/5/11.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import "WBHomePageVC.h"
#import "XSCell.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "JJRDetailVC.h"
#import "XianSuoDetailVC.h"
#import "JingJiRenVC.h"
#import "AppDelegate.h"
#import "MyXSDetailVC.h"
#import "MyLQDetailVC.h" 
#import "ToolManager.h"
#import "CoreArchive.h"
#import "CALayer+Transition.h"
#import "ViewController.h"//选择地址
#import "LoCationManager.h"

#import "LWImageBrowser.h"
#import "TableViewCell.h"
#import "GallopUtils.h"
#import "StatusModel.h"
#import "CellLayout.h"

#define kToolBarH 44
#define kTextFieldH 30
#define xsTabTag  110
#define jjrTabTag 120
@interface WBHomePageVC ()<UITableViewDelegate,UITableViewDataSource,TableViewCellDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{

    UIButton * xsBtn;
    int xspageNumb;
    int jjrpageNumb;
    
    UIImageView *_toolBar;
    UITextField *_textField;
    UIButton  *_sendBtn;
}
@property (strong,nonatomic)NSMutableArray * xsJsonArr;
@property (strong,nonatomic)NSMutableArray * fakeDatasource;
@property (strong,nonatomic)UITableView *xsTab;
@property (nonatomic,strong)TableViewCell *commentCell;
@property (nonatomic,strong)NSIndexPath *commentIndex;
@property (strong,nonatomic)BaseButton  *selectedIndustryBg;
@property (strong,nonatomic)NSString  *hyStr;
@property (strong,nonatomic) BaseButton *selectedBtn;
@end

@implementation WBHomePageVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([CoreArchive strForKey:@"isread"]) {
       [self.homePageBtn setImage:[UIImage imageNamed:@"xinxi"] forState:UIControlStateNormal];
    }
    else
    {
        [self.homePageBtn setImage:[UIImage imageNamed:@"xinxi"] forState:UIControlStateNormal];
    }
    
}

#pragma mark - KeyboardNotifications

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *fabubTn=[UIButton buttonWithType:UIButtonTypeCustom];
    fabubTn.frame=CGRectMake(APPWIDTH - 60, StatusBarHeight+2, 50, 40);
    [fabubTn setTitle:@"发布" forState:UIControlStateNormal];
    [fabubTn addTarget:self action:@selector(fabuAction) forControlEvents:UIControlEventTouchUpInside];
    [fabubTn setTitleColor:BlackTitleColor forState:UIControlStateNormal];
    [self navViewTitleAndBackBtn:@"线索" rightBtn:fabubTn];

    
    self.homePageBtn.hidden = NO;
    [self.view addSubview:self.homePageBtn];
    
    xspageNumb = 1;
    jjrpageNumb = 1;
    _xsJsonArr = [[NSMutableArray alloc]init];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithWhite:0.941 alpha:1.000];

    [self getxsJson];
    
    [self addTheTab];
  
  
}
-(void)fabuAction
{
    [[ToolManager shareInstance]addReleseDctView:self];
}
- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
}

//线索数据加载
-(void)getxsJson
{
    NSString *cityID =[CoreArchive strForKey:AddressID];
    [[HomeInfo shareInstance]getHomePageXianSuo:xspageNumb andCityID:cityID.intValue  andhangye:_hyStr andCallBack:^(BOOL issucced, NSString *info, NSArray *jsonArr) {
        if (issucced == YES) {
            if (jsonArr.count > 0) {
                [[ToolManager shareInstance]dismiss];
                for (NSDictionary * dic in jsonArr) {
                    [_xsJsonArr addObject:dic];
                }
                [_xsTab reloadData];
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


#pragma mark - Getter

- (void)sendAction:(UIButton *)sender
{
  
  
}
#pragma mark----tableview写在这里
-(void)addTheTab
{
    _xsTab = [[UITableView alloc]initWithFrame:CGRectMake(0,NavigationBarHeight+StatusBarHeight, SCREEN_WIDTH, APPHEIGHT-NavigationBarHeight-StatusBarHeight)];
    _xsTab.dataSource = self;
    _xsTab.delegate = self;
    _xsTab.tableFooterView = [[UIView alloc]init];
    _xsTab.backgroundColor = [UIColor clearColor];
    _xsTab.tag = xsTabTag;
    _xsTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    _xsTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        xspageNumb = 1;
        if (_xsJsonArr.count >0) {
            [_xsJsonArr removeAllObjects];
        }
        [_xsTab reloadData];
        [_xsTab.mj_header endRefreshing];
       
        [self getxsJson];
    }];
   
    _xsTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreXS)];
    _xsTab.footer.automaticallyHidden = NO;
    [self.view addSubview:_xsTab];
    
    
    
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
 *  加载更多线索
 */
-(void)loadMoreXS
{
    xspageNumb ++;
    [self getxsJson];
    [_xsTab.mj_footer endRefreshing];
}

#pragma mark----tableview代理和资源方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   

     
        return 280;
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        return _xsJsonArr.count;
    
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == xsTabTag) {
        static NSString * idenfStr = @"xsCell";
        XSCell * cell = [tableView dequeueReusableCellWithIdentifier:idenfStr];
        if (!cell) {
            cell = [[XSCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 280)];
            cell.backgroundColor = [UIColor clearColor];
            NSString * imgUrl;
            if ([[_xsJsonArr[indexPath.row]objectForKey:@"imgurl"] rangeOfString:@"http"].location != NSNotFound) {
                imgUrl = [_xsJsonArr[indexPath.row] objectForKey:@"imgurl"];
            }else{
            imgUrl = [NSString stringWithFormat:@"%@%@",IMG_URL,[_xsJsonArr[indexPath.row]objectForKey:@"imgurl"]];
            }
            cell.renzhImg.image = [[_xsJsonArr[indexPath.row]objectForKey:@"authen"] intValue]==3?[UIImage imageNamed:@"renzhen"]:[UIImage imageNamed:@"weirenzhen"];
            [[ToolManager shareInstance] imageView:cell.headImg  setImageWithURL:imgUrl placeholderType:PlaceholderTypeUserHead];
           
            cell.userNameLab.text = [_xsJsonArr[indexPath.row] objectForKey:@"realname"];
            cell.positionLab.text = [_xsJsonArr[indexPath.row] objectForKey:@"area"];
            NSString * timStr = [_xsJsonArr[indexPath.row] objectForKey:@"createtime"];
            NSTimeInterval time=[timStr doubleValue];
            NSDate *data = [NSDate dateWithTimeIntervalSince1970:time];
            cell.timeLab.text = [self getDateStringWithDate:data DateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString * sjcStr = [self intervalSinceNow:cell.timeLab.text];
            if ([sjcStr integerValue] <=60) {
                cell.timeLab.text = @"刚刚";
            }else if ([sjcStr integerValue]<=3600)
            {
                cell.timeLab.text = [NSString stringWithFormat:@"%ld分钟前",[sjcStr integerValue]/60];
            }else if ([sjcStr integerValue]<=60*60*24)
            {
                cell.timeLab.text = [NSString stringWithFormat:@"%ld小时前",[sjcStr integerValue]/(60*60)];
            }else if ([sjcStr integerValue]<=60*60*24*3)
            {
                cell.timeLab.text = [NSString stringWithFormat:@"%ld天前",[sjcStr integerValue]/(60*60*24)];
            }else
            {
                cell.timeLab.text = [self getDateStringWithDate:data DateFormat:@"MM-dd HH:mm"];
            }
            cell.lookLab.text = [NSString stringWithFormat:@"查看:%@",[_xsJsonArr[indexPath.row] objectForKey:@"readcount"]];
            cell.commentLab.text = [NSString stringWithFormat:@"评论:%@",[_xsJsonArr[indexPath.row] objectForKey:@"commentnum"]];
            [cell.hanyeBtn setTitle:[Parameter industryForChinese:[_xsJsonArr[indexPath.row]objectForKey:@"industry"]] forState:UIControlStateNormal];

            
            cell.titLab.text = [_xsJsonArr[indexPath.row] objectForKey:@"title"];
            cell.moneyLab.text = [_xsJsonArr[indexPath.row] objectForKey:@"cost"];
             cell.blueV.tag = 1000+indexPath.row;
            UITapGestureRecognizer * blueVTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(blueVAction:)];
            blueVTap.numberOfTapsRequired =1;
            blueVTap.numberOfTouchesRequired = 1;
           
            [cell.blueV addGestureRecognizer:blueVTap];
            NSString * xqStr;
            NSString * qdStr = @"需求强度: ";
            NSString * qdStr2;
            if ([[_xsJsonArr[indexPath.row] objectForKey:@"confidence_n"] intValue] == 3) {
                qdStr2 = [NSString stringWithFormat:@"很强"];
            }else if ([[_xsJsonArr[indexPath.row] objectForKey:@"confidence_n"] intValue] == 2)
            {
                qdStr2 = [NSString stringWithFormat:@"强"];
            }else
            {
                qdStr2 = [NSString stringWithFormat:@"一般"];
            }
            xqStr = [qdStr stringByAppendingString:qdStr2];
            NSMutableAttributedString * xqqdAtr = [[NSMutableAttributedString alloc]initWithString:xqStr];
            [xqqdAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1.000 green:0.518 blue:0.224 alpha:1.000] range:NSMakeRange([qdStr length], [qdStr2 length])];
            [xqqdAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.514 alpha:1.000] range:NSMakeRange(0,[qdStr length])];
            cell.xqqdLab.attributedText = xqqdAtr;
            NSString * lq1 = [NSString stringWithFormat:@"%@人领取",[_xsJsonArr[indexPath.row]objectForKey:@"coopnum"] ];
            NSString * lq2 = [NSString stringWithFormat:@""];
            if ([[_xsJsonArr[indexPath.row]objectForKey:@"iscoop"]intValue ]==1) {
                lq2 = [NSString stringWithFormat:@"(已领取)"];
            }
           
            if ([[_xsJsonArr[indexPath.row]objectForKey:@"state"]intValue ]>20) {
                 lq2 = [NSString stringWithFormat:@"(已合作)"];
            }
            
            NSString * lqStr = [lq1 stringByAppendingString:lq2];
            NSMutableAttributedString * lqAtr = [[NSMutableAttributedString alloc]initWithString:lqStr];
            [lqAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.514 alpha:1.000] range:NSMakeRange(0, [lq1 length])];
            if ([[_xsJsonArr[indexPath.row]objectForKey:@"iscoop"]intValue ]==1||[[_xsJsonArr[indexPath.row]objectForKey:@"state"]intValue ]>20) {
                [lqAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1.000 green:0.518 blue:0.224 alpha:1.000] range:NSMakeRange([lq1 length], [lq2 length])];
            }else
            {
                [lqAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.514 alpha:1.000] range:NSMakeRange([lq1 length], [lq2 length])];
            }
            cell.lqLab.attributedText = lqAtr;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnVAction:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            cell.btnV.tag = 200+indexPath.row;
            [cell.btnV addGestureRecognizer:tap];
            
        }
        return cell;
    }else
    {
        static NSString* cellIdentifier = @"cellIdentifier";
        TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indexPath = indexPath;
            return cell;

    }
}

#pragma mark----线索那边的头像那块view的点击事件
-(void)btnVAction:(UITapGestureRecognizer *)sender
{
    JJRDetailVC * jjrV = [[JJRDetailVC alloc]init];
    jjrV.jjrID = [_xsJsonArr[sender.view.tag-200] objectForKey:@"brokerid"];
    [self.navigationController pushViewController:jjrV animated:YES];
}
-(void)blueVAction:(UITapGestureRecognizer *)sender
{
    if ([[_xsJsonArr[sender.view.tag-1000] objectForKey:@"iscoop"] intValue] == 1) {
        //跳转我的领取线索详情
        MyLQDetailVC* myLqV =  [[MyLQDetailVC alloc]init];
        myLqV.xiansuoID = [_xsJsonArr[sender.view.tag - 1000] objectForKey:@"id"];
       [self.navigationController pushViewController:myLqV animated:YES];
        return;
    }
    if ([[_xsJsonArr[sender.view.tag-1000] objectForKey:@"isself"] intValue] == 1) {
        //跳转我的发布线索详情
        MyXSDetailVC* myxiansuoV =  [[MyXSDetailVC alloc]init];
        myxiansuoV.xiansuoID = [_xsJsonArr[sender.view.tag - 1000] objectForKey:@"id"];
        [self.navigationController pushViewController:myxiansuoV animated:YES];

        return;
    }
    XianSuoDetailVC * xiansuoV =  [[XianSuoDetailVC alloc]init];
    xiansuoV.xs_id = [_xsJsonArr[sender.view.tag - 1000] objectForKey:@"id"];
    [self.navigationController pushViewController:xiansuoV animated:YES];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
