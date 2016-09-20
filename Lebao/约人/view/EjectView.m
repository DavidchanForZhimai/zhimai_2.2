//
//  EjectView.m
//  Lebao
//
//  Created by adnim on 16/9/6.
//  Copyright © 2016年 David. All rights reserved.
//

#import "EjectView.h"


@interface EjectView()<D3RecordDelegate>
{
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    
    UITextField *logField;
}
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *titleLabel2;
@end


@implementation EjectView


- (instancetype) initAlertViewWithFrame:(CGRect)frame andSuperView:(UIView *)superView
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.middleView.frame = superView.frame;
        [superView addSubview:_middleView];
        
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15;
        self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, _centerY);
        [superView addSubview:self];
        
        
        self.titleLabel.frame = CGRectMake(0, 15, frame.size.width, 20);
        [self addSubview:_titleLabel];
        self.titleLabel2.frame=CGRectMake(0, 50, frame.size.width, 20);
        [self addSubview:_titleLabel2];
        
        btn1=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 setTitle:@"100元" forState:UIControlStateNormal];
        btn1.frame=CGRectMake(20, CGRectGetMaxY(_titleLabel2.frame)+15, (self.frame.size.width-20*4+10)/3.0, 30);
        btn1.layer.borderWidth=1;
        btn1.selected=YES;
        [btn1 setTitleColor:[UIColor colorWithRed:0.298 green:0.627 blue:0.996 alpha:1.000] forState:UIControlStateSelected];
        [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn1.layer.borderColor=[UIColor colorWithRed:0.298 green:0.627 blue:0.996 alpha:1.000].CGColor;
        btn1.layer.cornerRadius=13;
        btn1.tag=100;
                [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn1];
        btn2=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 setTitle:@"200元" forState:UIControlStateNormal];
        btn2.frame=CGRectMake(20*2-5+(self.frame.size.width-20*4+10)/3.0, CGRectGetMaxY(_titleLabel2.frame)+15, (self.frame.size.width-20*4+10)/3.0, 30);
        btn2.layer.borderWidth=1;
        [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [btn2 setTitleColor:[UIColor colorWithRed:0.298 green:0.627 blue:0.996 alpha:1.000] forState:UIControlStateSelected];
        btn2.layer.borderColor=[UIColor grayColor].CGColor;
        btn2.layer.cornerRadius=13;
        btn2.tag=101;
                [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn2];
        btn3=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn3 setTitle:@"其他" forState:UIControlStateNormal];
        btn3.frame=CGRectMake(20*3-10+(self.frame.size.width-20*4+10)/3.0*2, CGRectGetMaxY(_titleLabel2.frame)+15, (self.frame.size.width-20*4+10)/3.0, 30);
                [btn3 setTitleColor:[UIColor colorWithRed:0.298 green:0.627 blue:0.996 alpha:1.000] forState:UIControlStateSelected];
        btn3.layer.borderWidth=1;
        [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn3.layer.borderColor=[UIColor grayColor].CGColor;
        btn3.layer.cornerRadius=13;
        btn3.tag=102;
                [btn3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn3];
        
        
        _soundBtn=[D3RecordButton buttonWithType:UIButtonTypeSystem];
        _soundBtn.frame=CGRectMake(20,CGRectGetMaxY(btn1.frame)+15,self.frame.size.width-80, 32);
        _soundBtn.layer.borderColor= [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
        _soundBtn.layer.borderWidth=1;
        [_soundBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_soundBtn setTitle:@"按住  说话" forState:UIControlStateNormal];
        [_soundBtn initRecord:self maxtime:60];
        _soundBtn.layer.cornerRadius = 8;
        [self addSubview:_soundBtn];
        
        logField = [[UITextField alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(btn1.frame)+15,self.frame.size.width-80, 32)];
        logField.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 32)];
        logField.leftViewMode = UITextFieldViewModeAlways;
        logField.leftView = leftView;
        logField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        logField.layer.borderWidth = 1;
        logField.placeholder=@"请输入约见理由";
        logField.layer.cornerRadius=8;
        logField.backgroundColor=[UIColor whiteColor];
        [self addSubview:logField];
        
        UIButton *audioBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        audioBtn.frame=CGRectMake(CGRectGetMaxX(logField.frame)+10, logField.y, logField.height, logField.height);
        [audioBtn setImage:[UIImage imageNamed:@"yuejian_luying"] forState:UIControlStateNormal];
        [audioBtn addTarget:self action:@selector(audioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        audioBtn.tag=10;
        [self addSubview:audioBtn];
        
        
        CGRect cancelFrame = CGRectMake(0, CGRectGetMaxY(logField.frame)+15, frame.size.width/2, 42);
        UIButton *cancelBtn = [self creatButtonWithFrame:cancelFrame title:@"取消"];
        [self addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(leftCancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        CGRect confirmF = CGRectMake(frame.size.width/2, cancelBtn.frame.origin.y, cancelBtn.frame.size.width, cancelBtn.frame.size.height);
        UIButton *confirmBtn = [self creatButtonWithFrame:confirmF title:@"确定"];
        [self addSubview:confirmBtn];
        [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        //两条分割线
        UIView *horLine = [[UIView alloc] initWithFrame:CGRectMake(0, confirmF.origin.y-1, frame.size.width, 0.5)];
        horLine.backgroundColor = rgb(213, 213, 215);
        [self addSubview:horLine];
        
        UIView *verLine = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/2-1,confirmF.origin.y-1, 0.5, 43)];
        verLine.backgroundColor = horLine.backgroundColor;
        [self addSubview:verLine];
        self.frame=CGRectMake(0,0, frame.size.width, CGRectGetMaxY(confirmBtn.frame));
        self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, _centerY);
    }
    
    return self;
    
}

