//
//  ReleaseDocumentsPackagetViewController.m
//  Lebao
//
//  Created by David on 15/12/11.
//  Copyright © 2015年 David. All rights reserved.
//

#import "ReleaseDocumentsPackagetViewController.h"
#import "EncapsulationViewController.h"
#import "XLDataService.h"
//封装链接release/curl
#define LinkEncapsulation  [NSString stringWithFormat:@"%@release/curl",HttpURL]

@interface ReleaseDocumentsPackagetViewController ()<UITextViewDelegate>

@end
typedef NS_ENUM(int,ButtonActionTag) {
    
    ButtonActionTagNextStep =2,
 
    
};

@implementation ReleaseDocumentsDatas

@end

@implementation ReleaseDocumentsModal
@end


@implementation ReleaseDocumentsPackagetViewController
{
     UIScrollView *_mainScrollView;
     UITextView *_linkAddressTextView;
    UILabel *_linklB;
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
    
    [self navViewTitleAndBackBtn:@"封装链接"];
    
}

#pragma mark - mian_View
- (void)mainView
{
    _mainScrollView = allocAndInitWithFrame(UIScrollView, frame(0,StatusBarHeight + NavigationBarHeight, frameWidth(self.view), APPHEIGHT - StatusBarHeight - NavigationBarHeight));
    _mainScrollView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:_mainScrollView];

    [UILabel createLabelWithFrame:frame(9, 15, frameWidth(_mainScrollView) - 10, 24*SpacedFonts) text:@"把一个网页通过封装转化为自己的文章" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:_mainScrollView];
    NSArray *arrayTitle = @[@"复制\n链接",@"封装\n预览",@"提交\n发布"];
    float iconX = 30*ScreenMultiple;
    float iconY = 50;
    float iconW = 50*ScreenMultiple;
    float iconBT = (frameWidth(_mainScrollView) -2*iconX -3*iconW)/(arrayTitle.count-1);
    for (int i =0; i<arrayTitle.count; i++) {
        UILabel *lb =[UILabel createLabelWithFrame:frame(iconX + (iconW + iconBT)*i, iconY, iconW, iconW) text:arrayTitle[i] fontSize:28*SpacedFonts textColor:AppMainColor textAlignment:NSTextAlignmentCenter inView:_mainScrollView];
        lb.layer.masksToBounds = YES;
        lb.layer.cornerRadius = iconW/2.0;
        lb.layer.borderColor = AppMainColor.CGColor;
        lb.layer.borderWidth = 5;
        lb.numberOfLines = 0;
        lb.backgroundColor = WhiteColor;
        if (i>0) {
        UIImage *_icon =[UIImage imageNamed:@"icon_releseDocument_next"];
        UIImageView *icon = allocAndInitWithFrame(UIImageView, frame(frameX(lb) - _icon.size.width - (iconBT - 38)/2.0, iconY + (frameHeight(lb) - 14)/2.0, 38, 14));
            icon.image = _icon;
            [_mainScrollView addSubview:icon];
        }
        
    }
    
    UIView *_copyLink = allocAndInitWithFrame(UIView, frame(0,iconY + iconW + 20, frameWidth(_mainScrollView), 100));
    _copyLink.backgroundColor =WhiteColor;
    [_mainScrollView addSubview:_copyLink];
    
    [UILabel createLabelWithFrame:frame(10, 10, APPWIDTH, 28*SpacedFonts) text:@"复制链接" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:_copyLink];
    
    UIView *_linkView = allocAndInitWithFrame(UIView, frame(10, 32, frameWidth(_copyLink) -20, 59));
    _linkView.layer.masksToBounds = YES;
    _linkView.layer.cornerRadius = 5;
    _linkView.layer.borderWidth = 0.5;
    _linkView.layer.borderColor =LineBg.CGColor;
    [_copyLink addSubview:_linkView];
    
    _linkAddressTextView = allocAndInitWithFrame(UITextView, frame(7, 3, frameWidth(_linkView) -17, frameHeight(_linkView)-13));
    _linkAddressTextView.backgroundColor =[UIColor clearColor];
    _linkAddressTextView.delegate =self;
    [_linkView addSubview:_linkAddressTextView];
    
    _linklB = [UILabel createLabelWithFrame:frame(10,10, frameWidth(_linkAddressTextView), 28*SpacedFonts) text:@"请输入以http://开头的链接" fontSize:28*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:_linkView];
    _linklB.enabled = NO;
    
   UIButton *_nextBtn =  [UIButton createButtonWithfFrame:frame(12, CGRectGetMaxY(_copyLink.frame) + 35, frameWidth(_mainScrollView) -24, 40) title:@"下一步" backgroundImage:nil iconImage:nil highlightImage:nil tag:ButtonActionTagNextStep inView:_mainScrollView];
    _nextBtn.titleLabel.font =  Size(28);
    _nextBtn.backgroundColor = AppMainColor;
    _nextBtn.layer.masksToBounds = YES;
    [_nextBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _nextBtn.layer.cornerRadius = 5.0;
    
    
    if (CGRectGetMaxY(_nextBtn.frame) +10 >frameHeight(_mainScrollView)) {
        _mainScrollView.frame = frame(frameX(_mainScrollView), frameY(_mainScrollView), frameWidth(_mainScrollView), CGRectGetMaxY(_nextBtn.frame) +10);
    }
    
}
#pragma mark
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]
        ) {
        
        _linklB.text =@"请输入以http://开头的链接";
    }
    else
    {
       _linklB.text =@"";
    }
}
#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
    
    if (sender.tag ==NavViewButtonActionNavLeftBtnTag ) {
        PopView(self);
    }
    
    else
    if (sender.tag ==ButtonActionTagNextStep ) {
        if (![_linkAddressTextView.text hasPrefix:@"http://"]) {
            
            [[ToolManager shareInstance] showInfoWithStatus:@"请输入以http://开头的链接"];
            return;
        }
        [[ToolManager shareInstance] showWithStatus:@"读取数据..."];
        NSMutableDictionary *parame = [Parameter parameterWithSessicon];
        [parame setObject:_linkAddressTextView.text forKey:@"url"];
//        NSLog(@"parame =%@",parame);
        __weak ReleaseDocumentsPackagetViewController *weakSelf =self;
        [XLDataService postWithUrl:LinkEncapsulation param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
//            NSLog(@"dataObj =%@",dataObj);
            if (dataObj) {
                
                ReleaseDocumentsModal *modal = [ReleaseDocumentsModal mj_objectWithKeyValues:dataObj];
                if (modal.rtcode ==1) {
                     [[ToolManager shareInstance]dismiss];
                    EncapsulationData *data = allocAndInit(EncapsulationData);
                    data.title = modal.datas.title;
                    data.content = modal.datas.content;
                    data.amount = modal.datas.amount;
                    data.author = modal.datas.author;
                    data.imageurl = modal.datas.imgurl;
                    data.isreward = NO;
                    data.islibrary = NO;
                    data.isAddress = YES;
                    data.isRanking = YES;
                    data.isgetclue = YES;
                    
                    data.product = modal.product;
                    data.productID = modal.datas.productid;
                    data.product_imgurl = modal.datas.product_imgurl;
                    data.product_isgetclue = modal.datas.product_isgetclue;
                    data.product_uid = modal.datas.product_uid;
                    data.product_actype = modal.datas.product_actype;
                    data.product_industry = modal.datas.product_industry;
                    EncapsulationViewController *release =  allocAndInit(EncapsulationViewController);
                    release.data = data;
                 
                    [weakSelf.navigationController pushViewController:release animated:NO];
  
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
