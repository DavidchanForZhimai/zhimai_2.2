//
//  LoginViewController.m
//  Lebao
//
//  Created by David on 15/11/30.
//  Copyright © 2015年 David. All rights reserved.
//

#import "LoginViewController.h"
#import "NSString+Password.h"
#import "ForgetPasswordBeforeViewController.h"
#import "XLDataService.h"
#import "CoreArchive.h"
#import "BPush.h"
#define LoginURL [NSString stringWithFormat:@"%@site/login",HttpURL]
#define rememberPassWord  @"rememberPassWord"
#define rememberUserName  @"rememberUserName"
#define isremember @"isRemember"
@interface LoginViewController ()
@property(nonatomic,strong)BaseButton * remember;
@property(nonatomic,assign)int  isRemember;
@property(nonatomic,strong)UITextField *userNametext;
@property(nonatomic,strong)UITextField *passWordtext;
@end
typedef enum {
    
  ButtonLoginActionTag  = 2,
  ButtonForgetActionTag,
//  ButtonRegirstActionTag

    
}ButtonActionTag;

@implementation LoginViewController{

    
    UIScrollView *mainScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navViewTitleAndBackBtn:@"登录"];
    [self mainView];
}
#pragma mark - mainView
-(void)mainView{
    
    mainScrollView =allocAndInitWithFrame(UIScrollView, frame(0, StatusBarHeight+ NavigationBarHeight  , APPWIDTH, APPHEIGHT - (StatusBarHeight+ NavigationBarHeight)));
    mainScrollView.alwaysBounceVertical = YES;
    mainScrollView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:mainScrollView];
    
    float cellHeight = 58;
    float cellX = 23;
    float textFieldX =72;
    float bH = 27;
    
    _userNametext = allocAndInitWithFrame(UITextField, frame(textFieldX, bH, frameWidth(self.view) - 2*textFieldX, cellHeight -bH ));
    
    _userNametext.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userNametext.placeholder = @"请输入手机号";
    _userNametext.keyboardType = UIKeyboardTypeNumberPad;
    _userNametext.font = [UIFont systemFontOfSize:26.0*SpacedFonts];
    _userNametext.textColor =BlackTitleColor;
    if ([CoreArchive strForKey:rememberUserName]) {
        _userNametext.text = [CoreArchive strForKey:rememberUserName];
    };
    _userNametext.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName: LightBlackTitleColor}];
    [mainScrollView addSubview:_userNametext];
    
    UIImage *_userNameImage =[UIImage imageNamed:@"iconfont-shouji"];
    UIView *_userNameleftView = allocAndInitWithFrame(UIView , frame(cellX, frameY(_userNametext), 50, frameHeight(_userNametext)));
    UIImageView *_userNameleftImageView =allocAndInitWithFrame(UIImageView, frame(18, (frameHeight(_userNametext) -_userNameImage.size.height)/2.0 , _userNameImage.size.width, _userNameImage.size.height));
    _userNameleftImageView.image =_userNameImage;
    [_userNameleftView addSubview:_userNameleftImageView] ;
    [mainScrollView addSubview:_userNameleftView];
    
    
    UILabel *line1 = allocAndInitWithFrame(UILabel, frame(cellX, cellHeight, frameWidth(self.view) - 2*cellX, 0.5));
    line1.backgroundColor = LineBg;
    [mainScrollView addSubview:line1];
    
    //passWord
    
    _passWordtext = allocAndInitWithFrame(UITextField, frame(frameX(_userNametext), CGRectGetMaxY(_userNametext.frame) + bH, frameWidth(_userNametext), frameHeight(_userNametext)));
    _passWordtext.placeholder = @"请输入密码";
    _passWordtext.font = _userNametext.font;
    _passWordtext.secureTextEntry = YES;
    _passWordtext.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passWordtext.textColor =_userNametext.textColor;
    if ([CoreArchive strForKey:rememberPassWord]) {
        _passWordtext.text = [CoreArchive strForKey:rememberPassWord];
    }

    _passWordtext.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName: LightBlackTitleColor}];
    [mainScrollView addSubview:_passWordtext];
    
    UIImage *_passWordImage =[UIImage imageNamed:@"iconfont-mima"];
    UIView *_passWordleftView = allocAndInitWithFrame(UIView , frame(cellX, frameY(_passWordtext), 50, frameHeight(_passWordtext)));
    UIImageView *_passWordleftImageView =allocAndInitWithFrame(UIImageView, frame(18, (frameHeight(_passWordtext) -_passWordImage.size.height)/2.0 , _passWordImage.size.width, _passWordImage.size.height));
    _passWordleftImageView.image =_passWordImage;
    [_passWordleftView addSubview:_passWordleftImageView] ;
    [mainScrollView addSubview:_passWordleftView];
    
    
    UILabel *line2 = allocAndInitWithFrame(UILabel, frame(cellX ,CGRectGetMaxY(_passWordtext.frame), frameWidth(self.view) - 2*cellX, 0.5));
    line2.backgroundColor = line1.backgroundColor;
    [mainScrollView addSubview:line2];
    
    
    UIImage *iconImage = [UIImage imageNamed:@"xuanzheweixuanzhong"];
    UIImage *highlightImage = [UIImage imageNamed:@"xuanzhexuanzhong"];
    
    float rememberW = 88*SpacedFonts + iconImage.size.width + 5;
    float rememberH = iconImage.size.height;
    
    __weak typeof(self) weakSelf = self;
    _remember = [[BaseButton alloc]initWithFrame:frame(cellX + frameX(_passWordleftImageView) , CGRectGetMaxY(line2.frame) + 15, rememberW, rememberH) setTitle:@"记住密码" titleSize:22*SpacedFonts titleColor:BlackTitleColor backgroundImage:nil iconImage:iconImage highlightImage:highlightImage setTitleOrgin:CGPointMake((rememberH -22*SpacedFonts)/2.0 , 5) setImageOrgin:CGPointMake(0 , 0) inView:mainScrollView];
    _remember.titleLabel.textAlignment = NSTextAlignmentCenter;
    _remember.shouldAnmial = NO;
    if ([CoreArchive boolForKey:isremember]) {
        [weakSelf.remember setImage:highlightImage forState:UIControlStateNormal];
        [weakSelf.remember setImage:iconImage forState:UIControlStateHighlighted];
        
        
    }
    else
    {
        [weakSelf.remember setImage:iconImage forState:UIControlStateNormal];
        [weakSelf.remember setImage:highlightImage forState:UIControlStateHighlighted];
        
    }

    _remember.didClickBtnBlock = ^
    {
        if (!weakSelf.isRemember) {
            [weakSelf.remember setImage:highlightImage forState:UIControlStateNormal];
            [weakSelf.remember setImage:iconImage forState:UIControlStateHighlighted];
            
            
        }
        else
        {
            [weakSelf.remember setImage:iconImage forState:UIControlStateNormal];
            [weakSelf.remember setImage:highlightImage forState:UIControlStateHighlighted];
            
        }
        weakSelf.isRemember = !weakSelf.isRemember;
        
    };


    
    UIButton *loginBn = [UIButton createButtonWithfFrame:frame(cellX, CGRectGetMaxY(line2.frame) + 50*ScreenMultiple, frameWidth(line2), 40) title:nil backgroundImage:nil iconImage:nil highlightImage:nil tag:ButtonLoginActionTag];
    loginBn.backgroundColor = AppMainColor;
    loginBn.layer.cornerRadius = frameHeight(loginBn)/2.0;
    [loginBn setTitle:@"登录" forState:UIControlStateNormal];
    loginBn.titleLabel.font =[UIFont systemFontOfSize:32.0*SpacedFonts];
    [loginBn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [mainScrollView addSubview:loginBn];
    
    
   
    
    UIButton *userforgetpassword = allocAndInitWithFrame(UIButton, frame(frameWidth(loginBn) - 72*ScreenMultiple, CGRectGetMaxY(loginBn.frame), 72*ScreenMultiple, frameHeight(loginBn)));
    [userforgetpassword setTitle:@"忘记密码？" forState:UIControlStateNormal];
    userforgetpassword.titleLabel.font =[UIFont systemFontOfSize:22.0*SpacedFonts];
    [userforgetpassword setTitleColor:LightBlackTitleColor forState:UIControlStateNormal];
    userforgetpassword.tag = ButtonForgetActionTag;
    [userforgetpassword addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:userforgetpassword];
    
    
    if (CGRectGetMaxY(userforgetpassword.frame) + 10 > frameHeight(mainScrollView)) {
        mainScrollView.contentSize = CGSizeMake(frameWidth(mainScrollView), CGRectGetMaxY(userforgetpassword.frame) + 10);
        
    }


}
#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
  
   if (sender.tag ==0) {
    
       [self.navigationController popViewControllerAnimated:NO];
      
    }
   else if (sender.tag ==ButtonForgetActionTag)
   {
       [self.navigationController pushViewController:allocAndInit(ForgetPasswordBeforeViewController) animated:NO];
      
   }

  else if (sender.tag == ButtonLoginActionTag)
  {
      if (_userNametext.text.length!=11) {
          [[ToolManager shareInstance] showInfoWithStatus:@"手机号码有误！"];
          
          return;
      }
      if (_passWordtext.text.length<
          6) {
          [[ToolManager shareInstance] showInfoWithStatus:@"请输入大于6位密码！"];
          
          return;
      }
      
      [[ToolManager shareInstance] showWithStatus:@"登录..."];
      NSMutableDictionary *sendcaptchaParam = [NSMutableDictionary dictionary];
      if ([CoreArchive strForKey:DeviceToken]) {
        [sendcaptchaParam setObject:[CoreArchive strForKey:DeviceToken] forKey:@"channelid"];
       }
      
          [sendcaptchaParam setObject:_userNametext.text forKey:KuserName];
          [sendcaptchaParam setObject:[_passWordtext.text md5]   forKey:passWord];
          [sendcaptchaParam setObject:@"2" forKey:@"type"];
//          NSLog(@"sendcaptchaParam =%@",sendcaptchaParam);
          [XLDataService postWithUrl:LoginURL param:sendcaptchaParam modelClass:nil responseBlock:^(id dataObj, NSError *error) {
    
              if (error) {
                  
                  [[ToolManager shareInstance] showInfoWithStatus];
              }
              [self dealWithCode:dataObj];
          }];
     

  }

}
#pragma mark
#pragma mark 验证
- (void)dealWithCode:(id)dataObj
{
    if (dataObj) {
        NSDictionary *msg = (NSDictionary *)dataObj;
        
        switch ([msg[@"rtcode"] integerValue]) {
            case 1:
            {
                if (_isRemember) {
                
                    [CoreArchive setStr:_passWordtext.text key:rememberPassWord];
                    
                }
                else
                {
                
                    [CoreArchive removeStrForKey:rememberPassWord];
                }
                [CoreArchive setStr:_userNametext.text key:rememberUserName];
                [CoreArchive setBool:_isRemember key:isremember];
                
                [CoreArchive setStr:_userNametext.text key:KuserName];
                [CoreArchive setStr:[_passWordtext.text md5] key:passWord];
           
                [[ToolManager shareInstance] showSuccessWithStatus:@"登录成功！"];
                //兼容旧用户推送
                [CoreArchive setStr:@"push" key:@"once"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                     [[ToolManager shareInstance] LoginmianView];
                });
                
            }
                break;
            default:
                
                [[ToolManager shareInstance] showInfoWithStatus:msg[@"rtmsg"]];
                break;
        }
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
