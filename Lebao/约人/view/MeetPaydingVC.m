//
//  MeetPaydingVC.m
//  Lebao
//
//  Created by adnim on 16/9/12.
//  Copyright © 2016年 David. All rights reserved.
//

#import "MeetPaydingVC.h"
#import "XianSuoDetailInfo.h"
#import "ToolManager.h"
#import "WetChatPayManager.h"
#import "MeWantMeetVC.h"
#import "MP3PlayerManager.h"
#import "XLDataService.h"
#import "MeetingModel.h"
@interface MeetPaydingVC ()
typedef enum {
    zhimaizhifuType=0,//知脉支付
    weixinzhifuType,//微信支付
} ZFType;
@property (assign,nonatomic)int moneyType;

@end



@implementation MeetPaydingVC



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    self.zhifuBtn.layer.cornerRadius = 6.0f;
    self.dingjinLab.text = _jineStr;
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zhimAction)];
    tap1.numberOfTapsRequired = 1;
    tap1.numberOfTouchesRequired = 1;
    [_zhimaiV addGestureRecognizer:tap1];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weixinAction)];
    tap2.numberOfTapsRequired = 1;
    tap2.numberOfTouchesRequired = 1;
    [_weixinV addGestureRecognizer:tap2];
    _zhimaiImg.image = [UIImage imageNamed:@"xuanzhong"];
    _wxImg.image = [UIImage imageNamed:@"liuchengweijinxin"];
    self.moneyType = zhimaizhifuType;
    
    [[XianSuoDetailInfo shareInstance]getAmountWith:^(BOOL issucced, NSString *info, NSDictionary *jsonDic) {
        if (issucced == YES) {
            _yueLab.text = [NSString stringWithFormat:@"可用余额%@元",[jsonDic objectForKey:@"amount"]];
        }else
        {
            [[ToolManager shareInstance] showAlertMessage:info];
            
        }
    }];
}
-(void)zhimAction
{
    _zhimaiImg.image = [UIImage imageNamed:@"xuanzhong"];
    _wxImg.image = [UIImage imageNamed:@"liuchengweijinxin"];
    self.moneyType = zhimaizhifuType;
}
-(void)weixinAction
{
    _wxImg.image = [UIImage imageNamed:@"xuanzhong"];
    _zhimaiImg.image = [UIImage imageNamed:@"liuchengweijinxin"];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)zhifuAction:(id)sender {
    NSString * zhifuType ;
    if (_moneyType == zhimaizhifuType) {
        zhifuType = @"wallet";
    }else
        
    {
        zhifuType  = @"app";
    }
    [self.param setObject:zhifuType forKey:@"paytype"];
    MeWantMeetVC *iWantMeetVC =  allocAndInit(MeWantMeetVC);
    
    if (_audioData) {
        
        [[MP3PlayerManager shareInstance] uploadAudioWithType:@"mp3" audioData:_audioData  finishuploadBlock:^(BOOL succeed,id  audioDic)
         {
             NSLog(@"audioDic =%@",audioDic);
             [self.param setValue:audioDic[@"audiourl"] forKey:@"audio"];
             
             [XLDataService putWithUrl:MeetyouURL param:self.param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
                 if(dataObj){
                     
                     MeetingModel *model=[MeetingModel mj_objectWithKeyValues:dataObj];
                    
                     if (model.rtcode==1) {
                         
                         if (_moneyType==weixinzhifuType) {
                             [[WetChatPayManager shareInstance]wxPay:dataObj[@"datas"] succeedMeg:@"发布成功！" recharge:@"0" wetChatPaySucceed:^(NSString *payMoney) {
                                 
                                 UIAlertView *successAlertV=[[UIAlertView alloc]initWithTitle:@"恭喜您,约见成功!" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"对话",@"电话联系",@"继续约见他人", nil];
                                 successAlertV.cancelButtonIndex=2;
                                 PushView(self, iWantMeetVC);
                                 [successAlertV show];
                             }];
                             return ;
                             
                         }

                         UIAlertView *successAlertV=[[UIAlertView alloc]initWithTitle:@"恭喜您,约见成功!" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"对话",@"电话联系",@"继续约见他人", nil];
                         successAlertV.cancelButtonIndex=2;
                         PushView(self, iWantMeetVC);
                         [successAlertV show];
                         
                     }
                     
                     else
                     {
                         [[ToolManager shareInstance] showAlertMessage:model.rtmsg];
                     }
                     NSLog(@"model.rtmsg=========dataobj=%@",model.rtmsg);
                 }else
                 {
                     [[ToolManager shareInstance] showInfoWithStatus];
                     
                 }
                 
             }];
    
         }];
        
    }
    else
    {
        [XLDataService putWithUrl:MeetyouURL param:self.param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
            if(dataObj){
                
                MeetingModel *model=[MeetingModel mj_objectWithKeyValues:dataObj];
                
                if (model.rtcode==1) {
                    
                    if (_moneyType==weixinzhifuType) {
                        [[WetChatPayManager shareInstance]wxPay:dataObj[@"datas"] succeedMeg:@"发布成功！" recharge:@"0" wetChatPaySucceed:^(NSString *payMoney) {
                            
                            UIAlertView *successAlertV=[[UIAlertView alloc]initWithTitle:@"恭喜您,约见成功!" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"对话",@"电话联系",@"继续约见他人", nil];
                            successAlertV.cancelButtonIndex=2;
                            PushView(self, iWantMeetVC);
                            [successAlertV show];
                        }];
                        return ;
                        
                    }

                    UIAlertView *successAlertV=[[UIAlertView alloc]initWithTitle:@"恭喜您,约见成功!" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"对话",@"电话联系",@"继续约见他人", nil];
                    successAlertV.cancelButtonIndex=2;
                    PushView(self, iWantMeetVC);
                    [successAlertV show];
                    
                }
                
                else
                {
                    [[ToolManager shareInstance] showAlertMessage:model.rtmsg];
                }
                NSLog(@"model.rtmsg=========dataobj=%@",model.rtmsg);
            }else
            {
                [[ToolManager shareInstance] showInfoWithStatus];
                
            }
            
        }];
    }
    
    
    
    
    
    
}

@end

