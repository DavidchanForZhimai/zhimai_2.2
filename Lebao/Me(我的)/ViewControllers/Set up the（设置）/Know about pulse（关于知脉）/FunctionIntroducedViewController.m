//
//  FunctionIntroducedViewController.m
//  Lebao
//
//  Created by David on 16/2/24.
//  Copyright © 2016年 David. All rights reserved.
//

#import "FunctionIntroducedViewController.h"
#import "XLDataService.h"
//我的URL ：appinterface/personal
#define PersonalURL [NSString stringWithFormat:@"%@user/about-help",HttpURL]
#define cellH 40.0
@interface FunctionIntroducedViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation FunctionIntroducedViewController
{
    UITableView *_introductionView;
    NSMutableArray *_introductionArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navView];
    [self addMainView];
}

#pragma mark - Navi_View
- (void)navView
{
    [self navViewTitleAndBackBtn:@"功能介绍" ];

    [[ToolManager shareInstance] showWithStatus];
    NSMutableDictionary *param = [Parameter parameterWithSessicon];
    [param setObject:@"abouthelp" forKey:Conduct];
    [XLDataService postWithUrl:PersonalURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (dataObj) {
            
            if ([dataObj[@"rtcode"] integerValue] ==1) {
                _introductionArray = dataObj[@"datas"];
                [[ToolManager shareInstance] dismiss];
                [_introductionView reloadData];
                
            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus:dataObj[@"rtmsg"]];
            }
            
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus];
        }
        
    }];
    

}


#pragma mark
#pragma mark - addTableView -
- (void)addMainView
{
    _introductionArray = allocAndInit(NSMutableArray);
    _introductionView =[[UITableView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)) style:UITableViewStyleGrouped];
    _introductionView.backgroundColor =[UIColor clearColor];
    _introductionView.delegate = self;
    _introductionView.dataSource = self;

    [self.view addSubview:_introductionView];
    
    
}
#pragma mark
#pragma mark - TableViewDelegate TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _introductionArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = allocAndInit(UIView);

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
    

    cell.textLabel.text = _introductionArray[indexPath.row][@"desc"];
        
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[ToolManager shareInstance] loadWebViewWithUrl:_introductionArray[indexPath.row][@"url"] title:_introductionArray[indexPath.row][@"desc"] pushView:self rightBtn:nil];
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
