//
//  ReleaseProductViewController.m
//  Lebao
//
//  Created by David on 15/12/11.
//  Copyright © 2015年 David. All rights reserved.
//

#import "ReleaseProductViewController.h"
#import "EditWebDetailViewController.h"
#import "DWActionSheetView.h"
#import "XLDataService.h"
#import "WetChatShareManager.h"
#import "UpLoadImageManager.h"
#import "IMYWebView.h"
#import "AlreadysentproductViewController.h"
//保存产品和房源
#define Saveproduct [NSString stringWithFormat:@"%@product/saveother",HttpURL]

//发布文章
#define CreatearticleUrl  [NSString stringWithFormat:@"%@release/create",HttpURL]
#define BottomH 55
#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"

@interface ReleaseProductViewController ()<IMYWebViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)IMYWebView  *contentTextView;
@property(nonatomic,strong)BaseButton  *coverImage;
@property(nonatomic,strong)BaseButton *selectedImage;
@property(nonatomic,strong)NSMutableArray *items;
@end
typedef NS_ENUM(int,ButtonActionTag) {
    
    ButtonActionTagImage=2,
    ButtonActionTagAdd ,
    ButtonActionTagSave ,
    ButtonActionTagShare,
    
};
typedef NS_ENUM(int,SwitchActionTag) {
    
    SwitchActionTagBusinessCard =2,
    SwitchActionTagInfo,
    SwitchActionTagCollect,
    SwitchActionTagRed,
    SwitchActionTagPersonalInformation
};
@implementation ReleaseProduct


