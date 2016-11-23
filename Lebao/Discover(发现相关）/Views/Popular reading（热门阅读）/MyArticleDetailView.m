//
//  MyArticleDetailView.m
//  Lebao
//
//  Created by David on 16/3/2.
//  Copyright © 2016年 David. All rights reserved.
//

#import "MyArticleDetailView.h"
#import "XLDataService.h"
//工具类
#import "ToolManager.h"
#import "BaseButton.h"
#import "UILabel+Extend.h"
#import "NSString+Extend.h"
#import "MyDetialViewController.h"
@interface MyArticleDetailView() <UIAlertViewDelegate>

@end
@implementation MyArticleDetailView

- (instancetype)initWithFrame:(CGRect)frame postWithUrl:(NSString*)postWithUrl param:(NSMutableDictionary*)param
{
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor =[UIColor  whiteColor];
        _postWithUrl = postWithUrl;
        _param = param;
        [self addMainView:_param];
    }
    return self;
}
- (void)addMainView:(NSDictionary *)parame
{
    for (UIView *suView in self.subviews) {
        
        [suView removeFromSuperview];
    }
    __weak MyArticleDetailView *weakSelf =self;
    //    NSLog(@"parame =%@ _postWithUrl=%@",parame,_postWithUrl);
    [[ToolManager shareInstance] showWithStatus];
    [XLDataService postWithUrl:_postWithUrl param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        NSLog(@"data =%@",dataObj);
        if (dataObj) {
            [[ToolManager shareInstance] dismiss];
            modal = [MyArticleDetailModal mj_objectWithKeyValues:dataObj];
            
            weakSelf.webView = allocAndInitWithFrame(IMYWebView, CGRectZero);
            weakSelf.webView.backgroundColor = WhiteColor;
            weakSelf.webView.delegate = self;
            weakSelf.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            weakSelf.webView.scrollView.scrollEnabled = NO;
            [weakSelf.webView setScalesPageToFit:YES];
            [self addSubview:weakSelf.webView];
            
            if (modal.rtcode ==1) {
                
                UILabel * _descrip= [UILabel createLabelWithFrame:frame( 10, 10, APPWIDTH - 20, 30) text:@"" fontSize:30*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:self];
                _descrip.numberOfLines = 0;
                _descrip.text = modal.datas.title;
                
                
                CGSize size =[_descrip sizeWithMultiLineContent:_descrip.text rowWidth:frameWidth(_descrip) font:[UIFont systemFontOfSize:30*SpacedFonts]];
                _descrip.frame = frame(frameX(_descrip),frameY(_descrip), frameWidth(_descrip), size.height);
                UILabel *time =allocAndInit(UILabel);
                CGSize sizeTime = [time sizeWithContent:@"2015 - 12 - 31" font:[UIFont systemFontOfSize:22*SpacedFonts]];
                
                NSString *times =modal.datas.createtime;
                
                BaseButton* _time = [[BaseButton alloc]initWithFrame:frame(frameX(_descrip), size.height + 15 ,  5 + sizeTime.width, sizeTime.height)  setTitle:[times timeformatString:@"yyyy-MM-dd"]titleSize:22*SpacedFonts titleColor:LightBlackTitleColor backgroundImage:nil iconImage:nil highlightImage:nil setTitleOrgin:CGPointMake(0,0) setImageOrgin:CGPointMake(0,0)  inView:self];
                _time.shouldAnmial = NO;
                
                
                float height =CGRectGetMaxY(_time.frame)  +10 ;
                if (modal.datas.isaddress) {
                    
                    
                    UIView *bg = allocAndInitWithFrame(UIView, frame(0, height, APPWIDTH, 110));
                    bg.backgroundColor = WhiteColor;
                    bg.userInteractionEnabled = YES;
                    self.userInteractionEnabled = YES;
                    [self addSubview:bg];
                    
                    UIImageView *bg1 = allocAndInitWithFrame(UIImageView, frame(10, 10, APPWIDTH - 20, 90));
                    bg1.userInteractionEnabled = YES;
                    bg1.image = [UIImage imageNamed:@"mingpian_back"];
                    [bg addSubview:bg1];
                    
                    UIImageView *icon = allocAndInitWithFrame(UIImageView, frame(10, 20, 50, 50));
                    icon.userInteractionEnabled = YES;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconTap:)];
                    tap.numberOfTapsRequired = 1;
                    [icon addGestureRecognizer:tap];
                    
                    [[ToolManager shareInstance] imageView:icon setImageWithURL:modal.datas.isaddress_imgurl placeholderType:PlaceholderTypeUserHead];
                    
                    
                    [icon setRadius:frameHeight(icon)/2.0];
                    [bg1 addSubview:icon];
                    
                    UILabel *name = [UILabel createLabelWithFrame:frame(CGRectGetMaxX(icon.frame) +7, 14, 0, 26*SpacedFonts) text:modal.datas.isaddress_name fontSize:26*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:bg1];
                    
                    CGSize sizeName = [name sizeWithContent:name.text font:[UIFont systemFontOfSize:26*SpacedFonts]];
                    name.frame = frame(frameX(name), frameY(name), sizeName.width, frameHeight(name));
                    
                    [UILabel createLabelWithFrame:frame(frameX(name), CGRectGetMaxY(name.frame)+10, 200, 26*SpacedFonts) text:modal.datas.isaddress_add fontSize:22*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:bg1];//公司
                    
                    NSString *industryStr=modal.datas.industry;
                    [UILabel createLabelWithFrame:frame(CGRectGetMaxX(name.frame)+10, frameY(name), 200, 26*SpacedFonts) text:industryStr fontSize:22*SpacedFonts textColor:lightGrayTitleColor textAlignment:NSTextAlignmentLeft inView:bg1];//行业
                    
                    [UILabel createLabelWithFrame:frame(bg1.size.width-110, 14, 100, 26*SpacedFonts) text:modal.datas.isaddress_area fontSize:22*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentRight inView:bg1];//地址
                    
                    UIImage *shouji=[UIImage imageNamed:@"shouji(1)"];
                    
                    BaseButton *shoujibtn= [[BaseButton alloc]initWithFrame:frame(frameX(name), CGRectGetMaxY(name.frame) +26*SpacedFonts+20, 100, shouji.size.height+6) setTitle:modal.datas.isaddress_tel titleSize:22*SpacedFonts  titleColor:WhiteColor backgroundImage:nil iconImage:shouji highlightImage:nil setTitleOrgin:CGPointMake(3, 3) setImageOrgin:CGPointMake(3, 3) inView:bg1];
                    shoujibtn.didClickBtnBlock = ^
                    {
                        
                        UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"是否要拨打电话 %@",modal.datas.isaddress_tel] delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
                        [alertV show];
                    };
                    
                    shoujibtn.backgroundColor=[UIColor orangeColor];
                    shoujibtn.radius=(shouji.size.height+6)/2.0;
                    height += 110;
                }
                else
                {
                    UILabel *line1 = allocAndInitWithFrame(UILabel, frame(10, CGRectGetMaxY(_time.frame)  + 6, APPWIDTH - 20, 1.0));
                    line1.backgroundColor = LineBg;
                    [self addSubview:line1];
                    
                }
                
                weakSelf.webView.frame= frame(5, height, APPWIDTH -10, 0);
                
                [weakSelf.webView loadHTMLString:modal.datas.content baseURL:nil];
                
            }
            else
            {
                [weakSelf.webView loadHTMLString:[NSString stringWithFormat:@"<p>%@</p>",modal.rtmsg] baseURL:nil];
                
            }
            
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus];
        }
        
        
        
        
    }];
    
}
#pragma mark - UIWebview delegete

