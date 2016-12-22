//
//  RechargeViewController.m
//  Lebao
//
//  Created by David on 2016/12/22.
//  Copyright © 2016年 David. All rights reserved.
//

#import "RechargeViewController.h"
#import "WetChatPayManager.h"
#import "XLDataService.h"
#define WalletURL [NSString stringWithFormat:@"%@user/wallet",HttpURL]
//////// 特殊字符的限制输入，价格金额的有效性判断
#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"
@interface RechargeViewController ()<UITextFieldDelegate>


@end

@implementation RechargeViewController
{
    UILabel *_rechargeLb;
    UITextField *_rechargeTextField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navViewTitleAndBackBtn:@"充值"];

    UIView *_rechargeTextView = allocAndInitWithFrame(UIView, frame(15*ScreenMultiple, StatusBarHeight + NavigationBarHeight+10, APPWIDTH - 30*ScreenMultiple, 47));
    _rechargeTextView.backgroundColor = WhiteColor;
    _rechargeTextView.layer.masksToBounds =YES;
    _rechargeTextView.layer.cornerRadius = 5;
    _rechargeTextView.layer.borderColor = LineBg.CGColor;
    _rechargeTextView.layer.borderWidth = 0.5;
    [self.view addSubview:_rechargeTextView];
    
    _rechargeTextField = allocAndInitWithFrame(UITextField, frame(10, 0, frameWidth(_rechargeTextView) - 20, frameHeight(_rechargeTextView)));
    _rechargeTextField.placeholder = @"请输入要充值的金额";
    _rechargeTextField.delegate =self;
    _rechargeTextField.textColor = BlackTitleColor;
    _rechargeTextField.font = [UIFont systemFontOfSize:30*SpacedFonts];
    [_rechargeTextView addSubview:_rechargeTextField];
    
    
    _rechargeLb =[UILabel createLabelWithFrame:frame(_rechargeTextView.x, CGRectGetMaxY(_rechargeTextView.frame), frameWidth(_rechargeTextView), 35) text:@"本次充值需支付人民币 0.00 元" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentCenter inView:self.view];
    NSMutableAttributedString *_rechargeLbString =[[NSMutableAttributedString alloc]initWithString:_rechargeLb.text];
    [_rechargeLbString addAttribute:NSForegroundColorAttributeName value:AppMainColor range:[_rechargeLb.text rangeOfString:@"0.00 元"]];
   
    _rechargeLb.attributedText = _rechargeLbString;
    [self.view addSubview:_rechargeLb];
    
    BaseButton *_rechargeBtn = [[BaseButton alloc]initWithFrame:frame(frameX(_rechargeTextView), CGRectGetMaxY(_rechargeLb.frame) + 10, frameWidth(_rechargeTextView), 40) setTitle:@"充值" titleSize:28*SpacedFonts titleColor:WhiteColor textAlignment:NSTextAlignmentCenter backgroundColor:AppMainColor inView:self.view];
    [_rechargeBtn setRadius:8.0];
    __weak typeof(self) weakSelf = self;
    _rechargeBtn.didClickBtnBlock = ^
    {

        if ([_rechargeTextField.text floatValue]<=0.00) {
            [[ToolManager shareInstance] showInfoWithStatus:@"充值必需大于0.01（元）"];
            return;
        }
        [[WetChatPayManager shareInstance] jumpToBizPay:_rechargeTextField.text wetChatPaySucceed:^(NSString *payMoney) {
            if (weakSelf.moneyPayCallBack) {
                weakSelf.moneyPayCallBack(payMoney.floatValue);
            }
            
        }];
        
    };

}
#pragma mark
#pragma mark - UITextFieldDelegete -

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([text floatValue]>10000000.00) {
        [[ToolManager shareInstance] showInfoWithStatus:@"不能超过10000000元"];
        return NO;
    }
    _rechargeLb.text = [NSString stringWithFormat:@"本次充值需支付人名币 %.2f 元",[text floatValue]];
    NSMutableAttributedString *_rechargeLbString =[[NSMutableAttributedString alloc]initWithString:_rechargeLb.text];
    [_rechargeLbString addAttribute:NSForegroundColorAttributeName value:AppMainColor range:[_rechargeLb.text rangeOfString:[NSString stringWithFormat:@"%.2f 元",[text floatValue]]]];
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
