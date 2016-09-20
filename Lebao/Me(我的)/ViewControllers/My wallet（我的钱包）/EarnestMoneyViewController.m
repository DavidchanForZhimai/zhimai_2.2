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
#import "WetChatPayManager.h"
//////// 特殊字符的限制输入，价格金额的有效性判断
#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"
#define KNotificationWetChatWithdraw @"KNotificationWetChatWithdraw"
#define WalletURL [NSString stringWithFormat:@"%@user/wallet",HttpURL]
@interface EarnestMoneyViewController ()<UITextFieldDelegate>

@end
typedef enum {
    
   ButtonActionTagWithdraw =2,
   ButtonActionTagRecharge,
    ButtonActionTagRecode
    
}ButtonActionTag;

@implementation EarnestMoneyViewController
{
    
    UIScrollView *_mainScrollView;
    UILabel *_rechargeLb;
    UITextField *_rechargeTextField;
    
    UILabel *allAmount;
    UIView *_rechargeView;
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
    [self navViewTitleAndBackBtn:@"诚意金" ];
    
    
}
#pragma mark
#pragma mark - mainView
- (void)mainView
{
    _mainScrollView = allocAndInitWithFrame(UIScrollView, frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)));
    _mainScrollView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:_mainScrollView];
    _mainScrollView.alwaysBounceVertical = YES;
    
    UIView *headView = allocAndInitWithFrame(UIView, frame(0, 0, frameWidth(_mainScrollView), 125.0f));
    headView.backgroundColor = AppMainColor;
    [_mainScrollView addSubview:headView];
    
    UIButton *_recodeBtn = [UIButton createButtonWithfFrame:frame(frameWidth(_mainScrollView) -40, 0, 40, 40) title:nil backgroundImage:nil iconImage:[UIImage imageNamed:@"iconfont-chengyijinjilu"] highlightImage:nil tag:ButtonActionTagRecode inView:headView];
    [_recodeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *_withdrawBtn =[UIButton createButtonWithfFrame:frame(frameWidth(_mainScrollView) -80, 0, 40, 40) title:@"提现" backgroundImage:nil iconImage:nil highlightImage:nil tag:ButtonActionTagWithdraw inView:headView];
    _withdrawBtn.titleLabel.font = Size(24);
    [_withdrawBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [UILabel createLabelWithFrame:frame(0, 65, frameWidth(_mainScrollView) , 24*SpacedFonts) text:@"总金额(元)" fontSize:24*SpacedFonts textColor:WhiteColor textAlignment:NSTextAlignmentCenter inView:headView];
    
    allAmount =  [UILabel createLabelWithFrame:frame(0,87, frameWidth(_mainScrollView) , 26*SpacedFonts) text:@"00.00" fontSize:26*SpacedFonts textColor:WhiteColor textAlignment:NSTextAlignmentCenter inView:headView];
    
    UIView *footView = allocAndInitWithFrame(UIView, frame(frameX(headView), CGRectGetMaxY(headView.frame), frameWidth(headView), 50));
    footView.backgroundColor = WhiteColor;
    
    [_mainScrollView addSubview:footView];
    
    [UILabel createLabelWithFrame:frame(0, 10, frameWidth(_mainScrollView)/2.0 , 24*SpacedFonts) text:@"可提现(元)" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:footView];
    
    _canCarry =  [UILabel createLabelWithFrame:frame(0,15 + 24*SpacedFonts, frameWidth(_mainScrollView)/2.0 , 26*SpacedFonts) text:@"00.00" fontSize:26*SpacedFonts textColor:AppMainColor textAlignment:NSTextAlignmentCenter inView:footView];
    
    [UILabel createLabelWithFrame:frame(frameWidth(_mainScrollView)/2.0, 10, frameWidth(_mainScrollView)/2.0 , 24*SpacedFonts) text:@"红包(元)" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:footView];
    
     _redEnvelope =  [UILabel createLabelWithFrame:frame(frameWidth(_mainScrollView)/2.0,15 + 24*SpacedFonts, frameWidth(_mainScrollView)/2.0 , 26*SpacedFonts) text:@"00.00" fontSize:26*SpacedFonts textColor:AppMainColor textAlignment:NSTextAlignmentCenter inView:footView];
    
    
    UILabel *lineb=  [UILabel createLabelWithFrame:frame(frameWidth(_mainScrollView)/2.0, 5, 0.5, frameHeight(footView) - 10) text:@"" fontSize:0 textColor:LineBg textAlignment:0 inView:footView];
    lineb.backgroundColor = LineBg;
    
    UILabel *line = allocAndInitWithFrame(UILabel, frame(10,CGRectGetMaxY(footView.frame) + 10, 2, 16));
    line.backgroundColor= AppMainColor;
    [_mainScrollView addSubview:line];
    
    [UILabel createLabelWithFrame:frame(16, CGRectGetMaxY(footView.frame), 4*26*SpacedFonts  , 36) text:@"我要充值" fontSize:26*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:_mainScrollView];
    
    _rechargeView = allocAndInitWithFrame(UIView, frame(0, CGRectGetMaxY(line.frame) + 10, frameWidth(_mainScrollView), APPHEIGHT - (CGRectGetMaxY(line.frame) + 10)));
    _rechargeView.backgroundColor = WhiteColor;
    [_mainScrollView addSubview:_rechargeView];
    
    UIView *_rechargeTextView = allocAndInitWithFrame(UIView, frame(30*ScreenMultiple, 18, frameWidth(_rechargeView) - 60*ScreenMultiple, 41));
    _rechargeTextView.layer.masksToBounds =YES;
    _rechargeTextView.layer.cornerRadius = 5;
    _rechargeTextView.layer.borderColor = LineBg.CGColor;
    _rechargeTextView.layer.borderWidth = 0.5;
    [_rechargeView addSubview:_rechargeTextView];
    
    _rechargeTextField = allocAndInitWithFrame(UITextField, frame(10, 0, frameWidth(_rechargeTextView) - 20, frameHeight(_rechargeTextView)));
    _rechargeTextField.placeholder = @"请输入金额";
    _rechargeTextField.delegate =self;
//    _rechargeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _rechargeTextField.textColor = BlackTitleColor;
    _rechargeTextField.font = [UIFont systemFontOfSize:26*SpacedFonts];
//    _rechargeTextField.keyboardType =UIKeyboardTypeNumberPad;
    [_rechargeTextView addSubview:_rechargeTextField];
    
    
     _rechargeLb =[UILabel createLabelWithFrame:frame(0, CGRectGetMaxY(_rechargeTextView.frame) + 13, frameWidth(_rechargeTextView), 24*SpacedFonts) text:@"本次充值需支付人民币 0.00 元" fontSize:24*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentCenter inView:_rechargeView];
    NSMutableAttributedString *_rechargeLbString =[[NSMutableAttributedString alloc]initWithString:_rechargeLb.text];
    [_rechargeLbString addAttribute:NSForegroundColorAttributeName value:AppMainColor range:[_rechargeLb.text rangeOfString:@"0.00"]];
    [_rechargeLbString addAttribute:NSFontAttributeName value:Size(28) range:[_rechargeLb.text rangeOfString:@"0.00"]];
    _rechargeLb.attributedText = _rechargeLbString;
    [_rechargeView addSubview:_rechargeLb];
    
    BaseButton *_rechargeBtn = [[BaseButton alloc]initWithFrame:frame(frameX(_rechargeTextView), CGRectGetMaxY(_rechargeLb.frame) + 30, frameWidth(_rechargeTextView), 40) setTitle:@"充值" titleSize:28*SpacedFonts titleColor:WhiteColor textAlignment:NSTextAlignmentCenter backgroundColor:AppMainColor inView:_rechargeView];
    [_rechargeBtn setRadius:8.0];
    _rechargeBtn.didClickBtnBlock = ^
    {
//        NSLog(@"ButtonActionTagRecharge");
        if ([_rechargeTextField.text floatValue]<=0.00) {
            [[ToolManager shareInstance] showInfoWithStatus:@"充值必需大于0.01（元）"];
            return;
        }
        [[WetChatPayManager shareInstance] jumpToBizPay:_rechargeTextField.text wetChatPaySucceed:^(NSString *payMoney) {
            allAmount.text = [NSString stringWithFormat:@"%.2f",[allAmount.text floatValue] + payMoney.floatValue];
            _canCarry.text =[NSString stringWithFormat:@"%.2f",[_canCarry.text floatValue] + payMoney.floatValue];
        }];
    
    };

   UILabel *_instructions = [UILabel createLabelWithFrame:frame(16, CGRectGetMaxY(_rechargeBtn.frame) +33, 4*24*SpacedFonts , 24*SpacedFonts) text:@"充值说明" fontSize:24*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:_rechargeView];
    
    
   _rechargeiInstructions = [UILabel createLabelWithFrame:frame(16, CGRectGetMaxY(_instructions.frame) + 10, frameWidth(_rechargeView) - 30 , 36) text:@"1、知脉暂时支持微信支付\n2、充值金额主要用于平台的跨界传播、跨界合作等用途\n3、充值金额自行设定\n4、红包中的金额只能用于平台中的消费（如发布跨界红包等），不能直接提现" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:_rechargeView];
    
    _rechargeiInstructions.numberOfLines = 0;
    CGSize size = [_rechargeiInstructions sizeWithMultiLineContent:_rechargeiInstructions.text rowWidth:frameWidth(_rechargeiInstructions) font:Size(24)];
    _rechargeiInstructions.frame = frame(frameX(_rechargeiInstructions), frameY(_rechargeiInstructions), frameWidth(_rechargeiInstructions), size.height);
    
    _rechargeView.frame = frame(frameX(_rechargeView), frameY(_rechargeView), frameWidth(_rechargeView), CGRectGetMaxY(_rechargeiInstructions.frame )+ 10);
    
    if (CGRectGetMaxY(_rechargeView.frame) + 10 >frameHeight(_mainScrollView)) {
       
        _mainScrollView.contentSize =CGSizeMake(frameWidth(_mainScrollView), CGRectGetMaxY(_rechargeView.frame) + 10);
    }
    
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
                    CGSize size = [_rechargeiInstructions sizeWithMultiLineContent:_rechargeiInstructions.text rowWidth:frameWidth(_rechargeiInstructions) font:Size(24)];
                    _rechargeiInstructions.frame = frame(frameX(_rechargeiInstructions), frameY(_rechargeiInstructions), frameWidth(_rechargeiInstructions), size.height);
                    
                    _rechargeView.frame = frame(frameX(_rechargeView), frameY(_rechargeView), frameWidth(_rechargeView), CGRectGetMaxY(_rechargeiInstructions.frame )+ 10);
                    
                    if (CGRectGetMaxY(_rechargeView.frame) + 10 >frameHeight(_mainScrollView)) {
                        
                       _mainScrollView.contentSize =CGSizeMake(frameWidth(_mainScrollView), CGRectGetMaxY(_rechargeView.frame) + 10);
                    }

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
#pragma mark - UITextFieldDelegete -
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{

//    
//    return YES;
//}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([text floatValue]>10000000.00) {
            [[ToolManager shareInstance] showInfoWithStatus:@"不能超过10000000元"];
            return NO;
    }
    _rechargeLb.text = [NSString stringWithFormat:@"本次充值需支付人名币 %.2f 元",[text floatValue]];
    NSMutableAttributedString *_rechargeLbString =[[NSMutableAttributedString alloc]initWithString:_rechargeLb.text];
    [_rechargeLbString addAttribute:NSForegroundColorAttributeName value:AppMainColor range:[_rechargeLb.text rangeOfString:[NSString stringWithFormat:@"%.2f",[text floatValue]]]];
        _rechargeLb.attributedText = _rechargeLbString;
    
    NSCharacterSet *cs;
    NSUInteger nDotLoc = [textField.text rangeOfString:@"."].location;
    if (NSNotFound == nDotLoc && 0 != range.location) {
        cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers] invertedSet];
    }
    else {
        cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers] invertedSet];
    }
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if (!basicTest) {
        
 
        [[ToolManager shareInstance] showInfoWithStatus:@"只能输入数字和小数点"];
        return NO;
    }
    if (NSNotFound != nDotLoc && range.location > nDotLoc + 2) {
        [[ToolManager shareInstance] showInfoWithStatus:@"小数点后最多两位"];
       
        return NO;
    }
    
    return YES;

}
#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag ==NavViewButtonActionNavLeftBtnTag ) {
        PopView(self);
    }
  
    else if (sender.tag == ButtonActionTagWithdraw)
    {
        PushView(self, allocAndInit(WithdrawalViewController));
    }
    else if (sender.tag == ButtonActionTagRecode)
    {
        PushView(self, allocAndInit(EarnestRecodeViewController));
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
