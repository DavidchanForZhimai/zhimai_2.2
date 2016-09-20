//
//  EditWebDetailViewController.m
//  Lebao
//
//  Created by David on 16/3/1.
//  Copyright © 2016年 David. All rights reserved.
//

#import "EditWebDetailViewController.h"

@interface EditWebDetailViewController ()

@end

@implementation EditWebDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navView];
    // Do any additional setup after loading the view.
    // Set the base URL if you would like to use relative links, such as to images.
    self.shouldShowKeyboard = NO;
    // Set the HTML contents of the editor
    [self setHTML:_htmlStr];
}

#pragma mark - Navi_View
- (void)navView
{
    UIButton *_addBtn = [UIButton createButtonWithfFrame:frame(APPWIDTH - 20 -2*32.0*BandFonts , StatusBarHeight , 20 + 2*32.0*BandFonts , NavigationBarHeight) title:@"确认" backgroundImage:nil iconImage:nil highlightImage:nil tag:2];
    [_addBtn setTitleColor:BlackTitleColor forState:UIControlStateNormal];
    _addBtn.titleLabel.font = Size(32);
    [_addBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self navViewTitleAndBackBtn:_titles rightBtn:_addBtn];
    
}
#pragma mark
#pragma mark buttonAction
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag ==0) {
        PopView(self);
    }
    else if (sender.tag ==2)
    {
        
        if (_htmlBlock) {
            
            _htmlBlock([self getHTML]);
            PopView(self);
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
