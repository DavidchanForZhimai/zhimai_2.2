//
//  MyCrossBroderViewController.m
//  Lebao
//
//  Created by David on 16/4/5.
//  Copyright © 2016年 David. All rights reserved.
//

#import "MyCrossBroderViewController.h"
#import "MyCrossBroderView.h"
#define tabsTotal  2
#define tabsHeight  40.0
#import "NSString+Extend.h"
#import "CrossBorderTransmissionViewController.h"//红包转发详情
#import "WetChatShareManager.h"
#import "GJGCChatFriendViewController.h"
@interface MyCrossBroderViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)BaseButton *hasEarnMoney;
@property(nonatomic,strong)BaseButton *hasReward;

@property(nonatomic,strong)MyCrossBroderView *hasEarnMoneyView;
@property(nonatomic,strong)MyCrossBroderView *hasRewardView;
@end

@implementation MyCrossBroderViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navView];
    [self mainview];
    
   
}
#pragma mark - Navi_View
- (void)navView
{
    
    [self navViewTitleAndBackBtn:@"红包转发"];
    
}
#pragma mark - main_view
- (void)mainview{
    
    _hasEarnMoney = [[BaseButton alloc]initWithFrame:frame(0, NavigationBarHeight + StatusBarHeight, APPWIDTH/tabsTotal, tabsHeight) setTitle:@"已赚00.00元" titleSize:28*SpacedFonts titleColor:AppMainColor backgroundImage:nil iconImage:[UIImage imageNamed:@"me_mycross_icon_hasreward_press"] highlightImage:[UIImage imageNamed:@"me_mycross_icon_hasreward_normal"] setTitleOrgin:CGPointMake(12,(APPWIDTH/tabsTotal - 12 - 6*24*SpacedFonts)/2.0 + 5 ) setImageOrgin:CGPointMake(12,(APPWIDTH/tabsTotal - 12 - 6*24*SpacedFonts)/2.0 ) inView:self.view];
 
    _hasReward = [[BaseButton alloc]initWithFrame:frame(APPWIDTH/tabsTotal, NavigationBarHeight + StatusBarHeight, APPWIDTH/tabsTotal, tabsHeight) setTitle:@"已发00.00元" titleSize:28*SpacedFonts titleColor:hexColor(838383) backgroundImage:nil iconImage:[UIImage imageNamed:@"me_mycross_icon_hasfa_normal"] highlightImage: [UIImage imageNamed:@"me_mycross_icon_hasfa_press"]setTitleOrgin:CGPointMake(12,(APPWIDTH/tabsTotal - 12 - 6*24*SpacedFonts)/2.0 + 3 ) setImageOrgin:CGPointMake(12,(APPWIDTH/tabsTotal - 12 - 6*24*SpacedFonts)/2.0 ) inView:self.view];
    
     _hasReward.backgroundColor = _hasEarnMoney.backgroundColor =[UIColor whiteColor];
    
    _mainScrollView = allocAndInitWithFrame(UIScrollView, frame(0, CGRectGetMaxY(_hasEarnMoney.frame) , APPWIDTH, APPHEIGHT - (CGRectGetMaxY(_hasEarnMoney.frame))));
    _mainScrollView.backgroundColor = [UIColor clearColor];
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.contentSize = CGSizeMake(APPWIDTH*tabsTotal, frameHeight(_mainScrollView));
//    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    
    __weak MyCrossBroderViewController *weakSelf= self;
   _hasEarnMoneyView = [[MyCrossBroderView alloc]initWithFrame:frame(0, 0, APPWIDTH, frameHeight(_mainScrollView)) selectedIndex:0 moneyBlock:^(NSString *rewardreleasesum,NSString *rewardforwardsum) {
//       NSLog(@"str =%@",rewardreleasesum);
       [weakSelf.hasEarnMoney setTitle:[NSString stringWithFormat:@"已赚%@元",rewardforwardsum] forState:UIControlStateNormal];
       [_hasEarnMoney textAndImageCenter];
    } didCellBlock:^(MyCrossBroderRelease *myCrossBroderRelease,MyCrossBroderRewardforwards*myCrossBroderRewardforwards,MyCrossBroderCell *cell){
        
        if ([myCrossBroderRewardforwards.actype isEqualToString:@"article"]) {
        CrossBorderTransmissionViewController *crossBorderTransmissionViewController = allocAndInit(CrossBorderTransmissionViewController);

        crossBorderTransmissionViewController.ID= [NSString stringWithFormat:@"%i",(int)myCrossBroderRewardforwards.acid];

        crossBorderTransmissionViewController.nav_title = @"详情";
        crossBorderTransmissionViewController.actype = myCrossBroderRewardforwards.actype;
        crossBorderTransmissionViewController.industry = myCrossBroderRewardforwards.industry;
            crossBorderTransmissionViewController.shareImage = cell.cellIcon.image;
        crossBorderTransmissionViewController.uid = [NSString stringWithFormat:@"%i",(int)myCrossBroderRewardforwards.uid];
        PushView(self, crossBorderTransmissionViewController);
        }
       else [[ToolManager shareInstance]showAlertMessage:@"已无相关数据！！"];

        
        
    } communityBlock:^(MyCrossBroderRewardforwards*myCrossBroderRewardforwards,MyCrossBroderRelease *myCrossBroderRelease) {
       
        
        GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc]init];
        talk.talkType = GJGCChatFriendTalkTypePrivate;
        talk.toId = [NSString stringWithFormat:@"%i",(int)myCrossBroderRewardforwards.acid];
        GJGCChatFriendViewController *privateChat = [[GJGCChatFriendViewController alloc]initWithTalkInfo:talk];
        privateChat.type = MeeageTypeRedPage;
        privateChat.receiver = [NSString stringWithFormat:@"%i",(int)myCrossBroderRewardforwards.uid];
        [self.navigationController pushViewController:privateChat animated:YES];


    }];
    
    
    _hasRewardView = [[MyCrossBroderView alloc]initWithFrame:frame(CGRectGetMaxX(_hasEarnMoneyView.frame), 0, APPWIDTH, frameHeight(_mainScrollView))selectedIndex:1  moneyBlock:^(NSString *rewardreleasesum,NSString *rewardforwardsum) {
        
        [weakSelf.hasReward setTitle:[NSString stringWithFormat:@"已发%@元",rewardreleasesum] forState:UIControlStateNormal];
        
        [_hasReward textAndImageCenter];
      

        
    } didCellBlock:^(MyCrossBroderRelease *myCrossBroderRelease,MyCrossBroderRewardforwards*myCrossBroderRewardforwards,MyCrossBroderCell *cell){
        
        if ([myCrossBroderRelease.actype isEqualToString:@"article"]) {
            CrossBorderTransmissionViewController *crossBorderTransmissionViewController = allocAndInit(CrossBorderTransmissionViewController);
            
            crossBorderTransmissionViewController.ID= [NSString stringWithFormat:@"%i",(int)myCrossBroderRelease.ID];
            
            crossBorderTransmissionViewController.nav_title = @"详情";
            crossBorderTransmissionViewController.actype = myCrossBroderRelease.actype;
            crossBorderTransmissionViewController.industry = myCrossBroderRelease.industry;
            crossBorderTransmissionViewController.uid = [NSString stringWithFormat:@"%i",(int)myCrossBroderRelease.uid];
            crossBorderTransmissionViewController.shareImage = cell.cellIcon.image;
            PushView(self, crossBorderTransmissionViewController);
        }
        else [[ToolManager shareInstance]showAlertMessage:@"已无相关数据！！"];
    } communityBlock:^(MyCrossBroderRewardforwards*myCrossBroderRewardforwards,MyCrossBroderRelease *myCrossBroderRelease) {
        

        GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc]init];
        talk.talkType = GJGCChatFriendTalkTypePrivate;
        talk.toId = [NSString stringWithFormat:@"%i",(int)myCrossBroderRelease.ID];
        GJGCChatFriendViewController *privateChat = [[GJGCChatFriendViewController alloc]initWithTalkInfo:talk];
        privateChat.type = MeeageTypeRedPage;
        privateChat.receiver =[NSString stringWithFormat:@"%i",(int)myCrossBroderRelease.uid];
        [self.navigationController pushViewController:privateChat animated:YES];

        
    }];
  
    _hasRewardView.backgroundColor = _hasEarnMoneyView.backgroundColor = [UIColor clearColor];
    
    [_mainScrollView addSubview:_hasEarnMoneyView];
    [_mainScrollView addSubview:_hasRewardView];
    
    
    _hasEarnMoney.didClickBtnBlock = ^
    {
        [weakSelf.hasEarnMoney setImage:[UIImage imageNamed:@"me_mycross_icon_hasreward_press"] forState:UIControlStateNormal];
        [weakSelf.hasEarnMoney setImage:[UIImage imageNamed:@"me_mycross_icon_hasreward_normal"] forState:UIControlStateHighlighted];
        [weakSelf.hasReward setImage:[UIImage imageNamed:@"me_mycross_icon_hasfa_normal"] forState:UIControlStateNormal];
        [weakSelf.hasReward setImage:[UIImage imageNamed:@"me_mycross_icon_hasfa_press"] forState:UIControlStateHighlighted];
        
        [weakSelf.hasEarnMoney setTitleColor:AppMainColor forState:UIControlStateNormal];
        [weakSelf.hasEarnMoney setTitleColor:hexColor(838383) forState:UIControlStateHighlighted];
        [weakSelf.hasReward setTitleColor:hexColor(838383) forState:UIControlStateNormal];
        [weakSelf.hasReward setTitleColor:AppMainColor forState:UIControlStateHighlighted];
        
        [weakSelf.mainScrollView scrollRectToVisible:frame(0, frameX(weakSelf.mainScrollView), frameWidth(weakSelf.mainScrollView), frameHeight(weakSelf.mainScrollView)) animated:YES];
        
    };
    _hasReward.didClickBtnBlock = ^
    {
        [weakSelf.hasEarnMoney setImage:[UIImage imageNamed:@"me_mycross_icon_hasreward_normal"] forState:UIControlStateNormal];
        [weakSelf.hasEarnMoney setImage:[UIImage imageNamed:@"me_mycross_icon_hasreward_press"] forState:UIControlStateHighlighted];
        [weakSelf.hasReward setImage:[UIImage imageNamed:@"me_mycross_icon_hasfa_press"] forState:UIControlStateNormal];
        [weakSelf.hasReward setImage:[UIImage imageNamed:@"me_mycross_icon_hasfa_normal"] forState:UIControlStateHighlighted];
        
        [weakSelf.hasEarnMoney setTitleColor:hexColor(838383) forState:UIControlStateNormal];
        [weakSelf.hasEarnMoney setTitleColor:AppMainColor forState:UIControlStateHighlighted];
        [weakSelf.hasReward setTitleColor:AppMainColor forState:UIControlStateNormal];
        [weakSelf.hasReward setTitleColor:hexColor(838383) forState:UIControlStateHighlighted];
        [weakSelf.mainScrollView scrollRectToVisible:frame(APPWIDTH, frameX(weakSelf.mainScrollView), frameWidth(weakSelf.mainScrollView), frameHeight(weakSelf.mainScrollView)) animated:YES];
    };
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(APPWIDTH/2.0,_hasEarnMoney.y ,0.5, _hasEarnMoney.height)];
    line.backgroundColor = AppViewBGColor;
    [self.view addSubview:line];
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x/APPWIDTH ==0) {
        [self.hasEarnMoney setImage:[UIImage imageNamed:@"me_mycross_icon_hasreward_press"] forState:UIControlStateNormal];
        [self.hasEarnMoney setImage:[UIImage imageNamed:@"me_mycross_icon_hasreward_normal"] forState:UIControlStateHighlighted];
        [self.hasReward setImage:[UIImage imageNamed:@"me_mycross_icon_hasfa_normal"] forState:UIControlStateNormal];
        [self.hasReward setImage:[UIImage imageNamed:@"me_mycross_icon_hasfa_press"] forState:UIControlStateHighlighted];
        
        [self.hasEarnMoney setTitleColor:AppMainColor forState:UIControlStateNormal];
        [self.hasEarnMoney setTitleColor:hexColor(838383) forState:UIControlStateHighlighted];
        [self.hasReward setTitleColor:hexColor(838383) forState:UIControlStateNormal];
        [self.hasReward setTitleColor:AppMainColor  forState:UIControlStateHighlighted];
        
    }
    else if (scrollView.contentOffset.x/APPWIDTH ==1) {
        [self.hasEarnMoney setImage:[UIImage imageNamed:@"me_mycross_icon_hasreward_normal"] forState:UIControlStateNormal];
        [self.hasEarnMoney setImage:[UIImage imageNamed:@"me_mycross_icon_hasreward_press"] forState:UIControlStateHighlighted];
        [self.hasReward setImage:[UIImage imageNamed:@"me_mycross_icon_hasfa_press"] forState:UIControlStateNormal];
        [self.hasReward setImage:[UIImage imageNamed:@"me_mycross_icon_hasfa_normal"] forState:UIControlStateHighlighted];
        
        [self.hasEarnMoney setTitleColor:hexColor(838383) forState:UIControlStateNormal];
        [self.hasEarnMoney setTitleColor:AppMainColor forState:UIControlStateHighlighted];
        [self.hasReward setTitleColor:AppMainColor forState:UIControlStateNormal];
        [self.hasReward setTitleColor:hexColor(838383) forState:UIControlStateHighlighted];
    }
    
    
    
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
