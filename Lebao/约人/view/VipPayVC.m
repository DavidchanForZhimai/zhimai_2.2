//
//  VipPayVC.m
//  Lebao
//
//  Created by adnim on 16/11/3.
//  Copyright © 2016年 David. All rights reserved.
//

#import "VipPayVC.h"
#import "MeetingVC.h"
#import "XianSuoDetailInfo.h"
#import "ToolManager.h"
#import "WetChatPayManager.h"
#import "MeWantMeetVC.h"
#import "MP3PlayerManager.h"
#import "XLDataService.h"
#import "MeetingModel.h"

@interface VipPayVC ()<UIAlertViewDelegate>
typedef enum {
    zhimaizhifuType=0,//知脉支付
    weixinzhifuType,//微信支付
} ZFType;
typedef enum{
    meetType=0,
    addConnections=1,
    vipType=2,
}whatZfType;
@property (assign,nonatomic)int moneyType;

@end


@implementation VipPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    self.zhifuBtn.layer.cornerRadius = 6.0f;
    self.dingjinLab.text = _jineStr;

    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weixinAction)];
    tap2.numberOfTapsRequired = 1;
    tap2.numberOfTouchesRequired = 1;
    [_weixinV addGestureRecognizer:tap2];
//    _wxImg.image = [UIImage imageNamed:@"liuchengweijinxin"];
    self.moneyType = weixinzhifuType;
    _wxImg.image = [UIImage imageNamed:@"xuanzhong"];
    [[XianSuoDetailInfo shareInstance]getAmountWith:^(BOOL issucced, NSString *info, NSDictionary *jsonDic) {
        if (issucced == YES) {
//            _yueLab.text = [NSString stringWithFormat:@"可用余额%@元",[jsonDic objectForKey:@"amount"]];
        }else
        {
            [[ToolManager shareInstance] showAlertMessage:info];
            
        }
    }];
}
-(void)weixinAction
{
    _wxImg.image = [UIImage imageNamed:@"xuanzhong"];
    self.moneyType = weixinzhifuType;
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
    titLab.text = @"支付";
    titLab.font = [UIFont systemFontOfSize:16];
    [navView addSubview:titLab];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)zhifuAction:(id)sender {
    
    NSString * zhifuType ;
    zhifuType  = @"app";
    
    [self.param setObject:zhifuType forKey:@"paytype"];

        
        NSLog(@"self.param=%@",self.param);
        [XLDataService putWithUrl:vipOpenURL param:self.param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
            if(dataObj){
                
                MeetingModel *model=[MeetingModel mj_objectWithKeyValues:dataObj];
                NSLog(@"dataObj=%@",dataObj);
                if (model.rtcode==1) {
                    
                    if (_moneyType==weixinzhifuType) {
                        [[WetChatPayManager shareInstance]wxPay:dataObj[@"datas"] succeedMeg:@"发送成功！" recharge:@"0" wetChatPaySucceed:^(NSString *payMoney) {
                            [self.navigationController popViewControllerAnimated:YES];
                            if (_succeedBlock) {
                                _succeedBlock(YES);
                            }
                            
                        }];
                        return ;
                        
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                    if (_succeedBlock) {
                        _succeedBlock(YES);
                    }
                    
                    
                    
                }
                
                else
                {
                    [[ToolManager shareInstance] showAlertMessage:model.rtmsg];
                }
                //                NSLog(@"model.rtmsg=========dataobj=%@",model.rtmsg);
            }else
            {
                [[ToolManager shareInstance] showInfoWithStatus];
                
            }
            
        }];
        
    
}



@end
