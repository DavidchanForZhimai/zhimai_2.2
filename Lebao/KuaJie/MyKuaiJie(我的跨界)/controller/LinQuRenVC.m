//
//  LinQuRenVC.m
//  KuaJie
//
//  Created by 严文斌 on 16/5/25.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import "LinQuRenVC.h"
#import "LinQuCell.h"
#import "MJRefresh.h"
#import "MyKuaJieInfo.h"
@interface LinQuRenVC ()<UITableViewDelegate,UITableViewDataSource>
{
    int jsonPage;
}
@property (strong,nonatomic)UITableView * lqrTab;
@property (strong,nonatomic)NSMutableArray * jsonArr;
@end

@implementation LinQuRenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    jsonPage = 1;
    _jsonArr = [[NSMutableArray alloc]init];
    self.view.backgroundColor = BACKCOLOR;
    [self setNav];
    [self addTheLQRTab];
    [self getJson];
}
-(void)getJson
{
    [[MyKuaJieInfo shareInstance]getLQRWithID:_xiansID andPage:jsonPage andCallBack:^(BOOL issucced, NSString *info, NSArray *jsonArr) {
        if (issucced == YES) {
            if (jsonArr.count > 0) {
                for (NSDictionary * dic in jsonArr) {
                    [_jsonArr addObject:dic];
                }
                [_lqrTab reloadData];
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
-(void)addTheLQRTab
{
    _lqrTab = [[UITableView alloc]initWithFrame:CGRectMake(10, 74.5, SCREEN_WIDTH-20, SCREEN_HEIGHT-74.5) style:UITableViewStylePlain];
    _lqrTab.delegate = self;
    _lqrTab.dataSource = self;
    _lqrTab.tableFooterView = [[UIView alloc]init];
    _lqrTab.backgroundColor = [UIColor clearColor];
    _lqrTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    _lqrTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        jsonPage = 1;
        if (_jsonArr.count >0) {
            [_jsonArr removeAllObjects];
        }
        [_lqrTab reloadData];
        [_lqrTab.mj_header endRefreshing];
        
        [self getJson];
    }];
    
    _lqrTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    _lqrTab.footer.automaticallyHidden = NO;
    [self.view addSubview:_lqrTab];
}
-(void)loadMore
{
    jsonPage ++;
    [self getJson];
    [_lqrTab.mj_footer endRefreshing];

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
    titLab.text = @"领取人列表";
    titLab.font = [UIFont systemFontOfSize:16];
    [navView addSubview:titLab];
    UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0.5)];
    hxV.backgroundColor = [UIColor colorWithRed:0.816 green:0.820 blue:0.827 alpha:1.000];
    [self.view addSubview:hxV];
    
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _jsonArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"linquCell";
    LinQuCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[LinQuCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 61)];
        NSString * imgUrl;
        if ([[_jsonArr[indexPath.row]objectForKey:@"imgurl"] rangeOfString:@"http"].location != NSNotFound) {
            imgUrl = [_jsonArr[indexPath.row] objectForKey:@"imgurl"];
        }else{
            imgUrl = [NSString stringWithFormat:@"%@%@",IMG_URL,[_jsonArr[indexPath.row]objectForKey:@"imgurl"]];
        }
        cell.renzhImg.image = [[_jsonArr[indexPath.row]objectForKey:@"authen"] intValue]==3?[UIImage imageNamed:@"renzhen"]:[UIImage imageNamed:@"weirenzhen"];
        [[ToolManager shareInstance] imageView:cell.headImg  setImageWithURL:imgUrl placeholderType:PlaceholderTypeUserHead];

        if ([[_jsonArr[indexPath.row] objectForKey:@"selected"] intValue] == 1) {
            UIImageView * xzImg = [[UIImageView alloc]initWithFrame:CGRectMake(51-15, 10, 15, 15)];
            xzImg.image = [UIImage imageNamed:@"xuanzhong"];
            [cell addSubview:xzImg];
        }
        cell.userNameLab.text = [_jsonArr[indexPath.row] objectForKey:@"realname"];
        NSString * str1 = @"定金:";
        NSString * str2 = [NSString stringWithFormat:@"%@元",[_jsonArr[indexPath.row] objectForKey:@"deposit"]];
        NSString * djStr = [str1 stringByAppendingString:str2];
        NSMutableAttributedString * djAtr = [[NSMutableAttributedString alloc]initWithString:djStr];
        [djAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.545 green:0.549 blue:0.557 alpha:1.000] range:NSMakeRange(0, [str1 length])];
        [djAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.353 green:0.608 blue:0.992 alpha:1.000] range:NSMakeRange([str1 length], [str2 length])];
        [djAtr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, [djStr length])];
        cell.dingjLab.attributedText = djAtr;
        NSString * timStr = [_jsonArr[indexPath.row] objectForKey:@"createtime"];
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

    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction
{
    
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
