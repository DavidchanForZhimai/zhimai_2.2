//
//  ModifiedViewController.m
//  Lebao
//
//  Created by David on 15/12/9.
//  Copyright © 2015年 David. All rights reserved.
//

#import "ModifiedViewController.h"
#import "XLDataService.h"
#import "LoginViewController.h"
#import "NSString+Password.h"
#import "CoreArchive.h"
#define ChangepwdURL [NSString stringWithFormat:@"%@user/changepwd",HttpURL]
@interface ModifiedViewController ()

@end
typedef enum {
    
    ButtonSureActionTag  = 2
    
}ButtonActionTag;

typedef enum {
    
    RequestTypeVerificationCode  = 0,
    RequestTypeSubmit     =1,
    
}RequestType;

@implementation ModifiedViewController{
    
    UITextField *_oldPassWord;  //passWord
    UITextField *_passWord;  //passWord
    UITextField *_surePassWord;  //
    
    UIView *_succeedView;

    
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
    
    
    [self navViewTitleAndBackBtn:@"修改密码" ];
}

#pragma mark - mainView
-(void)mainView{
    
    UIScrollView *mainScrollView =allocAndInitWithFrame(UIScrollView, frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)));
     mainScrollView.alwaysBounceVertical = YES;
    mainScrollView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:mainScrollView];
    
    float Y = 10;
    float cellHeight = 46;
    float cellX = 14;
    
    UIView *_oldPassWordView = allocAndInitWithFrame(UIView, frame(cellX,Y, frameWidth(self.view) - 2*cellX, cellHeight));
    _oldPassWordView.backgroundColor =[UIColor whiteColor];
    _oldPassWordView.layer.masksToBounds = YES;
    _oldPassWordView.layer.cornerRadius = 3;
    _oldPassWordView.layer.borderWidth = 0.5;
    _oldPassWordView.layer.borderColor =LineBg.CGColor;
    [mainScrollView addSubview:_oldPassWordView];
    
    Y += frameHeight(_oldPassWordView);
    Y +=10;
    
    UILabel *_oldPassWordLb =[UILabel createLabelWithFrame:frame(15, 0, 4*26*SpacedFonts, cellHeight) text:@"旧密码：" fontSize:26*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:_oldPassWordView];
    UILabel *line1 = allocAndInitWithFrame(UILabel, frame(CGRectGetMaxX(_oldPassWordLb.frame), 10, 0.5, frameHeight(_oldPassWordView) -20));
    line1.backgroundColor = LineBg;
    [_oldPassWordView addSubview:line1];
    
    _oldPassWord = allocAndInitWithFrame(UITextField, frame(CGRectGetMaxX(line1.frame) + 12, 0, frameWidth(_oldPassWordView) - (CGRectGetMaxX(line1.frame) + 24), cellHeight));
    _oldPassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _oldPassWord.keyboardType = UIKeyboardTypeNumberPad;
    _oldPassWord.placeholder = @"请输入旧密码";
    _oldPassWord.secureTextEntry = YES;
    _oldPassWord.font = [UIFont systemFontOfSize:24.0*SpacedFonts];
    [_oldPassWordView addSubview:_oldPassWord];
    
    UIView *_passWordView = allocAndInitWithFrame(UIView, frame(cellX,Y, frameWidth(self.view) - 2*cellX, cellHeight));
    _passWordView.backgroundColor =[UIColor whiteColor];
    _passWordView.layer.masksToBounds = YES;
    _passWordView.layer.cornerRadius = 3;
    _passWordView.layer.borderWidth = 0.5;
    _passWordView.layer.borderColor =LineBg.CGColor;
    [mainScrollView addSubview:_passWordView];
    
    Y += frameHeight(_passWordView);
    Y +=10;
    
    UILabel *_PassWordLb =[UILabel createLabelWithFrame:frame(15, 0, 4*26*SpacedFonts, cellHeight) text:@"新密码：" fontSize:26*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:_passWordView];
    UILabel *line2 = allocAndInitWithFrame(UILabel, frame(CGRectGetMaxX(_PassWordLb.frame), 10, 0.5, frameHeight(_passWordView) -20));
    line2.backgroundColor = LineBg;
    [_passWordView addSubview:line2];
    
    _passWord = allocAndInitWithFrame(UITextField, frame(CGRectGetMaxX(line2.frame) + 12, 0, frameWidth(_passWordView) - (CGRectGetMaxX(line2.frame) + 24), cellHeight));
    _passWord.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _passWord.keyboardType = UIKeyboardTypeNumberPad;
    _passWord.placeholder = @"请输入新密码";
    _passWord.font = _oldPassWord.font;
    _passWord.secureTextEntry = YES;
    [_passWordView addSubview:_passWord];
    
    UIView *_surePassWordView = allocAndInitWithFrame(UIView, frame(cellX,Y, frameWidth(self.view) - 2*cellX, cellHeight));
    _surePassWordView.backgroundColor =[UIColor whiteColor];
    _surePassWordView.layer.masksToBounds = YES;
    _surePassWordView.layer.cornerRadius = 3;
    _surePassWordView.layer.borderWidth = 0.5;
    _surePassWordView.layer.borderColor =LineBg.CGColor;
    [mainScrollView addSubview:_surePassWordView];
    
     Y += frameHeight(_surePassWordView);
    Y +=20;
    
    UILabel *_surePassWordLb =[UILabel createLabelWithFrame:frame(15, 0, 6*26*SpacedFonts, cellHeight) text:@"确定新密码：" fontSize:26*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:_surePassWordView];
    UILabel *line3 = allocAndInitWithFrame(UILabel, frame(CGRectGetMaxX(_surePassWordLb.frame), 10, 0.5, frameHeight(_surePassWordView) -20));
    line3.backgroundColor = LineBg;
    [_surePassWordView addSubview:line3];
    
    _surePassWord = allocAndInitWithFrame(UITextField, frame(CGRectGetMaxX(line3.frame) + 12, 0, frameWidth(_surePassWordView) - (CGRectGetMaxX(line3.frame) + 24), cellHeight));
    _surePassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _surePassWord.keyboardType = UIKeyboardTypeNumberPad;
    _surePassWord.placeholder = @"请在次输入密码";
    _surePassWord.font = _oldPassWord.font;
     _surePassWord.secureTextEntry = YES;
    [_surePassWordView addSubview:_surePassWord];
    
    UIButton *sureBn = [UIButton createButtonWithfFrame:frame(cellX, Y , frameWidth(_surePassWordView), 40.0) title:nil backgroundImage:nil iconImage:nil highlightImage:nil tag:ButtonSureActionTag];
    sureBn.backgroundColor = AppMainColor;
    sureBn.layer.cornerRadius = 3.0;
    [sureBn setTitle:@"确定" forState:UIControlStateNormal];
    sureBn.titleLabel.font =[UIFont systemFontOfSize:28.0*SpacedFonts];
    [sureBn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:sureBn];
    
    
}
#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag ==NavViewButtonActionNavLeftBtnTag)
    {
        PopView(self);
    }
    
    else if (sender.tag == ButtonSureActionTag)
    {
      
        if (_passWord.text.length<
            6) {
            [[ToolManager shareInstance] showInfoWithStatus:@"请输入大于6位密码！"];
            
            return;
        }
        if (_oldPassWord.text.length<
            6) {
            [[ToolManager shareInstance] showInfoWithStatus:@"请输入大于6位密码！"];
            
            return;
        }
        if (![_passWord.text isEqualToString:_surePassWord.text ]) {
            [[ToolManager shareInstance] showInfoWithStatus:@"两次密码不同！"];
            
            return;
        }

        
        [[ToolManager shareInstance] showWithStatus:@"确认..."];
        NSMutableDictionary * sendcaptchaParam = [Parameter parameterWithSessicon];

        [sendcaptchaParam setObject:[_oldPassWord.text md5]   forKey:oldpassword];
        [sendcaptchaParam setObject:[_passWord.text md5]   forKey:newpassword];
        
//        NSLog(@"sendcaptchaParam =%@ sendcaptchaParam=%@",sendcaptchaParam,ChangepwdURL);
        [XLDataService postWithUrl:ChangepwdURL param:sendcaptchaParam modelClass:nil responseBlock:^(id dataObj, NSError *error) {
//            DDLog(@"dataObj =%@",dataObj);
        
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
                    [[ToolManager shareInstance] dismiss];
                    [CoreArchive removeStrForKey:userName];
                    [CoreArchive removeStrForKey:passWord];
                    [self.navigationController pushViewController:allocAndInit(NSClassFromString(@"LoginViewController")) animated:NO];
                }
            break;
            default:
               
                [[ToolManager shareInstance] showInfoWithStatus:msg[@"rtmsg"]];
                break;
        }
    }
    
}

- (void)succeedView
{
    _succeedView = allocAndInitWithFrame(UIView, frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT -(StatusBarHeight +NavigationBarHeight)));
    _succeedView.backgroundColor = AppViewBGColor;
    
    
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
