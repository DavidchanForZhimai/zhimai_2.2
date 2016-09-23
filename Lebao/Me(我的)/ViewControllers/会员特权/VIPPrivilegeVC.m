//
//  VIPPrivilegeVC.m
//  Lebao
//
//  Created by adnim on 16/9/22.
//  Copyright © 2016年 David. All rights reserved.
//

#import "VIPPrivilegeVC.h"
#import "VIPPrivilegeView.h"
@interface VIPPrivilegeVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@end

@implementation VIPPrivilegeVC
-(void)awakeFromNib
{
    
  
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self navViewTitleAndBackBtn:@"会员特权"];
    
    [self creatUI];
}
-(void)creatUI{
    VIPPrivilegeView *vipView=[[[NSBundle mainBundle]loadNibNamed:@"VIPPrivilegeView" owner:nil options:nil]firstObject];
    [vipView configWithModel:self.modal];
    vipView.frame=CGRectMake(0, 0, self.view.width, vipView.height);

    [self.mainScrollView addSubview:vipView];
    self.mainScrollView.contentSize=CGSizeMake(0, vipView.height);
}
- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
}
- (IBAction)vipBtnClick:(UIButton *)sender {
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
