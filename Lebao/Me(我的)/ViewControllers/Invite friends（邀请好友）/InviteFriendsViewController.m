//
//  InviteFriendsViewController.m
//  Lebao
//
//  Created by David on 16/3/15.
//  Copyright © 2016年 David. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "XLDataService.h"
#import "YLJViewController.h"
#import "WetChatShareManager.h"
//我的URL ：appinterface/personal
#define PersonalURL [NSString stringWithFormat:@"%@user/invite",HttpURL]
@interface InviteFriendsViewController ()
@property(nonatomic,strong)NSMutableArray *inviteFriendsArray;
@property(nonatomic,strong)UITableView *inviteFriendsView;

@end

@implementation InviteFriendsModal
+ (NSDictionary *)mj_objectClassInArray
{
    
    return @{
             @"datas":@"InviteFriendsDatas",
             };
    
}
@end

@implementation InviteFriendsDatas


@end
@implementation InviteFriendsViewController
{
    NSMutableArray *_inviteFriendsArray;
    UITableView *_inviteFriendsView;
    int _selected;
    InviteFriendsModal *modal;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    [self navView];
    [self addTableView];
    [self netWork:NO isFooter:NO isShouldClear:NO];
    
}
#pragma mark - Navi_View
- (void)navView
{
   
    [self navViewTitleAndBackBtn:@"邀请好友"];

  
}

#pragma mark
#pragma mark - addTableView -
- (void)addTableView
{
    _inviteFriendsArray= [NSMutableArray new];
    _inviteFriendsView =[[UITableView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)) style:UITableViewStyleGrouped];
    _inviteFriendsView.backgroundColor =[UIColor clearColor];
    _inviteFriendsView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _inviteFriendsView.tableHeaderView = [self headerView];
    [self.view addSubview:_inviteFriendsView];
    
    
}
- (UIView *)headerView
{
    UIView *headView = allocAndInitWithFrame(UIView, frame(0, 0, APPWIDTH, 0));
    headView.backgroundColor =[UIColor clearColor];
    UIImage  *image = [UIImage imageNamed:@"icon_ me_invitefriends"];
    UIImageView *imageViewbg =allocAndInitWithFrame(UIImageView, frame(0, 0, APPWIDTH,image.size.height/image.size.width*APPWIDTH));
    imageViewbg.image = image;
    [headView addSubview:imageViewbg];
//    邀请码
    NSString * invitecode=@"";
    if (modal.invitecode&&modal.invitecode.length>0) {
        invitecode = [NSString stringWithFormat:@"\n%@",modal.invitecode];
    }
    UILabel * inviteLable = [UILabel createLabelWithFrame:frame((APPWIDTH - 94)/2.0, imageViewbg.height -97*0.4, 94, 94) text:[NSString stringWithFormat:@"邀请码%@",invitecode] fontSize:26*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentCenter inView:imageViewbg];
    inviteLable.backgroundColor = WhiteColor;
    [inviteLable setRound];
    inviteLable.numberOfLines = 0;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:inviteLable.text];
    
    [str addAttribute:NSForegroundColorAttributeName
                    value:AppMainColor
                    range:[inviteLable.text  rangeOfString:invitecode]];
        
    [str addAttribute:NSFontAttributeName
                    value:Size(38)
                    range:[inviteLable.text  rangeOfString:invitecode]];
    inviteLable.attributedText = str;

    
    
    [inviteLable setBorder:AppMainColor width:3];
    
    //已累计邀请
    NSString * count=@"";
    if (modal.count&&modal.count.length>0) {
        count = [NSString stringWithFormat:@"%@人\n",modal.count];
    }
    UILabel * hasInvitecode = [UILabel createLabelWithFrame:frame((APPWIDTH - 120)/2.0, CGRectGetMaxY(inviteLable.frame)+ 45, 120, 67) text:[NSString stringWithFormat:@"%@已累计邀请",count] fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:headView];
    hasInvitecode.backgroundColor = WhiteColor;
    [hasInvitecode setRadius:5];
    [hasInvitecode setBorder:LineBg width:0.5];
     hasInvitecode.numberOfLines = 0;
    
    NSMutableAttributedString *hasstr = [[NSMutableAttributedString alloc] initWithString:hasInvitecode.text];
    
    [hasstr addAttribute:NSForegroundColorAttributeName
                value:[UIColor colorWithRed:0.9878 green:0.6834 blue:0.11 alpha:1.0]
                range:[hasInvitecode.text  rangeOfString:count]];
    
    [hasstr addAttribute:NSFontAttributeName
                value:Size(50)
                range:[hasInvitecode.text  rangeOfString:count]];
    hasInvitecode.attributedText = hasstr;
    hasInvitecode.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hasInvitecodeTap:)];
    tap.numberOfTapsRequired = 1;
    [hasInvitecode addGestureRecognizer:tap];

    //立即邀请
    BaseButton *lijiqiaoqing = [[BaseButton alloc]initWithFrame:frame(30*ScreenMultiple, CGRectGetMaxY(hasInvitecode.frame) + 45, APPWIDTH-60*ScreenMultiple, 40*ScreenMultiple) setTitle:@"立即邀请" titleSize:32*SpacedFonts titleColor:WhiteColor textAlignment:NSTextAlignmentCenter backgroundColor:AppMainColor inView:headView];
    [lijiqiaoqing setRadius:5];
    __weak typeof(self) weakSelf = self;
    lijiqiaoqing.didClickBtnBlock = ^
    {
        if (modal.url&&modal.url.length>0) {
            [[WetChatShareManager shareInstance] dynamicShareTo:modal.title desc:modal.content image:weakSelf.shareImage shareurl:modal.url];
        }
        else
        {
            [[ToolManager shareInstance] showAlertMessage:@"分享数据错误"];
        }
        
    };
    
    headView.frame = CGRectMake(headView.x, headView.y, headView.width, CGRectGetMaxY(lijiqiaoqing.frame)+ 20);
    return headView;
}
#pragma mark
#pragma mark - hasInvitecodeTap
- (void)hasInvitecodeTap:(UITapGestureRecognizer *)sender
{
    if (self.inviteFriendsArray.count>0) {
        YLJViewController *vc = [[YLJViewController alloc]init];
        vc.datas = self.inviteFriendsArray;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [[ToolManager shareInstance] showAlertMessage:@"没有邀请数据"];
    }
    

}
#pragma mark
#pragma mark - netWork-
- (void)netWork:(BOOL)isRefresh isFooter:(BOOL)isFooter isShouldClear:(BOOL)isShouldClear
{
    
    NSMutableDictionary *parame = [Parameter parameterWithSessicon];
    [[ToolManager shareInstance] showWithStatus];
  
    [XLDataService postWithUrl:PersonalURL param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        NSLog(@"dataObj===%@",dataObj);
        if (dataObj) {
            modal = [InviteFriendsModal mj_objectWithKeyValues:dataObj];
            
            
            if (modal.rtcode ==1) {
              
                for (InviteFriendsDatas *data in modal.datas) {
                    
                    if (_inviteFriendsArray.count ==0) {
                        InviteFriendsDatas *data = allocAndInit(InviteFriendsDatas);
                        data.realname = @"昵称";
                        data.tel = @"号码";
                        data.createtime = @"时间";
                        data.authen = @"状态";
                        [_inviteFriendsArray addObject:data];
                        
                    }
                    [_inviteFriendsArray addObject:data];
                }
                
                [_inviteFriendsView beginUpdates];
                _inviteFriendsView.tableHeaderView = [self headerView];
                [_inviteFriendsView endUpdates];
                [[ToolManager shareInstance] dismiss];
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
