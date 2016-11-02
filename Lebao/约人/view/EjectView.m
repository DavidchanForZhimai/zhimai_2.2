//
//  EjectView.m
//  Lebao
//
//  Created by adnim on 16/9/6.
//  Copyright © 2016年 David. All rights reserved.
//

#import "EjectView.h"
#import "MP3PlayerManager.h"
#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"
@interface EjectView()<D3RecordDelegate,AVAudioPlayerDelegate,UITextFieldDelegate>
{
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    UIButton *btn4;
    UIButton *audioBtn;//录音按键切换按钮
    UITextField *otherMoneyField;
    UIButton *cancelBtn;
    UIButton *confirmBtn;
    UIView *horLine;
    UIView *verLine;
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
        
        self.money=@"1";
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15;
        self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, _centerY);
        [superView addSubview:self];
        
        
        self.titleLabel.frame = CGRectMake(0, 15, frame.size.width, 20);
        [self addSubview:_titleLabel];
        self.titleLabel2.frame=CGRectMake(0, 50, frame.size.width, 20);
        [self addSubview:_titleLabel2];
        
        btn1=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 setTitle:@"1元" forState:UIControlStateNormal];
        btn1.frame=CGRectMake(20, CGRectGetMaxY(_titleLabel2.frame)+15, (self.frame.size.width-20*4+10)/4.0, 30);
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
        [btn2 setTitle:@"5元" forState:UIControlStateNormal];
        btn2.frame=CGRectMake(20+10+(self.frame.size.width-20*4+10)/4.0, CGRectGetMaxY(_titleLabel2.frame)+15, (self.frame.size.width-20*4+10)/4.0, 30);
        btn2.layer.borderWidth=1;
        [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [btn2 setTitleColor:[UIColor colorWithRed:0.298 green:0.627 blue:0.996 alpha:1.000] forState:UIControlStateSelected];
        btn2.layer.borderColor=[UIColor grayColor].CGColor;
        btn2.layer.cornerRadius=13;
        btn2.tag=101;
                [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn2];
        btn3=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn3 setTitle:@"10元" forState:UIControlStateNormal];
        btn3.frame=CGRectMake(20+20+(self.frame.size.width-20*4+10)/4.0*2, CGRectGetMaxY(_titleLabel2.frame)+15, (self.frame.size.width-20*4+10)/4.0, 30);
                [btn3 setTitleColor:[UIColor colorWithRed:0.298 green:0.627 blue:0.996 alpha:1.000] forState:UIControlStateSelected];
        btn3.layer.borderWidth=1;
        [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn3.layer.borderColor=[UIColor grayColor].CGColor;
        btn3.layer.cornerRadius=13;
        btn3.tag=102;
                [btn3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn3];
        
        btn4=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn4 setTitle:@"其他" forState:UIControlStateNormal];
        btn4.frame=CGRectMake(20+30+(self.frame.size.width-20*4+10)/4.0*3, CGRectGetMaxY(_titleLabel2.frame)+15, (self.frame.size.width-20*4+10)/4.0, 30);
        [btn4 setTitleColor:[UIColor colorWithRed:0.298 green:0.627 blue:0.996 alpha:1.000] forState:UIControlStateSelected];
        btn4.layer.borderWidth=1;
        [btn4 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn4.layer.borderColor=[UIColor grayColor].CGColor;
        btn4.layer.cornerRadius=13;
        btn4.tag=103;
        [btn4 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn4];

        
        otherMoneyField=[[UITextField alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(btn1.frame)+15,self.frame.size.width-40, 0)];
        otherMoneyField.layer.borderColor=[[UIColor colorWithWhite:0.9 alpha:1] CGColor];
        otherMoneyField.layer.borderWidth = 1;
        otherMoneyField.placeholder=@"请输入打赏的金额";
        otherMoneyField.textAlignment=NSTextAlignmentCenter;
        otherMoneyField.layer.cornerRadius=8;
        otherMoneyField.delegate=self;
        otherMoneyField.hidden=YES;
//        otherMoneyField.keyboardType=UIKeyboardTypePhonePad;
        otherMoneyField.text=@"1";
        otherMoneyField.backgroundColor=[UIColor whiteColor];
        [self addSubview:otherMoneyField];
        
        _soundBtn=[D3RecordButton buttonWithType:UIButtonTypeSystem];
        _soundBtn.frame=CGRectMake(20,CGRectGetMaxY(btn1.frame)+15,self.frame.size.width-80, 32);
        _soundBtn.layer.borderColor= [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
        _soundBtn.layer.borderWidth=1;
        [_soundBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_soundBtn setTitle:@"按住  说话" forState:UIControlStateNormal];
        [_soundBtn initRecord:self maxtime:60 title:@"松开停止录音"];
        _soundBtn.layer.cornerRadius = 8;
        [self addSubview:_soundBtn];
        
        _logField = [[UITextField alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(btn1.frame)+15,self.frame.size.width-80, 32)];
        _logField.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 32)];
        _logField.leftViewMode = UITextFieldViewModeAlways;
        _logField.leftView = leftView;
        _logField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _logField.layer.borderWidth = 1;
        _logField.placeholder=@"请输入约见理由";
        _logField.layer.cornerRadius=8;
        _logField.backgroundColor=[UIColor whiteColor];
        [self addSubview:_logField];
        
        audioBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        audioBtn.frame=CGRectMake(CGRectGetMaxX(_logField.frame)+10, _logField.y, _logField.height, _logField.height);
        [audioBtn setImage:[UIImage imageNamed:@"yuejian_luying"] forState:UIControlStateNormal];
        [audioBtn addTarget:self action:@selector(audioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        audioBtn.tag=10;
        [self addSubview:audioBtn];
        
        
        cancelBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame =  CGRectMake(0, CGRectGetMaxY(_logField.frame)+15, frame.size.width/2, 42);
        
        [cancelBtn setTitleColor:rgb(0, 123, 251) forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(leftCancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        confirmBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.frame =CGRectMake(frame.size.width/2, cancelBtn.frame.origin.y, cancelBtn.frame.size.width, cancelBtn.frame.size.height);
        [confirmBtn setTitleColor:rgb(0, 123, 251) forState:UIControlStateNormal];
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:confirmBtn];
        [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        //两条分割线
        horLine = [[UIView alloc] initWithFrame:CGRectMake(0, confirmBtn.origin.y-1, frame.size.width, 0.5)];
        horLine.backgroundColor = rgb(213, 213, 215);
        [self addSubview:horLine];
        
        verLine = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/2-1,confirmBtn.origin.y-1, 0.5, 43)];
        verLine.backgroundColor = horLine.backgroundColor;
        [self addSubview:verLine];
        self.frame=CGRectMake(0,0, frame.size.width, CGRectGetMaxY(confirmBtn.frame));
        self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, _centerY);
    }
    
    return self;
    
}

