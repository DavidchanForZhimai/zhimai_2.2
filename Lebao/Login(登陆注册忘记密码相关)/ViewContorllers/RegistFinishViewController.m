//
//  RegistFinishViewController.m
//  Lebao
//
//  Created by David on 16/4/19.
//  Copyright © 2016年 David. All rights reserved.
//

#import "RegistFinishViewController.h"
#import "CoreArchive.h"
#import "XLDataService.h"
#import "NSString+Password.h"
#define rememberUserName  @"rememberUserName"
#define RegisterURL [NSString stringWithFormat:@"%@site/register",HttpURL]
@interface RegistFinishViewController ()
@property(nonatomic,strong)NSMutableArray *selectedArray;
@property(nonatomic,strong)BaseButton *selectedBtn;
@property(nonatomic,assign)int selectedindex;
@end

@implementation RegistFinishViewController

{
    
    UITextField *_userName;  //userName
    UIScrollView *mainScrollView;
    NSArray *_arrayTitle;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedArray = allocAndInit(NSMutableArray);
    _selectedindex= 0;
    _arrayTitle = @[@"保险",@"房产",@"车行",@"金融",@"其他"];
    // Do any additional setup after loading the view.
    [self navViewTitleAndBackBtn:@"完善资料"];
    BaseButton *next = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 60, StatusBarHeight, 60, NavigationBarHeight) setTitle:@"完成" titleSize:28*SpacedFonts titleColor:BlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] inView:self.view];
    
    __weak RegistFinishViewController *weakSelf = self;
    next.didClickBtnBlock = ^{
        
        if (_userName.text.length==0) {
            [[ToolManager shareInstance] showInfoWithStatus:@"请输入姓名"];
            return ;
        }
        ;
        
        [[ToolManager shareInstance] showWithStatus:@"注册提交..."];
        NSMutableDictionary * sendcaptchaParam = allocAndInit(NSMutableDictionary);
        [sendcaptchaParam setObject:[Parameter industryForCode:_arrayTitle[_selectedindex]] forKey:Industry];
        [sendcaptchaParam setObject:_userName.text forKey:@"realname"];
        [sendcaptchaParam setObject:_phoneNum forKey:userName];
        [sendcaptchaParam setObject:[_password md5]   forKey:passWord];
        [sendcaptchaParam setObject:_verCode forKey:captchaCode];
        if (_invCode.length>0) {
            [sendcaptchaParam setObject:_invCode forKey:@"recommend"];
        }
//        NSLog(@"sendcaptchaParam =%@",sendcaptchaParam);
        [XLDataService postWithUrl:RegisterURL param:sendcaptchaParam modelClass:nil responseBlock:^(id dataObj, NSError *error) {
            DDLog(@"dataObj =%@",dataObj);
        
            if (error) {
                
                [[ToolManager shareInstance] showInfoWithStatus];
                
            }
            [weakSelf dealWithCode:dataObj];
        }];

        
    };
    [self mainView];
}
- (void)dealWithCode:(id)dataObj
{
    if (dataObj) {
        NSDictionary *msg = (NSDictionary *)dataObj;
        
        switch ([msg[@"rtcode"] integerValue]) {
            case 1:
            {
                [CoreArchive setStr:_phoneNum key:userName];
                [CoreArchive setStr:[_password md5] key:passWord];
                [CoreArchive setStr:_phoneNum key:rememberUserName];
                [[ToolManager shareInstance] showSuccessWithStatus:@"注册成功！"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[ToolManager shareInstance] LoginmianView];
                });
           }

            break;
            default:
                
                [[ToolManager shareInstance] showInfoWithStatus:msg[@"rtmsg"]];
              
                break;
        }
    }
    
}

