//
//  VIPPrivilegeVC.m
//  Lebao
//
//  Created by adnim on 16/9/22.
//  Copyright © 2016年 David. All rights reserved.
//

#import "VIPPrivilegeVC.h"
#import "XLDataService.h"
#import "VipPrivilegeCell.h"
#import "MeetPaydingVC.h"
@interface privilegeData : NSObject

@property(nonatomic,copy)NSString *ordinary;
@property(nonatomic,copy)NSString *describe;
@property(nonatomic,copy)NSString *vip;
@end

@interface pricesData : NSObject
@property(nonatomic,assign)int days;
@property(nonatomic,assign)int level;
@property(nonatomic,assign)int price;
@property(nonatomic,copy)NSString *price_unit;
@end

@interface vipModel : NSObject
@property(nonatomic,assign)int vip;
@property(nonatomic,assign)int authen;
@property(nonatomic,assign)int rtcode;
@property(nonatomic,copy)NSString *rtmsg;
@property(nonatomic,copy)NSString *realname;
@property(nonatomic,strong)NSArray<pricesData *> *prices;
@property(nonatomic,strong)NSArray<privilegeData*> *privilege;
@end
@implementation vipModel

+ (NSDictionary *)objectClassInArray{
    
    return @{@"prices" : [pricesData class],@"privilege" : [privilegeData class]};

}
@end

@implementation pricesData

@end

@implementation privilegeData

@end

@interface VIPPrivilegeVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *vipTab;
}

@property (strong, nonatomic)NSMutableArray * allArr;
@end

@implementation VIPPrivilegeVC
-(void)awakeFromNib
{
    
  
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self navViewTitleAndBackBtn:@"会员特权"];
    _allArr=[[NSMutableArray alloc]init];
    
    [self creatUI];
    [self netWork];
}
-(void)creatUI{

    vipTab=[[UITableView alloc]initWithFrame:CGRectMake(0,64, APPWIDTH, APPHEIGHT-64-44) style:(UITableViewStyleGrouped)];
    vipTab.delegate=self;
    vipTab.dataSource=self;
    vipTab.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:vipTab];
    vipTab.tableHeaderView=[self tabHeaderView];
    
    UIButton *vipBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, APPHEIGHT-44, APPWIDTH, 44)];
    vipBtn.backgroundColor=AppMainColor;
    [vipBtn setTitle:@"快去升级为特权会员" forState:UIControlStateNormal];
    [vipBtn addTarget:self action:@selector(vipAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:vipBtn];

}

