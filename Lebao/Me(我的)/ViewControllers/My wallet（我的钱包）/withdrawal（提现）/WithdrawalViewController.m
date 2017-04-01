//
//  Withdrawal ViewController.m
//  Lebao
//
//  Created by David on 16/1/26.
//  Copyright © 2016年 David. All rights reserved.
//

#import "WithdrawalViewController.h"
#import "WetChatAuthenManager.h"
#import "XLDataService.h"
#import "NSString+Extend.h"
//////// 特殊字符的限制输入，价格金额的有效性判断
#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"
#define CashURL [NSString stringWithFormat:@"%@user/cash",HttpURL]
@interface WithdrawalViewController ()<UITextFieldDelegate>

@end
typedef enum {
    
    ButtonActionTagWithdraw =2,
    ButtonActionTagChanged,
    
}ButtonActionTag;

@implementation WithdrawalViewController
{
    int poundage; //提现费率
    UIScrollView *_mainScrollView;
    UILabel *_wetchatLabel;
    UITextField *_rechargeTextField;
    BOOL isAuthen;
    NSString * amount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navView];
    [self mainView];
    
    
}

#pragma mark - Navi_View
- (void)navView
{
    [self navViewTitleAndBackBtn:@"提现" ];
    
}
#pragma mark
#pragma mark - mainView
- (void)mainView
{
    _mainScrollView = allocAndInitWithFrame(UIScrollView, frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)));
    _mainScrollView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:_mainScrollView];
    _mainScrollView.alwaysBounceVertical = YES;
    [[ToolManager shareInstance] showWithStatus];
    [XLDataService postWithUrl:CashURL param:[Parameter parameterWithSessicon] modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (dataObj) {
//            NSLog(@"提现费率dataObj  %@",dataObj);
            if ([dataObj[@"rtcode"] integerValue]==1) {
                [[ToolManager shareInstance] dismiss];
                
                isAuthen = [dataObj[@"authorize"] boolValue];
                amount = dataObj[@"amount"];
                
                _wetchatLabel = [UILabel createLabelWithFrame:frame(10, 16, frameWidth(_mainScrollView) -20, 26*SpacedFonts) text:[NSString stringWithFormat:@"提现到微信号：%@",dataObj[@"nickname"]] fontSize:26*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:_mainScrollView];
                
                //    UIButton *changedBtn = [UIButton createButtonWithfFrame:frame(frameWidth(_mainScrollView) -50, 8, 50, 30) title:@"更改" backgroundImage:nil iconImage:nil highlightImage:nil tag:ButtonActionTagChanged inView:_mainScrollView];
                //    [changedBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                //    changedBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                //    [changedBtn setTitleColor:AppMainColor forState:UIControlStateNormal];
                //    changedBtn.titleLabel.font = [UIFont systemFontOfSize:26*SpacedFonts];
                
                UIView *_rechargeView = allocAndInitWithFrame(UIView, frame(0, 38, frameWidth(_mainScrollView),70));
                _rechargeView.backgroundColor = WhiteColor;
                [_mainScrollView addSubview:_rechargeView];
                
                UIView *_rechargeTextView = allocAndInitWithFrame(UIView, frame(14*ScreenMultiple, 12, frameWidth(_rechargeView) - 28*ScreenMultiple, 47));
                _rechargeTextView.layer.masksToBounds =YES;
                _rechargeTextView.layer.cornerRadius = 5;
                _rechargeTextView.layer.borderColor = LineBg.CGColor;
                _rechargeTextView.layer.borderWidth = 0.5;
                [_rechargeView addSubview:_rechargeTextView];
                
                _rechargeTextField = allocAndInitWithFrame(UITextField, frame(10, 0, frameWidth(_rechargeTextView) - 20, frameHeight(_rechargeTextView)));
                _rechargeTextField.placeholder = @"请输入本次提现金额（最低5元，最高1000元）";
                _rechargeTextField.delegate =self;
                _rechargeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                _rechargeTextField.textColor = BlackTitleColor;
                _rechargeTextField.font = [UIFont systemFontOfSize:26*SpacedFonts];
//                _rechargeTextField.keyboardType =UIKeyboardTypeNumberPad;
                [_rechargeTextView addSubview:_rechargeTextField];
                
                poundage = [dataObj[@"poundage"] floatValue]*100;
                
                UILabel *cash =  [UILabel createLabelWithFrame:frame(0, CGRectGetMaxY(_rechargeView.frame) + 10, frameWidth(_mainScrollView) -14*ScreenMultiple, 26*SpacedFonts) text:[NSString stringWithFormat:@"可提现账户余额%@元(微信官方收取%d％的提现手续费)",dataObj[@"amount"],poundage] fontSize:26*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentRight inView:_mainScrollView];

                NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:cash.text];
                [string addAttribute:NSForegroundColorAttributeName value:AppMainColor range:[cash.text rangeOfString:dataObj[@"amount"]]];
                [string addAttribute:NSForegroundColorAttributeName value:AppMainColor range:[cash.text rangeOfString:[NSString stringWithFormat:@"(微信官方收取%d％的提现手续费)",poundage]]];
                [string addAttribute:NSFontAttributeName value:Size(20) range:[cash.text rangeOfString:[NSString stringWithFormat:@"(微信官方收取%d％的提现手续费)",poundage]]];
                cash.attributedText = string;
                
                UIButton *_rechargeBtn = [UIButton createButtonWithfFrame:frame(frameX(_rechargeTextView), CGRectGetMaxY(_rechargeView.frame) + 45, frameWidth(_rechargeTextView), 40) title:@"提现" backgroundImage:nil iconImage:nil highlightImage:nil tag:ButtonActionTagWithdraw inView:_mainScrollView];
                _rechargeBtn.backgroundColor = AppMainColor;
                _rechargeBtn.layer.masksToBounds = YES;
                _rechargeBtn.layer.cornerRadius = 8.0;
                _rechargeBtn.titleLabel.font = Size(28);
                [_rechargeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                
                UILabel *tishi =  [UILabel createLabelWithFrame:frame(frameX(_rechargeTextView), CGRectGetMaxY(_rechargeBtn.frame) + 30, frameWidth(_rechargeTextView), 40) text:@"" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:_mainScrollView];
                tishi.numberOfLines = 0;
                if (isAuthen) {
                    
                    tishi.text = [NSString stringWithFormat:@"提示:\n请确保微信昵称“%@”的实名认证信息（姓名）与知脉帐号的认证姓名（%@）一致，否则提现会失败。如提现失败，请联系知脉客服。",dataObj[@"nickname"],dataObj[@"realname"]];
                    
                    NSMutableAttributedString *tishistring = [[NSMutableAttributedString alloc]initWithString:tishi.text];
                     [tishistring addAttribute:NSForegroundColorAttributeName value:AppMainColor range:[tishi.text rangeOfString:@"姓名"]];
                    [tishistring addAttribute:NSForegroundColorAttributeName value:AppMainColor range:[tishi.text rangeOfString:dataObj[@"nickname"]]];
                    [tishistring addAttribute:NSForegroundColorAttributeName value:AppMainColor range:[tishi.text rangeOfString:dataObj[@"realname"]]];
                    [tishistring addAttribute:NSFontAttributeName value:Size(30) range:[tishi.text rangeOfString:@"提示:"]];
                    [tishistring addAttribute:NSForegroundColorAttributeName value:BlackTitleColor range:[tishi.text rangeOfString:@"提示:"]];
                    
                    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
                    [paragraphStyle1 setLineSpacing:5];
                    [tishistring addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [tishi.text length])];
                    
                    tishi.attributedText = tishistring;
                }
                else
                {
                    tishi.text = [NSString stringWithFormat:@"提示:\n1、第一次提现后自动绑定微信帐号\n2、第一次提现时，请确保您手机所登陆微信的实名认证信息（姓名）与知脉帐号的认证姓名（%@）一致，否则提现会失败。如提现失败，请联系知脉客服。",dataObj[@"realname"]];
                    
                    NSMutableAttributedString *tishistring = [[NSMutableAttributedString alloc]initWithString:tishi.text];
                    [tishistring addAttribute:NSForegroundColorAttributeName value:AppMainColor range:[tishi.text rangeOfString:@"姓名"]];
                    [tishistring addAttribute:NSForegroundColorAttributeName value:AppMainColor range:[tishi.text rangeOfString:@"第一次提现后自动绑定微信帐号"]];
                    [tishistring addAttribute:NSForegroundColorAttributeName value:AppMainColor range:[tishi.text rangeOfString:dataObj[@"realname"]]];
                    [tishistring addAttribute:NSFontAttributeName value:Size(30) range:[tishi.text rangeOfString:@"提示:"]];
                    [tishistring addAttribute:NSForegroundColorAttributeName value:BlackTitleColor range:[tishi.text rangeOfString:@"提示:"]];
                    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
                    [paragraphStyle1 setLineSpacing:5];
                    [tishistring addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [tishi.text length])];
                    tishi.attributedText = tishistring;
                }
               
                tishi.frame = CGRectMake(tishi.x, tishi.y, tishi.width, [tishi.text sizeWithFont:Size(40) maxSize:CGSizeMake(tishi.width, 1000)].height);
                
                if (CGRectGetMaxY(tishi.frame) + 10 >frameHeight(_mainScrollView)) {
                    
                    _mainScrollView.frame = frame(frameX(_mainScrollView), frameY(_mainScrollView), frameWidth(_mainScrollView), CGRectGetMaxY(tishi.frame) + 10);
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([text floatValue]>[amount floatValue]) {
        [[ToolManager shareInstance] showInfoWithStatus:[NSString stringWithFormat:@"不能超过%@元",amount]];
        return NO;
    }
    
    
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
        else if(sender.tag ==ButtonActionTagWithdraw)
    {
        if (_rechargeTextField.text.floatValue<5.00) {
            
            [[ToolManager shareInstance] showInfoWithStatus:@"提现金额不少于5.00元"];
            return;
        }
    
        float poundaged = poundage;
        
        
        [[ToolManager shareInstance] showAlertViewTitle:@"提现提醒" contentText:[NSString stringWithFormat:@"扣手续费后实际到账%@元",  [self notRounding:_rechargeTextField.text.floatValue*(1-poundaged/100) afterPoint:2]] showAlertViewBlcok:^{

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[WetChatAuthenManager shareInstance]wetChatWithdrawAuthen:isAuthen withdrawMoney:_rechargeTextField.text];
            });
            
        }];
        
    }
    
}
#pragma mark
#pragma mark - 私有方法（四舍五入问题）
-(NSString *)notRounding:(float)price afterPoint:(int)position{
//    NSLog(@"price =%f",price);
    NSString *priceStr = [NSString stringWithFormat:@"%f",price];
    NSArray *comp = [priceStr componentsSeparatedByString:@"."];
    NSString *afterPoint;
    NSString *noDoAfterPoint;
    NSString *beforePoint;
    if (comp.count>0) {
        beforePoint =comp[0];
    }
    if (comp.count>1) {
        noDoAfterPoint =comp[1];
        afterPoint = [noDoAfterPoint substringWithRange:NSMakeRange(0, 2)];
    }
   
    return  [NSString stringWithFormat:@"%@.%@",beforePoint,afterPoint];
    
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
