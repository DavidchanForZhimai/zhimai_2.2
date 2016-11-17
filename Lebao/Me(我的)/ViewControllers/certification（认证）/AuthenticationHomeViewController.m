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

#import "BasicInformationViewController.h"

#import "NSString+Extend.h"
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
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)NSMutableDictionary * parame;
@property(nonatomic,strong)UIImageView *userIcon;
@property(nonatomic,strong)UILabel *username;
@property(nonatomic,strong)UILabel *userOtherInfo;
@property(nonatomic,strong)BaseButton *edit;
@property(nonatomic,strong)UILabel *returnLiyou;
@property(nonatomic,strong)AuthenticationModal *modal;

@property(nonatomic,strong)UILabel *xinxi;
@end

@implementation AuthenticationHomeViewController
{
    NSString *url;
    
}
#pragma mark
#pragma mark -推送
- (void)pushModel:(PushDataChat *)pushData
{
    [self netWork];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navViewTitleAndBackBtn:@"身份认证"];
    [self.view addSubview:self.authenticationHomeView];
    [self.view addSubview:self.upload];
    [self netWork];
    
     _parame = [Parameter parameterWithSessicon];
    
    
}
- (void)netWork
{
    [[ToolManager shareInstance] showWithStatus];
    [XLDataService postWithUrl:AuthenURL param:[Parameter parameterWithSessicon] modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (dataObj) {
            _modal = [AuthenticationModal mj_objectWithKeyValues:dataObj];
                        NSLog(@"dataObj =%@",dataObj);
            if (_modal.rtcode ==1) {
                _authenticationHomeView.userInteractionEnabled = YES;
                [[ToolManager shareInstance] dismiss];
                url =_modal.datas.cardpic;
                if (_modal.datas.authen&&_modal.datas.authen!=1&&url.length>0) {
                    [[ToolManager shareInstance] imageView:_imageView setImageWithURL:url placeholderType:PlaceholderTypeImageProcessing];
                }
                [[ToolManager shareInstance] imageView:_userIcon setImageWithURL:_modal.datas.imgurl placeholderType:PlaceholderTypeUserHead];
                _username.text = _modal.datas.realname;
                
                NSString *position;
                if (_modal.datas.position.length>0) {
                    position = [NSString stringWithFormat:@"%@  %@\n",_modal.datas.position,_modal.datas.tel];
                    
                }
                else
                {
                    position = _modal.datas.tel;
                    if (position.length>0) {
                        position = [NSString stringWithFormat:@"%@/n",_modal.datas.tel];
                    }
                }
                _userOtherInfo.text = [NSString stringWithFormat:@"%@%@",position,_modal.datas.address];
                
                if (_modal.datas.authen ==9) {
                    
                     [_parame setObject:url forKey:@"cardpic"];
                    _returnLiyou.text =[NSString stringWithFormat:@"驳回理由:%@",_modal.datas.remark];
                    _returnLiyou.numberOfLines = 0;
                    _returnLiyou.frame = CGRectMake(_returnLiyou.x, _returnLiyou.y, _returnLiyou.width, [_returnLiyou.text sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(_returnLiyou.width, 1000)].height + 20);
                    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:_returnLiyou.text];
                    [string addAttribute:NSForegroundColorAttributeName value:BlackTitleColor range:[_returnLiyou.text rangeOfString:@"驳回理由:"]];
                    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:[_returnLiyou.text rangeOfString:@"驳回理由:"]];
                    _returnLiyou.attributedText = string;
                    _authenticationHomeView.contentSize = CGSizeMake(_authenticationHomeView.width, CGRectGetMaxY(_returnLiyou.frame) + 10);
                }
                
                NSString *text =@"修改";
                UIColor *color = hexColor(ff722d);
                BOOL isEdit = NO;
                if (_modal.datas.authen ==1||_modal.datas.authen==9) {
                    text = @"修改";
                    color = hexColor(ff722d);
                    isEdit = YES;
                    
                }
                if (_modal.datas.authen==2) {
                    text = @"审核中";
                    color = lightGrayTitleColor;
                    isEdit = NO;
                }
                if (_modal.datas.authen==3) {
                    text = @"审核通过";
                    color = lightGrayTitleColor;
                    isEdit = NO;
                }
                
                [_edit setTitle:text forState:UIControlStateNormal];
                [_edit setTitleColor:color forState:UIControlStateNormal];
                _edit.enabled = isEdit;
                
                NSString *str = @"提交认证";
                BOOL isEnable = NO;
                _xinxi.text = @"核对我的认证信息";
                UIColor *_uploadColor =rgba(210, 210, 210, 0.8);
                if (_modal.datas.authen ==2) {
                    _xinxi.text = @"我的认证信息";
                    str = @"审核中";
                    isEnable = NO;
                    _uploadColor = rgba(210, 210, 210, 0.8);
                }
                if (_modal.datas.authen ==3) {
                    _xinxi.text = @"我的认证信息";
                    str = @"审核通过";
                    isEnable = NO;
                    _uploadColor = rgba(210, 210, 210, 0.8);
                }
                if (_modal.datas.authen ==9) {
                    _xinxi.text = @"核对我的认证信息";
                    str = @"审核失败 重新提交";
                    isEnable = YES;
                    _uploadColor = AppMainColor;
                }
                [_upload setTitle:str forState:UIControlStateNormal];
                [_upload setBackgroundColor:_uploadColor];
                _upload.enabled = isEnable;
            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus:_modal.rtmsg];
                _authenticationHomeView.userInteractionEnabled = NO;
            }
            
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus];
            _authenticationHomeView.userInteractionEnabled = NO;
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
    
    _authenticationHomeView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + NavigationBarHeight+10, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight+ TabBarHeight))];
    _authenticationHomeView.backgroundColor = WhiteColor;
    _authenticationHomeView.scrollEnabled = YES;
    UILabel *title = [UILabel createLabelWithFrame:CGRectMake(30, 0, APPWIDTH -60, 100) text:@"上传名片认证职业身份\n\n认证成功后将获得“认证“图标，将认识更多优质人脉" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:_authenticationHomeView];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:title.text];
    [str addAttribute:NSFontAttributeName value:Size(32) range:[title.text rangeOfString:@"上传名片认证职业身份"]];
    [str addAttribute:NSForegroundColorAttributeName value:BlackTitleColor range:[title.text rangeOfString:@"上传名片认证职业身份"]];
    title.attributedText = str;
    title.numberOfLines = 0;
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake((APPWIDTH - image.size.width)/2.0, 100, image.size.width, image.size.height)];
    _imageView.image = image;
    
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap:) ];
    tap.numberOfTapsRequired = 1;
    [_imageView addGestureRecognizer:tap];
    
    [_authenticationHomeView addSubview:_imageView];
    
    _xinxi = [UILabel createLabelWithFrame:CGRectMake(10, CGRectGetMaxY(_imageView.frame)+ 10, APPWIDTH, 30) text:@"核对我的认证信息" fontSize:12 textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:_authenticationHomeView];
    _authenticationHomeView.contentSize=CGSizeMake(0, CGRectGetMaxY(_imageView.frame)+50);
    
    UIView *userView =[[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_imageView.frame)+ 40, APPWIDTH - 20, 70)];
    [userView setRadius:3];
    [userView setBorder:LineBg width:0.5];
    userView.userInteractionEnabled = YES;
    [_authenticationHomeView addSubview:userView];
    
    _userIcon = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 40, 40)];
    [_userIcon setRound];
    [userView addSubview:_userIcon];
    
    _username = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMaxX(_userIcon.frame) + 5, 10, APPWIDTH/2.0, 15) text:@"" fontSize:14 textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:userView ];
    
    _userOtherInfo = [UILabel createLabelWithFrame:CGRectMake(_username.x, CGRectGetMaxY(_username.frame) + 5, APPWIDTH/2.0, 35) text:@"" fontSize:12 textColor:lightGrayTitleColor textAlignment:NSTextAlignmentLeft inView:userView];
    _userOtherInfo.numberOfLines = 0;
    
    NSString *text =@"修改";
    UIColor *color = hexColor(ff722d);
    BOOL isEdit = NO;
    _edit = [[BaseButton alloc]initWithFrame:CGRectMake(userView.width - 80, 0, 80, userView.height) setTitle:text titleSize:13 titleColor:color textAlignment:NSTextAlignmentRight backgroundColor:WhiteColor inView:userView];
    _edit.enabled =isEdit;
    __weak typeof(self) weakSelf = self;
    _edit.didClickBtnBlock =^
    {
        BasicInformationViewController *info = [[BasicInformationViewController alloc] init];
        info.authenBlock = ^(NSString *imgurl,NSString *realname,NSString *position, NSString *address)
        {
            [[ToolManager shareInstance] imageView:weakSelf.userIcon setImageWithURL:imgurl placeholderType:PlaceholderTypeUserHead];
            weakSelf.username.text = realname;
            NSString *positions;
            if (position.length>0) {
                positions = [NSString stringWithFormat:@"%@  %@\n",position,_modal.datas.tel];
                
            }
            else
            {
                positions = _modal.datas.tel;
                if (positions.length>0) {
                    positions = [NSString stringWithFormat:@"%@/n",_modal.datas.tel];
                }
            }
            weakSelf.userOtherInfo.text = [NSString stringWithFormat:@"%@%@",positions,address];
        };
        [weakSelf.navigationController pushViewController:info animated:YES];
        
    };
    _returnLiyou = [UILabel createLabelWithFrame:CGRectMake(10, CGRectGetMaxY(userView.frame) + 10,APPWIDTH - 20,0) text:@"" fontSize:12 textColor:lightGrayTitleColor textAlignment:NSTextAlignmentLeft inView:_authenticationHomeView];
    
    return  _authenticationHomeView;
}

