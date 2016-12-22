//
//  EarnestMoneyViewController.m
//  Lebao
//
//  Created by David on 16/1/26.
//  Copyright © 2016年 David. All rights reserved.
//

#import "EarnestMoneyViewController.h"
#import "WithdrawalViewController.h"//提现
#import "EarnestRecodeViewController.h"//记录
#import "XLDataService.h"
#import "RechargeViewController.h"
#define KNotificationWetChatWithdraw @"KNotificationWetChatWithdraw"
#define WalletURL [NSString stringWithFormat:@"%@user/wallet",HttpURL]
@interface EarnestMoneyViewController ()

@end

@implementation EarnestMoneyViewController
{
    
    UIScrollView *_mainScrollView;

    UILabel *allAmount;
    UILabel *_rechargeiInstructions;
    
    UILabel *_canCarry;
    UILabel *_redEnvelope;
    id _dataObj;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navView];
    [self mainView];
    [self netWork];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wetChatWithdrawPayResult:) name:KNotificationWetChatWithdraw object:nil];
}
#pragma mark
#pragma mark wetChatWithdrawPayResult:
- (void)wetChatWithdrawPayResult:(NSNotification *)notif
{
    NSString *payMoney = notif.object;
    allAmount.text = [NSString stringWithFormat:@"%.2f",[allAmount.text floatValue] - payMoney.floatValue];
    _canCarry.text =[NSString stringWithFormat:@"%.2f",[_canCarry.text floatValue] - payMoney.floatValue];
}
#pragma mark - Navi_View
- (void)navView
{
    [self navViewTitleAndBackBtn:@"我的钱包" ];
    //充值
    BaseButton *chongzhi = [[BaseButton alloc]initWithFrame:CGRectMake(APPWIDTH - 50, StatusBarHeight, 50, NavigationBarHeight) setTitle:@"充值" titleSize:15 titleColor:BlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] inView:self.view];
    __weak typeof(self) weakSelf = self;
    chongzhi.didClickBtnBlock = ^
    {
        RechargeViewController *rechargeVC = [[RechargeViewController alloc]init];
        rechargeVC.moneyPayCallBack = ^(float money)
        {
         allAmount.text = [NSString stringWithFormat:@"%.2f",[allAmount.text floatValue] + money];
         _canCarry.text =[NSString stringWithFormat:@"%.2f",[_canCarry.text floatValue] + money];
        };
        PushView(weakSelf, rechargeVC);
    };
}
#pragma mark
#pragma mark - mainView
- (void)mainView
{
    _mainScrollView = allocAndInitWithFrame(UIScrollView, frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)));
    _mainScrollView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:_mainScrollView];
    _mainScrollView.alwaysBounceVertical = YES;
    
    UIView *headView = allocAndInitWithFrame(UIView, frame(0, 0, frameWidth(_mainScrollView), 172.0f));
    headView.backgroundColor = AppMainColor;
    [_mainScrollView addSubview:headView];
    
    
    [UILabel createLabelWithFrame:frame(0, 34, frameWidth(_mainScrollView) , 24*SpacedFonts) text:@"总金额(元)" fontSize:24*SpacedFonts textColor:hexColor(f2f2f2) textAlignment:NSTextAlignmentCenter inView:headView];
    
    allAmount =  [UILabel createLabelWithFrame:frame(0,65, frameWidth(_mainScrollView) , 60*SpacedFonts) text:@"00.00" fontSize:60*SpacedFonts textColor:WhiteColor textAlignment:NSTextAlignmentCenter inView:headView];
    
    UIView *footView = allocAndInitWithFrame(UIView, frame(frameX(headView), 119.0f, frameWidth(headView), 53));
    footView.backgroundColor = rgba(255, 255, 255, 0.2);
    
    [_mainScrollView addSubview:footView];
    
    [UILabel createLabelWithFrame:frame(0, 10, frameWidth(_mainScrollView)/2.0 , 24*SpacedFonts) text:@"可提现(元)" fontSize:24*SpacedFonts textColor:hexColor(f2f2f2) textAlignment:NSTextAlignmentCenter inView:footView];
    
    _canCarry =  [UILabel createLabelWithFrame:frame(0,15 + 24*SpacedFonts, frameWidth(_mainScrollView)/2.0 , 28*SpacedFonts) text:@"00.00" fontSize:28*SpacedFonts textColor:WhiteColor textAlignment:NSTextAlignmentCenter inView:footView];
    
    [UILabel createLabelWithFrame:frame(frameWidth(_mainScrollView)/2.0, 10, frameWidth(_mainScrollView)/2.0 , 24*SpacedFonts) text:@"红包(元)" fontSize:24*SpacedFonts textColor:hexColor(f2f2f2) textAlignment:NSTextAlignmentCenter inView:footView];
    
     _redEnvelope =  [UILabel createLabelWithFrame:frame(frameWidth(_mainScrollView)/2.0,15 + 24*SpacedFonts, frameWidth(_mainScrollView)/2.0 , 28*SpacedFonts) text:@"00.00" fontSize:28*SpacedFonts textColor:WhiteColor textAlignment:NSTextAlignmentCenter inView:footView];
    
   
    UIImage *tixianWXImage = [UIImage imageNamed:@"iconfont-tixian"];
    
    float btnH = 41*ScreenMultiple;
    BaseButton *tixianWX = [[BaseButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(footView.frame) +  10, APPWIDTH, btnH) setTitle:@"提现到微信钱包" titleSize:13 titleColor:BlackTitleColor backgroundImage:nil iconImage:tixianWXImage highlightImage:tixianWXImage setTitleOrgin:CGPointMake((btnH - 13)/2.0 , 20) setImageOrgin:CGPointMake((btnH -tixianWXImage.size.height)/2.0 , 10) inView:_mainScrollView];
    tixianWX.backgroundColor = WhiteColor;
    __weak typeof(self) weakSelf = self;
    tixianWX.didClickBtnBlock =^
    {
        WithdrawalViewController *withdrawalVC = [[WithdrawalViewController alloc]init];
        PushView(weakSelf, withdrawalVC);
    };
    
    UIImage *jiaoyiImage = [UIImage imageNamed:@"iconfont-chengyijinjilu"];
    BaseButton *jiaoyi = [[BaseButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tixianWX.frame)+0.5, APPWIDTH, btnH) setTitle:@"交易记录" titleSize:13 titleColor:BlackTitleColor backgroundImage:nil iconImage:jiaoyiImage highlightImage:jiaoyiImage setTitleOrgin:CGPointMake((btnH - 13)/2.0 , 20) setImageOrgin:CGPointMake((btnH -jiaoyiImage.size.height)/2.0 , 10) inView:_mainScrollView];
    jiaoyi.backgroundColor = WhiteColor;
    jiaoyi.didClickBtnBlock =^
    {
        EarnestRecodeViewController *earnestRecodeVC =[[EarnestRecodeViewController alloc]init];
        PushView(weakSelf, earnestRecodeVC);

    };
    UIImage *imageAssorry1 =[UIImage imageNamed:@"option"];
    UIImageView *assorry1 =allocAndInitWithFrame(UIImageView, frame(jiaoyi.width - 13 - imageAssorry1.size.width, (jiaoyi.height - imageAssorry1.size.height)/2.0, imageAssorry1.size.width, imageAssorry1.size.height));
    assorry1.image = imageAssorry1;
    
    UIImage *imageAssorry2 =[UIImage imageNamed:@"option"];
    UIImageView *assorry2 =allocAndInitWithFrame(UIImageView, frame(jiaoyi.width - 13 - imageAssorry2.size.width, (jiaoyi.height - imageAssorry2.size.height)/2.0, imageAssorry2.size.width, imageAssorry2.size.height));
    assorry2.image = imageAssorry2;
    
    [tixianWX  addSubview:assorry1];
    [jiaoyi  addSubview:assorry2];
    
    UILabel *_instructions = [UILabel createLabelWithFrame:frame(16, CGRectGetMaxY(jiaoyi.frame) + 20, 150 , 24*SpacedFonts) text:@"知脉钱包说明" fontSize:24*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:_mainScrollView];
    
    _rechargeiInstructions = [UILabel createLabelWithFrame:frame(15, CGRectGetMaxY(_instructions.frame) + 10, frameWidth(_mainScrollView) - 30 , 36) text:@"1、知脉目前仅支持微信支付充值\n2、充值的金额主要用于平台的打赏、购买会员等消费，也可以再次提现到微信钱包\n3、红包中的金额只能用于平台消费，无法提现" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:_mainScrollView];
    _rechargeiInstructions.numberOfLines = 0;
    CGSize size = [_rechargeiInstructions sizeWithMultiLineContent:_rechargeiInstructions.text rowWidth:frameWidth(_rechargeiInstructions) font:Size(24)];
    _rechargeiInstructions.frame = frame(frameX(_rechargeiInstructions), frameY(_rechargeiInstructions), frameWidth(_rechargeiInstructions), size.height);
    _mainScrollView.contentSize =CGSizeMake(frameWidth(_mainScrollView), CGRectGetMaxY(_rechargeiInstructions.frame) + 10);
   
    
}
- (void)netWork
{
    NSMutableDictionary * parameter =[Parameter parameterWithSessicon];
    [[ToolManager shareInstance] showWithStatus];
    [XLDataService postWithUrl:WalletURL param:parameter modelClass:nil responseBlock:^(id dataObj, NSError *error) {
//        NSLog(@"dataObj =%@",dataObj);
        if (dataObj) {
            
            if ([dataObj[@"rtcode"] intValue] ==1) {
                [[ToolManager shareInstance] dismiss];
                 _dataObj = dataObj;
                allAmount.text =dataObj[@"totalamount"];
                _canCarry.text = dataObj[@"amount"];
                _redEnvelope.text = dataObj[@"repackets"];
                _rechargeiInstructions.text = dataObj[@"desc"];
                {
                    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:_rechargeiInstructions.text];
                    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
                    [style setLineSpacing:3.0];
                    [string addAttribute:NSParagraphStyleAttributeName value:style range:[_rechargeiInstructions.text rangeOfString:_rechargeiInstructions.text]];
                    _rechargeiInstructions.attributedText =string;
                    
                    CGSize size = [_rechargeiInstructions sizeWithMultiLineContent:_rechargeiInstructions.text rowWidth:frameWidth(_rechargeiInstructions) font:Size(30)];
                    _rechargeiInstructions.frame = frame(frameX(_rechargeiInstructions), frameY(_rechargeiInstructions), frameWidth(_rechargeiInstructions), size.height);
                    
                    _mainScrollView.contentSize =CGSizeMake(frameWidth(_mainScrollView), CGRectGetMaxY(_rechargeiInstructions.frame) + 10);
                    

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
#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag ==NavViewButtonActionNavLeftBtnTag ) {
        PopView(self);
    }
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:KNotificationWetChatWithdraw];
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
