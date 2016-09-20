//
//  AboutViewController.m
//  Lebao
//
//  Created by David on 15/12/24.
//  Copyright © 2015年 David. All rights reserved.
//

#import "AboutViewController.h"
#import "FunctionIntroducedViewController.h"
#import "AbouthelpViewController.h"
#import "XLDataService.h"
//我的URL ：appinterface/personal
#define PersonalURL [NSString stringWithFormat:@"%@user/about",HttpURL]
#define cellH 40.0

@interface AboutViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    UITableView *_myAboutView;
    NSDictionary *dic;
    UIWebView *phoneCallWebView;
}
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    
    [self navView];
    [self addMainView];
    dic = [NSDictionary new];
    [[ToolManager shareInstance] showWithStatus];
    NSMutableDictionary *param = [Parameter parameterWithSessicon];
    [param setObject:@"about" forKey:Conduct];
    [XLDataService postWithUrl:PersonalURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (dataObj) {
            dic = dataObj;
            if ([dic[@"rtcode"] integerValue] ==1) {
                [[ToolManager shareInstance] dismiss];
                [_myAboutView reloadData];
                
            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus:dic[@"rtmsg"]];
            }
            
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus];
        }
        
    }];

}

#pragma mark - Navi_View
- (void)navView
{
    [self navViewTitleAndBackBtn:@"关于我们" ];
    
    
}

#pragma mark
#pragma mark - addTableView -
- (void)addMainView
{
    
    _myAboutView =[[UITableView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)) style:UITableViewStyleGrouped];
    _myAboutView.backgroundColor =[UIColor clearColor];
    _myAboutView.delegate = self;
    _myAboutView.dataSource = self;
//    _myAboutView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myAboutView];
    
    
}
#pragma mark
#pragma mark - TableViewDelegate TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 161*ScreenMultiple;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = allocAndInit(UIView);
    UIImageView *bg = allocAndInitWithFrame(UIImageView, frame((APPWIDTH -77*ScreenMultiple)/2.0, 33*ScreenMultiple, 77*ScreenMultiple, 77*ScreenMultiple));
    bg.image =[UIImage imageNamed:@"appIcon_logo_about"];
    [view addSubview:bg];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    [UILabel createLabelWithFrame:frame(0, CGRectGetMaxY(bg.frame) + 13*ScreenMultiple, APPWIDTH, 28*SpacedFonts) text:[NSString stringWithFormat:@"知脉 %@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]] fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentCenter inView:view];

    
    return view;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = allocAndInit(UIView);
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID =@"MeCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor =[UIColor whiteColor];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:24*SpacedFonts];
    cell.textLabel.frame = frame(20, 0, 100, cellH);
    
    if (indexPath.row ==0) {
      cell.textLabel.text = @"功能介绍";
    }
    if (indexPath.row ==1) {
        cell.textLabel.text = @"帮助与反馈";
    }
    if (indexPath.row ==2) {
        cell.textLabel.text =@"联系我们";
        
        [UILabel createLabelWithFrame:frame(120, 0, APPWIDTH - 160, cellH) text:dic[@"tel"] fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentRight inView:cell];
        
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
  
        PushView(self, allocAndInit(FunctionIntroducedViewController));
    }
    if (indexPath.row ==1) {
        PushView(self, allocAndInit(AbouthelpViewController));
    }
    
    if (indexPath.row ==2) {
        
       
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",dic[@"tel"]]];
    
        if ( !phoneCallWebView ) {
            
            phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];//
            
        }
        
        [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