-(void)imageViewTap:(UITapGestureRecognizer *)sender
{
    if (_modal.datas.authen ==1||_modal.datas.authen==9) {
        [[ToolManager shareInstance] seleteImageFormSystem:self seleteImageFormSystemBlcok:^(UIImage *image) {
            [[ToolManager shareInstance] showWithStatus:@"上传中"];
            [[UpLoadImageManager shareInstance] upLoadImageType:@"authen" image:image imageBlock:^(UpLoadImageModal * upLoadImageModal) {
                [[ToolManager shareInstance] dismiss];
                _upload.enabled = YES;
                _upload.backgroundColor = AppMainColor;
                [[ToolManager shareInstance] imageView:_imageView setImageWithURL:upLoadImageModal.imgurl placeholderType:PlaceholderTypeImageProcessing];
            
                [_parame setObject:upLoadImageModal.imgurl forKey:@"cardpic"];
                
            }];
        }];
        
    }
    else
    {
        LWImageBrowserModel* imageModel = [[LWImageBrowserModel alloc]initWithLocalImage:_imageView.image imageViewSuperView:_authenticationHomeView positionAtSuperView:_imageView.frame index:0];
        
        LWImageBrowser* imageBrowser = [[LWImageBrowser alloc] initWithParentViewController:self
                                                                                imageModels:@[imageModel]
                                                                               currentIndex:0];
        imageBrowser.view.backgroundColor = [UIColor blackColor];
        [imageBrowser show];
    }
    
}
- (BaseButton *)upload
{
    if (_upload) {
        return _upload;
    }
    
    NSString *str = @"提交认证";
    BOOL isEnable = NO;
    
    _upload = [[BaseButton alloc]initWithFrame:CGRectMake(0, APPHEIGHT - TabBarHeight, APPWIDTH, TabBarHeight) setTitle:str titleSize:30*SpacedFonts titleColor:WhiteColor textAlignment:NSTextAlignmentCenter backgroundColor:AppMainColor inView:nil];
    _upload.enabled = isEnable;
    if (!isEnable) {
        _upload.backgroundColor = rgba(210, 210, 210, 0.8);
    }
    _upload.shouldAnmial = NO;
    __weak typeof(self) weakSelf = self;
    _upload.didClickBtnBlock = ^
    {
        
        if (!weakSelf.parame||weakSelf.parame.allKeys.count<[Parameter parameterWithSessicon].allKeys.count + 1) {
            
            [[ToolManager shareInstance] showAlertMessage:@"请上传图片"];
            return ;
        }
        
        [XLDataService postWithUrl:SaveAuthenURL param:weakSelf.parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
            
            if (dataObj) {
                if ([dataObj[@"rtcode"] integerValue]==1) {
                    
                    [[ToolManager shareInstance] showSuccessWithStatus:@"上传成功！"];
                    [weakSelf.upload setTitle:@"审核中" forState:UIControlStateNormal];
                    weakSelf.edit.enabled = NO;
                    [weakSelf.edit setTitle:@"审核中" forState:UIControlStateNormal];
                    [weakSelf.edit setTitleColor:lightGrayTitleColor forState:UIControlStateNormal];
                    weakSelf.upload.enabled = NO;
                    weakSelf.modal.datas.authen = 2;
                     weakSelf.xinxi.text = @"我的认证信息";
                    weakSelf.upload.backgroundColor = rgba(210, 210, 210, 0.8);
                    
                }
                else
                {
                    [[ToolManager shareInstance]showInfoWithStatus:dataObj[@"rtmsg"]];
                    [weakSelf.upload setTitle:@"上传失败 重新上传" forState:UIControlStateNormal];
                    weakSelf.upload.enabled = YES;
                    weakSelf.upload.backgroundColor = AppMainColor;
                }
                
            }
            else
            {
                [weakSelf.upload setTitle:@"上传失败 重新上传" forState:UIControlStateNormal];
                weakSelf.upload.enabled = YES;
                [[ToolManager shareInstance]showInfoWithStatus];
            }
            
            
            
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
