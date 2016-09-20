//
//  ForgetPassWordViewController.m
//  Lebao
//
//  Created by David on 15/12/1.
//  Copyright © 2015年 David. All rights reserved.
//

#import "ForgetPassWordViewController.h"
#import "XLDataService.h"
#import "NSString+Password.h"
#define sendtypeForget    @"forget"//忘记密码
#define ForgetURL [NSString stringWithFormat:@"%@site/forget",HttpURL]
#define SendcaptchaURL [NSString stringWithFormat:@"%@site/sendcaptcha",HttpURL]
@interface ForgetPassWordViewController ()

@end
typedef enum {
    
    ButtonSureActionTag  = 2,
    ButtonVerificationCodeTag,
//    ButtonActionLoginTag
  
}ButtonActionTag;

typedef enum {
    
    RequestTypeVerificationCode  = 0,
    RequestTypeSubmit     =1,
    
}RequestType;
@implementation ForgetPassWordViewController
{
    UITextField *_passWordagain;  //userName
    UITextField *_passWord;  //passWord
    UITextField *_verificationCode;  //verificationCode
    UIButton    *_verificationCodeBtn; //verificationCodeBtn
    
    NSTimer *_timer; //倒计时
    int _seconds;
    
    UIScrollView *mainScrollView;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navViewTitleAndBackBtn:@"找回密码"];
    [self mainView];
}