- (void)netWork//加载数据
{
    
    NSMutableDictionary *param = [Parameter parameterWithSessicon];
    if (self.allArr.count==0) {
        [[ToolManager shareInstance] showWithStatus];
    }
    //     NSLog(@"param====%@",param);
    [XLDataService putWithUrl:vipviewURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
             if (dataObj) {
                        NSLog(@"meetObj====%@",dataObj);
            vipModel *modal = [vipModel mj_objectWithKeyValues:dataObj];

            if (modal.rtcode ==1) {
                [[ToolManager shareInstance]dismiss];
               
                    [self.allArr addObject:modal];
                
                vipTab.tableHeaderView = [self tabHeaderView];
                
                [vipTab reloadData];
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
-(UIView *)tabHeaderView
{
    vipModel *model=[_allArr firstObject];
    UIView *vipView=[[UIView alloc]init];
    vipView.frame=CGRectMake(0,0, APPWIDTH, 130);
    CALayer *toplayer=[[CALayer alloc]init];
    toplayer.frame=CGRectMake(0, 10, vipView.width, 70);
    toplayer.backgroundColor=[UIColor whiteColor].CGColor;
    [vipView.layer addSublayer:toplayer];
    
    UIImageView *headImagV=[[UIImageView alloc]init];//头像
    headImagV.frame = CGRectMake(10, 23, 44, 44);
    [[ToolManager shareInstance] imageView:headImagV setImageWithURL:_modal.imgurl placeholderType:PlaceholderTypeUserHead];
    [vipView addSubview:headImagV];
    
    UILabel *nameLab=[[UILabel alloc]init];//名字
    nameLab.font=Size(28);
    nameLab.text=_modal.realname;
    nameLab.frame= CGRectMake(CGRectGetMaxX(headImagV.frame) + 10, headImagV.y+3,_modal.realname.length*14, 14);
    [vipView addSubview:nameLab];
    
    UIImageView *certifyImgV=[[UIImageView alloc]init];//认证
    UIImage *certifyimag;
    if (_modal.authen) {
        certifyimag=[UIImage imageNamed:@"[iconprofilerenzhen]"];
    }else{
        certifyimag=[UIImage imageNamed:@"[iconprofileweirenzhen]"];
    }
    certifyImgV.frame=CGRectMake(CGRectGetMaxX(nameLab.frame)+5, CGRectGetMaxY(nameLab.frame)-certifyimag.size.height, certifyimag.size.width,certifyimag.size.height);
    certifyImgV.image=certifyimag;
    [vipView addSubview:certifyImgV];
    
    UIImageView *VIPImgV=[[UIImageView alloc]init];//vip
    UIImage *VIPimag;
    if (model.vip ==1) {
        VIPimag=[UIImage imageNamed:@"[iconprofilevip]"];
    }else{
        VIPimag=[UIImage imageNamed:@"[iconprofilevipweikaitong]"];
    }
    VIPImgV.frame=CGRectMake(CGRectGetMaxX(certifyImgV.frame)+5,certifyImgV.y, VIPimag.size.width, VIPimag.size.height);
    VIPImgV.image=VIPimag;
    [vipView addSubview:VIPImgV];
    
    UILabel *messageLab=[[UILabel alloc]init];//提醒是否开通vip
    messageLab.font=Size(24);
    messageLab.textColor=[UIColor lightGrayColor];
    if (model.vip ==1) {
        messageLab.text=@"您已经是会员";
    }else{
        messageLab.text=@"您还开通会员";
    }
    
    messageLab.frame= CGRectMake(CGRectGetMaxX(headImagV.frame) + 10, CGRectGetMaxY(nameLab.frame) + 10,messageLab.text.length*12, 12);
    [vipView addSubview:messageLab];
    
    
    UILabel *maneyLab=[[UILabel alloc]init];//钱
    maneyLab.font=Size(32);
    
    maneyLab.text=[NSString stringWithFormat:@"%d元/年",model.prices[0].price];
    maneyLab.textColor=AppMainColor;
    maneyLab.frame= CGRectMake(vipView.width-maneyLab.text.length*16-10, CGRectGetMaxY(nameLab.frame)-3,maneyLab.text.length*16, 16);
    maneyLab.textAlignment=NSTextAlignmentRight;
    NSMutableAttributedString *str=[[NSMutableAttributedString alloc]initWithString:maneyLab.text];
    [str addAttribute:NSFontAttributeName value:Size(28) range:[maneyLab.text rangeOfString:@"元/年"]];
    [str addAttribute:NSForegroundColorAttributeName value:BlackTitleColor range:[maneyLab.text rangeOfString:@"元/年"]];
    maneyLab.attributedText=str;
    maneyLab.numberOfLines=0;
    [vipView addSubview:maneyLab];
    CALayer *viplablayer=[[CALayer alloc]init];
    viplablayer.frame=CGRectMake(0, 90, APPWIDTH, 40);
    viplablayer.backgroundColor=[UIColor whiteColor].CGColor;
    [vipView.layer addSublayer:viplablayer];
    UILabel *viplab=[[UILabel alloc]initWithFrame:CGRectMake(10, 90, APPWIDTH-10, 40)];
    viplab.backgroundColor=[UIColor whiteColor];
    viplab.text=@"会员特权";
    [vipView addSubview:viplab];

    
    return vipView;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section<self.allArr.count) {
        vipModel *data =  self.allArr[section];
        if (data.privilege.count!=0) {
            return data.privilege.count+1;
        }
        return data.privilege.count;
    }
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footview=[[UIView alloc]init];
    footview.frame=CGRectMake(0, 0, APPWIDTH, 10);
    footview.backgroundColor=[UIColor whiteColor];
    return footview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VipPrivilegeCell *cell=[tableView dequeueReusableCellWithIdentifier:@"vipCell"];
    if (!cell) {
        cell=[[VipPrivilegeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"vipCell"];
    }
    vipModel *model=_allArr[indexPath.section];
    if (indexPath.row==0) {
        cell.lab1.text=@"权限";
        cell.lab2.text=@"免费";
        cell.lab3.text=@"收费";
        cell.lab1.backgroundColor=AppViewBGColor;
        cell.lab2.backgroundColor=AppViewBGColor;
        cell.lab3.backgroundColor=AppViewBGColor;
    }else
    {
        privilegeData * data = model.privilege[indexPath.row-1];
        cell.lab1.text=data.describe;
        cell.lab2.text=data.ordinary;
        cell.lab3.text=data.vip;
        cell.lab1.backgroundColor=[UIColor whiteColor];
        cell.lab2.backgroundColor=[UIColor whiteColor];
        cell.lab3.backgroundColor=[UIColor whiteColor];

    }
    
    
    
    
    return cell;
}
-(void)vipAction:(UIButton *)sender
{
    vipModel *model=[_allArr firstObject];
    MeetPaydingVC * payVC = [[MeetPaydingVC alloc]init];
    NSMutableDictionary *param=[Parameter parameterWithSessicon];
    [param setObject:@(model.prices[0].price) forKey:@"price"];
    payVC.param=param;
    payVC.jineStr =[NSString stringWithFormat:@"%d",model.prices[0].price];
    payVC.whatZfType=2;
    payVC.succeedBlock = ^(BOOL succeed)
    {
        UIAlertView *successAlertV=[[UIAlertView alloc]initWithTitle:@"恭喜您!" message:@"成为尊贵的知脉会员!" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [successAlertV show];
    };
    [self.navigationController pushViewController:payVC animated:YES];
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath//高亮
{
    return NO;
}

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
