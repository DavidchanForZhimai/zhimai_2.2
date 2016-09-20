//
//  SelectedLoginViewController.m
//  Lebao
//
//  Created by David on 16/4/19.
//  Copyright © 2016年 David. All rights reserved.
//

#import "SelectedLoginViewController.h"
#import "LoginViewController.h"
#import "RegistViewController.h"
@interface SelectedLoginViewController ()

@end

@implementation SelectedLoginViewController{

UIScrollView *mainScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self mainView];
    
}
#pragma mark - mainView
-(void)mainView{
    
    self.view.backgroundColor =AppMainColor;
    mainScrollView =allocAndInitWithFrame(UIScrollView, frame(0, StatusBarHeight  , APPWIDTH, APPHEIGHT - StatusBarHeight));
    mainScrollView.alwaysBounceVertical = YES;
    mainScrollView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:mainScrollView];
    
    UIImage *logoImage =[UIImage imageNamed:@"appIcon_logo"];
    UIImageView *_logo =allocAndInitWithFrame(UIImageView, frame(55*ScreenMultiple, 125*ScreenMultiple - StatusBarHeight, APPWIDTH -110*ScreenMultiple, (APPWIDTH -110*ScreenMultiple)/logoImage.size.width*logoImage.size.height));
    _logo.image =logoImage;
    [mainScrollView addSubview:_logo];
    
    BaseButton *regist = [[BaseButton alloc]initWithFrame:frame(35*ScreenMultiple, frameHeight(mainScrollView) - 130*ScreenMultiple , (APPWIDTH - 105*ScreenMultiple)/2.0, 40*ScreenMultiple) setTitle:@"注册" titleSize:28*SpacedFonts titleColor:AppMainColor textAlignment:NSTextAlignmentCenter backgroundColor:WhiteColor inView:mainScrollView];
    [regist setRadius:frameHeight(regist)/2.0];
    
    BaseButton *login = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - CGRectGetMaxX(regist.frame), frameY(regist) ,frameWidth(regist), frameHeight(regist)) setTitle:@"登录" titleSize:28*SpacedFonts titleColor:WhiteColor textAlignment:NSTextAlignmentCenter backgroundColor:AppMainColor inView:mainScrollView];
    [login setBorder:WhiteColor width:1.0];
    [login setRadius:frameHeight(login)/2.0];
    
   __weak  SelectedLoginViewController *weakSelf = self;
    regist.didClickBtnBlock = ^
    {
        [weakSelf.navigationController pushViewController:allocAndInit(RegistViewController) animated:NO];
      
    };
    login.didClickBtnBlock = ^
    {
        [weakSelf.navigationController pushViewController:allocAndInit(LoginViewController) animated:NO];
      
    };
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
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
