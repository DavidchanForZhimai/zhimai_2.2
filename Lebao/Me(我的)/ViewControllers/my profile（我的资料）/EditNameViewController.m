//
//  EditNameViewController.m
//  Lebao
//
//  Created by David on 16/1/28.
//  Copyright © 2016年 David. All rights reserved.
//

#import "EditNameViewController.h"

@interface EditNameViewController ()

@end
typedef enum
{
    ButtonActionTagFinish =2,
    
}ButtonActionTag;
@implementation EditNameViewController
{
    UIScrollView *_mainScrollView;
    UITextView *_modityTextView;
    UITextField *_modityTextField;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navView];
    [self mainView];
}

#pragma mark - Navi_View
- (void)navView
{
    UIButton *rightBtn =[UIButton createButtonWithfFrame:frame(APPWIDTH - 50, StatusBarHeight,50 , NavigationBarHeight) title:@"完成" backgroundImage:nil iconImage:nil highlightImage:nil tag:ButtonActionTagFinish];
    rightBtn.titleLabel.font = Size(28);
    [rightBtn setTitleColor:BlackTitleColor forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *title;
    if (_editPageTag == EditNamePageTag) {
       title =@"修改姓名";
    }
    else if (_editPageTag == EditPhoneNumPageTag)
    {
        title =@"修改手机";
    }
    else if (_editPageTag == EditIntroducePageTag)
    {
        title =@"个人简介";
    }
    else if (_editPageTag == EditCompanyTag)
    {
        title =@"公司名称";
    }
    
    else if (_editPageTag == EditWorkYearsPageTag)
    {
        title =@"从业年限";
    }
    else if (_editPageTag == EditeTag)
    {
        title =@"添加标签";
    }
    [self navViewTitleAndBackBtn:title rightBtn:rightBtn];
    
    
    
}
#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag ==NavViewButtonActionNavLeftBtnTag ) {
        PopView(self);
    }
    else if (sender.tag == ButtonActionTagFinish)
    {
        if (_editBlock) {
            if (_editPageTag == EditNamePageTag ||_editPageTag ==EditPhoneNumPageTag||_editPageTag ==EditCompanyTag||_editPageTag ==EditWorkYearsPageTag||_editPageTag == EditeTag) {
                
                _editBlock(_modityTextField.text);
            }
            
            else
            {
                _editBlock(_modityTextView.text);

            }
            PopView(self);
        }
    }
    
}

#pragma mark
#pragma mark - mainView
- (void)mainView
{
    _mainScrollView = allocAndInitWithFrame(UIScrollView, frame(0, StatusBarHeight  +NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)));
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    _mainScrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_mainScrollView];
    
    if (_editPageTag == EditNamePageTag ||_editPageTag ==EditPhoneNumPageTag||_editPageTag ==EditCompanyTag||_editPageTag ==EditWorkYearsPageTag||_editPageTag == EditeTag) {
    
        _modityTextField =  allocAndInitWithFrame(UITextField, frame(20*ScreenMultiple, 10, frameWidth(_mainScrollView) - 40*ScreenMultiple, 32));
    
        _modityTextField.text = _textView;
        _modityTextField.textColor = LightBlackTitleColor;
        _modityTextField.font = Size(28);
        _modityTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        if (_editPageTag == EditPhoneNumPageTag||_editPageTag ==EditWorkYearsPageTag) {
            _modityTextField.keyboardType = UIKeyboardTypeNumberPad;
        }
       
        [_mainScrollView addSubview:_modityTextField];
        
        UILabel *line = allocAndInitWithFrame(UILabel, frame(10*ScreenMultiple, CGRectGetMaxY(_modityTextField.frame), frameWidth(_mainScrollView) - 20*ScreenMultiple, 0.5));
        line.backgroundColor = AppMainColor;
        [_mainScrollView addSubview:line];
        
        
    }
    else
    {
        UIView *bg = allocAndInitWithFrame(UIView, frame(10*ScreenMultiple, 10, frameWidth(_mainScrollView) - 20*ScreenMultiple, 70));
        bg.layer.borderColor = AppMainColor.CGColor;
        bg.layer.borderWidth = 0.5;
        [_mainScrollView addSubview:bg];
        
        _modityTextView =  allocAndInitWithFrame(UITextView, frame(5, 0, frameWidth(bg), frameHeight(bg) - 10));
        _modityTextView.text = _textView;
        _modityTextView.textColor = LightBlackTitleColor;
        _modityTextView.font = Size(28);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [_modityTextView becomeFirstResponder];
        });
        [bg addSubview:_modityTextView];
        
    }
    
    if (CGRectGetMaxY(_modityTextField.frame) + 10>frameHeight(_mainScrollView)||CGRectGetMaxY(_modityTextView.frame) + 10>frameHeight(_mainScrollView)) {
        if (CGRectGetMaxY(_modityTextField.frame) + 10>frameHeight(_mainScrollView)) {
            _mainScrollView.frame = frame(frameX(_mainScrollView), frameY(_mainScrollView), frameWidth(_mainScrollView), CGRectGetMaxY(_modityTextField.frame) + 10);
        }
        else
        {
            _mainScrollView.frame = frame(frameX(_mainScrollView), frameY(_mainScrollView), frameWidth(_mainScrollView), CGRectGetMaxY(_modityTextView.frame) + 10);
        }
        
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
