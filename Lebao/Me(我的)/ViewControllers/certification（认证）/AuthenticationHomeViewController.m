//
//  AuthenticationHomeViewController.m
//  Lebao
//
//  Created by David on 16/9/19.
//  Copyright © 2016年 David. All rights reserved.
//

#import "AuthenticationHomeViewController.h"
#import "AuthenticationViewController.h"
@interface AuthenticationHomeViewController ()
@property(nonatomic,strong)UIView *authenticationHomeView;
@property(nonatomic,strong)BaseButton *upload;

@end

@implementation AuthenticationHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navViewTitleAndBackBtn:@"身份认证"];
    
    [self.view addSubview:self.authenticationHomeView];
    [self.view addSubview:self.upload];
}
#pragma mark
#pragma mark getters
- (UIView *)authenticationHomeView
{
    if (_authenticationHomeView) {
        return  _authenticationHomeView;
    }
    UIImage  *image = [UIImage imageNamed:@"icon_me_mingpian"];
    _authenticationHomeView = [[UIView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + NavigationBarHeight+10, APPWIDTH, image.size.height + 120)];
    _authenticationHomeView.backgroundColor = WhiteColor;
    
    UILabel *title = [UILabel createLabelWithFrame:CGRectMake(30, 0, APPWIDTH -60, 100) text:@"我该怎么做？\n\n只需要确保您所填写的信息和名片的保持一致，就可以通过审核!" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:_authenticationHomeView];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:title.text];
    [str addAttribute:NSFontAttributeName value:Size(32) range:[title.text rangeOfString:@"我该怎么做？"]];
    [str addAttribute:NSForegroundColorAttributeName value:BlackTitleColor range:[title.text rangeOfString:@"我该怎么做？"]];
    title.attributedText = str;
    title.numberOfLines = 0;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((APPWIDTH - image.size.width)/2.0, 100, image.size.width, image.size.height)];
    imageView.image = image;
    [_authenticationHomeView addSubview:imageView];
    return  _authenticationHomeView;
}
- (BaseButton *)upload
{
    if (_upload) {
        return _upload;
    }
    
    _upload = [[BaseButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.authenticationHomeView.frame) + 40, APPWIDTH - 60, 35) setTitle:@"上传自己的名片" titleSize:28*SpacedFonts titleColor:WhiteColor textAlignment:NSTextAlignmentCenter backgroundColor:AppMainColor inView:nil];
    [_upload setRadius:5];
    _upload.shouldAnmial = NO;
    __weak typeof(self) weakSelf = self;
    _upload.didClickBtnBlock = ^
    {
        AuthenticationViewController *authen = allocAndInit(AuthenticationViewController);
        authen.authen = weakSelf.authen;
        [weakSelf.navigationController pushViewController:authen animated:YES];
    };
     return _upload;
}

#pragma mark
#pragma mark - btn 
- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
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
