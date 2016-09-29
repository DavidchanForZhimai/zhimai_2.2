//
//  InvateFriendCommentViewController.m
//  Lebao
//
//  Created by David on 16/9/29.
//  Copyright © 2016年 David. All rights reserved.
//

#import "InvateFriendCommentViewController.h"

@interface InvateFriendCommentViewController()
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIImageView *bgHead;
@property(nonatomic,strong)UIImageView *bg;
@property(nonatomic,strong)BaseButton *wxFriend;
@property(nonatomic,strong)BaseButton *wxTimeLine;
@end
@implementation InvateFriendCommentViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self navViewTitleAndBackBtn:@"邀请好友评价"];
    [self.view addSubview:self.scrollView];
    
    
    
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
    [_bg addSubview:self.wxFriend];
    [_bg addSubview:self.wxTimeLine];
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
    _wxFriend.didClickBtnBlock = ^
    {
        NSLog(@"微信好友");
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
    _wxTimeLine.didClickBtnBlock = ^
    {
        NSLog(@"朋友圈");
    };
    return _wxTimeLine;
}
#pragma mark button aticons
- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
}
@end


