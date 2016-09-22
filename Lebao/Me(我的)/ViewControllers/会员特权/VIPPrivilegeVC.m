//
//  VIPPrivilegeVC.m
//  Lebao
//
//  Created by adnim on 16/9/22.
//  Copyright © 2016年 David. All rights reserved.
//

#import "VIPPrivilegeVC.h"

@interface VIPPrivilegeVC ()
@property (weak, nonatomic) IBOutlet UIImageView *icoudImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *renzhenImgV;
@property (weak, nonatomic) IBOutlet UIImageView *VIPImgV;
@property (weak, nonatomic) IBOutlet UILabel *boomlab;
@property (weak, nonatomic) IBOutlet UIImageView *privilegeImgV;

@end

@implementation VIPPrivilegeVC
-(void)awakeFromNib
{
    
    _icoudImgV.clipsToBounds=YES;
    _icoudImgV.layer.cornerRadius=_icoudImgV.width/2.0;
    [[ToolManager shareInstance] imageView:_icoudImgV setImageWithURL:_modal.imgurl placeholderType:PlaceholderTypeUserHead];
    _nameLab.text=_modal.realname;
    if(_modal.authen==3){
        _renzhenImgV.image=[UIImage imageNamed:@"[iconprofilerenzhen]"];
    }else{
        _renzhenImgV.image=[UIImage imageNamed:@"[iconprofileweirenzhen]"];
    }
    
    _VIPImgV.image=[UIImage imageNamed:@"[iconprofilevipweikaitong]"];
    _privilegeImgV.contentMode=UIViewContentModeScaleAspectFit;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self navViewTitleAndBackBtn:@"会员特权"];
    _privilegeImgV.image=[UIImage imageNamed:@"VIPprivilege.jpg"];
    
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
