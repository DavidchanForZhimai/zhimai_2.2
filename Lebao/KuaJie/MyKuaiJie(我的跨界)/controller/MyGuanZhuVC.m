//
//  MyGuanZhuVC.m
//  KuaJie
//
//  Created by 严文斌 on 16/5/23.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import "MyGuanZhuVC.h"
#import "JJRCell.h"
#import "MyKuaJieInfo.h"
#import "HomeInfo.h"
#import "MJRefresh.h"
#import "JJRDetailVC.h"
@interface MyGuanZhuVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTab;
@property (assign,nonatomic)int page;
@property (strong,nonatomic)NSMutableArray * jsonArr;
@property (strong,nonatomic)UILabel * titLab;
@end

@implementation MyGuanZhuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    _jsonArr = [[NSMutableArray alloc]init];
    self.view.backgroundColor = BACKCOLOR;
    [self setNav];
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
    [self getJson];
}
-(void)loadMore
{
    _page ++;
    [self getJson];
    [_myTab.mj_footer endRefreshing];
}
-(void)getJson
{
    [[MyKuaJieInfo shareInstance]getGuanZhuLieBiaoWithPage:_page andCallBack:^(BOOL issucced, NSString *info, NSArray *jsonArr) {
        if (issucced == YES) {
            if (jsonArr.count >0) {
                [[ToolManager shareInstance]dismiss];
                for (NSDictionary * dic in jsonArr) {
                    [_jsonArr addObject:dic];
                }
                _titLab.text = [NSString stringWithFormat:@"关注(%@)",_Numb];
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
    
    
    _titLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 20, 120, 44)];
    _titLab.textAlignment = NSTextAlignmentCenter;
    _titLab.textColor = [UIColor blackColor];
    _titLab.text = @"关注(0)";
    _titLab.font = [UIFont systemFontOfSize:16];
    [navView addSubview:_titLab];
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
    static NSString * idenfStr = @"jjrCell";
    JJRCell * cell = [tableView dequeueReusableCellWithIdentifier:idenfStr];
    if (!cell) {
        cell = [[JJRCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 98)];
        cell.backgroundColor = [UIColor clearColor];
        NSString * imgUrl;
        if ([[_jsonArr[indexPath.row]objectForKey:@"imgurl"] rangeOfString:@"http"].location != NSNotFound) {
            imgUrl = [_jsonArr[indexPath.row] objectForKey:@"imgurl"];
        }else{
            imgUrl = [NSString stringWithFormat:@"%@%@",IMG_URL,[_jsonArr[indexPath.row]objectForKey:@"imgurl"]];
        }
        cell.renzhImg.image = [[_jsonArr[indexPath.row]objectForKey:@"authen"] intValue]==3?[UIImage imageNamed:@"renzhen"]:[UIImage imageNamed:@"weirenzhen"];

        [[ToolManager shareInstance] imageView:cell.headImg  setImageWithURL:imgUrl placeholderType:PlaceholderTypeUserHead];
        cell.userNameLab.text = [_jsonArr[indexPath.row] objectForKey:@"realname"];
        cell.positionLab.text =[_jsonArr[indexPath.row] objectForKey:@"area"];
        if ([[_jsonArr[indexPath.row]objectForKey:@"industry"] isEqualToString:BAOXIAN]) {
            cell.hanyeLab.text = @"保险";
        }else if ([[_jsonArr[indexPath.row]objectForKey:@"industry"] isEqualToString:JINRONG])
        {
            cell.hanyeLab.text = @"金融";
        }else if ([[_jsonArr[indexPath.row]objectForKey:@"industry"] isEqualToString:FANGCHANG])
        {
            cell.hanyeLab.text = @"房产";
        }else if ([[_jsonArr[indexPath.row]objectForKey:@"industry"] isEqualToString:CHEHANG])
        {
            cell.hanyeLab.text = @"车行";
        }

        cell.fuwuLab.text =[NSString stringWithFormat:@"服务:%@",[_jsonArr[indexPath.row]objectForKey:@"servicenum" ]];
        cell.fansLab.text = [NSString stringWithFormat:@"粉丝:%@",[_jsonArr[indexPath.row]objectForKey:@"fansnum" ]];
        
        if ([[_jsonArr[indexPath.row]objectForKey:@"isfollow"] intValue] == 1) {
            cell.guanzhuBtn.selected = YES;
            if ([[_jsonArr[indexPath.row] objectForKey:@"mutual"]intValue]== 1) {
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

        cell.guanzhuBtn.tag = 100+indexPath.row;
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
    jjrV.jjrID = [_jsonArr[sender.view.tag-500] objectForKey:@"uid"];
    [self.navigationController pushViewController:jjrV animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 98.f;
}
-(void)guanzhuAction:(UIButton *)sender
{
    NSString * target_id = [_jsonArr[sender.tag-100] objectForKey:@"uid"];
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
            [[ToolManager shareInstance] showAlertMessage:info];
        }
        
    }];
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
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
