//
//  FriendImpressionViewController.m
//  Lebao
//
//  Created by David on 16/9/19.
//  Copyright © 2016年 David. All rights reserved.
//

#import "FriendImpressionViewController.h"

@interface FriendImpressionViewController ()
@property(nonatomic,strong)BaseButton *evaluation;
@end

@implementation FriendImpressionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navViewTitleAndBackBtn:@"好友印象"];
    [self.view addSubview:self.evaluation];
    
    
}
#pragma mark getter
- (BaseButton *)evaluation
{
    if (_evaluation) {
        return _evaluation;
    }
    _evaluation = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 50 ,StatusBarHeight,50, NavigationBarHeight) setTitle:@"求评价" titleSize:28*SpacedFonts titleColor:BlackTitleColor textAlignment:NSTextAlignmentRight backgroundColor:[UIColor clearColor] inView:nil];
    _evaluation.shouldAnmial = NO;
//    __weak typeof(self) weakSelf = self;
    _evaluation.didClickBtnBlock = ^
    {
        
    };
    return _evaluation;
}
#pragma mark button aticons
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
