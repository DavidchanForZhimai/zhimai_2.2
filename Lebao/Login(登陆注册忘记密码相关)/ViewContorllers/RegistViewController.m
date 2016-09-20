//
//  RegistViewController.m
//  Lebao
//
//  Created by David on 15/12/1.
//  Copyright © 2015年 David. All rights reserved.
//

#import "RegistViewController.h"
#import "LoginViewController.h"
#import "XLDataService.h"
#import "M80AttributedLabel.h"
#import "RegistNextViewController.h"
#define sendtypeRegister    @"register"//忘记密码
#define SendcaptchaURL [NSString stringWithFormat:@"%@site/sendcaptcha",HttpURL]
@interface RegistViewController ()<M80AttributedLabelDelegate>

@end
typedef enum {
    
    ButtonSubmitActionTag  = 2,
//    ButtonVerificationCodeTag,
//    ButtonActionLoginTag,
//    ButtonActionSelectedTag,
   
}ButtonActionTag;

typedef enum {
    
//    RequestTypeVerificationCode  = 0,
    RequestTypeSubmit     =1,
   
}RequestType;
@implementation RegistViewController
{
    
    UITextField *_userName;  //userName
    UITextField *_passWord;  //passWord
    UITextField *_verificationCode;  //verificationCode
//    UIButton    *_verificationCodeBtn; //verificationCodeBtn
    
//    NSTimer *_timer; //倒计时
//    int _seconds;
    
    UIScrollView *mainScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    [self navViewTitleAndBackBtn:@"注册"];
    [self mainView];
    
}
#pragma mark - mainView
-(void)mainView{
   
    mainScrollView =allocAndInitWithFrame(UIScrollView, frame(0, StatusBarHeight+NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight+NavigationBarHeight)));
    mainScrollView.alwaysBounceVertical = YES;
    mainScrollView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:mainScrollView];
    
    float cellHeight = 58;
    float cellX = 23;
    float textFieldX =72;
    float bH = 27;
    
    _userName = allocAndInitWithFrame(UITextField, frame(textFieldX, bH, frameWidth(self.view) - 2*textFieldX, cellHeight -bH ));
    
    _userName.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userName.placeholder = @"请输入手机号";
    _userName.keyboardType = UIKeyboardTypeNumberPad;
    _userName.font = [UIFont systemFontOfSize:26.0*SpacedFonts];
    _userName.textColor =BlackTitleColor;
    _userName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName: LightBlackTitleColor}];
    [mainScrollView addSubview:_userName];
    
    UIImage *_userNameImage =[UIImage imageNamed:@"iconfont-shouji"];
    UIView *_userNameleftView = allocAndInitWithFrame(UIView , frame(cellX, frameY(_userName), 50, frameHeight(_userName)));
    UIImageView *_userNameleftImageView =allocAndInitWithFrame(UIImageView, frame(18, (frameHeight(_userName) -_userNameImage.size.height)/2.0 , _userNameImage.size.width, _userNameImage.size.height));
    _userNameleftImageView.image =_userNameImage;
    [_userNameleftView addSubview:_userNameleftImageView] ;
    [mainScrollView addSubview:_userNameleftView];
    

    UILabel *line1 = allocAndInitWithFrame(UILabel, frame(cellX, cellHeight, frameWidth(self.view) - 2*cellX, 0.5));
    line1.backgroundColor = LineBg;
    [mainScrollView addSubview:line1];
    
    //passWord
    
    _passWord = allocAndInitWithFrame(UITextField, frame(frameX(_userName), CGRectGetMaxY(_userName.frame) + bH, frameWidth(_userName), frameHeight(_userName)));
    _passWord.placeholder = @"请输入密码";
    _passWord.font = _userName.font;
    _passWord.secureTextEntry = YES;
    _passWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passWord.textColor =_userName.textColor;
    _passWord.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName: LightBlackTitleColor}];
    [mainScrollView addSubview:_passWord];
    
    UIImage *_passWordImage =[UIImage imageNamed:@"iconfont-mima"];
    UIView *_passWordleftView = allocAndInitWithFrame(UIView , frame(cellX, frameY(_passWord), 50, frameHeight(_passWord)));
    UIImageView *_passWordleftImageView =allocAndInitWithFrame(UIImageView, frame(18, (frameHeight(_passWord) -_passWordImage.size.height)/2.0 , _passWordImage.size.width, _passWordImage.size.height));
    _passWordleftImageView.image =_passWordImage;
    [_passWordleftView addSubview:_passWordleftImageView] ;
    [mainScrollView addSubview:_passWordleftView];
    
    
    UILabel *line2 = allocAndInitWithFrame(UILabel, frame(cellX,CGRectGetMaxY(_passWord.frame), frameWidth(self.view) - 2*cellX, 0.5));
    line2.backgroundColor = line1.backgroundColor;
    [mainScrollView addSubview:line2];

    
