//
//  WBShenSuVC.m
//  KuaJie
//
//  Created by 严文斌 on 16/5/25.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import "WBShenSuVC.h"
#import "MyKuaJieInfo.h"
@interface WBShenSuVC ()<UITextViewDelegate>

@end

@implementation WBShenSuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    self.view.backgroundColor = BACKCOLOR;
    _pyText.delegate = self;
    _pyText.layer.cornerRadius = 6.0f;
    _pyText.layer.borderWidth = 1;
    _pyText.layer.borderColor = [BACKCOLOR CGColor];
    _pyText.textColor = [UIColor colorWithRed:0.741 green:0.741 blue:0.745 alpha:1.000];
    _pyText.text = @"请输入5-50个字的评语";
    _pyText.font = [UIFont systemFontOfSize:13];
    self.quedBtn.layer.cornerRadius = 6.0f;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(huishouAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tap];
}
-(void)huishouAction
{
    [self.view endEditing:YES];
}
-(void)setNav
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = YES;
    
    UIView * navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 60, 44);
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    backBtn.imageView.contentMode = UIViewContentModeLeft;

    [backBtn setImage:[UIImage imageNamed:@"iconfont-fanhui"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    UILabel * titLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 20, 120, 44)];
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.textColor = [UIColor blackColor];
    titLab.text = @"合作评价";
    titLab.font = [UIFont systemFontOfSize:16];
    [navView addSubview:titLab];
    UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0.5)];
    hxV.backgroundColor = [UIColor colorWithRed:0.816 green:0.820 blue:0.827 alpha:1.000];
    [self.view addSubview:hxV];
    
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self addNoti];
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString: @"请输入5-50个字的评语"]) {
        textView.text = @"";
    }
}
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 50) {
        textField.text = [textField.text substringToIndex:50];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length <5) {
        textView.text = @"请输入5-50个字的评语";
    }
}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction
{
    
}
-(void)addNoti{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyBoardShow:(NSNotification *)sender{
    //     NSLog(@"sender=%@",sender);
    CGRect keyboard_bounds = [sender.userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    float keyboard_h = keyboard_bounds.size.height;
    float keyboard_y = SCREEN_HEIGHT-keyboard_h;
    //     NSLog(@"keyboard_y=%.2f",keyboard_y);
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    CGRect rect = [firstResponder convertRect:firstResponder.bounds toView:self.view];
    float field_maxy = CGRectGetMaxY(rect);
    //     NSLog(@"field_maxy=%.2f",field_maxy);
    
    float keyboard_hide = (field_maxy - keyboard_y)>0?field_maxy - keyboard_y:0;
    //     NSLog(@"keyboard_hide=%.2f",keyboard_hide);
    
    self.view.transform=CGAffineTransformMakeTranslation(0, -keyboard_hide);
    
}
-(void)keyBoardHide:(NSNotificationCenter *)sender{
    
    self.view.transform = CGAffineTransformIdentity;
}

-(void)removeNoti{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self removeNoti];
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

- (IBAction)quedingAction:(id)sender {
    if ([_pyText.text length]<=5 || [_pyText.text length] >= 50) {
        [[ToolManager shareInstance]showAlertMessage:@"请输入5-50个字的评语"];
        return;
    }
    [[MyKuaJieInfo shareInstance]shensuWithID:_xsID andContent:_pyText.text andCallBack:^(BOOL issucced, NSString *info, NSDictionary *jsonDic) {
        [[ToolManager shareInstance] showAlertMessage:info];
        if (issucced == YES) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else
        {
            [[ToolManager shareInstance]showAlertMessage:info];
        }
        
    }];
}
@end
