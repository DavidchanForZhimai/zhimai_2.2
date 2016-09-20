//
//  InviteFriendsViewController.m
//  Lebao
//
//  Created by David on 16/3/15.
//  Copyright © 2016年 David. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "XLDataService.h"
#import "QRCodeGenerator.h"//二维码
#import "M80AttributedLabel.h"
#import "GeneratePosterViewController.h"
#import "RankingInvitedtalentViewController.h"
#import "NSString+Extend.h"
//我的URL ：appinterface/personal
#define PersonalURL [NSString stringWithFormat:@"%@user/invite",HttpURL]
#define PosterURL [NSString stringWithFormat:@"%@user/poster",HttpURL]
@interface InviteFriendsViewController ()<UITableViewDataSource,UITableViewDelegate,M80AttributedLabelDelegate>
@property(nonatomic,strong)NSMutableArray *inviteFriendsArray;
@property(nonatomic,strong)UITableView *inviteFriendsView;
@property(nonatomic,strong)UITableView *myInstructionsView;
@property(nonatomic,strong)BaseButton *scoredRecord;
@property(nonatomic,strong)UILabel *scoredRecordLb;
@property(nonatomic,strong)BaseButton *instructions;
@property(nonatomic,strong)UILabel *instructionsLb;

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
//    BaseButton *_inviteFriends = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 50, StatusBarHeight, 50, NavigationBarHeight) backgroundImage:nil iconImage:[UIImage imageNamed:@"daren"] highlightImage:nil inView:self.view];
//    __weak typeof(self) weakSelf = self;
//    _inviteFriends.didClickBtnBlock = ^
//    {
//        PushView(weakSelf, allocAndInit(RankingInvitedtalentViewController));
//    };
  
}

