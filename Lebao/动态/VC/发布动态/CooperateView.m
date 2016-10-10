//
//  CooperateView.m
//  Lebao
//
//  Created by adnim on 16/10/9.
//  Copyright © 2016年 David. All rights reserved.
//

#import "CooperateView.h"
@interface CooperateView()<UITextViewDelegate>
{

    UIButton *cancelBtn;
    UIButton *confirmBtn;
    UIView *horLine;
    UIView *verLine;
}
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *titleLabel2;
@end

@implementation CooperateView
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
//        self.titleLabel2.frame=CGRectMake(0, 50, frame.size.width, 20);
//        [self addSubview:_titleLabel2];
        
        
        _logField = [[UITextView alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(_titleLabel.frame)+15,self.frame.size.width-40, 100)];
        _logField.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
        _logField.textAlignment=NSTextAlignmentLeft;
        _logField.font = [UIFont systemFontOfSize:13];
        _logField.layer.borderWidth = 1;
        _logField.text=_oldText;
        _logField.textColor = [UIColor colorWithRed:0.741 green:0.741 blue:0.745 alpha:1.000];
        _logField.delegate = self;
        _logField.layer.cornerRadius=8;
        _logField.backgroundColor=[UIColor whiteColor];
        [self addSubview:_logField];
        
        
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

- (instancetype) initAlertViewWithFrame:(CGRect)frame   LogFieldDefaultText:(NSString *)text andSuperView:(UIView *)superView
{
    self.oldText = text;
    return [self initAlertViewWithFrame:frame andSuperView:superView];
    
}
#pragma mark - Action
- (void) leftCancelClick
{
    if ([_delegate respondsToSelector:@selector(customAlertView:clickedButtonAtIndex:)]) {
        [_delegate customAlertView:self clickedButtonAtIndex:0];
    }
    [self dissMiss];
}

- (void) confirmBtnClick
{
    if ([_delegate respondsToSelector:@selector(customAlertView:clickedButtonAtIndex:)]) {
        [_delegate customAlertView:self clickedButtonAtIndex:1];
    }
    if (_sureblock) {
        _sureblock(self,_logField.text);
    }
    [self dissMiss];
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

//限制字数
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *string = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ([string length]==255)
    {
        return NO;
    }
    else if ([string length] >255)
    {
        string = [string substringToIndex:255];
        textView.text = string;
        
        return NO;
    }
    else
        return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length <1) {
        textView.text =_oldText;
        textView.textColor = [UIColor colorWithRed:0.741 green:0.741 blue:0.745 alpha:1.000];
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString: _oldText]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
}



@end
