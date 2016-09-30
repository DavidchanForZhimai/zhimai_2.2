//
//  InvateFriendCommentViewController.m
//  Lebao
//
//  Created by David on 16/9/29.
//  Copyright © 2016年 David. All rights reserved.
//

#import "InvateFriendCommentViewController.h"
#import "XLDataService.h"
#import "BaseModal.h"
#import "LWLayout.h"
#import "LWTextParser.h"
#import "LWAsyncDisplayView.h"
#import "WetChatShareManager.h"
#define UserMemberBriefs [NSString stringWithFormat:@"%@user/member-brief",HttpURL]

@interface InvateFriendCommentModel : BaseModal
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *area;
@property(nonatomic,copy)NSString *imgurl;
@property(nonatomic,copy)NSString *realname;
@property(nonatomic,copy)NSString *workyears;
@property(nonatomic,copy)NSString *position;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *share_url;
@property(assign)BOOL vip;
@property(nonatomic,copy)NSString *authen;

@end
@implementation InvateFriendCommentModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}
@end

@interface InvateFriendCommentViewLayout : LWLayout
@property(nonatomic,assign)float height;
@property(nonatomic,strong)LWImageStorage *avatarStorage;
- (InvateFriendCommentViewLayout *)initCellWithFrame:(CGRect)frame LayoutWithModel:(InvateFriendCommentModel *)model;
@end


@implementation InvateFriendCommentViewLayout


- (InvateFriendCommentViewLayout *)initCellWithFrame:(CGRect)frame LayoutWithModel:(InvateFriendCommentModel *)model;
{
    self = [super init];
    if (self) {
        //用户头像
        _avatarStorage = [[LWImageStorage alloc]initWithIdentifier:@"avatar"];
        _avatarStorage.frame = CGRectMake((frame.size.width - 44)/2.0, 13, 44, 44);
        model.imgurl = [[ToolManager shareInstance] urlAppend:model.imgurl];
        //        NSLog(@"model.imgurl  =%@",model.imgurl );
        _avatarStorage.contents = model.imgurl;
        _avatarStorage.placeholder = [UIImage imageNamed:@"defaulthead"];
        if ([model.imgurl isEqualToString:ImageURLS]) {
            
            _avatarStorage.contents = [UIImage imageNamed:@"defaulthead"];
            
        }
        _avatarStorage.cornerRadius = _avatarStorage.width/2.0;
        
        //用户名
        //名字模型 nameTextStorage
        LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
        nameTextStorage.text = model.realname;
        nameTextStorage.font = Size(28.0);
        nameTextStorage.textColor = BlackTitleColor;
        nameTextStorage.frame = CGRectMake(0, _avatarStorage.bottom + 8, frame.size.width , CGFLOAT_MAX);
        nameTextStorage.textAlignment = NSTextAlignmentCenter;
        //行业
        LWTextStorage* industryTextStorage = [[LWTextStorage alloc] init];
        if (model.address&&model.address.length>0) {
            industryTextStorage.text =[NSString stringWithFormat:@"%@\n",model.address];
        }
        if (model.position&&model.position.length>0) {
            industryTextStorage.text =[NSString stringWithFormat:@"%@%@  ",industryTextStorage.text,model.position];
        }
        if (model.workyears&&model.workyears.length>0) {
            industryTextStorage.text=[NSString stringWithFormat:@"%@从业%@年\n",industryTextStorage.text,model.workyears];
        }
        NSString *authen;
        if ([model.authen isEqualToString:@"3"]) {
            authen = @"[iconprofilerenzhen]";
        }
        else
        {
            authen = @"[iconprofileweirenzhen]";
        }
        NSString *vip;
        if (model.vip ) {
            vip = @"[iconprofilevip]";
        }
        else
        {
            vip = @"[iconprofilevipweikaitong]";
        }
        industryTextStorage.text =[NSString stringWithFormat:@"%@ %@ %@ ",industryTextStorage.text,authen,vip];
        
        industryTextStorage.textColor = [UIColor colorWithRed:0.549 green:0.5569 blue:0.5608 alpha:1.0];
        industryTextStorage.font = Size(24.0);
        industryTextStorage.frame = CGRectMake(nameTextStorage.left, nameTextStorage.bottom + 8, nameTextStorage.width, CGFLOAT_MAX);
        industryTextStorage.textAlignment = NSTextAlignmentCenter;
        [LWTextParser parseEmojiWithTextStorage:industryTextStorage];
        
        [self addStorage:_avatarStorage];
        [self addStorage:nameTextStorage];
        [self addStorage:industryTextStorage];
        self.height  = [self suggestHeightWithBottomMargin:10];
    }
    return self;
}
@end