- (void)webViewDidFinishLoad:(IMYWebView *)webView
{
    [self webViewFitToScale:webView];
    
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id objc, NSError * error) {
        CGFloat height = [objc floatValue];
        if (!error) {
            
            CGRect frame = webView.frame;
            webView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
            if (modal.datas.isaddress) {
                self.contentSize = CGSizeMake(frameWidth(self), 140 + height);
                
            }
            else
            {
                self.contentSize = CGSizeMake(frameWidth(self), 70 + height);
                
            }
            
            
            if (modal.datas.productpics&&![modal.datas.productpics isEqualToString:@""]) {
                
                NSArray *images = [modal.datas.productpics componentsSeparatedByString:@","];
                
                for (int i = 0; i<images.count; i++) {
                    UIImageView *imageView = allocAndInitWithFrame(UIImageView, frame(5,self.contentSize.height + APPWIDTH *i, (APPWIDTH - 10), (APPWIDTH - 10)));
                    [[ToolManager shareInstance] imageView:imageView setImageWithURL:images[i] placeholderType:PlaceholderTypeImageUnProcessing];
                    [self addSubview:imageView];
                    
                }
                self.contentSize = CGSizeMake(frameWidth(self), self.contentSize.height + APPWIDTH*images.count);
            }
            
            
            
        }
    }];
    
}
//结合JS解决用webVIew加载图片时图片自动适配屏幕的问题
- (void)webViewFitToScale:(IMYWebView *)webView
{
    NSString *js=@"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
    "var myimg,oldwidth;"
    "var maxwidth = %f;"
    "for(i=0;i <document.images.length;i++){"
    "myimg = document.images[i];"
    "if(myimg.width > maxwidth){"
    "oldwidth = myimg.width;"
    "myimg.width = %f;"
    "}"
    "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    js=[NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width-15];
    [webView evaluateJavaScript:js completionHandler:^(id objc, NSError *error) {
        
    }];
    [webView evaluateJavaScript:@"ResizeImages();" completionHandler:^(id objc, NSError *error) {
        
    }];
    
}
#pragma mark
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0) {
        return;
    }else if (buttonIndex==1) {
        
        NSString *str=[NSString stringWithFormat:@"tel://%@",modal.datas.isaddress_tel];
        NSURL *url=[NSURL URLWithString:str];
        [[UIApplication sharedApplication]openURL:url];
        
    }
    
}

#pragma mark
#pragma mark 头像点击
- (void)iconTap:(UITapGestureRecognizer *)sender
{
    
    MyDetialViewController *myDetialViewCT=allocAndInit(MyDetialViewController);
    if (modal.datas.product_uid) {
        myDetialViewCT.userID=modal.datas.product_uid;
        
        
    }
    
    
}
@end
