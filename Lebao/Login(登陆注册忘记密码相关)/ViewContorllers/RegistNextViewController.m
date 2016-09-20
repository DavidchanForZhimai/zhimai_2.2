//
//  RegistNextViewController.m
//  Lebao
//
//  Created by David on 16/4/19.
//  Copyright © 2016年 David. All rights reserved.
//

#import "RegistNextViewController.h"
#import "RegistFinishViewController.h"
#import "XLDataService.h"
#define sendtypeRegister  @"register"//注册
#define SendcaptchaURL [NSString stringWithFormat:@"%@site/sendcaptcha",HttpURL]
@interface RegistNextViewController ()

@end
typedef enum {
    
    ButtonVerificationCodeTag =2,

    
}ButtonActionTag;

typedef enum {
    
    RequestTypeVerificationCode  = 0,
  
    
}RequestType;
@implementation RegistNextViewController
{
 
    UITextField *_verificationCode;  //verificationCode
    UIButton    *_verificationCodeBtn; //verificationCodeBtn
    
    NSTimer *_timer; //倒计时
    int _seconds;
    
    UIScrollView *mainScrollView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navViewTitleAndBackBtn:@"注册"];
   
    
    BaseButton *next = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 60, StatusBarHeight, 60, NavigationBarHeight) setTitle:@"下一步" titleSize:28*SpacedFonts titleColor:BlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] inView:self.view];
    
    __weak RegistNextViewController *weakSelf = self;
    next.didClickBtnBlock = ^{
        if (_verificationCode.text.length==0) {
            [[ToolManager shareInstance] showInfoWithStatus:@"验证码有误！"];
            
            return;
        }
        
        RegistFinishViewController *finish = allocAndInit(RegistFinishViewController);
        finish.invCode = weakSelf.invCode;
        finish.verCode = _verificationCode.text;
        finish.password = weakSelf.password;
        finish.phoneNum = weakSelf.phoneNum;
        [weakSelf.navigationController pushViewController:finish animated:NO];
        
    };

   

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
        [sendcaptchaParam setObject:sendtypeRegister forKey:sendType];
        
        [XLDataService postWithUrl:SendcaptchaURL param:sendcaptchaParam modelClass:nil responseBlock:^(id dataObj, NSError *error) {
            DDLog(@"dataObj =%@",dataObj);
            
            if (error) {
                [self timeOut];
                [[ToolManager shareInstance] showInfoWithStatus];
            }
            
            [self dealWithCode:dataObj type:RequestTypeVerificationCode];
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
                
                [[ToolManager shareInstance] showInfoWithStatus:@"验证码已发，请查收！"];
                [self uncannyClicker];
                
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