#pragma mark
#pragma mark - addTableView -
- (void)addTableView
{
    _inviteFriendsArray= [NSMutableArray new];
    _inviteFriendsView =[[UITableView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)) style:UITableViewStyleGrouped];
    _inviteFriendsView.delegate = self;
    _inviteFriendsView.dataSource = self;
    _inviteFriendsView.backgroundColor =[UIColor clearColor];
    _inviteFriendsView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_inviteFriendsView];
    
    
    _myInstructionsView =[[UITableView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)) style:UITableViewStyleGrouped];
    _myInstructionsView.delegate = self;
    _myInstructionsView.dataSource = self;
    _myInstructionsView.backgroundColor =[UIColor clearColor];
    _myInstructionsView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myInstructionsView];
    
    self.inviteFriendsView.hidden = NO;
    self.myInstructionsView.hidden = YES;
    
}
- (UIView *)headerView
{
    UIView *headView = allocAndInitWithFrame(UIView, frame(0, 0, APPWIDTH, 155*ScreenMultiple + 260));
    headView.backgroundColor =WhiteColor;
    UIImageView *imageViewbg =allocAndInitWithFrame(UIImageView, frame(0, 0, APPWIDTH, 155*ScreenMultiple));
    imageViewbg.image = [UIImage imageNamed:@"icon_ me_invitefriends"];
    [headView addSubview:imageViewbg];
//    df493f
    UILabel * inviteLable = [UILabel createLabelWithFrame:frame((APPWIDTH - 94)/2.0, 155*ScreenMultiple  -47, 94, 94) text:[NSString stringWithFormat:@"邀请码\n%@\n",modal.invitecode] fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:imageViewbg];
    inviteLable.backgroundColor = WhiteColor;
    [inviteLable setRound];
    inviteLable.numberOfLines = 0;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:inviteLable.text];
    
    [str addAttribute:NSFontAttributeName
                value:Size(32)
                range:[inviteLable.text  rangeOfString:@"邀请码"]];
    inviteLable.attributedText = str;

    if (modal.invitecode&&![modal.invitecode isEqualToString:@""]) {
        [str addAttribute:NSForegroundColorAttributeName
                    value:hexColor(df493f)
                    range:[inviteLable.text  rangeOfString:modal.invitecode]];
        
        [str addAttribute:NSFontAttributeName
                    value:Size(38)
                    range:[inviteLable.text  rangeOfString:modal.invitecode]];
        inviteLable.attributedText = str;

    }
    
    [inviteLable setBorder:hexColor(df493f) width:3];
    
    //二维码
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((APPWIDTH - 100)/2.0, CGRectGetMaxY(inviteLable.frame) + 10, 100, 100)];
    if (modal.inviteurl &&![modal.inviteurl isEqualToString:@""] ) {
         imageView.image = [QRCodeGenerator qrImageForString:modal.inviteurl imageSize:imageView.bounds.size.width];
        [headView addSubview:imageView];
    }
    
    //生成海报
    BaseButton *haibao = [[BaseButton alloc]initWithFrame:frame(APPWIDTH/3.0, CGRectGetMaxY(imageView.frame) + 10, APPWIDTH/3.0, 30) setTitle:@"生成海报" titleSize:28*SpacedFonts titleColor:WhiteColor textAlignment:NSTextAlignmentCenter backgroundColor:AppMainColor inView:headView];
    [haibao setRadius:5];
    haibao.didClickBtnBlock = ^
    {
        [[ToolManager shareInstance] showWithStatus:@"生成海报中..."];
        NSMutableDictionary *param = [Parameter parameterWithSessicon];
        [param setValue:modal.invitecode forKey:@"invite"];
//        NSLog(@"param =%@",param);
        [XLDataService postWithUrl:PosterURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
            if (dataObj) {
//                NSLog(@"dataObj =%@",dataObj);
                if ([dataObj[@"rtcode"] integerValue]==1) {
                    [[ToolManager shareInstance] dismiss];
                    
                    GeneratePosterViewController *poster = allocAndInit(GeneratePosterViewController);
                    poster.url =dataObj[@"datas"];
                    PushView(self, poster);
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
        
        
    };
    

    UIView *segment = allocAndInitWithFrame(UIView, frame(0, frameHeight(headView) - 50, APPWIDTH, 40));
    segment.backgroundColor =WhiteColor;
    [headView addSubview:segment];
    
    __weak InviteFriendsViewController *weakSelf =self;
    
    _scoredRecord = [[BaseButton alloc]initWithFrame:frame(0, 0, frameWidth(segment)/2.0, frameHeight(segment)) setTitle:[NSString stringWithFormat:@"成功邀请(%@)",modal.count] titleSize:26*SpacedFonts titleColor:AppMainColor textAlignment:NSTextAlignmentCenter backgroundColor:hexColor(dae9f7) inView:segment];

    
    _instructions = [[BaseButton alloc]initWithFrame:frame(frameWidth(segment)/2.0, 0, frameWidth(segment)/2.0, frameHeight(segment)) setTitle:@"说明" titleSize:26*SpacedFonts titleColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:WhiteColor inView:segment];
    _scoredRecordLb = allocAndInitWithFrame(UILabel, frame(0, 0, frameWidth(segment)/2.0, 4));
    
    [segment addSubview:_scoredRecordLb];
    
    _instructionsLb =allocAndInitWithFrame(UILabel, frame(frameWidth(segment)/2.0, 0, frameWidth(segment)/2.0, 4));
    [segment addSubview:_instructionsLb];
    
    if (_selected ==0) {
        [weakSelf.scoredRecord setTitleColor:AppMainColor forState:UIControlStateNormal];
        [weakSelf.scoredRecord setBackgroundColor:hexColor(dae9f7)];
        [weakSelf.instructions setTitleColor:LightBlackTitleColor forState:UIControlStateNormal];
        [weakSelf.instructions setBackgroundColor:WhiteColor];
        _instructionsLb.backgroundColor = WhiteColor;
        _scoredRecordLb.backgroundColor = AppMainColor;
    }
    else
    {
        [weakSelf.instructions setTitleColor:AppMainColor forState:UIControlStateNormal];
        [weakSelf.instructions setBackgroundColor:hexColor(dae9f7)];
        [weakSelf.scoredRecord setTitleColor:LightBlackTitleColor forState:UIControlStateNormal];
        [weakSelf.scoredRecord setBackgroundColor:WhiteColor];
        
        _instructionsLb.backgroundColor = AppMainColor;
        _scoredRecordLb.backgroundColor = WhiteColor;
    }
    
    
    _scoredRecord.didClickBtnBlock = ^
    {
        _selected = 0;
        [weakSelf.scoredRecord setTitleColor:AppMainColor forState:UIControlStateNormal];
        [weakSelf.scoredRecord setBackgroundColor:hexColor(dae9f7)];
        [weakSelf.instructions setTitleColor:LightBlackTitleColor forState:UIControlStateNormal];
        [weakSelf.instructions setBackgroundColor:WhiteColor];
        
        weakSelf.instructionsLb.backgroundColor = WhiteColor;
        weakSelf.scoredRecordLb.backgroundColor = AppMainColor;
        [weakSelf.inviteFriendsView reloadData];
        [weakSelf.myInstructionsView reloadData];
        weakSelf.inviteFriendsView.hidden = NO;
        weakSelf.myInstructionsView.hidden = YES;
        
        
    };
    
    
    _instructions.didClickBtnBlock = ^
    {
        _selected = 1;
        [weakSelf.instructions setTitleColor:AppMainColor forState:UIControlStateNormal];
        [weakSelf.instructions setBackgroundColor:hexColor(dae9f7)];
        [weakSelf.scoredRecord setTitleColor:LightBlackTitleColor forState:UIControlStateNormal];
        [weakSelf.scoredRecord setBackgroundColor:WhiteColor];
        
        weakSelf.instructionsLb.backgroundColor = AppMainColor;
        weakSelf.scoredRecordLb.backgroundColor = WhiteColor;
        
        [weakSelf.inviteFriendsView  reloadData];
        [weakSelf.myInstructionsView reloadData];
        weakSelf.myInstructionsView.hidden = NO;
        weakSelf.inviteFriendsView.hidden = YES;
        
    };
    
    UIView *lineView = allocAndInitWithFrame(UIView, frame(0, frameHeight(headView) - 10, APPWIDTH, 10));
    lineView.backgroundColor =AppViewBGColor;
    [headView addSubview:lineView];
    
    return headView;
}
#pragma mark
#pragma mark - netWork-
- (void)netWork:(BOOL)isRefresh isFooter:(BOOL)isFooter isShouldClear:(BOOL)isShouldClear
{
    
    NSMutableDictionary *parame = [Parameter parameterWithSessicon];
    [[ToolManager shareInstance] showWithStatus];
  
    [XLDataService postWithUrl:PersonalURL param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
      //  NSLog(@"dataObj===%@",dataObj);
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
                
                [_inviteFriendsView reloadData];
                [_myInstructionsView reloadData];
                
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
#pragma mark - TableViewDelegate TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_selected ==0) {
        return _inviteFriendsArray.count;
    }
    return 1;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 155*ScreenMultiple + 260;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return [self headerView];
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
    if (_selected ==0) {
        return 35;
    }
    
    UILabel * label = allocAndInit(UILabel);
    CGSize  size = [label sizeWithMultiLineContent:modal.desc rowWidth:APPWIDTH - 20 font:Size(24)];
    return size.height + 50 ;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selected ==0) {
        static NSString *cellID =@"InviteFriendsCell";
        InviteFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[InviteFriendsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:35 cellWidth:frameWidth(_inviteFriendsView)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        InviteFriendsDatas *data = _inviteFriendsArray[indexPath.row];
        BOOL isFirst = NO;
        if (indexPath.row==0) {
            isFirst = YES;
        }
        else
        {
            isFirst = NO;
        }
        [cell dataModal:data isFirst:isFirst];
        return cell;
    }
    
    static NSString *cellID =@"tableViewCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *title = [UILabel createLabelWithFrame:frame(10, 0, 48*SpacedFonts, 30) text:@"说明" fontSize:24*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
        
        M80AttributedLabel *des= [[M80AttributedLabel alloc]initWithFrame:CGRectZero];
        des.textColor =LightBlackTitleColor;
        des.font = Size(24);
        des.linkColor = hexColor(df493f);
        des.underLineForLink = NO;
        UILabel * label = allocAndInit(UILabel);
        CGSize  size = [label sizeWithMultiLineContent:modal.desc rowWidth:APPWIDTH - 20 font:Size(24)];
         ;
        NSRange range   = [modal.desc rangeOfString:modal.test];
        des.text = modal.desc;
        [des addCustomLink:[NSValue valueWithRange:range]
                    forRange:range];
        des.frame =frame(frameX(title), 30, APPWIDTH - 2*frameX(title), size.height + 30);
        des.delegate = self;
        [cell addSubview:des];
        
    }
    
    return cell;
    
    
    
}
#pragma mark
#pragma mark m80AttributedLabel Delegate
- (void)m80AttributedLabel:(M80AttributedLabel *)label
             clickedOnLink:(id)linkData
{
    [[ToolManager shareInstance]loadWebViewWithUrl:modal.testurl title:modal.test pushView:self rightBtn:nil];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
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
@implementation InviteFriendsCell
{

    UILabel   *_userName;
    UILabel   *_tel;
    UILabel   *_time;
    UILabel   *_status;
    UILabel   *_line;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor =[UIColor whiteColor];
        self.selectionStyle =  UITableViewCellSelectionStyleNone;
        
        
        _userName = [UILabel createLabelWithFrame:frame(0, 0, frameWidth(self)/4.0 - 10, cellHeight) text:@"" fontSize:24*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentCenter inView:self];
        
         _tel = [UILabel createLabelWithFrame:frame(CGRectGetMaxX(_userName.frame), frameY(_userName), frameWidth(_userName) + 20, frameHeight(_userName)) text:@"" fontSize:24*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentCenter inView:self];
        
         _time = [UILabel createLabelWithFrame:frame(CGRectGetMaxX(_tel.frame), frameY(_tel), frameWidth(_userName) + 20, frameHeight(_tel)) text:@"" fontSize:24*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentCenter inView:self];
        
         _status = [UILabel createLabelWithFrame:frame(CGRectGetMaxX(_time.frame), frameY(_time), frameWidth(_userName), frameHeight(_time)) text:@"" fontSize:24*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentCenter inView:self];
        
        _line = [UILabel CreateLineFrame:frame(0, cellHeight -  1, cellWidth, 1) inView:self];
        _line.hidden = YES;
    }
    
    return self;
}


- (void)dataModal:(InviteFriendsDatas *)modal isFirst:(BOOL)isFirst {
    
    _line.hidden = YES;
    if (isFirst) {
       _line.hidden = NO;
    }
    _userName.text = modal.realname;
    
    _tel.text = [NSString stringWithFormat:@"%@",modal.tel];
    
    if ([modal.createtime intValue]>0) {
        _time.text =[modal.createtime timeformatString:@"yyyy-MM-dd"];
    }
    else
    {
        _time.text  = modal.createtime;
    }
    
    NSString *str = modal.authen;
    if ([modal.authen intValue]==1) {
       str = @"未认证";
    }
    if ([modal.authen intValue]==2) {
        str = @"认证中";
    }
    if ([modal.authen intValue]==3) {
        str = @"已认证";
    }
    if ([modal.authen intValue]==9) {
        str = @"被驳回";
    }
     _status.text = str;
    
}

@end