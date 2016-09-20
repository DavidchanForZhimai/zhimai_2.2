
//
//  MeViewController.m
//  Lebao
//
//  Created by David on 15/12/4.
//  Copyright © 2015年 David. All rights reserved.
//

#import "MeViewController.h"
#import "MeCell.h"
#import "EarnestMoneyViewController.h"
#import "CExpandHeader.h"
#import "XLDataService.h"
#import "UIImage+Color.h"
#import "CoreArchive.h"
#import "AppDelegate.h"
#import "BasicInformationViewController.h"
#import "MyGuanZhuVC.h"//我的关注
#import "MyFansVC.h"//我的粉丝
#import "MyDetialViewController.h"
#import "AuthenticationHomeViewController.h"
#import "OtherDynamicdViewController.h"
#import "MeetSucceedVC.h"
#define cellH  40
#define PersonalURL [NSString stringWithFormat:@"%@user/index",HttpURL]
@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray *datas;
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation MeViewModal
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}

@end

@implementation MeViewController
{
    
    CExpandHeader *_header;
    UIImageView *userIcon;
    UILabel *username;
    UILabel *descrip;
    MeViewModal *modal;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self netWork];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *head = allocAndInitWithFrame(UIView, frame(0, 0,APPWIDTH,  StatusBarHeight));
    head.backgroundColor = AppMainColor;
    [self.view addSubview:head];
    
    modal =[[MeViewModal alloc]init];
    modal.authen = 1;
    
    
    [self.view addSubview:self.tableView];
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frameWidth(self.tableView), 120 )];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frameWidth(customView), frameHeight(customView))];
    [imageView setImage:[UIImage imageFromContextWithColor:AppMainColor]];
    
    //关键步骤 设置可变化背景view属性
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [customView addSubview:imageView];
    
    [self addHeadView:customView];
    
    _header = [CExpandHeader expandWithScrollView:self.tableView expandView:customView];
    
    //设置
    UIImage *image = [UIImage imageNamed:@"iconfonticon_me_shezhi"];
    BaseButton *set =  [[BaseButton alloc]initWithFrame:frame(frameWidth(self.tableView) - 54, APPHEIGHT - 49,54, 49) setTitle:@"设置" titleSize:24*SpacedFonts titleColor:hexColor(5a5a5a) backgroundImage:nil iconImage:image highlightImage:nil setTitleOrgin:CGPointMake(20,5) setImageOrgin:CGPointMake(20, 0) inView:self.view];
    set.didClickBtnBlock = ^
    {
        [[ToolManager shareInstance].drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            UITabBarController *tabBar = (UITabBarController *)[ToolManager shareInstance].drawerController.centerViewController;
            UINavigationController *nav =(UINavigationController *)tabBar.viewControllers[getAppDelegate().mainTab.selectedIndex];
            [nav pushViewController:allocAndInit((NSClassFromString(@"SettingViewController")))animated:YES];
            
        }];
        
    };
    
    
    
}

