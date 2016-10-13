
//
//  AddConnectionView.m
//  Lebao
//
//  Created by adnim on 16/9/23.
//  Copyright © 2016年 David. All rights reserved.
//

#import "AddConnectionView.h"
#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"
@interface AddConnectionView()<UITextFieldDelegate>
{
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    UIButton *cancelBtn;
    UIButton *confirmBtn;
    UIView *horLine;
    UIView *verLine;
}
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *titleLabel2;
@end
@implementation AddConnectionView

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
        [btn2 setTitle:@"2元" forState:UIControlStateNormal];
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
        [btn3 setTitle:@"5元" forState:UIControlStateNormal];
        btn3.frame=CGRectMake(20*3-10+(self.frame.size.width-20*4+10)/3.0*2, CGRectGetMaxY(_titleLabel2.frame)+15, (self.frame.size.width-20*4+10)/3.0, 30);
        [btn3 setTitleColor:[UIColor colorWithRed:0.298 green:0.627 blue:0.996 alpha:1.000] forState:UIControlStateSelected];
        btn3.layer.borderWidth=1;
        [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn3.layer.borderColor=[UIColor grayColor].CGColor;
        btn3.layer.cornerRadius=13;
        btn3.tag=102;
        [btn3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn3];
        
        _logField = [[UITextField alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(btn1.frame)+15,self.frame.size.width-30, 32)];
        _logField.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 32)];
        _logField.leftViewMode = UITextFieldViewModeAlways;
        _logField.leftView = leftView;
        _logField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _logField.layer.borderWidth = 1;
        _logField.placeholder=@"请输入其它金额";
        _logField.layer.cornerRadius=8;
        _logField.delegate=self;
        _logField.backgroundColor=[UIColor whiteColor];
        _logField.text=@"1";
        [self addSubview:_logField];
        
        
        
        cancelBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame =  CGRectMake(0, CGRectGetMaxY(_logField.frame)+15, frame.size.width/2, 42);
        
        [cancelBtn setTitleColor:rgb(0, 123, 251) forState:UIControlStateNormal];
        [cancelBtn setTitle:@"不打赏" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(leftCancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        confirmBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.frame =CGRectMake(frame.size.width/2, cancelBtn.frame.origin.y, cancelBtn.frame.size.width, cancelBtn.frame.size.height);
        [confirmBtn setTitleColor:rgb(0, 123, 251) forState:UIControlStateNormal];
        [confirmBtn setTitle:@"打赏" forState:UIControlStateNormal];
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

//赏金按钮
-(void)btnClick:(UIButton *)sender
{
    if (sender.tag==100) {
        _logField.text=@"1";
        self.money=@"1";
    }
    if (sender.tag==101) {
        _logField.text=@"2";
        self.money=@"2";
    }
    if (sender.tag==102) {
        _logField.text=@"5";
        self.money=@"5";
    }
    btn1.selected=NO;
    btn2.selected=NO;
    btn3.selected=NO;
    sender.selected=YES;
    btn1.layer.borderColor=[UIColor grayColor].CGColor;
    btn2.layer.borderColor=[UIColor grayColor].CGColor;
    btn3.layer.borderColor=[UIColor grayColor].CGColor;
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
    self.money=_logField.text;
    if ([_delegate respondsToSelector:@selector(customAlertView:clickedButtonAtIndex:)]) {
        [_delegate customAlertView:self clickedButtonAtIndex:1];
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

#pragma mark
#pragma mark textField 方法

-  (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSCharacterSet *cs;
        NSUInteger nDotLoc = [_logField.text rangeOfString:@"."].location;
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


@end

