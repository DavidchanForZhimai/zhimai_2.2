//
//  AppraiseVC.m
//  Lebao
//
//  Created by adnim on 16/9/27.
//  Copyright © 2016年 David. All rights reserved.
//

#import "AppraiseVC.h"
#import "XLDataService.h"

@interface appraiseMy : NSObject

@property(nonatomic,assign)int scord;
@property(nonatomic,strong)NSString *content;
@end

@interface appraiseData : NSObject
@property(nonatomic,strong)NSString *authen;
@property(nonatomic,strong)NSString *vip;
@property(nonatomic,strong)NSString *userid;
@property(nonatomic,strong)NSString *realname;
@property(nonatomic,strong)NSString *imgurl;
@property(nonatomic,strong)NSString *scord;
@property(nonatomic,strong)NSString *content;
@end

@interface iEvaluate : NSObject

@property(nonatomic,assign)int scord;
@property(nonatomic,strong)NSString *content;
@end

@interface appraiseModel : NSObject
@property(nonatomic,assign)int rtcode;
@property(nonatomic,strong)NSString *rtmsg;
@property(nonatomic,strong)appraiseMy *evaluate_of_my;
@property(nonatomic,strong)appraiseData *data;
@property(nonatomic,strong)iEvaluate *i_evaluate;
@end




@implementation appraiseModel

@end

@implementation appraiseData

@end

@implementation appraiseMy

@end
@implementation iEvaluate

@end

@interface AppraiseVC ()
{
    UIScrollView *botomScr;
    UIView *bgView;
    UITextView *appraiseTF;
    UIButton *appraiseBtn;
    UILabel *nameLab;
    UIImageView *renzhenImgV;
    UIImageView *VIPImgV;
    NSInteger scord;
    UIView *lineView;
    UIView *bgView2;
}

@end

@implementation AppraiseVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self creatUI];
    [self netWork];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navViewTitleAndBackBtn:@"评价"];
    self.view.backgroundColor=AppViewBGColor;
    //     [[ToolManager shareInstance] showWithStatus];
    scord=0;
    
}

-(void)netWork
{
    NSMutableDictionary *param=[Parameter parameterWithSessicon];
    [param setObject:_meetId forKey:@"id"];
    NSLog(@"parem=%@",param);
    [XLDataService putWithUrl:evaluateURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        NSLog(@"dataobj==%@",dataObj);
        if (dataObj) {
            appraiseModel *modal=[appraiseModel mj_objectWithKeyValues:dataObj];
            if (modal.rtcode ==1) {
                [[ToolManager shareInstance] dismiss];
                
                nameLab.text=modal.data.realname;
                if ([modal.data.authen isEqualToString:@"3"]) {
                    renzhenImgV.image=[UIImage imageNamed:@"[iconprofilerenzhen]"];
                }
                if ([modal.data.vip isEqualToString:@"1"]) {
                    VIPImgV.image=[UIImage imageNamed:@"[iconprofilevip]"];
                }
                if (modal.i_evaluate) {
                    for (UIButton *btn in bgView.subviews) {
                        if (btn.tag>=10&&btn.tag<=10+modal.i_evaluate.scord) {
                            [btn setImage:[UIImage imageNamed:@"[pingjia]"] forState:UIControlStateNormal];
                        }
                    }
                    
                    [self changeUIWithLabStr:modal.i_evaluate.content];
                   
                }
                else {
                    [self evalutateUI];
                }
                if (modal.evaluate_of_my) {
                    [self otherEvaluateMeWithContent:modal.evaluate_of_my.content andScord:modal.evaluate_of_my.scord];
                }
                
            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus:dataObj[@"rtmsg"]];
            }
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus];
        }
        
        
    }];
    
}



-(void)creatUI{
    botomScr=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, APPWIDTH, APPHEIGHT-64)];
    [self.view addSubview:botomScr];
    bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, APPWIDTH, 300)];
    bgView.backgroundColor=[UIColor whiteColor];
    [botomScr addSubview:bgView];
    UIImageView *headImgV=[[UIImageView alloc]initWithFrame:CGRectMake((APPWIDTH-50)/2.0, 20, 55, 55)];
    headImgV.layer.cornerRadius=headImgV.width/2.0;
    headImgV.clipsToBounds=YES;
    [[ToolManager shareInstance]imageView:headImgV setImageWithURL:_headImg placeholderType:PlaceholderTypeUserHead];
    [bgView addSubview:headImgV];
    
    nameLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headImgV.frame)+5, APPWIDTH, 30)];
    nameLab.text=@"";
    nameLab.textAlignment=NSTextAlignmentCenter;
    [bgView addSubview:nameLab];
    
    UIImage *renzhen=[UIImage imageNamed:@"[iconprofileweirenzhen]"];
    renzhenImgV=[[UIImageView alloc]initWithFrame:CGRectMake((APPWIDTH-2*renzhen.size.width-5)/2.0, CGRectGetMaxY(nameLab.frame), renzhen.size.width, renzhen.size.height)];
    renzhenImgV.image=renzhen;
    [bgView addSubview:renzhenImgV];
    
    VIPImgV=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(renzhenImgV.frame)+5, CGRectGetMaxY(nameLab.frame), renzhen.size.width, renzhen.size.height)];
    VIPImgV.image=[UIImage imageNamed:@"[iconprofilevipweikaitong]"];
    [bgView addSubview:VIPImgV];
    
    for (int i=0; i<5; i++) {
        UIButton *startBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        startBtn.tag=11+i;
        startBtn.frame=CGRectMake((APPWIDTH-20*5-15*4)/2.0+i*35,CGRectGetMaxY(renzhenImgV.frame)+10, 20, 20);
        [startBtn setImage:[UIImage imageNamed:@"[weixuanpingjia]"] forState:UIControlStateNormal];
        [startBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:startBtn];
        
    }
    lineView=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(renzhenImgV.frame)+40 , APPWIDTH, 1)];
    lineView.backgroundColor=AppViewBGColor;
    [bgView addSubview:lineView];
    botomScr.contentSize=CGSizeMake(0, bgView.height+10);
    
    }