//重新设置Frame
-(void)changeAllFrameWithHeight:(float)height
{
    otherMoneyField.frame=CGRectMake(20,CGRectGetMaxY(btn1.frame)+15,self.frame.size.width-40, 0+height);
    if(height>0){
        otherMoneyField.hidden=NO;
        _soundBtn.frame=CGRectMake(20,CGRectGetMaxY(otherMoneyField.frame)+15,self.frame.size.width-80, 32);}
    else{
        otherMoneyField.hidden=YES;
        _soundBtn.frame=CGRectMake(20,CGRectGetMaxY(btn1.frame)+15,self.frame.size.width-80, 32);
    }
    _logField.frame=_soundBtn.frame;
    audioBtn.frame=CGRectMake(CGRectGetMaxX(_logField.frame)+10, _logField.y, _logField.height, _logField.height);
    
    cancelBtn.frame= CGRectMake(0, CGRectGetMaxY(_logField.frame)+15, self.frame.size.width/2, 42);
    confirmBtn.frame = CGRectMake(self.frame.size.width/2, cancelBtn.frame.origin.y, cancelBtn.frame.size.width, cancelBtn.frame.size.height);
    horLine.frame =CGRectMake(0, confirmBtn.origin.y-1, self.frame.size.width, 0.5);
    verLine.frame =CGRectMake(self.frame.size.width/2-1,confirmBtn.origin.y-1, 0.5, 43);

    self.frame=CGRectMake(self.frame.origin.x,self.frame.origin.y, self.frame.size.width, CGRectGetMaxY(confirmBtn.frame));

}

