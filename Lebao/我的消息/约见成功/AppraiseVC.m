//
//  AppraiseVC.m
//  Lebao
//
//  Created by adnim on 16/9/27.
//  Copyright © 2016年 David. All rights reserved.
//

#import "AppraiseVC.h"

@interface AppraiseVC ()

@end

@implementation AppraiseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navViewTitleAndBackBtn:@"评价"];
    self.view.backgroundColor=AppMainColor;
    [self creatUI];
}
-(void)creatUI{
    
    UIImageView *headImgV=[[UIImageView alloc]init];
    
    
}






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
