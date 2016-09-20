//
//  GeneratePosterViewController.m
//  Lebao
//
//  Created by David on 16/6/3.
//  Copyright © 2016年 David. All rights reserved.
//

#import "GeneratePosterViewController.h"
#import "WetChatShareManager.h"
@interface GeneratePosterViewController ()

@end

@implementation GeneratePosterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self navViewTitleAndBackBtn:@"邀请好友"];
    BaseButton *share = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 50, StatusBarHeight, 50, NavigationBarHeight) backgroundImage:nil iconImage:[UIImage imageNamed:@"icon_widelyspreaddetail_share"] highlightImage:nil inView:self.view];
    
    UIImageView *haiBao = allocAndInitWithFrame(UIImageView, frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)));
    [[ToolManager shareInstance] imageView:haiBao setImageWithURL:_url placeholderType:PlaceholderTypeImageUnProcessing];
    [self.view addSubview:haiBao];
    share.didClickBtnBlock = ^
    {
        [[WetChatShareManager shareInstance] shareImageToWXApp:haiBao.image];
    };

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