-(void)btnClick:(UIButton *)sender
{
    
    if (sender.tag==100) {
        sender.selected=YES;
        btn2.selected=NO;
        btn3.selected=NO;
        sender.layer.borderColor=[UIColor colorWithRed:0.298 green:0.627 blue:0.996 alpha:1.000].CGColor;
        btn2.layer.borderColor=[UIColor grayColor].CGColor;
        btn3.layer.borderColor=[UIColor grayColor].CGColor;
    }
    if (sender.tag==101) {
        sender.selected=YES;
        btn1.selected=NO;
        btn3.selected=NO;
         sender.layer.borderColor=[UIColor colorWithRed:0.298 green:0.627 blue:0.996 alpha:1.000].CGColor;
        btn1.layer.borderColor=[UIColor grayColor].CGColor;
        btn3.layer.borderColor=[UIColor grayColor].CGColor;
    }
    if (sender.tag==102) {
        sender.selected=YES;
        btn2.selected=NO;
        btn1.selected=NO;
         sender.layer.borderColor=[UIColor colorWithRed:0.298 green:0.627 blue:0.996 alpha:1.000].CGColor;
        btn2.layer.borderColor=[UIColor grayColor].CGColor;
        btn1.layer.borderColor=[UIColor grayColor].CGColor;
    }
}

- (UIButton *) creatButtonWithFrame:(CGRect) frame title:(NSString *) title
{
    UIButton *cancelBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = frame;
    
    [cancelBtn setTitleColor:rgb(0, 123, 251) forState:UIControlStateNormal];
    [cancelBtn setTitle:title forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    return cancelBtn;
}


#pragma mark - Action
- (void) leftCancelClick
{
    if ([_delegate respondsToSelector:@selector(customAlertView:clickedButtonAtIndex:)]) {
        [_delegate customAlertView:self clickedButtonAtIndex:0];
    }
}

- (void) confirmBtnClick
{
    if ([_delegate respondsToSelector:@selector(customAlertView:clickedButtonAtIndex:)]) {
        [_delegate customAlertView:self clickedButtonAtIndex:1];
    }
    
}
#pragma mark <D3RecordDelegate>
-(void)endRecord:(NSData *)voiceData{
    NSError *error;
    play = [[AVAudioPlayer alloc]initWithData:voiceData error:&error];
    NSLog(@"%@",error);
    play.volume = 1.0f;
    [play play];
    NSLog(@"yesssssssssss..........%f",play.duration);
    [_soundBtn setTitle:@"按住  说话" forState:UIControlStateNormal];
}

-(void)audioBtnClick:(UIButton *)sender
{
    NSLog(@"sender.tag=%ld",(long)sender.tag);
    if (sender.tag==10) {
        sender.tag=11;
        [sender setImage:[UIImage imageNamed:@"yuejian_jianpan"] forState:UIControlStateNormal];
        logField.frame=CGRectMake(CGRectGetMaxX(logField.frame), CGRectGetMaxY(logField.frame), 0, 0);
        
    }else if(sender.tag==11){
        sender.tag=10;
        [sender setImage:[UIImage imageNamed:@"yuejian_luying"] forState:UIControlStateNormal];
       logField.frame=_soundBtn.frame;
    }
}

#pragma mark - 注销视图
- (void) dissMiss
{
    
    if (_middleView) {
        [_middleView removeFromSuperview];
        _middleView = nil;
    }
    
    [self removeFromSuperview];
}

#pragma mark - getter And setter

- (void) setTitleStr:(NSString *)titleStr
{
    _titleLabel.text = titleStr;
}
- (void) setTitle2Str:(NSString *)title2Str
{
    _titleLabel2.text = title2Str;
}

- (UIView *) middleView
{
    if (_middleView == nil) {
        _middleView = [[UIView alloc] init];
        _middleView.backgroundColor = [UIColor blackColor];
        _middleView.alpha = 0.65;
    }
    
    return _middleView;
}

- (UILabel *) titleLabel{
    
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _titleLabel;
}
- (UILabel *) titleLabel2{
    
    if (_titleLabel2 == nil) {
        _titleLabel2 = [[UILabel alloc] init];
        _titleLabel2.font = [UIFont systemFontOfSize:15];
        _titleLabel2.textAlignment = NSTextAlignmentCenter;
        _titleLabel2.textColor=[UIColor grayColor];
        _titleLabel2.backgroundColor = [UIColor clearColor];
    }
    
    return _titleLabel2;
}



@end