//赏金按钮
-(void)btnClick:(UIButton *)sender
{
    
    if (sender.tag==100) {

        self.money=@"1";
        otherMoneyField.text=@"1";
        [self changeAllFrameWithHeight:0];
    }
    if (sender.tag==101) {

        self.money=@"5";
        otherMoneyField.text=@"5";
        [self changeAllFrameWithHeight:0];
    }
    if (sender.tag==102) {

        self.money=@"10";
        otherMoneyField.text=@"10";
        [self changeAllFrameWithHeight:0];
    }
    if (sender.tag==103) {

        [self changeAllFrameWithHeight:32];
        self.money=otherMoneyField.text;
    }
    
    btn1.selected=NO;
    btn2.selected=NO;
    btn3.selected=NO;
    btn4.selected=NO;
    sender.selected=YES;
    btn1.layer.borderColor=[UIColor grayColor].CGColor;
    btn2.layer.borderColor=[UIColor grayColor].CGColor;
    btn3.layer.borderColor=[UIColor grayColor].CGColor;
    btn4.layer.borderColor=[UIColor grayColor].CGColor;
    sender.layer.borderColor=sender.tintColor.CGColor;
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
    self.money=otherMoneyField.text;
    if ([_delegate respondsToSelector:@selector(customAlertView:clickedButtonAtIndex:)]) {
        [_delegate customAlertView:self clickedButtonAtIndex:1];
    }
    
}
#pragma mark <D3RecordDelegate>
-(void)endRecord:(NSData *)voiceData{

    _audioData=voiceData;
     [audioBtn setImage:[UIImage imageNamed:@"yuejian_luyinhou"] forState:UIControlStateNormal];
    audioBtn.tag=12;
    _logField.frame=_soundBtn.frame;
    _soundBtn.hidden=YES;
    _logField.hidden=NO;
}


#pragma mark
#pragma mark private 方法
-(void)audioBtnClick:(UIButton *)sender
{

    if (sender.tag==10) {
        sender.tag=11;
        [sender setImage:[UIImage imageNamed:@"yuejian_jianpan"] forState:UIControlStateNormal];
        _logField.frame=CGRectMake(CGRectGetMaxX(_logField.frame), CGRectGetMaxY(_logField.frame), 0, 0);
        _logField.hidden=YES;
        _soundBtn.hidden=NO;
        
    }else if(sender.tag==11){
        sender.tag=10;
        [sender setImage:[UIImage imageNamed:@"yuejian_luying"] forState:UIControlStateNormal];
       _logField.frame=_soundBtn.frame;
        _soundBtn.hidden=YES;
        _logField.hidden=NO;
    }else if(sender.tag==12){
        sender.tag=13;
        [sender setImage:[UIImage imageNamed:@"yuejian_bofang"] forState:UIControlStateNormal];
        NSError *error;
        play = [[AVAudioPlayer alloc]initWithData:_audioData error:&error];
        play.volume = 1.0f;
        play.delegate=self;
        //添加近距离事件监听，添加前先设置为YES，如果设置完后还是NO的读话，说明当前设备没有近距离传感器
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:)name:UIDeviceProximityStateDidChangeNotification object:nil];
        }

        [play play];
    

    }else if(sender.tag==13){
        sender.tag=12;
        [audioBtn setImage:[UIImage imageNamed:@"yuejian_luyinhou"] forState:UIControlStateNormal];
        [play stop];
    }
}
#pragma mark - 处理近距离监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)//黑屏
    {
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
    }
    else//没黑屏幕
    {
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        if (![play isPlaying]) {//没有播放了，也没有在黑屏状态下，就可以把距离传感器关了
            [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        }
    }
}

#pragma mark
#pragma mark textField 方法
-  (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSCharacterSet *cs;
    NSUInteger nDotLoc = [otherMoneyField.text rangeOfString:@"."].location;
    if (NSNotFound == nDotLoc && 0 != range.location) {
        cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers] invertedSet];
    }
    else {
        cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers] invertedSet];
    }
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if (!basicTest) {
        
        
        return NO;
    }
    if (NSNotFound != nDotLoc && range.location > nDotLoc + 2) {
        
        return NO;
    }
    return YES;
}
#pragma mark - 播放器代理方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{   NSLog(@"播放完成!");
    
    audioBtn.tag=12;
    [audioBtn setImage:[UIImage imageNamed:@"yuejian_luyinhou"] forState:UIControlStateNormal];
    //删除近距离事件监听
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
    }
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];

    
}
#pragma mark - 注销视图
- (void) dissMiss
{
    
    if (_middleView) {
        [_middleView removeFromSuperview];
        _middleView = nil;
    }
    //删除近距离事件监听
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
    }
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
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
