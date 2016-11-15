//
//  DyMessageViewController.m
//  Lebao
//
//  Created by David on 2016/11/14.
//  Copyright © 2016年 David. All rights reserved.
//

#import "DyMessageViewController.h"

@interface DyMessageViewController ()

@end

@implementation DyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navViewTitleAndBackBtn:@"动态消息"];
}
#pragma mark
#pragma mark back 
- (void)buttonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
