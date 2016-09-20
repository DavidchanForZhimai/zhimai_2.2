//
//  ForgetPasswordBeforeViewController.m
//  Lebao
//
//  Created by David on 16/4/19.
//  Copyright © 2016年 David. All rights reserved.
//

#import "ForgetPasswordBeforeViewController.h"
#import "ForgetPassWordViewController.h" //忘记密码
#import "XLDataService.h"
#define sendtypeForget    @"forget"//忘记密码
#define SendcaptchaURL [NSString stringWithFormat:@"%@site/sendcaptcha",HttpURL]
@interface ForgetPasswordBeforeViewController ()

@end

@implementation ForgetPasswordBeforeViewController
{
    
    UITextField *_userName;  //userName
    UIScrollView *mainScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navViewTitleAndBackBtn:@"找回密码"];
    BaseButton *next = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 60, StatusBarHeight, 60, NavigationBarHeight) setTitle:@"下一步" titleSize:28*SpacedFonts titleColor:BlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] inView:self.view];
    
    __weak ForgetPasswordBeforeViewController *weakSelf = self;
    next.didClickBtnBlock = ^{
        if (_userName.text.length!=11) {
            [[ToolManager shareInstance] showInfoWithStatus:@"手机号码有误！"];
            return;
        }
        
        [[ToolManager shareInstance] showWithStatus:@"发起短信验证"];
        NSMutableDictionary * sendcaptchaParam = allocAndInit(NSMutableDictionary);
        [sendcaptchaParam setObject:_userName.text forKey:userName];
        [sendcaptchaParam setObject:sendtypeForget forKey:sendType];
        
        [XLDataService postWithUrl:SendcaptchaURL param:sendcaptchaParam modelClass:nil responseBlock:^(id dataObj, NSError *error) {
            
            if (error) {
                [[ToolManager shareInstance] showInfoWithStatus];
            }
            
            [weakSelf dealWithCode:dataObj type:0];
            
        }];
        
    };
    [self mainView];
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
            {  ForgetPassWordViewController *forget = allocAndInit(ForgetPassWordViewController);
                forget.phoneNum = _userName.text;
                [self.navigationController pushViewController:forget animated:NO];
            }
                break;
            default:
                
                [[ToolManager shareInstance] showInfoWithStatus:msg[@"rtmsg"]];
                break;
        }
    }
    
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

}
#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
    
    if (sender.tag ==0) {
        
        [self.navigationController popViewControllerAnimated:NO];
        
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
