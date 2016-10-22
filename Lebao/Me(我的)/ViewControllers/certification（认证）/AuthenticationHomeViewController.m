//
//  AuthenticationHomeViewController.m
//  Lebao
//
//  Created by David on 16/9/19.
//  Copyright © 2016年 David. All rights reserved.
//

#import "AuthenticationHomeViewController.h"

#import "UpLoadImageManager.h"

#import "XLDataService.h"

#import "LWImageBrowser.h"
//认证
#define AuthenURL [NSString stringWithFormat:@"%@user/authen",HttpURL]
#define SaveAuthenURL [NSString stringWithFormat:@"%@user/save-authen",HttpURL]

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


@interface AuthenticationHomeViewController ()
@property(nonatomic,strong)UIScrollView *authenticationHomeView;
@property(nonatomic,strong)BaseButton *upload;
@property(nonatomic,strong)UIView *authenView;
@property(nonatomic,strong)UIImageView *authenImageView;
@end

@implementation AuthenticationHomeViewController
{
    NSString *url;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navViewTitleAndBackBtn:@"身份认证"];
    
    [self.view addSubview:self.authenticationHomeView];
    [self.authenticationHomeView addSubview:self.upload];
    [self netWork];
    

}
- (void)netWork
{
    [[ToolManager shareInstance] showWithStatus];
    [XLDataService postWithUrl:AuthenURL param:[Parameter parameterWithSessicon] modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        
        if (dataObj) {
           AuthenticationModal *modal = [AuthenticationModal mj_objectWithKeyValues:dataObj];
           
            if (modal.rtcode ==1) {
                [[ToolManager shareInstance] dismiss];
                if (modal.datas.cardpic&&![modal.datas.cardpic isEqualToString:@""]) {
                    url =modal.datas.cardpic;
                    [self.authenticationHomeView addSubview:self.authenView];
                    [[ToolManager shareInstance] imageView:self.authenImageView setImageWithURL:modal.datas.cardpic placeholderType:PlaceholderTypeOther];
                    self.authenImageView.contentMode = UIViewContentModeScaleAspectFit;
                    self.upload.frame = CGRectMake(30, CGRectGetMaxY(self.authenView.frame) + 40, APPWIDTH - 60, 35);
                    
                    if (CGRectGetMaxY(self.upload.frame) +10 >self.authenticationHomeView.height) {
                        
                        self.authenticationHomeView.contentSize = CGSizeMake(self.authenticationHomeView.width, CGRectGetMaxY(self.upload.frame) +10);
                    }
                }
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
}
#pragma mark
#pragma mark getters
- (UIScrollView *)authenticationHomeView
{
    if (_authenticationHomeView) {
        return  _authenticationHomeView;
    }
    UIImage  *image = [UIImage imageNamed:@"icon_me_mingpian"];
    
    _authenticationHomeView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + NavigationBarHeight+10, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight+10))];
    _authenticationHomeView.backgroundColor = WhiteColor;
    
    UILabel *title = [UILabel createLabelWithFrame:CGRectMake(30, 0, APPWIDTH -60, 100) text:@"我该怎么做？\n\n只需要确保您所填写的信息和名片的保持一致，就可以通过审核!" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:_authenticationHomeView];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:title.text];
    [str addAttribute:NSFontAttributeName value:Size(32) range:[title.text rangeOfString:@"我该怎么做？"]];
    [str addAttribute:NSForegroundColorAttributeName value:BlackTitleColor range:[title.text rangeOfString:@"我该怎么做？"]];
    title.attributedText = str;
    title.numberOfLines = 0;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((APPWIDTH - image.size.width)/2.0, 100, image.size.width, image.size.height)];
    imageView.image = image;
    [_authenticationHomeView addSubview:imageView];
    _authenticationHomeView.contentSize=CGSizeMake(0, CGRectGetMaxY(imageView.frame)+10);
    return  _authenticationHomeView;
}
- (UIView *)authenView
{
    
    if (!_authenView) {
         UIImage  *image = [UIImage imageNamed:@"icon_me_mingpian"];
        _authenView  = [[UIView alloc]initWithFrame:CGRectMake(0, image.size.height + 130, APPWIDTH, 120)];
        _authenView.backgroundColor = WhiteColor;
        
        [_authenView addSubview:self.authenImageView];
        
        UIView *lien1 = [[UIView alloc]initWithFrame:frame(0, 0, APPHEIGHT, 10)];
        lien1.backgroundColor = AppViewBGColor;
        [_authenView addSubview:lien1];
       
        UIView *lien2 = [[UIView alloc]initWithFrame:frame(0, 110, APPHEIGHT, 10)];
        lien2.backgroundColor = AppViewBGColor;
        [_authenView addSubview:lien2];
        
    }
    
    return _authenView;
    
}
- (UIImageView *)authenImageView
{
    if (!_authenImageView) {
        _authenImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, APPWIDTH - 40, 80)];
    }
    _authenImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap:)];
    
    tap.numberOfTapsRequired = 1;
    
    [_authenImageView addGestureRecognizer:tap];
    
    return _authenImageView;
}
-(void)imageViewTap:(UITapGestureRecognizer *)sender
{
    
    LWImageBrowserModel* imageModel = [[LWImageBrowserModel alloc]initWithLocalImage:_authenImageView.image imageViewSuperView:_authenView positionAtSuperView:_authenImageView.frame index:0];
    
    LWImageBrowser* imageBrowser = [[LWImageBrowser alloc] initWithParentViewController:self
                                                                            imageModels:@[imageModel]
                                                                           currentIndex:0];
    imageBrowser.view.backgroundColor = [UIColor blackColor];
    [imageBrowser show];

}
- (BaseButton *)upload
{
    if (_upload) {
        return _upload;
    }
    
    _upload = [[BaseButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.authenView.frame) + 40, APPWIDTH - 60, 35) setTitle:@"上传自己的名片" titleSize:28*SpacedFonts titleColor:WhiteColor textAlignment:NSTextAlignmentCenter backgroundColor:AppMainColor inView:nil];
    [_upload setRadius:5];
    _upload.shouldAnmial = NO;
    __weak typeof(self) weakSelf = self;
    _upload.didClickBtnBlock = ^
    {
        
        [[ToolManager shareInstance] seleteImageFormSystem:weakSelf seleteImageFormSystemBlcok:^(UIImage *image) {
                [[ToolManager shareInstance] showWithStatus:@"修改中.."];
                [[UpLoadImageManager shareInstance] upLoadImageType:@"authen" image:image   imageBlock:^(UpLoadImageModal * upLoadImageModal) {
                        NSMutableDictionary * parame = [Parameter parameterWithSessicon];
                    
                        [parame setObject:upLoadImageModal.imgurl forKey:@"cardpic"];
                    
                        [XLDataService postWithUrl:SaveAuthenURL param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
                    
                            if (dataObj) {
                                if ([dataObj[@"rtcode"] integerValue]==1) {
                                    url =upLoadImageModal.imgurl;;
                                    [[ToolManager shareInstance] showSuccessWithStatus:@"上传成功！"];
                                    [weakSelf.authenView removeFromSuperview];
                                    [weakSelf.authenticationHomeView addSubview:weakSelf.authenView];
                                    [[ToolManager shareInstance] imageView:weakSelf.authenImageView setImageWithURL:upLoadImageModal.imgurl placeholderType:PlaceholderTypeOther];
                                    weakSelf.authenImageView.contentMode = UIViewContentModeScaleAspectFit;
                                    weakSelf.upload.frame = CGRectMake(30, CGRectGetMaxY(weakSelf.authenView.frame) + 40, APPWIDTH - 60, 35);
                                    
                                    if (CGRectGetMaxY(weakSelf.upload.frame) +10 >weakSelf.authenticationHomeView.height) {
                                        weakSelf.authenticationHomeView.contentSize = CGSizeMake(weakSelf.authenticationHomeView.width, CGRectGetMaxY(weakSelf.upload.frame) +10);
                                    }

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

                    }];
                
            
        }];

    };
     return _upload;
}

#pragma mark
#pragma mark - btn 
- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
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
