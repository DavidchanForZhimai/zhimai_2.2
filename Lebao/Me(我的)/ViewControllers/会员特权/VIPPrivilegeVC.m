//
//  VIPPrivilegeVC.m
//  Lebao
//
//  Created by adnim on 16/9/22.
//  Copyright © 2016年 David. All rights reserved.
//

#import "VIPPrivilegeVC.h"

@interface VIPPrivilegeVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

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
    
    [self creatUI];
}
-(void)creatUI{
    UIView *vipView=[[UIView alloc]init];
    vipView.frame=CGRectMake(0,64, APPWIDTH, APPHEIGHT-64-44);
    [self.mainScrollView addSubview:vipView];
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
    certifyImgV.frame=CGRectMake(CGRectGetMaxX(nameLab.frame)+10, CGRectGetMaxY(nameLab.frame)-certifyimag.size.height, certifyimag.size.width,certifyimag.size.height);
    certifyImgV.image=certifyimag;
    [vipView addSubview:certifyImgV];
    
    UIImageView *VIPImgV=[[UIImageView alloc]init];//vip
    UIImage *VIPimag;
    if ([_modal.vip isEqualToString:@"1"]) {
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
    if ([_modal.vip isEqualToString:@"1"]) {
        messageLab.text=@"您已经是会员";
    }else{
        messageLab.text=@"您还开通会员";
    }
    
    messageLab.frame= CGRectMake(CGRectGetMaxX(headImagV.frame) + 10, CGRectGetMaxY(nameLab.frame) + 10,messageLab.text.length*12, 12);
    [vipView addSubview:messageLab];
    
    
    UILabel *maneyLab=[[UILabel alloc]init];//钱
    maneyLab.font=Size(32);
    maneyLab.text=@"198元/年";
    maneyLab.textColor=AppMainColor;
    maneyLab.frame= CGRectMake(vipView.width-maneyLab.text.length*16-10, CGRectGetMaxY(nameLab.frame)-3,maneyLab.text.length*16, 16);
    maneyLab.textAlignment=NSTextAlignmentRight;
    NSMutableAttributedString *str=[[NSMutableAttributedString alloc]initWithString:maneyLab.text];
    [str addAttribute:NSFontAttributeName value:Size(28) range:[maneyLab.text rangeOfString:@"元/年"]];
    [str addAttribute:NSForegroundColorAttributeName value:BlackTitleColor range:[maneyLab.text rangeOfString:@"元/年"]];
    maneyLab.attributedText=str;
    maneyLab.numberOfLines=0;
    [vipView addSubview:maneyLab];
    
    UIImageView *vipPrivilegeImgV=[[UIImageView alloc]init];
    UIImage *vipPrivilegeImg=[UIImage imageNamed:@"VIPprivilege.jpg"];
    vipPrivilegeImgV.frame=CGRectMake(0, 90, APPWIDTH, APPWIDTH/vipPrivilegeImg.size.width*vipPrivilegeImg.size.height);

    vipPrivilegeImgV.image=vipPrivilegeImg;
    [vipView addSubview:vipPrivilegeImgV];
    
    vipView.frame=CGRectMake(0,64, APPWIDTH,CGRectGetMaxY(vipPrivilegeImgV.frame));
//
    self.mainScrollView.contentSize=CGSizeMake(0, vipView.height);
    
    
    
}
- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
}
- (IBAction)vipBtnClick:(UIButton *)sender {
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
