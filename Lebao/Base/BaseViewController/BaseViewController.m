//
//  BaseViewController.m
//  Lebao
//
//  Created by David on 15/11/27.
//  Copyright © 2015年 David. All rights reserved.
//

#import "BaseViewController.h"
#import "CoreArchive.h"
#import "NotificationViewController.h"
@interface BaseViewController ()
@property(nonatomic,strong)UILabel *v;//空状态
@property(nonatomic,weak) UIViewController* currentShowVC;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    self.view.backgroundColor = AppViewBGColor;
    self.navigationController.navigationBarHidden = YES;
    
    
}


- (void)navViewTitle:(NSString *)title
{
    _homePageBtn = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 50, StatusBarHeight, 50, NavigationBarHeight) backgroundImage:nil iconImage:[UIImage imageNamed:@"icon_dicover_me"] highlightImage:nil inView:self.view];
    _homePageBtn.didClickBtnBlock = ^
    {
        [CoreArchive removeStrForKey:@"isread"];
        [[ToolManager shareInstance].drawerController openDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
            
        }];

        
    };
    
    [self navViewTitle:title leftBtn:nil rightBtn:_homePageBtn];
}

- (void)navViewTitleAndBackBtn:(NSString *)title
{
    [self navViewTitleAndBackBtn:title rightBtn:nil];
}
- (void)navViewTitleAndBackBtn:(NSString *)title rightBtn:(UIButton *)navRightBtn
{
    UIImage *navBarLeftImg = [UIImage imageNamed:@"icon_back"];
    UIButton *navBarLeftBtn = [UIButton createButtonWithfFrame:frame(0 ,StatusBarHeight, navBarLeftImg.size.width +20*ScreenMultiple, NavigationBarHeight) title:nil backgroundImage:nil iconImage:navBarLeftImg highlightImage:nil tag:NavViewButtonActionNavLeftBtnTag ];
    [navBarLeftBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self navViewTitle:title leftBtn:navBarLeftBtn rightBtn:navRightBtn];
}
- (void)navViewTitle:(NSString *)title leftBtn:(UIButton *)navLeftBtn rightBtn:(UIButton *)navRightBtn
{
    _navigationBarView = [[UIView alloc]initWithFrame:frame(0, 0, APPWIDTH, StatusBarHeight + NavigationBarHeight)];
    _navigationBarView.backgroundColor = WhiteColor;
    [_navigationBarView setBorder:LineBg width:0.5];
    [self.view addSubview:_navigationBarView];
    
    _navTitle = [UILabel createLabelWithFrame:frame(50, StatusBarHeight, APPWIDTH - 100, NavigationBarHeight) text:title fontSize:34*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentCenter inView:_navigationBarView];
    ;
    [_navigationBarView addSubview:navLeftBtn];
        
    [_navigationBarView addSubview:navRightBtn];
    
    
}


#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
   
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setTabbarIndex:(int)index
{
    _index = index;
   _bottomView= [[BottomView alloc] initWithFrame:frame(0, APPHEIGHT - TabBarHeight, APPWIDTH, TabBarHeight) selectIndex:index clickCenterButton:^{
        
        [[ToolManager shareInstance] addReleseDctView:self];
        
    }];
    _message = [[UIView alloc]initWithFrame:frame(2.57*APPWIDTH/4.0, 5, 8, 8)];
    [_message setRound];
    _message.backgroundColor = [UIColor clearColor];
    [_bottomView addSubview:_message];
    [self.view addSubview:_bottomView];
    
}

- (void)isShowEmptyStatus:(BOOL)isShowEmptyStatus
{
    
    if (!_v) {
        _v =[UILabel createLabelWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, 100) text:@"没有相关数据" fontSize:28*SpacedFonts textColor: AppMainColor textAlignment:NSTextAlignmentCenter inView:self.view];
    }

    _v.hidden = !isShowEmptyStatus;
   
    
    
}
#pragma mark
#pragma mark- pushMessage
- (void)pushMessage
{
    _message.backgroundColor = [UIColor redColor];
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    if (_index ==2) {
       _message.backgroundColor = [UIColor clearColor];
    }
  
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    if (_index!=2) {
         _message.backgroundColor = [UIColor clearColor];
    }
    [super viewWillDisappear:animated];
    
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
