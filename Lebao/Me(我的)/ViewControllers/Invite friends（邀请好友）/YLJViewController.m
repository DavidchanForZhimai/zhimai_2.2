//
//  YLJViewController.m
//  Lebao
//
//  Created by David on 2016/10/26.
//  Copyright © 2016年 David. All rights reserved.
//

#import "YLJViewController.h"
#import "NSString+Extend.h"
@interface YLJViewController() <UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray *inviteFriendsArray;
@end
@implementation YLJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navView];
    [self addTableView];
    if (_datas) {
        _inviteFriendsArray = _datas;
         [self.inviteFriendsView reloadData];
    }
    
}
#pragma mark - Navi_View
- (void)navView
{
    
    [self navViewTitleAndBackBtn:@"累计邀请记录"];
    
    
}

#pragma mark
#pragma mark - addTableView -
- (void)addTableView
{
   
    _inviteFriendsView =[[UITableView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)) style:UITableViewStyleGrouped];
    _inviteFriendsView.delegate = self;
    _inviteFriendsView.dataSource = self;
    _inviteFriendsView.backgroundColor =[UIColor clearColor];
    _inviteFriendsView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_inviteFriendsView];
    
    
}

#pragma mark
#pragma mark - TableViewDelegate TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _inviteFriendsArray.count;
    
    
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
    
    return [[UIView alloc]init];
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
  
    return 35;
   
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
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