//    _verificationCodeBtn
    
    _verificationCode = allocAndInitWithFrame(UITextField, frame(frameX(_userName), CGRectGetMaxY(line2.frame) + bH , frameWidth(_userName) - 50, frameHeight(_userName)));
    _verificationCode.placeholder = @"如有邀请码请输入";
    _verificationCode.keyboardType = UIKeyboardTypeNumberPad;
    _verificationCode.font = _userName.font;
    _verificationCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    _verificationCode.textColor =_userName.textColor;
    _verificationCode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"如有邀请码请输入" attributes:@{NSForegroundColorAttributeName: LightBlackTitleColor}];

    [mainScrollView addSubview:_verificationCode];
    
    UIImage *_verificationImage =[UIImage imageNamed:@"iconfont-yaoqinghaoyou"];
    UIView *_verificationleftView = allocAndInitWithFrame(UIView , frame(cellX, frameY(_verificationCode), 50, frameHeight(_verificationCode)));
    UIImageView *_verificationleftImageView =allocAndInitWithFrame(UIImageView, frame(18, (frameHeight(_verificationCode) -_verificationImage.size.height)/2.0 , _verificationImage.size.width, _verificationImage.size.height));
    _verificationleftImageView.image =_verificationImage;
    [_verificationleftView addSubview:_verificationleftImageView] ;
    [mainScrollView addSubview:_verificationleftView];
    
    
    UILabel *line3 = allocAndInitWithFrame(UILabel, frame(cellX,CGRectGetMaxY(_verificationCode.frame) , frameWidth(self.view) - 2*cellX , 0.5));
    line3.backgroundColor = line1.backgroundColor;
    [mainScrollView addSubview:line3];
    
    BaseButton *_invitation = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 110, frameY(_verificationCode), 110, frameHeight(_verificationCode)) setTitle:@"了解邀请码" titleSize:26*SpacedFonts titleColor:AppMainColor textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] inView:mainScrollView];
    _invitation.didClickBtnBlock = ^
    {
        [[ToolManager shareInstance] showAlertViewTitle:@"什么是邀请码?" contentText:@"每个手机号码注册成功后，系统会随机生成唯一的邀请码。填写邀请码有什么好处?\n1.可以互相提升活跃值。\n2.后续的推广奖励模式举例：B通过A的邀请码注册，B开通了会员，A可以获得奖励；C通过B的邀请码注册，C开通了会员，B能获 得奖励，A同时也能获得奖励。\n3.在使用过程中，可以向邀请人请教" showAlertViewBlcok:^{
            
        }];
    };

    
    UIButton *registBn = [UIButton createButtonWithfFrame:frame(cellX, CGRectGetMaxY(line3.frame) + 40*ScreenMultiple, frameWidth(line2), 40) title:nil backgroundImage:nil iconImage:nil highlightImage:nil tag:ButtonSubmitActionTag];
    registBn.backgroundColor = AppMainColor;
    registBn.layer.cornerRadius = frameHeight(registBn)/2.0;
    [registBn setTitle:@"注册" forState:UIControlStateNormal];
    registBn.titleLabel.font =[UIFont systemFontOfSize:32.0*SpacedFonts];
    [registBn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [mainScrollView addSubview:registBn];
    
    M80AttributedLabel *userAgreement= [[M80AttributedLabel alloc]initWithFrame:CGRectZero];
    userAgreement.textColor =BlackTitleColor;
    userAgreement.font = Size(24);
    userAgreement.backgroundColor = [UIColor clearColor];
    userAgreement.linkColor =AppMainColor;
    userAgreement.underLineForLink = NO;
    userAgreement.text =@"点击“注册表示您同意《用户注册协议》";
    NSRange range   = [@"点击“注册表示您同意《用户注册协议》" rangeOfString:@"《用户注册协议》"];
    [userAgreement addCustomLink:[NSValue valueWithRange:range]
              forRange:range];
    userAgreement.frame =frame(frameX(registBn), CGRectGetMaxY(registBn.frame) + 10, APPWIDTH - 2*frameX(registBn), 30);
    userAgreement.delegate = self;
    userAgreement.textAlignment = NSTextAlignmentCenter;
    [mainScrollView  addSubview:userAgreement];
    
//    UIButton *userAgreement = allocAndInitWithFrame(UIButton, frame(frameX(registBn), CGRectGetMaxY(registBn.frame), frameWidth(registBn), frameHeight(registBn)));
//    [userAgreement setTitle:@"已有账号直接登录？" forState:UIControlStateNormal];
//    userAgreement.titleLabel.font =[UIFont systemFontOfSize:22.0*SpacedFonts];
//    [userAgreement setTitleColor:WhiteColor forState:UIControlStateNormal];
//    userAgreement.tag = ButtonActionLoginTag;
//    [userAgreement addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [mainScrollView addSubview:userAgreement];

   
    if (CGRectGetMaxY(userAgreement.frame) + 10 > frameHeight(mainScrollView)) {
        mainScrollView.contentSize = CGSizeMake(frameWidth(mainScrollView), CGRectGetMaxY(userAgreement.frame) + 10);
    
    }
    
    
}
#pragma mark
#pragma mark - M80 Delegate
- (void)m80AttributedLabel:(M80AttributedLabel *)label clickedOnLink:(id)linkData
{
//    NSLog(@"linkData=%@",linkData);
}
#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag == 0)
    {
        
        [self.navigationController popViewControllerAnimated:NO];
    }
    else if (sender.tag == ButtonSubmitActionTag)
    {
       
        if (_userName.text.length!=11) {
            [[ToolManager shareInstance] showInfoWithStatus:@"手机号码有误！"];
            
            return;
        }
        
        if (_passWord.text.length<
            6) {
            [[ToolManager shareInstance] showInfoWithStatus:@"请输入大于6位密码！"];
            
            return;
        }
        
        [[ToolManager shareInstance] showWithStatus:@"发起短信验证"];
         NSMutableDictionary * sendcaptchaParam = allocAndInit(NSMutableDictionary);
        [sendcaptchaParam setObject:_userName.text forKey:userName];
        [sendcaptchaParam setObject:sendtypeRegister forKey:sendType];
        
        [XLDataService postWithUrl:SendcaptchaURL param:sendcaptchaParam modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        
            if (error) {
            [[ToolManager shareInstance] showInfoWithStatus];
            }
            
            [self dealWithCode:dataObj type:0];
            
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
            [[ToolManager shareInstance] dismiss];
            { RegistNextViewController *next = allocAndInit(RegistNextViewController);
                next.phoneNum = _userName.text;
                next.password = _passWord.text;
                next.invCode = _verificationCode.text;
                PushView(self, next);
            }
                break;
            default:
                
                [[ToolManager shareInstance] showInfoWithStatus:msg[@"rtmsg"]];
                break;
        }
    }
    
}
#pragma mark
#pragma mark 验证码为灰色不可点击效果

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