#pragma mark
#pragma mark getters
- (NSMutableArray *)datas
{
    if (_datas) {
        return _datas;
    }
    
    _datas =[NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"会员特权",@"name",@"icon_me_VIP",@"image",@"1",@"show",@"",@"viewController",nil] ,[NSDictionary dictionaryWithObjectsAndKeys:@"我的钱包",@"name",@"icon_me_qianbao",@"image",@"1",@"show",@"EarnestMoneyViewController",@"viewController",nil],[NSDictionary dictionaryWithObjectsAndKeys:@"我的资料",@"name",@"icon_me_zhiliao",@"image",@"1",@"show",@"BasicInformationViewController",@"viewController",nil],[NSDictionary dictionaryWithObjectsAndKeys:@"身份认证",@"name",@"icon_me_renzheng",@"image",@"1",@"show",@"AuthenticationHomeViewController",@"viewController",nil],[NSDictionary dictionaryWithObjectsAndKeys:@"活跃值",@"name",@"icon_me_huoyuezhi",@"image",@"1",@"show",@"ActiveValueViewController",@"viewController",nil],[NSDictionary dictionaryWithObjectsAndKeys:@"好友印象",@"name",@"icon_me_yinxiang",@"image",@"1",@"show",@"FriendImpressionViewController",@"viewController",nil],[NSDictionary dictionaryWithObjectsAndKeys:@"邀请好友",@"name",@"icon_me_yaoqinghaoyou",@"image",@"1",@"show",@"InviteFriendsViewController",@"viewController",nil],[NSDictionary dictionaryWithObjectsAndKeys:@"我的客服",@"name",@"icon_me_kefu",@"image",@"0",@"show",@"",@"viewController",nil],nil];
    
    
    return _datas;
}
- (UITableView *)tableView
{
    if (_tableView) {
        return _tableView;
    }
    _tableView =[[UITableView alloc]initWithFrame:frame(0, StatusBarHeight, APPWIDTH - 60*ScreenMultiple, APPHEIGHT - StatusBarHeight - 49) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor =AppViewBGColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return _tableView;
}
#pragma mark
#pragma mark - headView
- (void)addHeadView:(UIView *)view
{
    //headIcon
    userIcon =allocAndInitWithFrame(UIImageView, frame((frameWidth(_tableView) -53)/2.0,14, 53, 53));
    
    userIcon.backgroundColor =[UIColor clearColor];
    userIcon.userInteractionEnabled =YES;
    userIcon.contentMode = UIViewContentModeRedraw;
    userIcon.layer.borderWidth = 3;
    userIcon.layer.borderColor = rgba(255, 255, 255, 0.5).CGColor;
    userIcon.layer.masksToBounds =YES;
    userIcon.layer.cornerRadius = frameWidth(userIcon)/2.0;
    [view addSubview:userIcon];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userIconTap)];
    userIcon.image = [UIImage imageNamed:@"defaulthead"];
    tap.numberOfTapsRequired = 1;
    [userIcon addGestureRecognizer:tap];
    
    //userName
    username = [UILabel createLabelWithFrame:frame(0, CGRectGetMaxY(userIcon.frame)+ 8, frameWidth(_tableView), 28.0*SpacedFonts) text:@"" fontSize:28.0*SpacedFonts textColor:WhiteColor textAlignment: NSTextAlignmentCenter inView:view];
    
    
    //descrip
    descrip =[UILabel createLabelWithFrame:frame(0, CGRectGetMaxY(username.frame)+ 10, frameWidth(_tableView), 24.0*SpacedFonts) text:@"钱包余额:00.00元" fontSize:24*SpacedFonts textColor:WhiteColor textAlignment: NSTextAlignmentCenter inView:view];
    
}
- (void)netWork
{
    NSMutableDictionary * parameter =[Parameter parameterWithSessicon];
    
    [XLDataService postWithUrl:PersonalURL param:parameter modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        
        if (dataObj) {
            MeViewModal * _modal =[MeViewModal mj_objectWithKeyValues:dataObj];
            modal         = _modal;
            if (modal.rtcode ==1) {
                
                [[ToolManager shareInstance] imageView:userIcon setImageWithURL:modal.imgurl placeholderType:PlaceholderTypeUserHead];
                username.text = modal.realname;
                descrip.text  = [NSString stringWithFormat:@"钱包余额: %@元",modal.amount];
                [_tableView  reloadData];
            }
            
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus:modal.rtmsg];
            }
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus];
        }
    }];
    
}
#pragma mark
#pragma mark
- (void)userIconTap
{
    [[ToolManager shareInstance].drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        UITabBarController *tabBar = (UITabBarController *)[ToolManager shareInstance].drawerController.centerViewController;
        UINavigationController *nav =(UINavigationController *)tabBar.viewControllers[getAppDelegate().mainTab.selectedIndex];
        MyDetialViewController *myDetialVC = allocAndInit(MyDetialViewController);
        myDetialVC.userID = modal.ID;
        modal.ID?[nav pushViewController:myDetialVC animated:YES]:[[ToolManager shareInstance] showInfoWithStatus:@"信息参数不全"];
        
        
    }];
}
#pragma mark
#pragma mark - TableViewDelegate TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.datas.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        
        return 50;
    }
    
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *view = allocAndInitWithFrame(UIView, frame(0, 0, frameWidth(
                                                                            self.tableView), 50));
        
        UIView  *attentionAndfensView = allocAndInitWithFrame(UIView, frame(0, 0, frameWidth(self.tableView), 40));
        attentionAndfensView.backgroundColor = WhiteColor;
        [view addSubview:attentionAndfensView];
        
        UILabel *line = allocAndInitWithFrame(UILabel , frame(frameWidth(self.tableView)/2.0 - 0.5, 7, 0.5, 26));
        line.backgroundColor = LineBg;
        [view addSubview:line];
        NSString *str = @"0";
        BaseButton *attention = [[BaseButton alloc]initWithFrame:frame(0, 0, frameWidth(attentionAndfensView)/2.0, frameHeight(attentionAndfensView)) setTitle:[NSString stringWithFormat:@"%@\n约见成功",modal.invitednum?modal.invitednum:str] titleSize:24*SpacedFonts titleColor:AppMainColor textAlignment:NSTextAlignmentCenter backgroundColor:WhiteColor inView:attentionAndfensView];
        attention.titleLabel.numberOfLines = 0;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:attention.titleLabel.text];
        [attributedString addAttribute:NSFontAttributeName value:Size(28) range:[attention.titleLabel.text rangeOfString:modal.invitednum?modal.invitednum:str]];
        //        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[attention.titleLabel.text rangeOfString:modal.follownum?modal.follownum:str]];
        attention.titleLabel.attributedText =attributedString;
        
        attention.didClickBtnBlock = ^
        {
            [[ToolManager shareInstance].drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                
                UITabBarController *tabBar = (UITabBarController *)[ToolManager shareInstance].drawerController.centerViewController;
                UINavigationController *nav =(UINavigationController *)tabBar.viewControllers[getAppDelegate().mainTab.selectedIndex];
                
                MeetSucceedVC *otherDynamicdVC = allocAndInit(MeetSucceedVC);
//
                [nav pushViewController:otherDynamicdVC animated:YES];
                
            }];
            
            
            
        };
        
        BaseButton *fens = [[BaseButton alloc]initWithFrame:frame(CGRectGetMaxX(attention.frame), frameY(attention), frameWidth(attention), frameHeight(attention)) setTitle:[NSString stringWithFormat:@"%@\n我的动态",modal.dynamicnum?modal.dynamicnum:str] titleSize:24*SpacedFonts titleColor:AppMainColor textAlignment:NSTextAlignmentCenter backgroundColor:WhiteColor inView:attentionAndfensView];
        fens.titleLabel.numberOfLines = 0;
        
        NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc]initWithString:fens.titleLabel.text];
        //        [attributedString1 addAttribute:NSForegroundColorAttributeName value:AppMainColor range:[fens.titleLabel.text rangeOfString:modal.fansnum?modal.fansnum:str]];
        
        [attributedString1 addAttribute:NSFontAttributeName value:Size(28) range:[fens.titleLabel.text rangeOfString:modal.dynamicnum?modal.dynamicnum:str]];
        fens.titleLabel.attributedText =attributedString1;
        
        fens.didClickBtnBlock = ^
        {
            [[ToolManager shareInstance].drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                
                UITabBarController *tabBar = (UITabBarController *)[ToolManager shareInstance].drawerController.centerViewController;
                UINavigationController *nav =(UINavigationController *)tabBar.viewControllers[getAppDelegate().mainTab.selectedIndex];
                
                OtherDynamicdViewController *otherDynamicdVC = allocAndInit(OtherDynamicdViewController);
                otherDynamicdVC.dynamicdID = modal.ID;
                otherDynamicdVC.dynamicdName = @"我的动态";
                [nav pushViewController:otherDynamicdVC animated:YES];
                
            }];
            
        };
        
        
        return view;
    }
    return allocAndInit(UIView);
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    return allocAndInit(UIView);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID =@"MeCell";
    MeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:cellH cellWidth:frameWidth(self.tableView)];
        
        
    }
    NSDictionary *dict = self.datas[indexPath.row];
    if ([dict[@"viewController"] isEqualToString:@"NotificationViewController"]) {
        cell.message.hidden = !modal.newmsg;
    }
    else
    {
        cell.message.hidden = YES;
    }
    if ([dict[@"viewController"] isEqualToString:@"MyKuaJieVC"]) {
        cell.detail.hidden = NO;
        cell.detail.text = modal.demandline;
    }
    else
    {
        cell.detail.hidden = YES;
    }
    if (indexPath.row ==3) {
        
        cell.authen.hidden = NO;
        
        
        switch (modal.authen) {
            case AuthenTypeNo:
                cell.authen.text = @"未认证";
                break;
            case AuthenTypeIng:
                cell.authen.text = @"认证中";
                break;
            case AuthenTypeYes:
                cell.authen.text = @"已认证";
                break;
            case AuthenTypeOther:
                cell.authen.text = @"被驳回";
            default:
                break;
        }
    }
    else
    {
        
        cell.authen.hidden = YES;
    }
    
    [cell setLeftImage:dict[@"image"] Title:dict[@"name"] isShowLine:[dict[@"show"] boolValue]];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = self.datas[indexPath.row];
    
    if ([dict[@"viewController"] hasPrefix:@"http://"]) {
        
        return;
    }
    if (NSClassFromString(dict[@"viewController"])) {
        
        [[ToolManager shareInstance].drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            
            UITabBarController *tabBar = (UITabBarController *)[ToolManager shareInstance].drawerController.centerViewController;
            UINavigationController *nav =(UINavigationController *)tabBar.viewControllers[getAppDelegate().mainTab.selectedIndex];
            
            if ([dict[@"viewController"] isEqualToString:@"AuthenticationHomeViewController"]) {
                AuthenticationHomeViewController *authen = allocAndInit(AuthenticationHomeViewController);
                authen.authen = modal.authen;
                [nav pushViewController:authen animated:YES];
                return ;
            }
            
            [nav pushViewController:allocAndInit((NSClassFromString(dict[@"viewController"] )))animated:YES];
            
        }];
        
        
    }
    else
    {
        [[ToolManager shareInstance] showAlertMessage:@"暂未开放"];
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