@interface InvateFriendCommentViewController()
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIImageView *bgHead;
@property(nonatomic,strong)UIImageView *bg;

@property(nonatomic,strong)LWAsyncDisplayView *userView;
@property(nonatomic,strong)InvateFriendCommentViewLayout *headerViewLayout;

@property(nonatomic,strong)BaseButton *wxFriend;
@property(nonatomic,strong)BaseButton *wxTimeLine;
@property(nonatomic,strong)UIView *line;
@property(nonatomic,strong)UILabel *lb;
@property(nonatomic,strong)UILabel *lb2;
@property(nonatomic,strong)InvateFriendCommentModel *model;
@end
@implementation InvateFriendCommentViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self navViewTitleAndBackBtn:@"邀请好友评价"];
    [self.view addSubview:self.scrollView];
    [self netWork];
    
    
}
- (UIScrollView *)scrollView
{
    if (_scrollView) {
        return _scrollView;
    }
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, StatusBarHeight +NavigationBarHeight, APPWIDTH, APPHEIGHT - StatusBarHeight +NavigationBarHeight)];
    _scrollView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:self.bgHead];
    [_scrollView addSubview:self.bg];
    return _scrollView;
    
}
#pragma mark
#pragma mark- getters
- (UIImageView *)bgHead
{
    if (_bgHead) {
        return _bgHead;
    }
    UIImage *imagebg = [UIImage imageNamed:@"icon_friend_qinjia"];
    _bgHead = [[UIImageView alloc]initWithFrame:CGRectMake((APPWIDTH - imagebg.size.width)/2.0,  38*ScreenMultiple, imagebg.size.width, imagebg.size.height)];
    _bgHead.image = imagebg;
    return _bgHead;
}

- (UIImageView *)bg
{
    if (_bg) {
        return _bg;
    }
    UIImage *imagebg = [UIImage imageNamed:@"icon_friend_qiupingjia"];
    _bg = [[UIImageView alloc]initWithFrame:CGRectMake((APPWIDTH - imagebg.size.width)/2.0, CGRectGetMaxY(self.bgHead.frame)+ 20*ScreenMultiple , imagebg.size.width, imagebg.size.height)];
    _bg.image = imagebg;
    _bg.userInteractionEnabled = YES;

    if (CGRectGetMaxY(_bg.frame)+ 10>self.scrollView.height) {
        
        self.scrollView.contentSize = CGSizeMake(APPWIDTH, CGRectGetMaxY(_bg.frame)+ 10);
        
    }
    return _bg;
}
- (BaseButton *)wxFriend
{
    if (_wxFriend) {
        return _wxFriend;
    }
    
    UIImage *image = [UIImage imageNamed:@"icon_me_yinxiangweixing"];
    _wxFriend = [[BaseButton alloc]initWithFrame:CGRectMake(70*ScreenMultiple, _bg.height - 85*ScreenMultiple,48, image.size.height + 20) setTitle:@"微信好友" titleSize:12 titleColor:[UIColor colorWithRed:0.2941 green:0.5647 blue:0.9961 alpha:1.0] backgroundImage:nil iconImage:image highlightImage:image setTitleOrgin:CGPointMake(image.size.height + 8,  - image.size.width) setImageOrgin:CGPointMake(0, (48 - image.size.width)/2.0) inView:nil];
    __weak typeof(self) weakSelf = self;
    _wxFriend.didClickBtnBlock = ^
    {
        
        [[WetChatShareManager shareInstance] invateFriendShareTo:[NSString stringWithFormat:@"我是%@,来评价我吧",weakSelf.model.realname] desc:[NSString stringWithFormat:@"我想知道我%@在你眼里是什么样的人！",weakSelf.model.realname] image: weakSelf.headerViewLayout.avatarStorage.imageStorage shareurl:weakSelf.model.share_url type:ShareWxFriendType];
    };
    return _wxFriend;
}

