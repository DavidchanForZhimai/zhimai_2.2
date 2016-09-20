//
//  SettingViewController.m
//  Lebao
//
//  Created by David on 16/5/12.
//  Copyright © 2016年 David. All rights reserved.
//

#import "SettingViewController.h"
#import "CoreArchive.h"
#import "AboutViewController.h"
#import "ModifiedViewController.h"
#import "AbouthelpViewController.h"
#import "BPush.h"
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *settingView;
@end

@implementation SettingViewController

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
    if (section ==0) {
        return 1;
    }
    return 4;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    textLabel = [UILabel createLabelWithFrame:frame(10, 0, 100, 40) text:@"" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
    }
    
    if (indexPath.section==0) {
        
        textLabel.text = @"清空缓存";
    }
    else if (indexPath.section ==1 &&indexPath.row ==0)
    {
       textLabel.text = @"修改密码";
    }
    else if (indexPath.section ==1 &&indexPath.row ==1)
    {
      textLabel.text = @"意见反馈";
    }
    else if (indexPath.section ==1 &&indexPath.row ==2)
    {
        textLabel.text = @"关于知脉";
    }
    else if (indexPath.section ==1 &&indexPath.row ==3)
    {
        textLabel.text = @"退出";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        dispatch_async(
                       dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                       , ^{
                           NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                           
                           NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                           [[ToolManager shareInstance]showWithStatus:[NSString stringWithFormat:@"正在清除%li个文件",files.count]];
                       
                           for (NSString *p in files) {
                               NSError *error;
                               NSString *path = [cachPath stringByAppendingPathComponent:p];
                               if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                                   [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                               }
                           }
    [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
    }
    else if (indexPath.section ==1 &&indexPath.row ==0)
    {
        PushView(self, allocAndInit(ModifiedViewController));
    }
    else if (indexPath.section ==1 &&indexPath.row ==1)
    {
        PushView(self, allocAndInit(AbouthelpViewController));
    }
    else if (indexPath.section ==1 &&indexPath.row ==2)
    {
       PushView(self, allocAndInit(AboutViewController));
    }
    else if (indexPath.section ==1 &&indexPath.row ==3)
    {
        [[ToolManager shareInstance] showAlertViewTitle:@"确定要退出登录？" contentText:nil showAlertViewBlcok:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [CoreArchive removeStrForKey:userName];
                [CoreArchive removeStrForKey:passWord];
                
                [[ToolManager shareInstance] enterLoginView];
                
                //解绑推送通知
                [BPush unbindChannelWithCompleteHandler:^(id result, NSError *error) {
                   
                }];

            });
            
            
        }];
    }

}
-(void)clearCacheSuccess
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [[ToolManager shareInstance] showSuccessWithStatus:@"清除缓存成功！"];
    });
   
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