-(void)startBtnClick:(UIButton  *)sender
{
    for (UIButton *btn in bgView.subviews) {
        if (btn.tag>=10&&btn.tag<=sender.tag) {
            [btn setImage:[UIImage imageNamed:@"[pingjia]"] forState:UIControlStateNormal];
        }
        if (btn.tag>=10&&btn.tag>sender.tag) {
            [btn setImage:[UIImage imageNamed:@"[weixuanpingjia]"] forState:UIControlStateNormal];
        }
    }
    scord=sender.tag-10;
}

-(void)evalutateUI//还没评价的ui
{
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
-(void)changeUIWithLabStr:(NSString *)str//已经评价后的ui
{
    for (UIButton *btn in bgView.subviews) {
        if (btn.tag>=10&&btn.tag<=15) {
            btn.userInteractionEnabled=NO;
        }
        
    }
    UILabel *appraiseLab=[[UILabel alloc]initWithFrame:CGRectMake(15, lineView.y+10, APPWIDTH-30, 55)];
    appraiseLab.text=str;
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
-(void)otherEvaluateMeWithContent:(NSString *)content andScord:(int)otherScord
{
    bgView2=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame)+10, APPWIDTH, 30)];
    bgView2.backgroundColor=[UIColor whiteColor];
    [botomScr addSubview:bgView2];
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, APPWIDTH, 15)];
    lab.text=@"对方已评价我";
    lab.textColor=[UIColor grayColor];
    lab.font=[UIFont systemFontOfSize:12];
    lab.textAlignment=NSTextAlignmentCenter;
    [bgView2 addSubview:lab];
    for (int i=0; i<5; i++) {
        UIButton *startBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        startBtn.userInteractionEnabled=NO;
        startBtn.tag=21+i;
        startBtn.frame=CGRectMake((APPWIDTH-20*5-15*4)/2.0+i*35,CGRectGetMaxY(lab.frame)+10, 20, 20);
        if (i<otherScord) {
            [startBtn setImage:[UIImage imageNamed:@"[pingjia]"] forState:UIControlStateNormal];
        }else{
        [startBtn setImage:[UIImage imageNamed:@"[weixuanpingjia]"] forState:UIControlStateNormal];
        }
        [bgView2 addSubview:startBtn];
    }
    
    UILabel *appraiseMeLab=[[UILabel alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(lab.frame)+40, APPWIDTH-30, 55)];
    appraiseMeLab.text=content;
    appraiseMeLab.numberOfLines=0;
    appraiseMeLab.textAlignment=NSTextAlignmentCenter;
    [appraiseMeLab sizeToFit];
    appraiseMeLab.frame=CGRectMake((APPWIDTH-appraiseMeLab.width)/2.0, appraiseMeLab.y, appraiseMeLab.width, appraiseMeLab.height);
    
    [bgView2 addSubview:appraiseMeLab];



    bgView2.frame=CGRectMake(bgView2.x, bgView2.y, bgView2.width, CGRectGetMaxY(appraiseMeLab.frame)+10);

    botomScr.contentSize=CGSizeMake(0, bgView.height+20+bgView2.height);

    
    
    
}

-(void)appraiseBtnClick:(UIButton *)sender
{
    NSMutableDictionary *param=[Parameter parameterWithSessicon];
    [param setObject:_meetId forKey:@"id"];
    [param setObject:@(scord) forKey:@"scord"];
    [param setObject:appraiseTF.text forKey:@"content"];
    NSLog(@"parem=%@",param);
    
    [XLDataService putWithUrl:saveEvaluateURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        NSLog(@"dataobj==%@",dataObj);
        
        if (dataObj) {
            appraiseModel *modal=[appraiseModel mj_objectWithKeyValues:dataObj];
            if (modal.rtcode ==1) {
                [[ToolManager shareInstance] dismiss];
                [self changeUIWithLabStr:appraiseTF.text];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"EVALUATE" object:@{@"meetid":_meetId,@"operation":@"yes"}];
                bgView2.frame=CGRectMake(bgView2.x, CGRectGetMaxY(bgView.frame)+10, bgView2.width,bgView2.height);
                
                botomScr.contentSize=CGSizeMake(0, bgView.height+20+bgView2.height);
            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus:dataObj[@"rtmsg"]];
            }
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus];
        }
        
        
    }];
    
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
