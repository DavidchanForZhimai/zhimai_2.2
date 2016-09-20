//
//  AbouthelpViewController.m
//  Lebao
//
//  Created by David on 16/3/15.
//  Copyright © 2016年 David. All rights reserved.
//

#import "AbouthelpViewController.h"
#import "XLDataService.h"
#define cellH 40.0
//我的URL ：appinterface/personal
#define PersonalURL [NSString stringWithFormat:@"%@user/feedback",HttpURL]
@interface AbouthelpViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate>

@end

@implementation AbouthelpViewController
{
    UITableView *_introductionView;
    NSMutableArray *_introductionArray;
    UITextView *_textView;
    UITextField *_textField;
    NSString *textViewText;
    NSString *textFieldText;
    
    UILabel *label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navView];
    
    
    [self addMainView];
}

#pragma mark - Navi_View
- (void)navView
{
    [self navViewTitleAndBackBtn:@"帮助与反馈" ];
}
#pragma mark
#pragma mark - addTableView -
- (void)addMainView
{
    _introductionArray = [NSMutableArray arrayWithObjects:@"闪屏，黑屏", @"发布不了产品",@"分享不了产品",nil];
    _introductionView =[[UITableView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)) style:UITableViewStyleGrouped];
    _introductionView.backgroundColor =[UIColor clearColor];
    _introductionView.delegate = self;
    _introductionView.dataSource = self;
    
    [self.view addSubview:_introductionView];
    
    
}
#pragma mark
#pragma mark UITextFiled Delgate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textFieldText= textField.text;
}

#pragma mark
#pragma mark UITextView Delgate
- (void)textViewDidChange:(UITextView *)textView
{
    textViewText= textView.text;
    if ([textView.text isEqualToString:@""]) {
        label.text= @"请输入您的邮箱我们会第一时间联系您";
    }
    else
    {
        label.text= @"";
    }
}
//利用正则表达式验证
-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark
#pragma mark - TableViewDelegate TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _introductionArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return cellH;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = allocAndInit(UIView);
    view.backgroundColor = [UIColor clearColor];
    
    [UILabel createLabelWithFrame:frame(10, 0, APPWIDTH - 10, cellH) text:@"热门问题" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:view];
    
    return view;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 250;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = allocAndInit(UIView);
    view.backgroundColor = [UIColor clearColor];
    [UILabel createLabelWithFrame:frame(10, 0, APPWIDTH - 10, cellH) text:@"意见反馈" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:view];
    
    UIView *yijian = allocAndInitWithFrame(UIView, frame(10, 40, APPWIDTH - 20, 90));
    yijian.backgroundColor  = WhiteColor;
    [yijian setRadius:5.0];
    [view addSubview:yijian];
    
    _textView = allocAndInitWithFrame(UITextView, frame(5, 5, frameWidth(yijian) - 10, frameHeight(yijian) -10));
    _textView.text = textViewText;
    _textView.delegate =self;
    _textView.font = Size(24);
    [yijian addSubview:_textView];
   
    label = [UILabel createLabelWithFrame:frame(frameX(_textView), frameY(_textView) + 7, frameWidth(_textView), 24*SpacedFonts) text:@"" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:yijian];
    if ([textViewText isEqualToString:@""]||!textViewText) {
        label.text = @"请输入您的意见和建议";
    }
    label.enabled = NO;
    
    UIView *mail = allocAndInitWithFrame(UIView, frame(frameX(yijian), CGRectGetMaxY(yijian.frame) + 15, frameWidth(yijian), 40));
    mail.backgroundColor  = WhiteColor;
    [mail setRadius:5.0];
    [view addSubview:mail];
    
    _textField = allocAndInitWithFrame(UITextField, frame(frameX(_textView), frameY(_textView),frameWidth(_textView) , 30));
    _textField.delegate =self;
    _textField.placeholder = @"请输入您的邮箱我们会第一时间联系您";
    _textField.font = Size(24);
    _textField.text = textFieldText;
    [mail addSubview:_textField];
    
    
    BaseButton *sumbit = [[BaseButton alloc]initWithFrame:frame(25*ScreenMultiple, 205, APPWIDTH - 50*ScreenMultiple, 40) setTitle:@"提交" titleSize:28*SpacedFonts titleColor:WhiteColor textAlignment:NSTextAlignmentCenter backgroundColor:AppMainColor inView:view];
    [sumbit setRadius:5.0];
//    __weak AbouthelpViewController *weakSelf  =self;
    sumbit.didClickBtnBlock = ^
    {
        [[ToolManager shareInstance] showWithStatus];
        NSMutableDictionary *param = [Parameter parameterWithSessicon];
        if ([textViewText isEqualToString:@""]||!textViewText) {
            [[ToolManager shareInstance] showInfoWithStatus:@"请输入意见内容"];
            return ;
        }
        if ([textFieldText isEqualToString:@""]||!textFieldText) {
            [[ToolManager shareInstance] showInfoWithStatus:@"请输入邮箱号"];
            return ;
        }
        if (![self isValidateEmail:textFieldText]) {
            [[ToolManager shareInstance] showInfoWithStatus:@"请输入正确的邮箱号"];
            return;
        }
        [param setObject:textViewText forKey:@"content"];
        [param setObject:textFieldText forKey:@"mail"];
        [XLDataService postWithUrl:PersonalURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
            if (dataObj) {
                
                if ([dataObj[@"rtcode"] integerValue] ==1) {
                    [[ToolManager shareInstance] showSuccessWithStatus:@"提交成功"];
                     PopView(self);
                    
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
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID =@"MeCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor =[UIColor whiteColor];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:26*SpacedFonts];
    cell.textLabel.frame = frame(20, 0, 100, cellH);
    
    
    cell.textLabel.text = _introductionArray[indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