@end
@implementation ReleaseProductViewController
{
    UIScrollView *_mainScrollView;
    UITextField *_titleTextField;
    UITextField *_authorTextField;
    
    float redHight;
    UIView *_redViewBg;
    
    UITextField *_redTextField;
    
    UILabel     *_contentTextViewPlace;
    UIImageView *_releaseImage;
    
    UISwitch *_personalInformationSwitch;
    UISwitch *_businessCardSwitch;
    UISwitch *_infoSwitch;
    UISwitch *_collectSwitch;
    UISwitch *_redSwitch;
    
    UILabel *_personalInformationLb;
    UILabel *_businessCardLb;
    
    UIView *_info;
    UIView *_infoBg;
    
    UILabel *_infoLb;
    UILabel *_collectLb;
    UILabel *_redLb;
    UIView *_redView;
    
    UIColor *fontColor;
    
    BOOL isHaveDian;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    _items = [NSMutableArray new];
    
    if (_data.isEdit) {
        [self navView:@"产品编辑"];
        [self mainView];
        [self bottomView];
    }
    else
    {
    [self navView:@"发布产品"];
    [[ToolManager shareInstance] showWithStatus];
    [XLDataService postWithUrl:CreatearticleUrl param:[Parameter parameterWithSessicon] modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (dataObj) {
            if ([dataObj[@"rtcode"] intValue] ==1) {
                [[ToolManager shareInstance] dismiss];
                _data.amount =dataObj[@"amount"];
                _data.author =dataObj[@"author"];
                _data.imageurl = [NSMutableArray new];
                _data.selecteds = [NSMutableArray arrayWithObjects:@"0", @"0",@"0",@"0",@"0",@"0",nil];
                [self mainView];
                [self bottomView];
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

}


#pragma mark - Navi_View
- (void)navView:(NSString *)title
{
    [self navViewTitleAndBackBtn:title];
    
}
#pragma mark - mian_View
- (void)mainView
{
    _mainScrollView = allocAndInitWithFrame(UIScrollView, frame(0,StatusBarHeight  + NavigationBarHeight, frameWidth(self.view), APPHEIGHT - StatusBarHeight - NavigationBarHeight -BottomH));
    _mainScrollView.userInteractionEnabled = YES;
    _mainScrollView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:_mainScrollView];
    
    UIView *_releaseViewBg = allocAndInitWithFrame(UIView, frame(10 , 10, frameWidth(_mainScrollView) - 20, 42));
    _releaseViewBg.backgroundColor =[UIColor whiteColor];
    [_releaseViewBg setBorder:LineBg width:0.5];
    [_releaseViewBg setRadius:5.0];
    [_mainScrollView addSubview:_releaseViewBg];
    
    _titleTextField = allocAndInitWithFrame(UITextField, frame(10 , 0, frameWidth(_releaseViewBg)-20, frameHeight(_releaseViewBg)));
    _titleTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入标题" attributes:@{NSForegroundColorAttributeName:LightBlackTitleColor }];
    [_releaseViewBg addSubview:_titleTextField];
    _titleTextField.textColor = BlackTitleColor;
    _titleTextField.font = Size(24);_titleTextField.text = _data.title;
    _titleTextField.clearButtonMode =UITextFieldViewModeWhileEditing;
    
    UIView *_authorViewBg = allocAndInitWithFrame(UIView, frame(10 , CGRectGetMaxY(_releaseViewBg.frame)  + 10, frameWidth(_mainScrollView) - 20, 42));
    _authorViewBg.backgroundColor =[UIColor whiteColor];
    [_authorViewBg setBorder:LineBg width:0.5];
    [_authorViewBg setRadius:5.0];
    [_mainScrollView addSubview:_authorViewBg];
    
    _authorTextField = allocAndInitWithFrame(UITextField, frame(10 , 0, frameWidth(_authorViewBg)-20, frameHeight(_authorViewBg)));
    _authorTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入作者" attributes:@{NSForegroundColorAttributeName:LightBlackTitleColor }];
    [_authorViewBg addSubview:_authorTextField];
    _authorTextField.textColor = BlackTitleColor;
    _authorTextField.font = Size(24);_authorTextField.text = _data.author;
    _authorTextField.clearButtonMode =UITextFieldViewModeWhileEditing;
    
    UIView *_bg = allocAndInitWithFrame(UIView, frame(frameX(_titleTextField), CGRectGetMaxY(_authorViewBg.frame) + 10, APPWIDTH - 2*frameX(_titleTextField), 190*ScreenMultiple));
    _bg.backgroundColor =[UIColor whiteColor];
    
    [_bg setBorder:LineBg width:0.5];
    [_bg setRadius:5.0];
    [_mainScrollView addSubview:_bg];
    _contentTextView = allocAndInitWithFrame(IMYWebView, frame(0, 0, frameWidth(_bg), frameHeight(_bg)));
    
    fontColor = BlackTitleColor;
    if ([_data.content isEqualToString:@""]||!_data.content) {
        _data.content =@"<p>请输入您要发布的内容</p>";
        fontColor =LightBlackTitleColor;
    }
    
    _contentTextView.backgroundColor = [UIColor clearColor];;
    _contentTextView.scrollView.scrollEnabled = NO;
    _contentTextView.delegate = self;
    
    [_contentTextView loadHTMLString:_data.content baseURL:nil];
    [_bg addSubview:_contentTextView];
    
    BaseButton *clickBtn = [[BaseButton alloc]initWithFrame:_contentTextView.frame setTitle:@"" titleSize:0 titleColor:WhiteColor textAlignment:0 backgroundColor:WhiteColor inView:_bg];
    clickBtn.backgroundColor = [UIColor clearColor];
    clickBtn.didClickBtnBlock = ^
    {
        EditWebDetailViewController *edit = allocAndInit(EditWebDetailViewController);
        if (![_data.content isEqualToString:@"<p>请输入您要发布的内容</p>"]) {
            edit.htmlStr = _data.content;
            
        }
        edit.htmlBlock = ^(NSString *str)
        {   _data.content = str;
            [_contentTextView loadHTMLString:_data.content baseURL:nil];
        };
        edit.titles = @"编辑文章";
        PushView(self, edit);
    };
    
    UILabel *line = allocAndInitWithFrame(UILabel , frame(10,CGRectGetMaxY(_bg.frame)+ 10, 3, 28*SpacedFonts));
    line.backgroundColor = AppMainColor;
    [_mainScrollView addSubview:line];
    [UILabel createLabelWithFrame:frame(CGRectGetMaxX(line.frame) + 4, frameY(line), 4*SpacedFonts*28,  28*SpacedFonts) text:@"添加封面" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:_mainScrollView];
    
    UIView *_coverView = allocAndInitWithFrame(UIView , frame(0, CGRectGetMaxY(line.frame) + 10, APPWIDTH, 90));
    _coverView.backgroundColor = WhiteColor;
    [_mainScrollView addSubview:_coverView];
    
    _coverImage = [[BaseButton alloc]initWithFrame:frame(frameX(line), 10, 60, 60) backgroundImage:[UIImage imageNamed:@"addition"] iconImage:nil highlightImage:nil inView:_coverView];
    
    if (_data.currentImageurl) {
        [[ToolManager shareInstance] imageView:_coverImage setImageWithURL:_data.currentImageurl placeholderType:PlaceholderTypeOther];
    }
    
//    [UILabel createLabelWithFrame:frame(0,CGRectGetMaxY(_coverImage.frame), 80, 20) text:@"选择图片相册" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:_coverView];
    
    __weak ReleaseProductViewController *weakSelf = self;
    _coverImage.didClickBtnBlock =^
    {
        [[ToolManager shareInstance] seleteImageFormSystem:weakSelf seleteImageFormSystemBlcok:^(UIImage *image) {
            
            [[UpLoadImageManager shareInstance] upLoadImageType:@"cover" image:image  imageBlock:^(UpLoadImageModal * upLoadImageModal) {
                weakSelf.data.currentImageurl = upLoadImageModal.imgurl;
                [[ToolManager shareInstance] imageView:weakSelf.coverImage setImageWithURL:weakSelf.data.currentImageurl placeholderType:PlaceholderTypeImageProcessing];
            }];
            
        }];
    };
    
    //上传产品图
    UILabel *line2 = allocAndInitWithFrame(UILabel , frame(10,CGRectGetMaxY(_coverView.frame)+ 10, 3, 28*SpacedFonts));
    line2.backgroundColor = AppMainColor;
    [_mainScrollView addSubview:line2];
    [UILabel createLabelWithFrame:frame(CGRectGetMaxX(line2.frame) + 3, frameY(line2), APPWIDTH, 28*SpacedFonts) text:@"上传产品图" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:_mainScrollView];
    
    UIScrollView *_coverSelectedView  = allocAndInitWithFrame(UIScrollView , frame(0, CGRectGetMaxY(line2.frame) + 10 , APPWIDTH, 80));
    
    _selectedImage = [[BaseButton alloc]initWithFrame:frame(10, 10, 60, 60) backgroundImage:[UIImage imageNamed:@"addition"] iconImage:nil highlightImage:nil inView:_coverSelectedView];
    _selectedImage.didClickBtnBlock = ^
    {
        if (weakSelf.data.imageurl.count>=8) {
           
            [[ToolManager shareInstance] showInfoWithStatus:@"最多只能选择8张"];
            
        }
        else{
            
            [[ToolManager shareInstance] seleteImageFormSystem:weakSelf seleteImageFormSystemBlcok:^(UIImage *image) {
                
                [[UpLoadImageManager shareInstance] upLoadImageType:@"product" image:image  imageBlock:^(UpLoadImageModal * upLoadImageModal)
                {
//                    NSLog(@"imageUrl =%@",imageUrl);
                    [weakSelf.data.imageurl addObject:upLoadImageModal.imgurl];
                   
                    [weakSelf setImageView:_coverSelectedView weakSelf:weakSelf];
                    
                }];
                
            }];
            

        }
    };
    
    _coverSelectedView.bounces = NO;
    _coverSelectedView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_coverSelectedView];
    
    if (weakSelf.data.imageurl.count>0) {
        [weakSelf setImageView:_coverSelectedView weakSelf:weakSelf];
    }
    
    float cellHeight = 40.0f;
    //是否显示个人资料
    
    UIView *_personalInformation =allocAndInitWithFrame(UIView , frame(0, CGRectGetMaxY(_coverSelectedView.frame) + 10, APPWIDTH, cellHeight));
    _personalInformation.backgroundColor =[UIColor whiteColor];
    [_mainScrollView addSubview:_personalInformation];
    
    
    _personalInformationLb = [UILabel createLabelWithFrame:frame(10, 0, 10*28*SpacedFonts, cellHeight) text:@"是否在个人资料中显示" fontSize:28*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:_personalInformation];
    
    _personalInformationSwitch =allocAndInitWithFrame(UISwitch, frame(frameWidth(_personalInformation) -60, 5, 50, 30));
    
    _personalInformationSwitch.onTintColor = AppMainColor;
    _personalInformationSwitch.tag = SwitchActionTagPersonalInformation;
    [_personalInformationSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [_personalInformation addSubview:_personalInformationSwitch];
    
    if (_data.iscross) {
        [_personalInformationSwitch setOn:YES animated:YES];
        [self switchAction:_personalInformationSwitch];
    }
    else
    {
        
        [_personalInformationSwitch setOn:NO animated:YES];
        [self switchAction:_personalInformationSwitch];
    }

    //According to micro business card
    UIView *_businessCard =allocAndInitWithFrame(UIView , frame(0, CGRectGetMaxY(_personalInformation.frame)+0.5, APPWIDTH, cellHeight));
    _businessCard.backgroundColor =[UIColor whiteColor];
    [_mainScrollView addSubview:_businessCard];
    

    _businessCardLb = [UILabel createLabelWithFrame:frame(10, 0, 5*28*SpacedFonts, cellHeight) text:@"显示微名片" fontSize:28*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:_businessCard];
    
    _businessCardSwitch =allocAndInitWithFrame(UISwitch, frame(frameWidth(_businessCard) -60, 5, 50, 30));

    _businessCardSwitch.onTintColor = AppMainColor;
    _businessCardSwitch.tag = SwitchActionTagBusinessCard;
    [_businessCardSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [_businessCard addSubview:_businessCardSwitch];
    
    if (_data.isAddress) {
        [_businessCardSwitch setOn:YES animated:YES];
        [self switchAction:_businessCardSwitch];
    }
    else
    {
        
        [_businessCardSwitch setOn:NO animated:YES];
        [self switchAction:_businessCardSwitch];
    }
    
    //    _collect to the original
    
    UIView *_collect =allocAndInitWithFrame(UIView , frame(0, CGRectGetMaxY(_businessCard.frame)+0.5, APPWIDTH, cellHeight));
    _collect.backgroundColor =[UIColor whiteColor];
    [_mainScrollView addSubview:_collect];
    
    _collectLb = [UILabel createLabelWithFrame:frame(10, 0, 6*28*SpacedFonts, cellHeight) text:@"收集传播路径" fontSize:28*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:_collect];
    
    _collectSwitch =allocAndInitWithFrame(UISwitch, frame(frameWidth(_businessCard) -60, 5, 50, 30));
    _collectSwitch.tag = SwitchActionTagCollect;
    _collectSwitch.onTintColor = AppMainColor;
    [_collectSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [_collect addSubview:_collectSwitch];
    if (_data.isgetclue) {
        [_collectSwitch setOn:YES animated:YES];
        [self switchAction:_collectSwitch];
    }
    
    if (_data.isreward) {
        [_collectSwitch setEnabled:NO];
    }
    else
    {
        [_collectSwitch setEnabled:YES];
    }
 

    _info =allocAndInitWithFrame(UIView , frame(0, CGRectGetMaxY(_collect.frame)+0.5, APPWIDTH, cellHeight));
    _info.backgroundColor =[UIColor whiteColor];
    [_mainScrollView addSubview:_info];
    _infoLb = [UILabel createLabelWithFrame:frame(10, 0, 7*28*SpacedFonts, cellHeight) text:@"收集客户信息" fontSize:28*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:_info];
    
    _infoSwitch =allocAndInitWithFrame(UISwitch, frame(frameWidth(_businessCard) -60, 5, 50, 30));
    _infoSwitch.tag = SwitchActionTagInfo;
    _infoSwitch.onTintColor = AppMainColor;
    [_infoSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [_info addSubview:_infoSwitch];
    if (_data.iscollect) {
         [_infoSwitch setOn:YES animated:YES];
        [self switchAction:_infoSwitch];
      
    }
    _infoBg = allocAndInitWithFrame(UIView, frame(0, cellHeight + 0.5, APPWIDTH, 2*cellHeight));
    
    _infoBg.hidden = !_data.iscollect;
    [_info addSubview:_infoBg];
    //开关选择
    NSArray *array = @[@"姓名",@"姓别",@"手机",@"公司",@"职务",@"备注"];
    NSArray *arrayName = @[@"name",@"sex",@"tel",@"company",@"position",@"remark"];
    
//    NSMutableArray *instanceArray =
    
    float cellW = APPWIDTH/4.0;
    UIImage *imageicon = [UIImage imageNamed:@"xuanzheweixuanzhong"];
    for (int i =0; i<array.count; i++) {
        NSString *name  = array[i];
        UIImage *  iconImage;
        UIImage *highlightImage;
        if ([weakSelf.data.selecteds[i] isEqualToString:@"0"]) {
            iconImage = [UIImage imageNamed:@"xuanzheweixuanzhong"];
            highlightImage = [UIImage imageNamed:@"xuanzhexuanzhong"];
        }
        else
        {
            highlightImage = [UIImage imageNamed:@"xuanzheweixuanzhong"];
            iconImage = [UIImage imageNamed:@"xuanzhexuanzhong"];
        }
        
       BaseButton * _item = [[BaseButton alloc]initWithFrame:frame(i%4*cellW, i/4*cellHeight, cellW, cellHeight) setTitle:name titleSize:24*SpacedFonts titleColor:BlackTitleColor backgroundImage:nil iconImage:iconImage highlightImage:highlightImage setTitleOrgin:CGPointMake((cellHeight -imageicon.size.height)/2.0 , (cellW - 48*SpacedFonts)/2.0 - imageicon.size.width + 5) setImageOrgin:CGPointMake((cellHeight -imageicon.size.height)/2.0 , (cellW - 48*SpacedFonts)/2.0 - imageicon.size.width) inView:_infoBg];
        _item.shouldAnmial = NO;
       
        _item.didClickBtnBlock=^
        {
       
            BaseButton *btn = _items[i];
           
            if ([weakSelf.data.selecteds[i] isEqualToString:@"0"]) {
                [btn setImage:[UIImage imageNamed:@"xuanzhexuanzhong"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"xuanzheweixuanzhong"] forState:UIControlStateHighlighted];
                
                [weakSelf.data.selecteds replaceObjectAtIndex:i withObject:arrayName[i]];
            }
            else
            {
                [btn setImage:[UIImage imageNamed:@"xuanzhexuanzhong"] forState:UIControlStateHighlighted];
                [btn setImage:[UIImage imageNamed:@"xuanzheweixuanzhong"] forState:UIControlStateNormal];
                  [weakSelf.data.selecteds replaceObjectAtIndex:i withObject:@"0"];
                
            }
           
          
        };
        [_items addObject:_item];
        
    }
  

    //     to the original
    _redView =allocAndInitWithFrame(UIView , frame(0, CGRectGetMaxY(_info.frame)+0.5, APPWIDTH, cellHeight));
    _redView.backgroundColor =[UIColor whiteColor];
    [_mainScrollView addSubview:_redView];
    _redLb = [UILabel createLabelWithFrame:frame(10, 0, APPWIDTH/2.0, cellHeight) text:@"跨界红包设置" fontSize:28*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:_redView];
    
    if (_data.isreward) {
        
        _redLb.text = [NSString stringWithFormat:@"红包金额:%@(元)",_data.reward];
        [_redLb setTextColor:BlackTitleColor];
    }
    else
    {
        _redSwitch =allocAndInitWithFrame(UISwitch, frame(frameWidth(_businessCard) -60, 5, 50, 30));
        _redSwitch.tag = SwitchActionTagRed;
        _redSwitch.onTintColor = AppMainColor;
        [_redSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [_redView addSubview:_redSwitch];
        if (_data.isreward) {
            [_redSwitch setOn:YES animated:YES];
            [self switchAction:_redSwitch];
        }
        if (!_data.isgetclue) {
            [_collectSwitch setOn:NO animated:YES];
            [self switchAction:_collectSwitch];
            
        }
    }
    //输入红包
    _redViewBg = allocAndInitWithFrame(UIView, frame(0 , cellHeight, frameWidth(_mainScrollView), 42));
    _redViewBg.backgroundColor =AppViewBGColor;
    [_redView addSubview:_redViewBg];
    
    UIView * _redTextFieldView = allocAndInitWithFrame(UIView, frame(10 , 10, frameWidth(_redViewBg)-20, 42));
    _redTextFieldView.backgroundColor =WhiteColor;
    [_redTextFieldView setBorder:LineBg width:0.5];
    [_redTextFieldView setRadius:5.0];
    [_redViewBg addSubview:_redTextFieldView];
    
    _redTextField= allocAndInitWithFrame(UITextField, frame(10 ,0, frameWidth(_redTextFieldView)-20, 42));
    _redTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"请输入红包金额，最大可输入%@元",_data.amount] attributes:@{NSForegroundColorAttributeName:LightBlackTitleColor }];
    [_redTextFieldView addSubview:_redTextField];
    _redTextField.textColor = BlackTitleColor;
    _redTextField.font = Size(24);
    _redTextField.clearButtonMode =UITextFieldViewModeWhileEditing;
    _redTextField.backgroundColor = WhiteColor;
    _redTextField.delegate = self;
    //    _redTextField.text = _data.amount;
    UILabel *desc = [UILabel createLabelWithFrame:frame(10 ,CGRectGetMaxY(_redTextField.frame) + 10, frameWidth(_redTextFieldView), 0) text:@"跨界传播内容规范:\n1.标题不带有诱导分享的字眼，如转发就给红包、转发有现金等\n2.所发内容、产品、房源不含涉黄、涉暴、涉谣等信息\n3.鼓励发布有用的内容、真实的产品，内容中可以附带个人微名片\n4.所有带跨界传播设置的内容都需要知脉后台审核，审核通过后才可以发布到知脉首页中\n5.若内容被驳回，所扣红包金额全额退回到红包账户中" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:_redViewBg];
    desc.numberOfLines = 0;
//    desc.backgroundColor = AppViewBGColor;
    CGSize size = [desc sizeWithMultiLineContent:desc.text rowWidth:frameWidth(desc) font:Size(24)];
    desc.frame = frame(frameX(desc), frameY(desc), frameWidth(desc), size.height);
    _redViewBg.frame = frame(frameX(_redViewBg), frameY(_redViewBg), APPWIDTH, size.height + 10 + frameHeight(_redViewBg));
    _redViewBg.hidden = YES;
    redHight = 40 + frameHeight(_redViewBg);
    
    if (CGRectGetMaxY(_redView.frame) +10>frameWidth(_mainScrollView)) {
        
        _mainScrollView.contentSize =CGSizeMake(frameWidth(_mainScrollView), CGRectGetMaxY(_redView.frame) +10);
    }
    
}
#pragma mark
#pragma mark 照片布局
- (void)setImageView:(UIScrollView *)view weakSelf:(ReleaseProductViewController *)weakSelf
{
    for (int i =0;i< weakSelf.data.imageurl.count;i++) {
        
        NSString *imageurl = weakSelf.data.imageurl[i];
        BaseButton *setImage = [[BaseButton alloc]initWithFrame:frame(10 + i*80, frameY(weakSelf.selectedImage), frameWidth(weakSelf.selectedImage), frameHeight(weakSelf.selectedImage)) backgroundImage:nil iconImage:nil highlightImage:nil inView:view];
        [[ToolManager shareInstance] imageView:setImage setImageWithURL:imageurl placeholderType:PlaceholderTypeOther];
        
        UILabel *delete = [UILabel createLabelWithFrame:frame(50, 0, 15, 15) text:@"-" fontSize:40*SpacedFonts textColor:WhiteColor textAlignment:NSTextAlignmentCenter inView:setImage];
        [delete setRound];
        delete.backgroundColor = [UIColor redColor];
        
        setImage.didClickBtnBlock = ^
        {
            [[ToolManager shareInstance] showAlertViewTitle:@"确定删除此照片" contentText:nil showAlertViewBlcok:^{
                
                [weakSelf.data.imageurl removeObjectAtIndex:i];
              
                for (UIView *subView in view.subviews) {
                    
                    if ([subView isKindOfClass:[BaseButton class]] && ![subView isEqual:_selectedImage]) {
                        [subView removeFromSuperview];
                    }
                }
                
                [weakSelf setImageView:view weakSelf:weakSelf];
            }];
        };
        
    }
    weakSelf.selectedImage.frame = frame(10 + weakSelf.data.imageurl.count*80 , frameY(weakSelf.selectedImage), frameWidth(weakSelf.selectedImage), frameHeight(weakSelf.selectedImage));
    
    if (CGRectGetMaxX(weakSelf.selectedImage.frame) + 10>frameWidth(view)) {
        
        view.contentSize = CGSizeMake(CGRectGetMaxX(weakSelf.selectedImage.frame) + 10, frameHeight(view));
        
    }
    else
    {
       view.contentSize = CGSizeMake(APPWIDTH, frameHeight(view));
    }

}
#pragma mark - UITextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    float money = [[NSString stringWithFormat:@"%@%@",textField.text,string] floatValue];
    
    if (money>[_data.amount floatValue]) {
        
        [[ToolManager shareInstance] showInfoWithStatus:[NSString stringWithFormat:@"最大金额%@",_data.amount]];
        return NO;
    }
    
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            //首字母不能为0和小数点
            if([textField.text length] == 0){
                if(single == '.') {
                    
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                ////                if (single == '0') {
                ////
                ////                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                ////                    return NO;
                ////                }
            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                    
                }else{
                    
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}
#pragma mark
#pragma mark IMYWebViewDelegate
- (void)webViewDidFinishLoad:(IMYWebView *)webView
{
    //    NSString *jsString = [[NSString alloc] initWithFormat:@"document.body.style.fontSize=%f;document.body.style.color=%@",24*SpacedFonts,fontColor];
    //    [webView evaluateJavaScript:jsString completionHandler:^(id ee, NSError *e) {
    //
    //        NSLog(@"eeee =%@",ee);
    //    }];
    
    
}
#pragma mark
#pragma mark - switchAction
- (void)switchAction:(UISwitch *)sender
{
 
    if (sender.tag ==SwitchActionTagBusinessCard) {
        if (sender.isOn) {
            _businessCardLb.textColor = BlackTitleColor;
        }
        else
        {
            _businessCardLb.textColor = LightBlackTitleColor;
        }
        
    }
    else if (sender.tag ==SwitchActionTagPersonalInformation)
    {
        if (sender.isOn) {
            _personalInformationLb.textColor = BlackTitleColor;
        }
        else
        {
            _personalInformationLb.textColor = LightBlackTitleColor;
        }
    }
    
    else if(sender.tag ==SwitchActionTagInfo)
    {
        _infoBg.hidden =!sender.isOn;
       
        if (sender.isOn) {
            _infoLb.textColor = BlackTitleColor;
            
            _info.frame = frame(frameX(_info),frameY(_info) ,frameWidth(_info), frameHeight(_info) + 80);
        }
        else
        {
            _infoLb.textColor = LightBlackTitleColor;
            
            _info.frame = frame(frameX(_info),frameY(_info) ,frameWidth(_info), frameHeight(_info) - 80);
        }
        
        _redView.frame = frame(frameX(_redView),CGRectGetMaxY(_info.frame) +0.5,frameWidth(_redView), frameHeight(_redView));
        
        if (!_collectSwitch.isOn) {
            if (CGRectGetMaxY(_info.frame) +10>frameWidth(_mainScrollView)) {
                
                _mainScrollView.contentSize =CGSizeMake(frameWidth(_mainScrollView), CGRectGetMaxY(_info.frame) +10);
            }

        }
        else
        {
            if (CGRectGetMaxY(_redView.frame) +10>frameWidth(_mainScrollView)) {
                
                _mainScrollView.contentSize =CGSizeMake(frameWidth(_mainScrollView), CGRectGetMaxY(_redView.frame) +10);
            }
        }
        
        
        [_mainScrollView scrollRectToVisible:frame(frameX(_mainScrollView), frameY(_mainScrollView), frameWidth(_mainScrollView), _mainScrollView.contentSize.height) animated:YES];
        
    }
    else if (sender.tag ==SwitchActionTagCollect)
    {
//        NSLog(@"sender.isOn =%i",sender.isOn);
         _redView.hidden = !sender.isOn;
     
        if (sender.isOn) {

            _collectLb.textColor = BlackTitleColor;
            
            if (CGRectGetMaxY(_redView.frame) +10>frameWidth(_mainScrollView)) {
                
                 _mainScrollView.contentSize =CGSizeMake(frameWidth(_mainScrollView), CGRectGetMaxY(_redView.frame) +10);
            }
            if (_redSwitch.isOn) {
                 _redViewBg.hidden = NO;
            }
            else
            {
                _redViewBg.hidden = YES;
            }
          

        }
        else
        {
            _redViewBg.hidden = YES;
            _collectLb.textColor = LightBlackTitleColor;
            if (CGRectGetMaxY(_info.frame) +10>frameWidth(_mainScrollView)) {
          _mainScrollView.contentSize =CGSizeMake(frameWidth(_mainScrollView), CGRectGetMaxY(_info.frame) +10);
            }
            
        }
        
        [_mainScrollView scrollRectToVisible:frame(frameX(_mainScrollView), frameY(_mainScrollView), frameWidth(_mainScrollView), _mainScrollView.contentSize.height) animated:YES];
    }
    else if (sender.tag ==SwitchActionTagRed)
    {
       _redViewBg.hidden = !sender.isOn;
        
        if (sender.isOn) {
            
            _redLb.textColor = BlackTitleColor;
            
            _redView.frame = frame(frameX(_redView), frameY(_redView), frameWidth(_redView), redHight);
            
            
        }
        else
        {
            _redLb.textColor = LightBlackTitleColor;
            
            _redView.frame = frame(frameX(_redView), frameY(_redView), frameWidth(_redView), 40);
        }
        
        if (CGRectGetMaxY(_redView.frame) +10>frameWidth(_mainScrollView)) {
            
            _mainScrollView.contentSize =CGSizeMake(frameWidth(_mainScrollView), CGRectGetMaxY(_redView.frame) +10);
        }
        
        [_mainScrollView scrollRectToVisible:frame(frameX(_mainScrollView), frameY(_mainScrollView), frameWidth(_mainScrollView), _mainScrollView.contentSize.height) animated:YES];

    }
    
}
#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag ==NavViewButtonActionNavLeftBtnTag ) {
        PopView(self);
    }
    
}

#pragma mark - BottomView
- (void)bottomView
{

    UIView *_botoomView = allocAndInitWithFrame(UIView, frame(0, APPHEIGHT - 50, APPWIDTH, 50));
    _botoomView.backgroundColor = WhiteColor;
    [_botoomView setBorder:LineBg width:0.5];
    [self.view addSubview:_botoomView];
    
    BaseButton *_save = [[BaseButton alloc]initWithFrame:frame((APPWIDTH - 115*ScreenMultiple)/2.0, 8, 115*ScreenMultiple, 34) setTitle:@"保存" titleSize:26*SpacedFonts titleColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:WhiteColor inView:_botoomView];
    [_save setBorder:LineBg width:0.5];
    [_save setRoundWithfloat:frameWidth(_save)/8.0];
    _save.didClickBtnBlock = ^
    {
        
        NSMutableDictionary *parameter = [Parameter parameterWithSessicon];
        [parameter setObject:@"product" forKey:@"actype"];
        if (_data.documentID&&_data.isEdit) {
            [parameter setObject:_data.documentID forKey:@"acid"];
        }
        if (!_authorTextField ||[_authorTextField.text isEqualToString:@""]) {
            [[ToolManager shareInstance] showInfoWithStatus:@"请输入作者"];
            return ;
        }
        if (!_titleTextField ||[_titleTextField.text isEqualToString:@""]) {
            [[ToolManager shareInstance] showInfoWithStatus:@"请输入标题"];
            return ;
        }
        
        [parameter setObject:_authorTextField.text forKey:@"author"];
        
        if (!_data.content ||[_data.content isEqualToString:@"<p>请输入您要发布的内容</p>"]||[_data.content isEqualToString:@""]) {
            [[ToolManager shareInstance] showInfoWithStatus:@"请输入内容"];
            return ;
        }
        [parameter setObject:_data.content forKey:@"content"];
        [parameter setObject:@(_businessCardSwitch.isOn) forKey:@"isaddress"];
        [parameter setObject:@(_personalInformationSwitch.isOn) forKey:@"iscross"];
        [parameter setObject:@(_collectSwitch.isOn) forKey:@"isgetclue"];
        [parameter setObject:@(_infoSwitch.isOn) forKey:@"iscollect"];
        if (_infoSwitch.isOn) {
            
            NSMutableArray *arrays = [NSMutableArray new];
//             NSLog(@"_data =%@",_data.selecteds);
            for (NSString *str  in _data.selecteds) {
                if (![str isEqualToString:@"0"]) {
                    
                    [arrays addObject:str];
                }
            }
            
            if ( arrays.count ==0) {
                [[ToolManager shareInstance] showInfoWithStatus:@"请选择相关信息"];
                return;
            }
            [parameter setObject:[arrays mj_JSONString] forKey:@"fields"];
            
        }
        
        if (!_data.currentImageurl ||[_data.currentImageurl isEqualToString:@""]) {
            [[ToolManager shareInstance] showInfoWithStatus:@"封面图片不能为空"];
            return ;
        }
        [parameter setObject:_data.currentImageurl forKey:@"imgurl"];
        
//        if (_data.imageurl.count<1) {
//            [[ToolManager shareInstance] showInfoWithStatus:@"请选择产品图片"];
//            return;
//        }
        [parameter setObject:[_data.imageurl mj_JSONString] forKey:@"productpics"];
        
        [parameter setObject:@(_redSwitch.isOn) forKey:@"isreward"];
        [parameter setObject:_titleTextField.text forKey:@"title"];
        
        
        if (_redSwitch.isOn) {
            if ([_redTextField.text floatValue]<=0.01) {
                if (_collectSwitch.isOn) {
                    [[ToolManager shareInstance] showInfoWithStatus:@"请输入红包金额"];
                    return ;
                }
                
            }
            [parameter setObject:_redTextField.text forKey:@"reward"];
        }
        [[ToolManager shareInstance] showWithStatus:@"保存中..."];
        __weak ReleaseProductViewController *weakSelf =self;
//         NSLog(@"parameter = %@",parameter);
        [XLDataService postWithUrl:Saveproduct param:parameter modelClass:nil responseBlock:^(id dataObj, NSError *error) {
//            NSLog(@"dataObj = %@",dataObj);
            if (dataObj) {
                if ([dataObj[@"rtcode"] intValue]==1) {
                    [[ToolManager shareInstance] dismiss];
                    
                    if (_data.isEdit) {
                    
                        PopToPointView(weakSelf, @"AlreadysentproductViewController");
                    }
                    else
                    {
                      
                        AlreadysentproductViewController *article  = allocAndInit(AlreadysentproductViewController);
                        article.ispopToRoot = YES;
                        PushView(weakSelf, article);
                    }
                    
                    
                }
                else
                {
                    [[ToolManager shareInstance] showInfoWithStatus:dataObj[@"rtmsg"]];
                }
            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus] ;
            }
        }];
        
    };
    
//    BaseButton *_share = [[BaseButton alloc]initWithFrame:frame(frameWidth(_botoomView) - CGRectGetMaxX(_save.frame), frameY(_save), frameWidth(_save), frameHeight(_save)) setTitle:@"保存并分享" titleSize:26*SpacedFonts titleColor:BlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:WhiteColor inView:_botoomView];
//    [_share setBorder:LightBlackTitleColor width:0.5];
//    [_share setRoundWithfloat:frameWidth(_share)/8.0];
//    
//    _share.didClickBtnBlock = ^{
//        
//        
//    };
    
    
    
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