#pragma mark - mainView
-(void)mainView{
    
    mainScrollView =allocAndInitWithFrame(UIScrollView, frame(0, StatusBarHeight+ NavigationBarHeight  , APPWIDTH, APPHEIGHT - (StatusBarHeight+ NavigationBarHeight)));
    mainScrollView.alwaysBounceVertical = YES;
    mainScrollView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:mainScrollView];
    
    float cellHeight = 58;
    float cellX = 23;
    float textFieldX =72;
    float bH = 27;
    
    _userName = allocAndInitWithFrame(UITextField, frame(textFieldX, bH, frameWidth(self.view) - 2*textFieldX, cellHeight -bH ));
    
    _userName.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userName.placeholder = @"请输入姓名";
    _userName.font = [UIFont systemFontOfSize:26.0*SpacedFonts];
    _userName.textColor =BlackTitleColor;
    _userName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入姓名" attributes:@{NSForegroundColorAttributeName: LightBlackTitleColor}];
    [mainScrollView addSubview:_userName];
    
    UIImage *_userNameImage =[UIImage imageNamed:@"iconfont-geren-copy"];
    UIView *_userNameleftView = allocAndInitWithFrame(UIView , frame(cellX, frameY(_userName), 50, frameHeight(_userName)));
    UIImageView *_userNameleftImageView =allocAndInitWithFrame(UIImageView, frame(18, (frameHeight(_userName) -_userNameImage.size.height)/2.0 , _userNameImage.size.width, _userNameImage.size.height));
    _userNameleftImageView.image =_userNameImage;
    [_userNameleftView addSubview:_userNameleftImageView] ;
    [mainScrollView addSubview:_userNameleftView];
    
    
    UILabel *line1 = allocAndInitWithFrame(UILabel, frame(cellX, cellHeight, frameWidth(self.view) - 2*cellX, 0.5));
    line1.backgroundColor = LineBg;
    [mainScrollView addSubview:line1];
    
    UILabel *line2 = allocAndInitWithFrame(UILabel, frame(cellX, CGRectGetMaxY(line1.frame) + 45, 100*ScreenMultiple, 0.5));
    line2.backgroundColor = LineBg;
    [mainScrollView addSubview:line2];
    
    UILabel *line3 = allocAndInitWithFrame(UILabel, frame(APPWIDTH -  CGRectGetMaxX(line2.frame), frameY(line2),frameWidth(line2), frameHeight(line2)));
    line3.backgroundColor = LineBg;
    [mainScrollView addSubview:line3];
    
    [UILabel createLabelWithFrame:frame(0, CGRectGetMaxY(line1.frame)+ 40, APPWIDTH, 15) text:@"选择行业" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentCenter inView:mainScrollView];
    
   
    float itemY =CGRectGetMaxY(line3.frame) + 50;
    float itemW = APPWIDTH/5.0;
    float itemH = 30;
    float itemBt = itemW/2.0;
    __weak RegistFinishViewController *weakSelf = self;
    for (int i =0; i<_arrayTitle.count; i++) {
        
        NSString *tilte = _arrayTitle[i];
        _selectedBtn = [[BaseButton alloc]initWithFrame:frame(itemBt + (i%3)*(itemW + itemBt), itemY +(i/3)*(itemH + 20), itemW, itemH) setTitle:tilte titleSize:28*SpacedFonts titleColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:WhiteColor inView:mainScrollView];
        [_selectedBtn setRadius:frameHeight(_selectedBtn)/2.0];
        [_selectedBtn setBorder:LineBg width:1.0];
        if (i ==0) {
            [_selectedBtn setBorder:AppMainColor width:1.0];
            [_selectedBtn setBackgroundColor:AppMainColor];
            [_selectedBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        }
        _selectedBtn.didClickBtnBlock = ^
        {
            for (int j=0; j<_selectedArray.count; j++) {
                
                BaseButton *tag = weakSelf.selectedArray[j];
                if (j==i) {
                    [tag setBorder:AppMainColor width:1.0];
                    [tag setBackgroundColor:AppMainColor];
                    [tag setTitleColor:WhiteColor forState:UIControlStateNormal];
                }
                else
                {
                [tag setBorder:LineBg width:1.0];
                [tag setBackgroundColor:WhiteColor];
                [tag setTitleColor:LightBlackTitleColor forState:UIControlStateNormal];
                }
                
            }
            _selectedindex = i;
            
        };
        
        [_selectedArray addObject:_selectedBtn];
    }
    
    
}
#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag ==0)
    {
        [self.navigationController popViewControllerAnimated:NO];
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
