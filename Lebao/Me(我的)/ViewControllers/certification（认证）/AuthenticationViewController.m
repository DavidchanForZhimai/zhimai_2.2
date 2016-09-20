
//
//  Authentication ViewController.m
//  Lebao
//
//  Created by David on 15/12/23.
//  Copyright © 2015年 David. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "XLDataService.h"
#import "UpLoadImageManager.h"
#import "FSComboListView.h"
//认证
#define AuthenURL [NSString stringWithFormat:@"%@user/authen",HttpURL]
#define SaveAuthenURL [NSString stringWithFormat:@"%@user/save-authen",HttpURL]
@interface AuthenticationViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIScrollView *_myAuthenticationView;
    UITextField *_userName;
    UITextField *_identityCard;
    
    BaseButton *_leftImage;
    BaseButton *_rightImage;
    NSString  *leftImageUrl;
    NSString  *rightImageUrl;
    
    AuthenticationModal *modal;
    
}
@property(nonatomic,strong) FSComboListView * comboBox;
@end
typedef NS_ENUM(NSInteger, ButtonAction) {
    ButtonActionSubmit ,
    
};

@implementation AuthenticationModal


@end
@implementation AuthenDatas

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}
@end
@implementation AuthenIndustry


@end

@implementation AuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navView];
    
    [[ToolManager shareInstance] showWithStatus];
    [XLDataService postWithUrl:AuthenURL param:[Parameter parameterWithSessicon] modelClass:nil responseBlock:^(id dataObj, NSError *error) {

        if (dataObj) {
            modal = [AuthenticationModal mj_objectWithKeyValues:dataObj];
            leftImageUrl= modal.datas.cardpic;
            rightImageUrl = modal.datas.idcard;
            if (modal.rtcode ==1) {
                [[ToolManager shareInstance] dismiss];
                 [self addMainView];
            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus:modal.rtmsg];
            }
            
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus];
        }
        
    }];

    [self addMainView];
}

#pragma mark - Navi_View
- (void)navView
{
    [self navViewTitleAndBackBtn:@"认证" ];
    
    
}

