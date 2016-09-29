//
//  AppraiseVC.m
//  Lebao
//
//  Created by adnim on 16/9/27.
//  Copyright © 2016年 David. All rights reserved.
//

#import "AppraiseVC.h"

@interface AppraiseVC ()
{
    UIScrollView *botomScr;
    UIView *bgView;
    UITextView *appraiseTF;
    UIButton *appraiseBtn;
}
@end

@implementation AppraiseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navViewTitleAndBackBtn:@"评价"];
    self.view.backgroundColor=AppViewBGColor;
    [self creatUI];
}
-(void)creatUI{
    botomScr=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, APPWIDTH, APPHEIGHT-64)];
    [self.view addSubview:botomScr];
    bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, APPWIDTH, 300)];
    bgView.backgroundColor=[UIColor whiteColor];
    [botomScr addSubview:bgView];
    UIImageView *headImgV=[[UIImageView alloc]initWithFrame:CGRectMake((APPWIDTH-50)/2.0, 20, 50, 50)];
    headImgV.layer.cornerRadius=headImgV.width/2.0;
    headImgV.clipsToBounds=YES;
    headImgV.image=[UIImage imageNamed:@"022[睡觉]"];
    [bgView addSubview:headImgV];
    
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headImgV.frame)+10, APPWIDTH, 30)];
    nameLab.text=@"张大炮";
    nameLab.textAlignment=NSTextAlignmentCenter;
    [bgView addSubview:nameLab];
    
    UIImage *renzhen=[UIImage imageNamed:@"[iconprofilerenzhen]"];
    UIImageView *renzhenImgV=[[UIImageView alloc]initWithFrame:CGRectMake((APPWIDTH-2*renzhen.size.width-5)/2.0, CGRectGetMaxY(nameLab.frame), renzhen.size.width, renzhen.size.height)];
    renzhenImgV.image=renzhen;
    [bgView addSubview:renzhenImgV];
    
    UIImageView *VIPImgV=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(renzhenImgV.frame)+5, CGRectGetMaxY(nameLab.frame), renzhen.size.width, renzhen.size.height)];
    VIPImgV.image=[UIImage imageNamed:@"[iconprofilevip]"];
    [bgView addSubview:VIPImgV];
    
    for (int i=0; i<5; i++) {
        UIButton *startBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        startBtn.tag=10+i;
        startBtn.frame=CGRectMake((APPWIDTH-20*5-15*4)/2.0+i*35,CGRectGetMaxY(renzhenImgV.frame)+10, 20, 20);
        [startBtn setImage:[UIImage imageNamed:@"weixuanpingjia"] forState:UIControlStateNormal];
        [startBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:startBtn];
        
    }
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(renzhenImgV.frame)+40 , APPWIDTH, 1)];
    lineView.backgroundColor=AppViewBGColor;
    [bgView addSubview:lineView];
    
    
    appraiseTF=[[UITextView alloc]initWithFrame:CGRectMake(15, lineView.y+10, APPWIDTH-30, 55)];
    appraiseTF.layer.cornerRadius=5;
    appraiseTF.layer.borderColor=AppViewBGColor.CGColor;
    appraiseTF.layer.borderWidth=1;
    [bgView addSubview:appraiseTF];
    
    appraiseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    appraiseBtn.backgroundColor=AppMainColor;
    [appraiseBtn setTitle:@"发表评价" forState:UIControlStateNormal];
    appraiseBtn.frame=CGRectMake(APPWIDTH/4.0, CGRectGetMaxY(appraiseTF.frame)+10, APPWIDTH/2.0, 40);
    appraiseBtn.layer.cornerRadius=5;
    [appraiseBtn addTarget:self action:@selector(appraiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:appraiseBtn];
    
    bgView.frame=CGRectMake(bgView.x, bgView.y, bgView.width, CGRectGetMaxY(appraiseBtn.frame)+10);
    
    botomScr.contentSize=CGSizeMake(0, bgView.height+10);
}

-(void)startBtnClick:(UIButton  *)sender
{
    for (UIButton *btn in bgView.subviews) {
        if (btn.tag>=10&&btn.tag<=sender.tag) {
            [btn setImage:[UIImage imageNamed:@"pingjia"] forState:UIControlStateNormal];
        }
        if (btn.tag>=10&&btn.tag>sender.tag) {
            [btn setImage:[UIImage imageNamed:@"weixuanpingjia"] forState:UIControlStateNormal];
        }
    }
}

-(void)appraiseBtnClick:(UIButton *)sender
{
    UILabel *appraiseLab=[[UILabel alloc]initWithFrame:appraiseTF.frame];
    appraiseLab.text=appraiseTF.text;
    appraiseLab.numberOfLines=0;
    appraiseLab.textAlignment=NSTextAlignmentCenter;
    [appraiseLab sizeToFit];
    appraiseLab.frame=CGRectMake((APPWIDTH-appraiseLab.width)/2.0, appraiseLab.y, appraiseLab.width, appraiseLab.height);
    
    [bgView addSubview:appraiseLab];
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(appraiseLab.frame)+10, APPWIDTH, 15)];
    lab.text=@"我已评价";
    lab.textColor=[UIColor grayColor];
    lab.font=[UIFont systemFontOfSize:12];
    lab.textAlignment=NSTextAlignmentCenter;
    [bgView addSubview:lab];
    bgView.frame=CGRectMake(bgView.x, bgView.y, bgView.width, CGRectGetMaxY(lab.frame)+10);
    [appraiseBtn removeFromSuperview];
    [appraiseTF removeFromSuperview];
    botomScr.contentSize=CGSizeMake(0, bgView.height+10);
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
