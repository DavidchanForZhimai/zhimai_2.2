//
//  EditArticlesViewController.m
//  Lebao
//
//  Created by David on 16/4/5.
//  Copyright © 2016年 David. All rights reserved.
//

#import "EditArticlesViewController.h"
#import "AlreadysentproductViewController.h"
#import "EditWebDetailViewController.h"
#import "DWActionSheetView.h"
#import "XLDataService.h"
#import "WetChatShareManager.h"
#import "UpLoadImageManager.h"
#import "IMYWebView.h"
#import "SelectedPruductViewController.h"
//我的内容
#define MyreleaseURL [NSString stringWithFormat:@"%@release/save",HttpURL]
//发布文章
#define CreatearticleUrl  [NSString stringWithFormat:@"%@release/create",HttpURL]
#define BottomH 55
#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"

@interface EditArticlesViewController ()<IMYWebViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)IMYWebView  *contentTextView;
@property(nonatomic,strong)BaseButton  *coverImage;
@property(nonatomic,strong)BaseButton *supplementaryProductsView;
@property(nonatomic,strong)BaseButton *supplementaryProductsViewDele;
@property(nonatomic,strong)UIImageView *supplementaryProductsImage;
@property(nonatomic,strong)UILabel *supplementaryProductsLabel;
@property(nonatomic,strong)UIScrollView *mainScrollView;
@end
typedef NS_ENUM(int,ButtonActionTag) {
    
    ButtonActionTagImage=2,
    ButtonActionTagAdd ,
    ButtonActionTagSave ,
//    ButtonActionTagShare,
    
};
typedef NS_ENUM(int,SwitchActionTag) {
    
    SwitchActionTagBusinessCard =2,
    SwitchActionTagRanking ,
//    SwitchActionTagShare,
    SwitchActionTagCollect,
     SwitchActionTagRed,
};
@implementation EditArticlesData