- (BaseButton *)wxTimeLine
{
    if (_wxTimeLine) {
        return _wxTimeLine;
    }
    
    UIImage *image = [UIImage imageNamed:@"icon_me_yinxiangpenyouquan"];
    _wxTimeLine = [[BaseButton alloc]initWithFrame:CGRectMake(self.bg.width - 48-70*ScreenMultiple, _bg.height - 85*ScreenMultiple,48, image.size.height + 20) setTitle:@"朋友圈" titleSize:12 titleColor:[UIColor colorWithRed:0.2941 green:0.5647 blue:0.9961 alpha:1.0] backgroundImage:nil iconImage:image highlightImage:image setTitleOrgin:CGPointMake(image.size.height + 8,  6- image.size.width) setImageOrgin:CGPointMake(0, (48 - image.size.width)/2.0) inView:nil];
    __weak typeof(self) weakSelf = self;
    _wxTimeLine.didClickBtnBlock = ^
    {
       
         [[WetChatShareManager shareInstance] invateFriendShareTo:[NSString stringWithFormat:@"我是%@,来评价我吧",weakSelf.model.realname] desc:[NSString stringWithFormat:@"我想知道我%@在你眼里是什么样的人！",weakSelf.model.realname] image: weakSelf.headerViewLayout.avatarStorage.imageStorage shareurl:weakSelf.model.share_url type:ShareWxTimeLineType];
    };
    return _wxTimeLine;
}
- (LWAsyncDisplayView *)userView
{
    if (_userView) {
        return  _userView;
    }
    
    _userView = [[LWAsyncDisplayView alloc]initWithFrame:frame(0,self.bg.height*0.08, self.bg.width, self.headerViewLayout.height)];
    _userView.backgroundColor = [UIColor clearColor];
    return _userView;
    
}
- (void)setHeaderViewLayout:(InvateFriendCommentViewLayout *)headerViewLayout
{
    if (_headerViewLayout == headerViewLayout) {
        return;
    }
    _headerViewLayout = headerViewLayout;
    self.userView.layout = headerViewLayout;
    
}
- (UIView *)line
{
    if (_line) {
        return _line;
    }
    _line = [[UIView alloc]initWithFrame:CGRectMake(0.1*_bg.width, CGRectGetMaxY(_userView.frame), 0.8*_bg.width, 0.5)];
    _line.backgroundColor = LineBg;
    return _line;
}
- (UILabel *)lb
{
    if (_lb) {
        return _lb ;
    }
    
    _lb =[UILabel createLabelWithFrame:CGRectMake(_bg.width*0.1, CGRectGetMaxY(_line.frame) + 10*ScreenMultiple,  _bg.width*0.8, 50*ScreenMultiple) text:@"你的评价就是我最好的职业背书，快来给我打上印象标签吧！" fontSize:28*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:nil];
    _lb.numberOfLines = 0;
    return _lb;
}
- (UILabel *)lb2
{
    if (_lb2) {
        return _lb2 ;
    }
    
    _lb2 =[UILabel createLabelWithFrame:CGRectMake(_lb.x, CGRectGetMaxY(_lb.frame) + 10*ScreenMultiple, _lb.width, 24*SpacedFonts) text:@"------分享邀请好友------" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:nil];
    return _lb2;
}
#pragma mark
#pragma mark netWork
#pragma mark 网络请求
-(void)netWork
{
    NSMutableDictionary *param=[Parameter parameterWithSessicon];
    
    [[ToolManager shareInstance] showWithStatus];
    [XLDataService putWithUrl:UserMemberBriefs param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        NSLog(@"dataObj =%@",dataObj);
        _model = [InvateFriendCommentModel mj_objectWithKeyValues:dataObj];
        if (dataObj) {
            
            if (_model.rtcode ==1) {
                [[ToolManager shareInstance] dismiss];
                self.headerViewLayout = [[InvateFriendCommentViewLayout alloc]initCellWithFrame:self.bg.frame LayoutWithModel:_model];
                [_bg addSubview:self.userView];
                [_bg addSubview:self.line];
                [_bg addSubview:self.lb];
                [_bg addSubview:self.lb2];
                [_bg addSubview:self.wxFriend];
                [_bg addSubview:self.wxTimeLine];
            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus:_model.rtmsg];
                
            }
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus];
        }
        
    }];
}
#pragma mark button aticons
- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
}
@end


