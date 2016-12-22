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
#import "IndustrySelectionViewController.h"
#define rememberUserName  @"rememberUserName"
#import "NSString+Password.h"
#import "LoginViewController.h"
#define LoginURL [NSString stringWithFormat:@"%@site/login",HttpURL]
#define IndustryURL [NSString stringWithFormat:@"%@user/industry",HttpURL]
#define signmemberURL [NSString stringWithFormat:@"%@user/sign-member",HttpURL]
@interface RegistFinishViewController ()
@property(nonatomic,strong)NSMutableArray *selectedArray;
@property(nonatomic,strong)BaseButton *selectedBtn;
@property(nonatomic,assign)int selectedindex;
@end

@implementation RegistFinishViewController

{
    
    UITextField *_userName;  //userName
    UIScrollView *mainScrollView;
//    NSArray *_arrayTitle;
    UIButton *industry;
    UILabel *industryLab;
    UITextField *vocational;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _selectedArray = allocAndInit(NSMutableArray);
    _selectedindex= 0;
//    _arrayTitle = @[@"保险",@"房产",@"车行",@"金融",@"其他"];
    // Do any additional setup after loading the view.
    [self navViewTitle:@"完善资料"];
    self.homePageBtn.hidden = YES;
    BaseButton *next = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 60, StatusBarHeight, 60, NavigationBarHeight) setTitle:@"完成" titleSize:28*SpacedFonts titleColor:BlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] inView:self.view];
    
    __weak RegistFinishViewController *weakSelf = self;
    next.didClickBtnBlock = ^{
        
        if (_userName.text.length==0) {
            [[ToolManager shareInstance] showInfoWithStatus:@"请输入姓名"];
            return ;
        }
        ;
        
        [[ToolManager shareInstance] showWithStatus:@"资料完善中..."];
        NSMutableDictionary * sendcaptchaParam = allocAndInit(NSMutableDictionary);
//        [sendcaptchaParam setObject:[Parameter industryForCode:_arrayTitle[_selectedindex]] forKey:Industry];
        [sendcaptchaParam setObject:_userName.text forKey:@"realname"];
        [sendcaptchaParam setObject:_phoneNum forKey:KuserName];
        [sendcaptchaParam setObject:[_password md5]   forKey:passWord];
        [sendcaptchaParam setObject:vocational.text forKey:@"position"];
        if (_invCode.length>0) {
            [sendcaptchaParam setObject:_invCode forKey:@"recommend"];
        }
//        NSLog(@"sendcaptchaParam =%@",sendcaptchaParam);
        [XLDataService postWithUrl:signmemberURL param:sendcaptchaParam modelClass:nil responseBlock:^(id dataObj, NSError *error) {
//            DDLog(@"dataObj =%@",dataObj);
        
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
                [CoreArchive setStr:_phoneNum key:KuserName];
                [CoreArchive setStr:[_password md5] key:passWord];
                [CoreArchive setStr:_phoneNum key:rememberUserName];
//                [[ToolManager shareInstance] showSuccessWithStatus:@"注册成功！"];
                
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
    
    
    
    industryLab = allocAndInitWithFrame(UILabel, frame(textFieldX, bH+50, frameWidth(self.view) - 2*textFieldX, cellHeight -bH ));
    industryLab.text = @"请选择行业";
    industryLab.textAlignment=NSTextAlignmentLeft;
    industryLab.font = [UIFont systemFontOfSize:26.0*SpacedFonts];
    industryLab.textColor =LightBlackTitleColor;
    [mainScrollView addSubview:industryLab];

    industry =[UIButton buttonWithType:UIButtonTypeCustom];
    industry.frame=frame(textFieldX, bH+50, frameWidth(self.view) - 2*textFieldX, cellHeight -bH );
    [mainScrollView addSubview:industry];
    [industry addTarget:self action:@selector(industryClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *industryImage =[UIImage imageNamed:@"icon_hangye"];
    UIView *industryleftView =allocAndInitWithFrame(UIView , frame(cellX, frameY(industry), 50, frameHeight(industry)));
    UIImageView *industryleftImageView =allocAndInitWithFrame(UIImageView, frame(18, (frameHeight(industryLab) -industryImage.size.height)/2.0 , industryImage.size.width, industryImage.size.height));
    industryleftImageView.image =industryImage;
    [industryleftView addSubview:industryleftImageView] ;
    [mainScrollView addSubview:industryleftView];
    

    
    UILabel *line2 = allocAndInitWithFrame(UILabel, frame(cellX,50+cellHeight, frameWidth(self.view) - 2*cellX, 0.5));
    line2.backgroundColor = LineBg;
    [mainScrollView addSubview:line2];
    
    
    
    vocational = allocAndInitWithFrame(UITextField, frame(textFieldX, bH+100, frameWidth(self.view) - 2*textFieldX, cellHeight -bH ));
    
    vocational.clearButtonMode = UITextFieldViewModeWhileEditing;
    vocational.placeholder = @"请输入职位";
    vocational.font = [UIFont systemFontOfSize:26.0*SpacedFonts];
    vocational.textColor =BlackTitleColor;
    vocational.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入职位" attributes:@{NSForegroundColorAttributeName: LightBlackTitleColor}];
    [mainScrollView addSubview:vocational];
    
    UIImage *vocationalImage =[UIImage imageNamed:@"icon_zhiwei"];
    UIView *vocationalleftView = allocAndInitWithFrame(UIView , frame(cellX, frameY(vocational), 50, frameHeight(vocational)));
    UIImageView *vocationalleftImageView =allocAndInitWithFrame(UIImageView, frame(18, (frameHeight(vocational) -vocationalImage.size.height)/2.0 , vocationalImage.size.width, vocationalImage.size.height));
    vocationalleftImageView.image =vocationalImage;
    [vocationalleftView addSubview:vocationalleftImageView] ;
    [mainScrollView addSubview:vocationalleftView];
    
    
    UILabel *line3 = allocAndInitWithFrame(UILabel, frame(cellX, 100+cellHeight, frameWidth(self.view) - 2*cellX, 0.5));
    line3.backgroundColor = LineBg;
    [mainScrollView addSubview:line3];
//    UILabel *line2 = allocAndInitWithFrame(UILabel, frame(cellX, CGRectGetMaxY(line1.frame) + 45, 100*ScreenMultiple, 0.5));
//    line2.backgroundColor = LineBg;
//    [mainScrollView addSubview:line2];
//    
//    UILabel *line3 = allocAndInitWithFrame(UILabel, frame(APPWIDTH -  CGRectGetMaxX(line2.frame), frameY(line2),frameWidth(line2), frameHeight(line2)));
//    line3.backgroundColor = LineBg;
//    [mainScrollView addSubview:line3];
    
//    [UILabel createLabelWithFrame:frame(0, CGRectGetMaxY(line1.frame)+ 40, APPWIDTH, 15) text:@"选择行业" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentCenter inView:mainScrollView];
//    
//    
//   
//    float itemY =CGRectGetMaxY(line3.frame) + 50;
//    float itemW = APPWIDTH/5.0;
//    float itemH = 30;
//    float itemBt = itemW/2.0;
//    __weak RegistFinishViewController *weakSelf = self;
//    for (int i =0; i<_arrayTitle.count; i++) {
//        
//        NSString *tilte = _arrayTitle[i];
//        _selectedBtn = [[BaseButton alloc]initWithFrame:frame(itemBt + (i%3)*(itemW + itemBt), itemY +(i/3)*(itemH + 20), itemW, itemH) setTitle:tilte titleSize:28*SpacedFonts titleColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:WhiteColor inView:mainScrollView];
//        [_selectedBtn setRadius:frameHeight(_selectedBtn)/2.0];
//        [_selectedBtn setBorder:LineBg width:1.0];
//        if (i ==0) {
//            [_selectedBtn setBorder:AppMainColor width:1.0];
//            [_selectedBtn setBackgroundColor:AppMainColor];
//            [_selectedBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
//        }
//        _selectedBtn.didClickBtnBlock = ^
//        {
//            for (int j=0; j<_selectedArray.count; j++) {
//                
//                BaseButton *tag = weakSelf.selectedArray[j];
//                if (j==i) {
//                    [tag setBorder:AppMainColor width:1.0];
//                    [tag setBackgroundColor:AppMainColor];
//                    [tag setTitleColor:WhiteColor forState:UIControlStateNormal];
//                }
//                else
//                {
//                [tag setBorder:LineBg width:1.0];
//                [tag setBackgroundColor:WhiteColor];
//                [tag setTitleColor:LightBlackTitleColor forState:UIControlStateNormal];
//                }
//                
//            }
//            _selectedindex = i;
//            
//        };
//        
//        [_selectedArray addObject:_selectedBtn];
//    }
//    
//    
}


#pragma mark
#pragma mark - buttonAction -
//- (void)buttonAction:(UIButton *)sender
//{
//    if (sender.tag ==0)
//    {
//        [self.navigationController popViewControllerAnimated:NO];
//    }
//}

-(void)industryClick:(UIButton *)sender
{
  
    NSMutableDictionary *sendcaptchaParam = [NSMutableDictionary dictionary];
    if ([CoreArchive strForKey:DeviceToken]) {
        [sendcaptchaParam setObject:[CoreArchive strForKey:DeviceToken] forKey:@"channelid"];
    }
    
    [sendcaptchaParam setObject:_phoneNum forKey:KuserName];
    [sendcaptchaParam setObject:[_password md5]   forKey:passWord];
    [sendcaptchaParam setObject:@"2" forKey:@"type"];
    //          NSLog(@"sendcaptchaParam =%@",sendcaptchaParam);
    [[ToolManager shareInstance] showWithStatus];
    [XLDataService postWithUrl:LoginURL param:sendcaptchaParam modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (error) {
            [[ToolManager shareInstance] showInfoWithStatus:@"获取数据失败,请重新请求或查看网络状态"];
            return ;
        }
        [[ToolManager shareInstance]dismiss];
    }];
    NSMutableDictionary *parame = [Parameter parameterWithSessicon];
    
//    NSLog(@"parame=====%@",parame);
//    [parame setObject:[CoreArchive strForKey:DeviceToken] forKey:@"channelid"];
    
    [XLDataService postWithUrl:IndustryURL param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        
        if (dataObj) {
            if ([dataObj[@"rtcode"] intValue] ==1) {
    IndustrySelectionViewController *industrySelectionVC = [[IndustrySelectionViewController alloc]init];
    industrySelectionVC.dataObj = dataObj;
    industrySelectionVC.editBlock = ^(NSString *text,NSString *num)
    {

//        NSLog(@"text===%@",text);
                industryLab.text = text;
        
        industryLab.textColor=[UIColor blackColor];
    };

          PushView(self, industrySelectionVC);
                
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
