//
//  NotificationSettingViewController.m
//  Lebao
//
//  Created by David on 16/5/25.
//  Copyright © 2016年 David. All rights reserved.
//

#import "NotificationSettingViewController.h"

@interface NotificationSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *settingView;

@end

@implementation NotificationSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navViewTitleAndBackBtn:@"设置"];
    [self tableView];
}
- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
}
- (void)tableView
{
    _settingView = [[UITableView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH,APPHEIGHT - (StatusBarHeight + NavigationBarHeight)) style:UITableViewStyleGrouped];
    _settingView.delegate = self;
    _settingView.dataSource = self;
    _settingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_settingView];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return 4;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"settingView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    UILabel *textLabel;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = 0;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        textLabel = [UILabel createLabelWithFrame:frame(10, 0, 100, 40) text:@"" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
    }
    
  
    if (indexPath.row ==0)
    {
        textLabel.text = @"推送通知";
    }
    else if (indexPath.row ==1)
    {
        textLabel.text = @"新线索提醒";
    }
    else if (indexPath.row ==2)
    {
        textLabel.text = @"有人领取";
    }
    else if (indexPath.row ==3)
    {
        textLabel.text = @"关注提醒";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    
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
