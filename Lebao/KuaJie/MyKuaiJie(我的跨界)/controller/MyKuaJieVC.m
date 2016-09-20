//
//  MyKuaJieVC.m
//  KuaJie
//
//  Created by 严文斌 on 16/5/18.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import "MyKuaJieVC.h"
#import "FabuCell.h"
#import "MyLinQuCell.h"
#import "MyXSDetailVC.h"
#import "MyLQDetailVC.h"
#import "MJRefresh.h"
#import "MyKuaJieInfo.h"
#import "ToolManager.h"
#define FABUTAG 119
#define LINQUTAG 911

@interface MyKuaJieVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *myFabuBtn;
@property (weak, nonatomic) IBOutlet UIButton *myLinquBtn;
- (IBAction)fabuAction:(id)sender;
- (IBAction)linquAction:(id)sender;
@property (strong,nonatomic)UIView * btmBlueV;
@property (weak, nonatomic) IBOutlet UIView *bottomV;
@property (strong,nonatomic)UIScrollView * myScrollV;
@property (strong,nonatomic)UITableView * fubTab;
@property (strong,nonatomic)UITableView * linqTab;
@property (assign,nonatomic)int fabuPage;
@property (assign,nonatomic)int linquPage;
@property (strong,nonatomic)NSMutableArray * fabuArr;
@property (strong,nonatomic)NSMutableArray * linquArr;
@end