@end
@implementation EditArticlesViewController
{
    
    UITextField *_titleTextField;
    UITextField *_authorTextField;
    
    UIView *_redViewBg;
    UITextField *_redTextField;
    
    UILabel     *_contentTextViewPlace;
    UIImageView *_releaseImage;
    
    UISwitch *_businessCardSwitch;
    UISwitch *_rankingSwitch;
//    UISwitch *_shareSwitch;
    UISwitch *_collectSwitch;
    UISwitch *_redSwitch;
    
    UILabel *_businessCardLb;
    UILabel *_rankingLb;
//    UILabel *_shareLb;
    UILabel *_collectLb;
    UILabel *_redLb;
    UIView *_redView;
    
   
    BaseButton *supplementaryProducts;
    
    UIColor *fontColor;
    
    BOOL isHaveDian;
    
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navView];
   
    if (_data.isReleseArticle) {
         [[ToolManager shareInstance] showWithStatus];
        [XLDataService postWithUrl:CreatearticleUrl param:[Parameter parameterWithSessicon] modelClass:nil responseBlock:^(id dataObj, NSError *error) {
            if (dataObj) {
                if ([dataObj[@"rtcode"] intValue] ==1) {
                     [[ToolManager shareInstance] dismiss];
                    _data.amount =dataObj[@"amount"];
                    _data.author =dataObj[@"author"];
                    _data.product =dataObj[@"product"];
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
    else
    {
        [self mainView];
        [self bottomView];
    }
    
}


#pragma mark - Navi_View
- (void)navView
{
    [self navViewTitleAndBackBtn:@"编辑文章"];
    
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
    
//    [UILabel createLabelWithFrame:frame(0,CGRectGetMaxY(_coverImage.frame), 80, 20) text:@"选择图片相册" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:_coverView];
    
    if (_data.imageurl&&![_data.imageurl isEqualToString:@""]) {
        [[ToolManager shareInstance] imageView:_coverImage setImageWithURL:_data.imageurl placeholderType:PlaceholderTypeImageProcessing];
    }
    __weak EditArticlesViewController *weakSelf = self;
    _coverImage.didClickBtnBlock =^
    {
        [[ToolManager shareInstance] seleteImageFormSystem:weakSelf seleteImageFormSystemBlcok:^(UIImage *image) {
            
            [[UpLoadImageManager shareInstance] upLoadImageType:@"cover" image:image  imageBlock:^(UpLoadImageModal * upLoadImageModal) {
                weakSelf.data.imageurl = upLoadImageModal.imgurl;
                [[ToolManager shareInstance] imageView:weakSelf.coverImage setImageWithURL:weakSelf.data.imageurl placeholderType:PlaceholderTypeImageProcessing];
            }];
            
        }];
    };
    //    //According to micro business card
    float cellHeight = 40.0f;
    
    UIView *_businessCard =allocAndInitWithFrame(UIView , frame(0, CGRectGetMaxY(_coverView.frame)+ 10, APPWIDTH, cellHeight));
    _businessCard.backgroundColor =[UIColor whiteColor];
    [_mainScrollView addSubview:_businessCard];
    
    UIColor * _businessCardColor;
    if (_data.isAddress) {
        _businessCardColor = BlackTitleColor;
    }
    else{
        _businessCardColor = LightBlackTitleColor;
    }
    _businessCardLb = [UILabel createLabelWithFrame:frame(10, 0, 5*28*SpacedFonts, cellHeight) text:@"显示微名片" fontSize:28*SpacedFonts textColor:_businessCardColor textAlignment:NSTextAlignmentLeft inView:_businessCard];
    
    _businessCardSwitch =allocAndInitWithFrame(UISwitch, frame(frameWidth(_businessCard) -60, 5, 50, 30));
    _businessCardSwitch.on = _data.isAddress;
    _businessCardSwitch.onTintColor = AppMainColor;
    _businessCardSwitch.tag = SwitchActionTagBusinessCard;
    [_businessCardSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [_businessCard addSubview:_businessCardSwitch];
    
    // Participate in ranking
    UIView *_ranking =allocAndInitWithFrame(UIView , frame(0, CGRectGetMaxY(_businessCard.frame)+0.5, APPWIDTH, cellHeight));
    _ranking.backgroundColor =[UIColor whiteColor];
    [_mainScrollView addSubview:_ranking];
    
    UIColor *  _rankingColor;
    if (_data.isRanking) {
        _rankingColor = BlackTitleColor;
    }
    else{
        _rankingColor = LightBlackTitleColor;
    }
    _rankingLb = [UILabel createLabelWithFrame:frame(10, 0, 4*28*SpacedFonts, 35) text:@"参与排名" fontSize:28*SpacedFonts textColor:_rankingColor textAlignment:NSTextAlignmentLeft inView:_ranking];
    
    _rankingSwitch =allocAndInitWithFrame(UISwitch, frame(frameWidth(_businessCard) -60, 5, 50, 30));
    _rankingSwitch.tag = SwitchActionTagRanking;
    _rankingSwitch.onTintColor = AppMainColor;
    [_rankingSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    _rankingSwitch.on =_data.isRanking;
    
    [_ranking addSubview:_rankingSwitch];
    
    
    
    //    _collect to the original
    
    UIView *_collect =allocAndInitWithFrame(UIView , frame(0, CGRectGetMaxY(_ranking.frame)+0.5, APPWIDTH, cellHeight));
    _collect.backgroundColor =[UIColor whiteColor];
    [_mainScrollView addSubview:_collect];
    
    UIColor * _collectColor;
    if (_data.isgetclue) {
        _collectColor = BlackTitleColor;
    }
    else{
        _collectColor = LightBlackTitleColor;
    }
    
    _collectLb = [UILabel createLabelWithFrame:frame(10, 0, 6*28*SpacedFonts, cellHeight) text:@"收集传播路径" fontSize:28*SpacedFonts textColor:_collectColor textAlignment:NSTextAlignmentLeft inView:_collect];
    
    _collectSwitch =allocAndInitWithFrame(UISwitch, frame(frameWidth(_businessCard) -60, 5, 50, 30));
    _collectSwitch.on =_data.isgetclue;
    _collectSwitch.tag = SwitchActionTagCollect;
    _collectSwitch.onTintColor = AppMainColor;
    [_collectSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [_collect addSubview:_collectSwitch];
    
//    //    Share to the original
//    
//    UIView *_share =allocAndInitWithFrame(UIView , frame(0, CGRectGetMaxY(_collect.frame)+0.5, APPWIDTH, cellHeight));
//    _share.backgroundColor =[UIColor whiteColor];
//    [_mainScrollView addSubview:_share];
//    
//    UIColor *  _shareColor;
//    if (_data.islibrary) {
//        _shareColor = BlackTitleColor;
//    }
//    else{
//        _shareColor = LightBlackTitleColor;
//    }
//    _shareLb = [UILabel createLabelWithFrame:frame(10, 0, 5*28*SpacedFonts, cellHeight) text:@"贡献到原创" fontSize:28*SpacedFonts textColor:_shareColor textAlignment:NSTextAlignmentLeft inView:_share];
//    
//    _shareSwitch =allocAndInitWithFrame(UISwitch, frame(frameWidth(_businessCard) -60, 5, 50, 30));
//    _shareSwitch.on =_data.islibrary;
//    _shareSwitch.tag = SwitchActionTagShare;
//    _shareSwitch.onTintColor = AppMainColor;
//    [_shareSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
//    [_share addSubview:_shareSwitch];
//    
   
    
    //    Share to the original
    
    _redView =allocAndInitWithFrame(UIView , frame(0, CGRectGetMaxY(_collect.frame)+0.5, APPWIDTH, cellHeight));
    _redView.backgroundColor =[UIColor whiteColor];
    [_mainScrollView addSubview:_redView];
    
    UIColor * _redColor;
    if (_data.isreward) {
        _redColor = BlackTitleColor;
    }
    else{
        _redColor = LightBlackTitleColor;
    }
    
    _redLb = [UILabel createLabelWithFrame:frame(10, 0, APPWIDTH/2.0, cellHeight) text:@"跨界红包设置" fontSize:28*SpacedFonts textColor:_redColor textAlignment:NSTextAlignmentLeft inView:_redView];
    
    if (_data.isreward) {
        
        _redLb.text = [NSString stringWithFormat:@"红包金额:%@(元)",_data.reward];
    }
    else
    {
        _redSwitch =allocAndInitWithFrame(UISwitch, frame(frameWidth(_businessCard) -60, 5, 50, 30));
        _redSwitch.on =_data.isreward;
        _redSwitch.tag = SwitchActionTagRed;
        _redSwitch.onTintColor = AppMainColor;
        [_redSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [_redView addSubview:_redSwitch];
    }
    //输入红包
    _redViewBg = allocAndInitWithFrame(UIView, frame(10 , CGRectGetMaxY(_redView.frame) +10, frameWidth(_mainScrollView) - 20, 42));
    _redViewBg.backgroundColor =[UIColor clearColor];
    _redViewBg.hidden = YES;
    [_mainScrollView addSubview:_redViewBg];
    
     UIView * _redTextFieldView = allocAndInitWithFrame(UIView, frame(0 , 0, frameWidth(_redViewBg), 42));
    _redTextFieldView.backgroundColor =WhiteColor;
    [_redTextFieldView setBorder:LineBg width:0.5];
    [_redTextFieldView setRadius:5.0];
    [_redViewBg addSubview:_redTextFieldView];
    
    _redTextField= allocAndInitWithFrame(UITextField, frame(10 ,0, frameWidth(_redViewBg)-20, 42));
    _redTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"请输入红包金额，最大可输入%@元",_data.amount] attributes:@{NSForegroundColorAttributeName:LightBlackTitleColor }];
    [_redTextFieldView addSubview:_redTextField];
    _redTextField.textColor = BlackTitleColor;
    _redTextField.font = Size(24);
    _redTextField.clearButtonMode =UITextFieldViewModeWhileEditing;
    _redTextField.backgroundColor = WhiteColor;
    _redTextField.delegate = self;
//    _redTextField.text = _data.amount;
    UILabel *desc = [UILabel createLabelWithFrame:frame(0 ,CGRectGetMaxY(_redTextField.frame) + 10, frameWidth(_redViewBg), 0) text:@"跨界传播内容规范:\n1.标题不带有诱导分享的字眼，如转发就给红包、转发有现金等\n2.所发内容、产品、房源不含涉黄、涉暴、涉谣等信息\n3.鼓励发布有用的内容、真实的产品，内容中可以附带个人微名片\n4.所有带跨界传播设置的内容都需要知脉后台审核，审核通过后才可以发布到知脉首页中\n5.若内容被驳回，所扣红包金额全额退回到红包账户中" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:_redViewBg];
    desc.numberOfLines = 0;
    CGSize size = [desc sizeWithMultiLineContent:desc.text rowWidth:frameWidth(desc) font:Size(24)];
    desc.frame = frame(frameX(desc), frameY(desc), frameWidth(desc), size.height);
    _redViewBg.frame = frame(frameX(_redViewBg), frameY(_redViewBg), frameWidth(desc), size.height + 10 + frameHeight(_redViewBg));
    
    //选择附带产品
    
    _supplementaryProductsView = [[BaseButton alloc]initWithFrame:frame(0, CGRectGetMaxY(_redView.frame)+0.5, APPWIDTH, cellHeight) setTitle:@"" titleSize:0 titleColor:WhiteColor textAlignment:0 backgroundColor:WhiteColor inView:_mainScrollView];
    
    UIImage *image = [UIImage imageNamed:@"jjr_gengduo"];
    supplementaryProducts = [[BaseButton alloc]initWithFrame:frame(0, 0, APPWIDTH, cellHeight) setTitle:@"选择附带产品" titleSize:28*SpacedFonts titleColor:BlackTitleColor backgroundImage:nil iconImage:image highlightImage:nil setTitleOrgin:CGPointMake((cellHeight - 28*SpacedFonts)/2.0 , 10 - image.size.width) setImageOrgin:CGPointMake((cellHeight - image.size.height)/2.0 ,APPWIDTH - (image.size.width + 10)) inView:_supplementaryProductsView];
    supplementaryProducts.backgroundColor = WhiteColor;
    
    if (_data.productID&& [_data.productID intValue]>0) {
        [weakSelf addProductWithId:_data.productID andImageUrl:_data.product_imgurl andTitle:_data.product_title andView:weakSelf andCellHeight:cellHeight];
    }
    

    supplementaryProducts.didClickBtnBlock = ^
    {
        if ( weakSelf.data.product.count>0) {
            SelectedPruductViewController *pruduct = allocAndInit(SelectedPruductViewController);
            pruduct.selectedPruductArray = weakSelf.data.product;
        //    NSLog(@"weakSelf.data.product =%@",weakSelf.data.product);
            pruduct.selectedPruductSureBlock = ^(NSDictionary *dic)
            {
         //       NSLog(@"dic =%@",dic);
                [weakSelf addProductWithId:dic[@"id"] andImageUrl:dic[@"imgurl"] andTitle:dic[@"title"] andView:weakSelf andCellHeight:cellHeight];
            };
            
            PushView(weakSelf, pruduct);
        
        }
        else
        {
            [[ToolManager shareInstance] showAlertMessage:@"没有可选择的产品"];
            return ;
        }
        
    };
    
    if (CGRectGetMaxY(_supplementaryProductsView.frame) +10>frameHeight(_mainScrollView)) {
        
        _mainScrollView.contentSize =CGSizeMake(frameWidth(_mainScrollView), CGRectGetMaxY(_supplementaryProductsView.frame) +10);
    }
    
}
- (void)addProductWithId:(NSString *)Id andImageUrl:(NSString *)imageUrl andTitle:(NSString *)title andView:(EditArticlesViewController *)weakSelf
           andCellHeight:(float)cellHeight
{
//    NSLog(@"weakSelf.data.productID = %@",weakSelf.data.productID);
    weakSelf.data.productID =Id;
    
    if (frameHeight(weakSelf.supplementaryProductsView)<60||[Id intValue]>0) {
        weakSelf.supplementaryProductsView.frame = frame(frameX(weakSelf.supplementaryProductsView), frameY(weakSelf.supplementaryProductsView), frameWidth(weakSelf.supplementaryProductsView), cellHeight + 60);
        
        if (!weakSelf.supplementaryProductsImage) {
            weakSelf.supplementaryProductsImage = allocAndInitWithFrame(UIImageView, frame(10, cellHeight + 5, 80, 50));
            [weakSelf.supplementaryProductsView addSubview: weakSelf.supplementaryProductsImage ];
        }
        if (!weakSelf.supplementaryProductsLabel) {
            weakSelf.supplementaryProductsLabel = allocAndInitWithFrame(UILabel, frame(CGRectGetMaxX(weakSelf.supplementaryProductsImage.frame) + 5, cellHeight, frameWidth(weakSelf.supplementaryProductsView) - CGRectGetMaxX(weakSelf.supplementaryProductsImage.frame) - 60, 60));
            
            weakSelf.supplementaryProductsLabel.font = Size(28);
            weakSelf.supplementaryProductsLabel.numberOfLines = 0;
            weakSelf.supplementaryProductsLabel.textColor = BlackTitleColor;
            [weakSelf.supplementaryProductsView addSubview: weakSelf.supplementaryProductsLabel];
        }
        if (!weakSelf.supplementaryProductsViewDele) {
            weakSelf.supplementaryProductsViewDele = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 50, cellHeight, 50, 60) setTitle:@"删除" titleSize:24*SpacedFonts titleColor:LightBlackTitleColor textAlignment:NSTextAlignmentRight backgroundColor:WhiteColor inView:weakSelf.supplementaryProductsView];
            weakSelf.supplementaryProductsViewDele.didClickBtnBlock = ^
            {
                self.data.productID = nil;
                [self.supplementaryProductsViewDele removeFromSuperview];
                [self.supplementaryProductsImage removeFromSuperview];
                [self.supplementaryProductsLabel removeFromSuperview];
                self.supplementaryProductsViewDele  = nil;
                self.supplementaryProductsImage  = nil;
                self.supplementaryProductsLabel  = nil;
                
                self.supplementaryProductsView.frame = frame(frameX(self.supplementaryProductsView), frameY(self.supplementaryProductsView), frameWidth(self.supplementaryProductsView), cellHeight );
                if (CGRectGetMaxY(self.supplementaryProductsView.frame) +10>frameHeight(self.mainScrollView)) {
                    
                    self.mainScrollView.contentSize =CGSizeMake(frameWidth(self.mainScrollView), CGRectGetMaxY(self.supplementaryProductsView.frame) +10);
                    
                    [self.mainScrollView scrollRectToVisible:frame(frameX(self.mainScrollView), frameY(self.mainScrollView), frameWidth(self.mainScrollView), self.mainScrollView.contentSize.height) animated:YES];
                }
                
                
                
            };
            
        }
        
        [[ToolManager shareInstance] imageView:weakSelf.supplementaryProductsImage setImageWithURL:imageUrl placeholderType:PlaceholderTypeImageUnProcessing];
        weakSelf.supplementaryProductsLabel.text = title;
        
        
        if (CGRectGetMaxY(weakSelf.supplementaryProductsView.frame) +10>frameHeight(weakSelf.mainScrollView)) {
            
            weakSelf.mainScrollView.contentSize =CGSizeMake(frameWidth(weakSelf.mainScrollView), CGRectGetMaxY(weakSelf.supplementaryProductsView.frame) +10);
            
            [weakSelf.mainScrollView scrollRectToVisible:frame(frameX(weakSelf.mainScrollView), frameY(weakSelf.mainScrollView), frameWidth(weakSelf.mainScrollView), weakSelf.mainScrollView.contentSize.height) animated:YES];
        }
        
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
//                if (single == '0') {
//                   
//                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
//                    return NO;
//                }
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
    else if (sender.tag ==SwitchActionTagRanking)
    {
        if (sender.isOn) {
            _rankingLb.textColor = BlackTitleColor;
        }
        else
        {
            _rankingLb.textColor = LightBlackTitleColor;
        }
    }
//    else if(sender.tag ==SwitchActionTagShare)
//    {
//        if (sender.isOn) {
//            _shareLb.textColor = BlackTitleColor;
//        }
//        else
//        {
//            _shareLb.textColor = LightBlackTitleColor;
//        }
//        
//    }
    else if (sender.tag ==SwitchActionTagCollect)
    {
        if (sender.isOn) {
            _collectLb.textColor = BlackTitleColor;
        }
        else
        {
            _collectLb.textColor = LightBlackTitleColor;
        }
    }
    else if (sender.tag ==SwitchActionTagRed)
    {
        _redViewBg.hidden = !sender.isOn;
        if (sender.isOn) {
            
            _redLb.textColor = BlackTitleColor;
            
            _supplementaryProductsView.frame = frame(frameX(_supplementaryProductsView), CGRectGetMaxY(_redViewBg.frame) + 10, frameWidth(_supplementaryProductsView), frameHeight(_supplementaryProductsView));
            
            if (CGRectGetMaxY(_supplementaryProductsView.frame) +10>frameHeight(_mainScrollView)) {
                
                _mainScrollView.contentSize =CGSizeMake(frameWidth(_mainScrollView), CGRectGetMaxY(_supplementaryProductsView.frame) +10);
                
                [_mainScrollView scrollRectToVisible:frame(frameX(_mainScrollView), frameY(_mainScrollView), frameWidth(_mainScrollView), _mainScrollView.contentSize.height) animated:YES];
            }
            

        }
        else
        {
            _redLb.textColor = LightBlackTitleColor;
            _supplementaryProductsView.frame = frame(frameX(_supplementaryProductsView), CGRectGetMaxY(_redView.frame), frameWidth(_supplementaryProductsView), frameHeight(_supplementaryProductsView));
            if (CGRectGetMaxY(supplementaryProducts.frame) +10>frameHeight(_mainScrollView)) {
                
                _mainScrollView.contentSize =CGSizeMake(frameWidth(_mainScrollView), CGRectGetMaxY(_supplementaryProductsView.frame) +10);
            }

        }
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
        if (_data.documentID&&!_data.isReleseArticle) {
            [parameter setObject:_data.documentID forKey:ConductID];
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
        if (!_data.imageurl ||[_data.imageurl isEqualToString:@""]) {
            [[ToolManager shareInstance] showInfoWithStatus:@"请选择图片"];
            return ;
        }
        
        [parameter setObject:_data.content forKey:@"content"];
        [parameter setObject:@(_businessCardSwitch.isOn) forKey:@"isaddress"];
        [parameter setObject:@(_collectSwitch.isOn) forKey:@"isgetclue"];
        [parameter setObject:@(_rankingSwitch.isOn) forKey:@"isranking"];

        if (_data.productID) {
            
            [parameter setObject:_data.productID forKey:@"productid"];
        }
        [parameter setObject:@(_redSwitch.isOn) forKey:@"isreward"];
       
        [parameter setObject:_titleTextField.text forKey:@"title"];
        if (!_data.imageurl ||[_data.imageurl isEqualToString:@""]) {
            [[ToolManager shareInstance] showInfoWithStatus:@"请选择图片"];
            return ;
        }
        [parameter setObject:_data.imageurl forKey:@"imgurl"];
        if (_redSwitch.isOn) {
            if ([_redTextField.text floatValue]<=0.01) {
                [[ToolManager shareInstance] showInfoWithStatus:@"请输入红包金额"];
                return ;
            }
           [parameter setObject:_redTextField.text forKey:@"reward"];
        }
        [[ToolManager shareInstance] showWithStatus:@"保存中..."];
        __weak EditArticlesViewController *weakSelf =self;
//        NSLog(@"parameter = %@",parameter);
        [XLDataService postWithUrl:MyreleaseURL param:parameter modelClass:nil responseBlock:^(id dataObj, NSError *error) {
                       
            if (dataObj) {
                if ([dataObj[@"rtcode"] intValue]==1) {
                    [[ToolManager shareInstance] dismiss];
                    
                    if (_data.isReleseArticle) {
                        AlreadysentproductViewController *article  = allocAndInit(AlreadysentproductViewController);
                        article.isArticle = YES;
                        article.ispopToRoot = YES;
                        PushView(weakSelf, article);
                    }
                    else
                    PopToPointView(weakSelf, @"AlreadysentproductViewController");
                    
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