#pragma mark
#pragma mark - addTableView -
- (void)addMainView
{
    
    for (UIView *subView in _myAuthenticationView.subviews) {
        [subView removeFromSuperview];
    }
    _myAuthenticationView =[[UIScrollView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)) ];
    _myAuthenticationView.alwaysBounceVertical = YES;
    _myAuthenticationView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:_myAuthenticationView];
    //认证中
    if (_authen ==2) {
        _myAuthenticationView.userInteractionEnabled = NO;
    }
    
    UIView *_myAuthenView = allocAndInitWithFrame(UIView, frame(0, 8, APPWIDTH, 122));
    _myAuthenView.backgroundColor = [UIColor whiteColor];
    [_myAuthenticationView addSubview:_myAuthenView];
    
    
    UILabel *userNameLb =[UILabel createLabelWithFrame:frame(10, 0, 28*SpacedFonts*2,frameHeight(_myAuthenView)/3.0) text:@"姓名" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:_myAuthenView];
    
    _userName = allocAndInitWithFrame(UITextField, frame(CGRectGetMaxX(userNameLb.frame)+48,frameY(userNameLb), APPWIDTH -CGRectGetMaxX(userNameLb.frame) - 50 , frameHeight(userNameLb)));
    
    _userName.placeholder = @"请输入您的姓名";
    _userName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的姓名" attributes:@{NSForegroundColorAttributeName:LightBlackTitleColor}];
    _userName.textColor = BlackTitleColor;
    _userName.font =[UIFont systemFontOfSize:24*SpacedFonts];
    _userName.clearButtonMode = UITextFieldViewModeWhileEditing;
    if (modal.datas.username) {
        _userName.text = modal.datas.realname;
    }
    [_myAuthenView addSubview:_userName];
    
    UILabel *line1 = allocAndInitWithFrame(UILabel, frame(0, CGRectGetMaxY(userNameLb.frame), APPWIDTH , 0.5));
    line1.backgroundColor = LineBg;
    [_myAuthenView addSubview:line1];
    
    UILabel *_identityCardLb =[UILabel createLabelWithFrame:frame(frameX(userNameLb), frameHeight(userNameLb) , 28*SpacedFonts*3, frameHeight(userNameLb)) text:@"身份证" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:_myAuthenView];
    
    _identityCard = allocAndInitWithFrame(UITextField, frame(frameX(_userName),frameY(_identityCardLb), APPWIDTH -CGRectGetMaxX(userNameLb.frame) - 50 , frameHeight(userNameLb)));
    
    _identityCard.placeholder = @"请输入身份证号码";

    _identityCard.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入身份证号码" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor] }];
    _identityCard.textColor = _userName.textColor;
    _identityCard.font =[UIFont systemFontOfSize:24*SpacedFonts];
    _identityCard.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [_myAuthenView addSubview:_identityCard];
    if (modal.datas.code) {
        _identityCard.text =modal.datas.code;
    }
    
    UILabel *line2 = allocAndInitWithFrame(UILabel, frame(0, CGRectGetMaxY(_identityCardLb.frame), APPWIDTH , 0.5));
    line2.backgroundColor = LineBg;
    [_myAuthenView addSubview:line2];
    
    
   [UILabel createLabelWithFrame:frame(frameX(userNameLb), 2*frameHeight(userNameLb) , 28*SpacedFonts*2, frameHeight(userNameLb)) text:@"行业" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:_myAuthenView];
     __weak AuthenticationViewController *weakSelf =self;

    _comboBox = [[FSComboListView alloc] initWithValues:@[@"保险",@"金融",@"房产",@"车行"]
                                                                    frame:frame(frameX(_myAuthenticationView), 2*frameHeight(userNameLb) +(frameHeight(userNameLb) -25)/2.0 +10, APPWIDTH, frameHeight(userNameLb))];
    _comboBox.Combotype = comboListTypePicker;
    _comboBox.valueLabel.layer.borderColor = [UIColor clearColor].CGColor;
    _comboBox.valueLabel.font = Size(28);
    [_myAuthenticationView addSubview:_comboBox];
    
    
    if (modal.datas.industry) {
    
        _comboBox.valueLabel.text = [Parameter industryForChinese:modal.datas.industry];
    }

    
    [UILabel createLabelWithFrame:frame(frameX(userNameLb), 12 + CGRectGetMaxY(_myAuthenView.frame) , 28*SpacedFonts*5,  28*SpacedFonts) text:@"工牌或名片" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:_myAuthenticationView];
    
    UIView *_loadView = allocAndInitWithFrame(UIView, frame(10, CGRectGetMaxY(_myAuthenView.frame) + 35, APPWIDTH - 20, 133));
    _loadView.backgroundColor = WhiteColor;
    [_loadView setBorder:LineBg width:0.5];
    [_myAuthenticationView addSubview:_loadView];
    
    float orgin = 20;
    float btW =  frameHeight(_loadView) - orgin*2;
    float  imageW=  btW - 20;
    
    _leftImage = [[BaseButton alloc]initWithFrame:frame(orgin, orgin, btW, btW) setTitle:@"" titleSize:20*SpacedFonts titleColor:LightBlackTitleColor backgroundImage:[UIImage imageNamed:@"addition"] iconImage:nil highlightImage:nil setTitleOrgin:CGPointMake(imageW + 5,(btW -200*SpacedFonts)/2.0 ) setImageOrgin:CGPointMake(0, orgin) inView:_loadView];
    [UILabel createLabelWithFrame:frame(frameX(_leftImage) -10, CGRectGetMaxY(_leftImage.frame), frameWidth(_leftImage) + 20,15) text:@"上传名片(必填)" fontSize:20*SpacedFonts textColor:[UIColor redColor] textAlignment:NSTextAlignmentCenter inView:_loadView];
    _leftImage.didClickBtnBlock = ^
    {
        [weakSelf  seletedImageFormSystem:0];
    };
    if (![modal.datas.cardpic isEqualToString:@""]&&modal.datas.cardpic) {
        
        [[ToolManager shareInstance] imageView:_leftImage setImageWithURL:modal.datas.cardpic placeholderType:PlaceholderTypeImageUnProcessing];
    }
    
     _rightImage = [[BaseButton alloc]initWithFrame:frame(frameWidth(_loadView) -btW -orgin , orgin, btW, btW) setTitle:@"" titleSize:20*SpacedFonts titleColor:LightBlackTitleColor backgroundImage:[UIImage imageNamed:@"addition"] iconImage:nil highlightImage:nil setTitleOrgin:CGPointMake(imageW + 5,(btW -100*SpacedFonts)/2.0 ) setImageOrgin:CGPointMake(0, orgin) inView:_loadView];
    [UILabel createLabelWithFrame:frame(frameX(_rightImage), CGRectGetMaxY(_rightImage.frame), frameWidth(_rightImage),15) text:@"上传身份证" fontSize:20*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:_loadView];
    _rightImage.didClickBtnBlock = ^
    {
         [weakSelf  seletedImageFormSystem:1];
    };
    if (![modal.datas.idcard isEqualToString:@""]&&modal.datas.idcard) {
        
        [[ToolManager shareInstance] imageView:_rightImage setImageWithURL:modal.datas.idcard placeholderType:PlaceholderTypeImageUnProcessing];
    }

    BaseButton *submit =[[BaseButton alloc]initWithFrame:frame(66*ScreenMultiple, 320, APPWIDTH - 132*ScreenMultiple, 40) setTitle:@"提交" titleSize:28*SpacedFonts titleColor:WhiteColor textAlignment:NSTextAlignmentCenter backgroundColor:AppMainColor inView:_myAuthenticationView];
    [submit setRadius:8.0];
    if (_authen==2) {
        [submit setTitle:@"认证中" forState:UIControlStateNormal];
        
    }
    submit.didClickBtnBlock = ^
    {
        
        NSMutableDictionary * parame = [Parameter parameterWithSessicon];
    
        [parame setObject:[Parameter industryForCode:_comboBox.valueLabel.text] forKey:Industry];
        
        [parame setObject:_identityCard.text forKey:@"code"];
        
        [parame setObject:_userName.text forKey:@"realname"];
        if (![leftImageUrl isEqualToString:@""]&&leftImageUrl) {
           [parame setObject:leftImageUrl forKey:@"cardpic"];
        }
        else
        {
            [[ToolManager shareInstance]showInfoWithStatus:@"名片未上传"];
            return ;
        }
        if (![rightImageUrl isEqualToString:@""]&&rightImageUrl) {
            [parame setObject:rightImageUrl forKey:@"idcard"];
        }

        [[ToolManager shareInstance] showWithStatus:@"修改中.."];
        [XLDataService postWithUrl:SaveAuthenURL param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
            
        
            if (dataObj) {
                if ([dataObj[@"rtcode"] integerValue]==1) {
                     PopView(self);
                    [[ToolManager shareInstance] showSuccessWithStatus:@"上传成功！"];
                   
                }
                else
                {
                    [[ToolManager shareInstance]showInfoWithStatus:dataObj[@"rtmsg"]];
                }
                
            }
            else
            {
                [[ToolManager shareInstance]showInfoWithStatus];
            }
            
            
            
        }];
 
    };
    
    
}
- (void)seletedImageFormSystem:(int)seletedIndex
{
    
    [[ToolManager shareInstance] seleteImageFormSystem:self seleteImageFormSystemBlcok:^(UIImage *image) {
        if (seletedIndex ==0) {
            
            [[UpLoadImageManager shareInstance] upLoadImageType:@"authen" image:image   imageBlock:^(UpLoadImageModal * upLoadImageModal) {
                leftImageUrl = upLoadImageModal.imgurl;
                [[ToolManager shareInstance] imageView:_leftImage setImageWithURL:upLoadImageModal.imgurl placeholderType:PlaceholderTypeImageUnProcessing];
            }];
            
        }
        else
        {
            [[UpLoadImageManager shareInstance]upLoadImageType:@"authen" image:image imageBlock:^(UpLoadImageModal * upLoadImageModal) {
                rightImageUrl = upLoadImageModal.imgurl;
                [[ToolManager shareInstance] imageView:_rightImage setImageWithURL:upLoadImageModal.imgurl placeholderType:PlaceholderTypeImageUnProcessing];
            }];
            
        }

    }];
    
   
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