@implementation MyKuaJieVC
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _linquPage = 1;
    if (_linquArr.count >0) {
        [_linquArr removeAllObjects];
    }
    [_linqTab reloadData];
    [self getLinfQuJson];

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _fabuPage = 1;
    _linquPage = 1;
    [self setNav];
    _fabuArr = [[NSMutableArray alloc]init];
    _linquArr = [[NSMutableArray alloc]init];
    [self addTheBtmBlueV];
    [self customScrollV];
    [self customTwoTab];
    [self getFabuJson];
    [self getLinfQuJson];
    
    //如果是领取，跳到领取界面
    if (_isLinquVC) {
        [self linquAction:_myLinquBtn];
    }
    
}
- (void)setIsLinquVC:(BOOL)isLinquVC
{
    if (isLinquVC)
    {
     [self linquAction:_myLinquBtn];
    }
    else
    {
     [ self linquAction:_myFabuBtn];
    }

}
-(void)getLinfQuJson
{
    [[MyKuaJieInfo shareInstance]lingQuLieBiaoWithPage:_linquPage andCallBack:^(BOOL issucced, NSString *info, NSArray *jsonArr) {
        if (issucced == YES) {
            if (jsonArr.count > 0) {
                [[ToolManager shareInstance]dismiss];
                for (NSDictionary * dic in jsonArr) {
                    [_linquArr addObject:dic];
                }
                [_linqTab reloadData];
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
-(void)getFabuJson
{
    [[MyKuaJieInfo shareInstance]faBuLieBiaoWithPage:_fabuPage andCallBack:^(BOOL issucced, NSString *info, NSArray *jsonArr) {
        if (issucced == YES) {
            if (jsonArr.count > 0) {
                [[ToolManager shareInstance]dismiss];
                for (NSDictionary * dic in jsonArr) {
                    [_fabuArr addObject:dic];
                }
                [_fubTab reloadData];
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
    titLab.text = @"我的跨界";
    titLab.font = [UIFont systemFontOfSize:16];
    [navView addSubview:titLab];
    UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0.5)];
    hxV.backgroundColor = [UIColor colorWithRed:0.816 green:0.820 blue:0.827 alpha:1.000];
    [self.view addSubview:hxV];
}
-(void)backAction
{
    PopRootView(self);
}
-(void)addTheBtmBlueV
{
    _btmBlueV = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2-60)/2, 29, 60, 1)];
    _btmBlueV.backgroundColor = [UIColor colorWithRed:0.243 green:0.553 blue:1.000 alpha:1.000];
    [_bottomV addSubview:_btmBlueV];
    _myFabuBtn.selected = YES;
}
-(void)customScrollV
{
    _myScrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 94.5, SCREEN_WIDTH, SCREEN_HEIGHT-94.5)];
    _myScrollV.backgroundColor = [UIColor clearColor];
    _myScrollV.contentSize = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT-94.5);
    _myScrollV.showsVerticalScrollIndicator = NO;
    _myScrollV.showsHorizontalScrollIndicator = NO;
    _myScrollV.pagingEnabled = YES;
    _myScrollV.bounces = NO;
    _myScrollV.delegate = self;
    [self.view addSubview:_myScrollV];
}
-(void)customTwoTab
{
    _fubTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _myScrollV.frame.size.height) style:UITableViewStylePlain];
    _fubTab.backgroundColor = [UIColor clearColor];
    _fubTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    _fubTab.delegate = self;
    _fubTab.dataSource = self;
    _fubTab.tag = FABUTAG;
    _fubTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _fabuPage = 1;
        if (_fabuArr.count >0) {
            [_fabuArr removeAllObjects];
        }
        [_fubTab reloadData];
        [_fubTab.mj_header endRefreshing];
        
        [self getFabuJson];
    }];
    
    _fubTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMorefabu)];
     _fubTab.footer.automaticallyHidden = NO;
    [_myScrollV addSubview:_fubTab];
    
    _linqTab = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, _myScrollV.frame.size.height) style:UITableViewStylePlain];
    _linqTab.backgroundColor = [UIColor clearColor];
    _linqTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    _linqTab.delegate = self;
    _linqTab.dataSource = self;
    _linqTab.tag = LINQUTAG;
    _linqTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _linquPage = 1;
        if (_linquArr.count >0) {
            [_linquArr removeAllObjects];
        }
        [_linqTab reloadData];
        [_linqTab.mj_header endRefreshing];
        
        [self getLinfQuJson];
    }];
    
    _linqTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMorelinqu)];
    _linqTab.footer.automaticallyHidden = NO;
    [_myScrollV addSubview:_linqTab];

}
-(void)loadMorefabu
{
    _fabuPage ++;
    [self getFabuJson];
    [_fubTab.mj_footer endRefreshing];

}
-(void)loadMorelinqu
{
    _linquPage ++;
    [self getLinfQuJson];
    [_linqTab.mj_footer endRefreshing];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == FABUTAG) {
        //发布tableview
        return _fabuArr.count;
    }else
    {
        //领取tableview
        return _linquArr.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == FABUTAG) {
       static NSString * fubuCellStr = @"fubuCell";
        FabuCell * cell = [tableView dequeueReusableCellWithIdentifier:fubuCellStr];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"FabuCell" owner:nil options:nil];
            cell = [nibs firstObject];
            cell.backgroundColor = [UIColor clearColor];
            NSString * timStr = [_fabuArr[indexPath.row] objectForKey:@"createtime"];
            NSTimeInterval time=[timStr doubleValue];
            NSDate *data = [NSDate dateWithTimeIntervalSince1970:time];
            cell.timeLab.text = [self getDateStringWithDate:data DateFormat:@"MM-dd HH:mm"];
            if ([[_fabuArr[indexPath.row]objectForKey:@"industry"] isEqualToString:BAOXIAN]) {
                [cell.hanyeBtn setTitle:@"保险" forState:UIControlStateNormal];
            }else if ([[_fabuArr[indexPath.row]objectForKey:@"industry"] isEqualToString:JINRONG])
            {
                [cell.hanyeBtn setTitle:@"金融" forState:UIControlStateNormal];
            }else if ([[_fabuArr[indexPath.row]objectForKey:@"industry"] isEqualToString:FANGCHANG])
            {
                [cell.hanyeBtn setTitle:@"房产" forState:UIControlStateNormal];
            }else if ([[_fabuArr[indexPath.row]objectForKey:@"industry"] isEqualToString:CHEHANG])
            {
                [cell.hanyeBtn setTitle:@"车行" forState:UIControlStateNormal];
            }
            if ([[_fabuArr[indexPath.row] objectForKey:@"confidence_n"] intValue] == 3) {
                [cell.xuqiuBtn setTitle:@"需求:很强" forState:UIControlStateNormal];
            }else if ([[_fabuArr[indexPath.row] objectForKey:@"confidence_n"] intValue] == 2)
            {
                [cell.xuqiuBtn setTitle:@"需求:强" forState:UIControlStateNormal];
            }else
            {
                [cell.xuqiuBtn setTitle:@"需求:一般" forState:UIControlStateNormal];
            }
            cell.jirenlqLab.text =[NSString stringWithFormat:@"%@人领取",[_fabuArr[indexPath.row] objectForKey:@"coopnum"]];
            cell.jirenLookLab.text =[NSString stringWithFormat:@"%@人查看",[_fabuArr[indexPath.row] objectForKey:@"readcount"]];

            cell.titleLab.text = [_fabuArr[indexPath.row] objectForKey:@"title"];
            cell.allinV.tag = 500+indexPath.row;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookXSDetailAction:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [cell.allinV addGestureRecognizer:tap];
            cell.fabuImg.image = [UIImage imageNamed:@"liuchengguo"];
    cell.shengheImg.image = cell.hezuozImg.image = cell.sddjImg.image = cell.sdwkImg.image = cell.yipjiaImg.image  = cell.jieshuImg.image  = [UIImage imageNamed:@"liuchengweijinxin"];
            switch ([[_fabuArr[indexPath.row]objectForKey:@"state"] intValue]) {
                case 10:
                  cell.shengheImg.image = cell.hezuozImg.image = cell.sddjImg.image = cell.sdwkImg.image = cell.yipjiaImg.image = cell.jieshuImg.image   = [UIImage imageNamed:@"liuchengweijinxin"];
                    cell.mySlider.value = 0.08;
                    break;
                case 20:
                    cell.shengheImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    cell.hezuozImg.image = cell.sddjImg.image = cell.sdwkImg.image = cell.yipjiaImg.image = cell.jieshuImg.image  = [UIImage imageNamed:@"liuchengweijinxin"];
                    cell.mySlider.value = 0.08+0.16;
                    break;
                case 30:
                    cell.shengheImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    cell.hezuozImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    cell.sddjImg.image = cell.sdwkImg.image = cell.sdwkImg.image = cell.jieshuImg.image  = [UIImage imageNamed:@"liuchengweijinxin"];
                    cell.mySlider.value = 0.08+0.16*2;
                    break;
                case 40:
                    cell.shengheImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    cell.hezuozImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    cell.sddjImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    cell.sdwkImg.image = cell.yipjiaImg.image = cell.jieshuImg.image  = [UIImage imageNamed:@"liuchengweijinxin"];
                    cell.mySlider.value = 0.08+0.16*3;
                    break;
                case 45:
                case 55:
                    cell.shengheImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    cell.hezuozImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    
                    cell.sddjImg.image = cell.sdwkImg.image = cell.yipjiaImg.image = cell.jieshuImg.image  = [UIImage imageNamed:@"liuchengweijinxin"];
                    cell.mySlider.value = 0.08+0.16*2;
                    break;
                    case 65:
                    case 70:
                    cell.shengheImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    cell.hezuozImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    cell.sddjImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    cell.sdwkImg.image = cell.yipjiaImg.image = cell.jieshuImg.image = [UIImage imageNamed:@"liuchengweijinxin"];
                    cell.mySlider.value = 0.08+0.16*3;
                    break;
                    case 80:
                    cell.shengheImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    cell.hezuozImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    cell.sddjImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                     cell.sdwkImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    cell.yipjiaImg.image =  cell.jieshuImg.image = [UIImage imageNamed:@"liuchengweijinxin"];
                    cell.mySlider.value = 0.08+0.16 * 4;
                    break;
                    case 90:
                    cell.shengheImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    cell.hezuozImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    cell.sddjImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    cell.sdwkImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    cell.yipjiaImg.image =  cell.jieshuImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    cell.mySlider.value = 1;
                    break;
                    case 98:
                    cell.shengheImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    cell.hezuozImg.image = cell.sddjImg.image = cell.sdwkImg.image = cell.yipjiaImg.image = cell.jieshuImg.image = [UIImage imageNamed:@"liuchengweijinxin"];
                    cell.mySlider.value = 0.08+0.16;
                    break;
                    case 99:
                    cell.shengheImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    cell.hezuozImg.image = cell.sddjImg.image = cell.sdwkImg.image = cell.yipjiaImg.image = cell.jieshuImg.image = [UIImage imageNamed:@"liuchengweijinxin"];
                    cell.shenheLab.text = @"审核不通过";
                    cell.mySlider.value = 0.08+0.16;
                    cell.qwbcLab.text = [NSString stringWithFormat:@"%@",[_fabuArr[indexPath.row]objectForKey:@"remark"]];
                    break;
                default:
                    break;
            }
            cell.qwbcLab.text = [NSString stringWithFormat:@"成交报酬:%@元",[_fabuArr[indexPath.row] objectForKey:@"cost"]];
        }
        return cell;
    }else
    {
       static NSString * myLinQuCellStr = @"mylqCell";
        MyLinQuCell * cell = [tableView dequeueReusableCellWithIdentifier:myLinQuCellStr];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MyLinQuCell" owner:nil options:nil];
            cell = [nibs firstObject];
            NSString * lqtimStr = [_linquArr[indexPath.row] objectForKey:@"retime"];
            NSTimeInterval lqtime=[lqtimStr doubleValue];
            NSDate *lqdata = [NSDate dateWithTimeIntervalSince1970:lqtime];
            cell.timeLab.text = [self getDateStringWithDate:lqdata DateFormat:@"MM-dd HH:mm"];
            cell.backgroundColor = [UIColor clearColor];
            
            if ([[_linquArr[indexPath.row]objectForKey:@"industry"] isEqualToString:BAOXIAN]) {
                [cell.hanyeBtn setTitle:@"保险" forState:UIControlStateNormal];
            }else if ([[_linquArr[indexPath.row]objectForKey:@"industry"] isEqualToString:JINRONG])
            {
                [cell.hanyeBtn setTitle:@"金融" forState:UIControlStateNormal];
            }else if ([[_linquArr[indexPath.row]objectForKey:@"industry"] isEqualToString:FANGCHANG])
            {
                [cell.hanyeBtn setTitle:@"房产" forState:UIControlStateNormal];
            }else if ([[_linquArr[indexPath.row]objectForKey:@"industry"] isEqualToString:CHEHANG])
            {
                [cell.hanyeBtn setTitle:@"车行" forState:UIControlStateNormal];
            }
            if ([[_linquArr[indexPath.row] objectForKey:@"confidence_n"] intValue] == 3) {
                [cell.xuqiuBtn setTitle:@"需求:很强" forState:UIControlStateNormal];
            }else if ([[_linquArr[indexPath.row] objectForKey:@"confidence_n"] intValue] == 2)
            {
                [cell.xuqiuBtn setTitle:@"需求:强" forState:UIControlStateNormal];
            }else
            {
                [cell.xuqiuBtn setTitle:@"需求:一般" forState:UIControlStateNormal];
            }

            cell.titleLab.text = [_linquArr[indexPath.row] objectForKey:@"title"];
            cell.allinV.tag = 600+indexPath.row;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookLQDetailAction:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [cell.allinV addGestureRecognizer:tap];
            cell.linquImg.image = [UIImage imageNamed:@"liuchengguo"];
            switch ([[_linquArr[indexPath.row] objectForKey:@"state"] intValue]) {
                case 10:
                case 20:
                    cell.beixuanzhongImg.image = cell.manyiImg.image = cell.fuweikuanImg.image = cell.jieshuImg.image = [UIImage imageNamed:@"liuchengweijinxin"];
                    cell.fwkLab.text = @"未付尾款";
                    cell.bxzLab.text = @"未被选中";
                    cell.mySlider.value =0.125;
                    break;
                    case 30:
                    cell.beixuanzhongImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    cell.manyiImg.image = cell.fuweikuanImg.image = cell.jieshuImg.image = [UIImage imageNamed:@"liuchengweijinxin"];
                    cell.mySlider.value =0.125+0.25;
                    cell.bxzLab.text = @"被选中";
                    cell.fwkLab.text = @"未付尾款";
                    break;
                    case 40:
                    cell.beixuanzhongImg.image = cell.manyiImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    cell.fuweikuanImg.image = cell.jieshuImg.image = [UIImage imageNamed:@"liuchengweijinxin"];
                    cell.mySlider.value =0.125+0.25*2;
                    cell.bxzLab.text = @"被选中";
                    cell.fwkLab.text = @"未付尾款";
                    break;
                    case 45:
                    cell.beixuanzhongImg.image = cell.manyiImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    cell.fuweikuanImg.image = cell.jieshuImg.image = [UIImage imageNamed:@"liuchengweijinxin"];
                    cell.manyiLab.text = @"不满意";
                    cell.bxzLab.text = @"被选中";
                    cell.fwkLab.text = @"调解结果";
                    cell.mySlider.value =0.125+0.25*2;
                    break;
                    case 55:
                    cell.beixuanzhongImg.image = cell.manyiImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    cell.fuweikuanImg.image =  cell.jieshuImg.image = [UIImage imageNamed:@"liuchengweijinxin"];
                    cell.fwkLab.text = @"调解结果";
                    cell.bxzLab.text = @"被选中";
                    cell.manyiLab.text =@"不满意";
                    cell.mySlider.value =0.125+0.25*2;
                    break;
                    case 65:
                    cell.beixuanzhongImg.image = cell.manyiImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    cell.fuweikuanImg.image =  cell.jieshuImg.image = [UIImage imageNamed:@"liuchengweijinxin"];
                    cell.fwkLab.text = @"未付尾款";
                    cell.bxzLab.text = @"被选中";
                    cell.mySlider.value =0.125+0.25*2;
                    break;
                    case 70:
                    cell.beixuanzhongImg.image = cell.manyiImg.image =cell.fuweikuanImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    cell.jieshuImg.image = [UIImage imageNamed:@"liuchengweijinxin"];
                    cell.fwkLab.text = @"已付尾款";
                    cell.bxzLab.text = @"被选中";
                    cell.mySlider.value =0.125+0.25*3;
                    break;
                    case 80:
                    cell.beixuanzhongImg.image = cell.manyiImg.image =cell.fuweikuanImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    cell.jieshuImg.image = [UIImage imageNamed:@"liuchengweijinxin"];
                    if ([_linquArr[indexPath.row] objectForKey:@"state"]) {
                        
                    }
                    cell.fwkLab.text = @"收到尾款";
                    cell.bxzLab.text = @"被选中";
                    cell.mySlider.value =0.125+0.25*3;
                    
                    break;
                    case 90:
                    if ([[_linquArr[indexPath.row] objectForKey:@"result"]intValue] == 1) {
                        cell.beixuanzhongImg.image = cell.manyiImg.image =cell.fuweikuanImg.image = cell.jieshuImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                        cell.fwkLab.text = @"收到尾款";
                        cell.bxzLab.text = @"被选中";
                        cell.mySlider.value =1;
                    }else
                    {
                        cell.beixuanzhongImg.image = cell.manyiImg.image =cell.fuweikuanImg.image = cell.jieshuImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                        cell.fwkLab.text = @"调解结果";
                        cell.bxzLab.text = @"被选中";
                        cell.mySlider.value =1;
                        cell.manyiLab.text = @"不满意";
                    }
                  
                    break;
                    case 98:
                    cell.beixuanzhongImg.image = cell.manyiImg.image = cell.fuweikuanImg.image = cell.jieshuImg.image = [UIImage imageNamed:@"liuchengweijinxin"];
                    cell.lqLab.text = @"取消领取";
                    cell.bxzLab.text = @"被选中";
                    cell.fwkLab.text = @"未付尾款";
                    cell.mySlider.value =0.125;
                    break;
                    case 99:
                    cell.manyiImg.image = cell.fuweikuanImg.image = cell.jieshuImg.image = [UIImage imageNamed:@"liuchengweijinxin"];
                    cell.beixuanzhongImg.image = [UIImage imageNamed:@"liuchengjinxinzhong"];
                    cell.bxzLab.text = @"未被选中";
                    cell.fwkLab.text = @"未付尾款";
                    cell.mySlider.value =0.25;
                    break;
                default:
                    break;
            }
            cell.dingjinLab.text = [NSString stringWithFormat:@"已出定金%@元",[_linquArr[indexPath.row] objectForKey:@"deposit"]];
            cell.jirenlqLab.text =[NSString stringWithFormat:@"%@人领取",[_linquArr[indexPath.row] objectForKey:@"coopnum"]];
            cell.jirenLookLab.text =[NSString stringWithFormat:@"%@人查看",[_linquArr[indexPath.row] objectForKey:@"readcount"]];
            cell.laiziLab.text =[NSString stringWithFormat:@"来自:%@",[_linquArr[indexPath.row] objectForKey:@"source"]];
            NSString * timStr = [_linquArr[indexPath.row] objectForKey:@"createtime"];
            NSTimeInterval time=[timStr doubleValue];
            NSDate *data = [NSDate dateWithTimeIntervalSince1970:time];
            NSString * timeStr =  [self getDateStringWithDate:data DateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString * sjcStr = [self intervalSinceNow:timeStr];
            if ([sjcStr integerValue] <=60) {
                cell.fabuyuLab.text = @"刚刚";
            }else if ([sjcStr integerValue]<=3600)
            {
                cell.fabuyuLab.text = [NSString stringWithFormat:@"发布于:%ld分钟前",[sjcStr integerValue]/60];
            }else if ([sjcStr integerValue]<=60*60*24)
            {
                cell.fabuyuLab.text = [NSString stringWithFormat:@"发布于:%ld小时前",[sjcStr integerValue]/(60*60)];
            }else if ([sjcStr integerValue]<=60*60*24*3)
            {
                cell.fabuyuLab.text = [NSString stringWithFormat:@"发布于:%ld天前",[sjcStr integerValue]/(60*60*24)];
            }else
            {
                cell.fabuyuLab.text = [NSString stringWithFormat:@"发布于:%@",[self getDateStringWithDate:data DateFormat:@"MM-dd HH:mm"]];
            }
        }
        return cell;

    }
}
-(void)lookXSDetailAction:(UIGestureRecognizer *)sender
{
    
    MyXSDetailVC * myXSV = [[MyXSDetailVC alloc]init];
    myXSV.xiansuoID = [_fabuArr[sender.view.tag-500] objectForKey:@"id"];
    [self.navigationController pushViewController:myXSV animated:YES];
}
-(void)lookLQDetailAction:(UIGestureRecognizer *)sender
{
    
    MyLQDetailVC * myLQV = [[MyLQDetailVC alloc]init];
    myLQV.xiansuoID = [_linquArr[sender.view.tag-600] objectForKey:@"id"];
    [self.navigationController pushViewController:myLQV animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == FABUTAG) {
        return 270;
    }else
    {
        return 270;
    }
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = _myScrollV.contentOffset;
    [UIView animateWithDuration:0.3f animations:^{
        if ((int)point.x % (int)SCREEN_WIDTH == 0) {
            if (point.x/SCREEN_WIDTH ==1) {
                //               NSLog(@"第二页");
                _myLinquBtn.selected = YES;
                _myFabuBtn.selected = NO;
                [_btmBlueV setFrame:CGRectMake((SCREEN_WIDTH/2-60)/2+SCREEN_WIDTH/2, 29, 60, 1)];
            }else if(point.x/SCREEN_WIDTH ==0)
            {
                //               NSLog(@"第一页");
                _myLinquBtn.selected = NO;
                _myFabuBtn.selected = YES;
                [_btmBlueV setFrame:CGRectMake((SCREEN_WIDTH/2-60)/2, 29, 60, 1)];
            }
        }
        
    }];

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
- (IBAction)fabuAction:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        _myFabuBtn.selected = YES;
        _myLinquBtn.selected = NO;
        [_btmBlueV setFrame:CGRectMake((SCREEN_WIDTH/2-60)/2, 29, 60, 1)];
        _myScrollV.contentOffset = CGPointMake(0, 0);
    }];
}

- (IBAction)linquAction:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        _myFabuBtn.selected = NO;
        _myLinquBtn.selected = YES;
        [_btmBlueV setFrame:CGRectMake((SCREEN_WIDTH/2-60)/2+SCREEN_WIDTH/2, 29, 60, 1)];
        _myScrollV.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    }];

}
@end