#pragma mark - mainView
-(void)mainView{
    
    mainScrollView =allocAndInitWithFrame(UIScrollView, frame(0, StatusBarHeight+NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight+NavigationBarHeight)));
    mainScrollView.alwaysBounceVertical = YES;
    mainScrollView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:mainScrollView];
    
    [UILabel createLabelWithFrame:frame(0, 0, APPWIDTH, 55) text:@"我们已经发送验证码短信到这个号码" fontSize:26*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:mainScrollView];
    
     [UILabel createLabelWithFrame:frame(0, 55, APPWIDTH, 26*SpacedFonts) text:_phoneNum fontSize:26*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentCenter inView:mainScrollView];
    
    float cellHeight = 58;
    float cellX = 23;
    float textFieldX =72;
    float bH = 27;
    
    _verificationCode = allocAndInitWithFrame(UITextField, frame(textFieldX, 100, frameWidth(self.view) - 2*textFieldX  -90, cellHeight -bH ));
    
    _verificationCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    _verificationCode.placeholder = @"请输入验证码";
    _verificationCode.keyboardType = UIKeyboardTypeNumberPad;
    _verificationCode.font = [UIFont systemFontOfSize:26.0*SpacedFonts];
    _verificationCode.textColor =BlackTitleColor;
    _verificationCode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName: LightBlackTitleColor}];
    [mainScrollView addSubview:_verificationCode];
    
    UIImage *passWordImage =[UIImage imageNamed:@"iconfont-mima"];
    UIView *passWordView = allocAndInitWithFrame(UIView , frame(cellX, frameY(_verificationCode), 50, frameHeight(_verificationCode)));
    UIImageView *passWordImageView =allocAndInitWithFrame(UIImageView, frame(18, (frameHeight(passWordView) -passWordImage.size.height)/2.0 , passWordImage.size.width, passWordImage.size.height));
    passWordImageView.image =passWordImage;
    [passWordView addSubview:passWordImageView] ;
    [mainScrollView addSubview:passWordView];
    
    UILabel *line1 = allocAndInitWithFrame(UILabel, frame(cellX, CGRectGetMaxY(_verificationCode.frame), frameWidth(self.view) - 2*cellX, 0.5));
    line1.backgroundColor = LineBg;
    [mainScrollView addSubview:line1];
    
    _verificationCodeBtn = allocAndInitWithFrame(UIButton, frame(APPWIDTH - cellX - 90*ScreenMultiple , frameY(_verificationCode) - 5, 80*ScreenMultiple, 30));
    _verificationCodeBtn.backgroundColor = AppMainColor;
    [_verificationCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    [_verificationCodeBtn setTitleColor:WhiteColor  forState:UIControlStateNormal];
    _verificationCodeBtn.titleLabel.font = _verificationCode.font;
    _verificationCodeBtn.tag = ButtonVerificationCodeTag;
    [_verificationCodeBtn setRadius:frameHeight(_verificationCodeBtn)/2.0];
    [_verificationCodeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
     [self uncannyClicker];
    
    [mainScrollView addSubview:_verificationCodeBtn];
    
    //passWord
    
    _passWord = allocAndInitWithFrame(UITextField, frame(frameX(_verificationCode), CGRectGetMaxY(line1.frame) + bH, frameWidth(self.view) - 2*textFieldX, frameHeight(_verificationCode)));
    _passWord.placeholder = @"请输入新密码";
    _passWord.font = _verificationCode.font;
    _passWord.secureTextEntry = YES;
    _passWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passWord.textColor =_verificationCode.textColor;
    _passWord.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入新密码" attributes:@{NSForegroundColorAttributeName: LightBlackTitleColor}];
    [mainScrollView addSubview:_passWord];
    
    UIView *_passWordleftView = allocAndInitWithFrame(UIView , frame(cellX, frameY(_passWord), 50, frameHeight(_passWord)));
    UIImageView *_passWordImageView =allocAndInitWithFrame(UIImageView, frame(18, (frameHeight(passWordView) -passWordImage.size.height)/2.0 , passWordImage.size.width, passWordImage.size.height));
   _passWordImageView.image =passWordImage;
    [_passWordleftView addSubview:_passWordImageView] ;
    [mainScrollView addSubview:_passWordleftView];
    
    UILabel *line2 = allocAndInitWithFrame(UILabel, frame(cellX,CGRectGetMaxY(_passWord.frame), frameWidth(self.view) - 2*cellX, 0.5));
    line2.backgroundColor = line1.backgroundColor;
    [mainScrollView addSubview:line2];
    
    
    //    _verificationCodeBtn
    
    _passWordagain = allocAndInitWithFrame(UITextField, frame(frameX(_passWord), CGRectGetMaxY(line2.frame) + bH , frameWidth(_passWord), frameHeight(_passWord)));
    _passWordagain.placeholder = @"请再一次输入新密码";
    _passWordagain.secureTextEntry = YES;
    _passWordagain.font = _verificationCode.font;
    _passWordagain.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passWordagain.textColor =_verificationCode.textColor;
    _passWordagain.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请再一次输入新密码" attributes:@{NSForegroundColorAttributeName: LightBlackTitleColor}];
    
    [mainScrollView addSubview:_passWordagain];
    
    UIView *_verificationleftView = allocAndInitWithFrame(UIView , frame(cellX, frameY(_passWordagain), 50, frameHeight(_passWordagain)));
    UIImageView *_verificationImageView =allocAndInitWithFrame(UIImageView, frame(18, (frameHeight(passWordView) -passWordImage.size.height)/2.0 , passWordImage.size.width, passWordImage.size.height));
    _verificationImageView.image =passWordImage;
    [_verificationleftView addSubview:_verificationImageView] ;
    [mainScrollView addSubview:_verificationleftView];
    
    
    UILabel *line3 = allocAndInitWithFrame(UILabel, frame(cellX,CGRectGetMaxY(_passWordagain.frame) , frameWidth(self.view) - 2*cellX , 0.5));
    line3.backgroundColor = line1.backgroundColor;
    [mainScrollView addSubview:line3];

    UIButton *succeed = [UIButton createButtonWithfFrame:frame(cellX, CGRectGetMaxY(line3.frame) + 40*ScreenMultiple, frameWidth(line3), 40) title:nil backgroundImage:nil iconImage:nil highlightImage:nil tag:ButtonSureActionTag];
    succeed.backgroundColor =AppMainColor;
    succeed.layer.cornerRadius = frameHeight(succeed)/2.0;
    [succeed setTitle:@"完成" forState:UIControlStateNormal];
    succeed.titleLabel.font =[UIFont systemFontOfSize:32.0*SpacedFonts];
    [succeed addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [mainScrollView addSubview:succeed];
    
    
    if (CGRectGetMaxY(succeed.frame) + 10 > frameHeight(mainScrollView)) {
        mainScrollView.contentSize = CGSizeMake(frameWidth(mainScrollView), CGRectGetMaxY(succeed.frame) + 10);
        
        
    }

}
#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
     if (sender.tag ==0)
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
    else if (sender.tag ==ButtonVerificationCodeTag)
    {
       
       
        [[ToolManager shareInstance] showWithStatus:@"发起短信验证"];
        NSMutableDictionary * sendcaptchaParam = allocAndInit(NSMutableDictionary);
        [sendcaptchaParam setObject:_phoneNum forKey:userName];
        [sendcaptchaParam setObject:sendtypeForget forKey:sendType];
        
        [XLDataService postWithUrl:SendcaptchaURL param:sendcaptchaParam modelClass:nil responseBlock:^(id dataObj, NSError *error) {
            DDLog(@"dataObj =%@",dataObj);
            
            if (error) {
                [self timeOut];
                [[ToolManager shareInstance] showInfoWithStatus];
            }
            
            [self dealWithCode:dataObj type:RequestTypeVerificationCode];
        }];

    }
    else if (sender.tag == ButtonSureActionTag)
    {
    
        
        if (_verificationCode.text.length==0) {
            [[ToolManager shareInstance] showInfoWithStatus:@"验证码有误！"];
            
            return;
        }
        if (_passWord.text.length<
            6) {
            [[ToolManager shareInstance] showInfoWithStatus:@"请输入大于6位密码！"];
            
            return;
        }
        if (![_passWordagain.text isEqualToString:_passWord.text]) {
            [[ToolManager shareInstance] showInfoWithStatus:@"两次密码不同！"];
            
            return;
        }
        
        [[ToolManager shareInstance] showWithStatus:@"确认..."];
        NSMutableDictionary * sendcaptchaParam = allocAndInit(NSMutableDictionary);
    
        [sendcaptchaParam setObject:_phoneNum forKey:userName];
        [sendcaptchaParam setObject:[_passWord.text md5]   forKey:newpassword];
        [sendcaptchaParam setObject:_verificationCode.text forKey:captchaCode];
        [XLDataService postWithUrl:ForgetURL param:sendcaptchaParam modelClass:nil responseBlock:^(id dataObj, NSError *error) {
            DDLog(@"dataObj =%@",dataObj);
             [self timeOut];
            if (error) {
                
                [[ToolManager shareInstance] showInfoWithStatus];
            }
            [self dealWithCode:dataObj type:RequestTypeSubmit];
        }];
        
    }

    
}
#pragma mark
#pragma mark 验证
- (void)dealWithCode:(id)dataObj type:(int)type
{
    if (dataObj) {
        NSDictionary *msg = (NSDictionary *)dataObj;
        
        switch ([msg[@"rtcode"] integerValue]) {
            case 1:
                if (type == RequestTypeSubmit) {
                    
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([NSStringFromClass([controller class]) isEqualToString:@"LoginViewController"]) {
                            [self.navigationController popToViewController:controller animated:NO];
                        }
                        
                    }

                    [[ToolManager shareInstance] showSuccessWithStatus:@"密码重置成功！"];
                }
                else
                {
                    [[ToolManager shareInstance] showInfoWithStatus:@"验证码已发，请查收！"];
                    [self uncannyClicker];
                }
                break;
            default:
                [self timeOut];
                [[ToolManager shareInstance] showInfoWithStatus:msg[@"rtmsg"]];
            break;
        }
    }
    
}
#pragma mark
#pragma mark 验证码为灰色不可点击效果
- (void)uncannyClicker
{
    _seconds = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [_timer fire];
    _verificationCodeBtn.userInteractionEnabled=NO;
    _verificationCodeBtn.alpha=0.4;
    [_verificationCodeBtn setTitle:[NSString stringWithFormat:@"%i秒",_seconds] forState:UIControlStateNormal];
}
#pragma mark
#pragma mark - count down-
- (void)countDown
{
    _seconds --;
    if (_seconds>=0) {
        [_verificationCodeBtn setTitle:[NSString stringWithFormat:@"%i秒",_seconds] forState:UIControlStateNormal];
    }
    else
    {
        
        [self timeOut];
    }
    
}
#pragma mark
#pragma mark - Time out
- (void)timeOut
{
    [_timer invalidate];
    _seconds = 60;
    _verificationCodeBtn.userInteractionEnabled=YES;
    _verificationCodeBtn.alpha=1.0;
    [_verificationCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
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
