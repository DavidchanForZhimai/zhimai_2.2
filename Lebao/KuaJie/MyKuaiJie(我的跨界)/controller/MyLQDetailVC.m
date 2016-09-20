//
//  MyLQDetailVC.m
//  KuaJie
//
//  Created by 严文斌 on 16/5/23.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import "MyLQDetailVC.h"
#import "XianSuoDetailInfo.h"
#import "LinQuRenVC.h"
#import "WBPingJiaVC.h"
#import "MyKuaJieInfo.h"
#import "ToolManager.h"
#import "PayDingJinVC.h"
#import "JJRDetailVC.h"
#import "ClueCommunityViewController.h"
#import "CommunicationViewController.h"
#import "MP3PlayerManager.h"
@interface MyLQDetailVC ()
{
    UIView* xsDetailV;
  
     NSString *_url;
}
@property (strong,nonatomic)UIScrollView * btmScr;
@property (strong,nonatomic) UIView      * jibaoV;
@property (strong,nonatomic) UIView * dangzhuV;;
@property (strong,nonatomic) UILabel     * userNameLab;
@property (strong,nonatomic) UILabel     * positionLab;
@property (strong,nonatomic) UILabel     * timeLab;
@property (strong,nonatomic) UIImageView * headImg;
@property (strong,nonatomic) NSDictionary * xiansuoDic;
@end

@implementation MyLQDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self customScro];
    self.view.backgroundColor = BACKCOLOR;
    [self getJson];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[MP3PlayerManager shareInstance] stopPlayer];
}
-(void)getJson
{
    [[MyKuaJieInfo shareInstance]getLinQuDetailXianSuoWithID:_xiansuoID andCallBack:^(BOOL issucced, NSString *info, NSDictionary *jsonDic) {
        if (issucced == YES) {
            _xiansuoDic = [NSDictionary dictionaryWithDictionary:jsonDic];
             [self customV];
             [self customJbV];
    }else
     {
         [[ToolManager shareInstance] showAlertMessage:info];
        
     }

    }];
}
-(void)customV
{
    UIView * jjrV = [[UIView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 101)];
    jjrV.backgroundColor = [UIColor whiteColor];
    [_btmScr addSubview:jjrV];
    UIView * tapV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, jjrV.frame.size.width, 61)];
    tapV.backgroundColor = [UIColor clearColor];
    tapV.userInteractionEnabled = YES;
    [jjrV addSubview:tapV];
    UITapGestureRecognizer * jjrTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jjrTapAction)];
    jjrTap.numberOfTapsRequired = 1;
    jjrTap.numberOfTouchesRequired = 1;
    [tapV addGestureRecognizer:jjrTap];
    _headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 41, 41)];
    

    
    NSString * imgUrl;
    if ([[_xiansuoDic objectForKey:@"imgurl"] rangeOfString:@"http"].location != NSNotFound) {
        imgUrl = [_xiansuoDic objectForKey:@"imgurl"];
    }else{
        imgUrl = [NSString stringWithFormat:@"%@%@",IMG_URL,[_xiansuoDic objectForKey:@"imgurl"]];
    }
    [[ToolManager shareInstance] imageView:_headImg setImageWithURL:imgUrl placeholderType:PlaceholderTypeUserHead];

    [tapV addSubview:_headImg];
    
    _userNameLab = [[UILabel alloc]initWithFrame:CGRectMake(_headImg.frame.origin.x+_headImg.frame.size.width+10, 7, 55, 25)];
    _userNameLab.font = [UIFont systemFontOfSize:15];
    _userNameLab.textColor = [UIColor blackColor];
    _userNameLab.textAlignment = NSTextAlignmentLeft;
    _userNameLab.text = [_xiansuoDic objectForKey:@"realname"];
    [tapV addSubview:_userNameLab];
    
    UIImageView * posImg = [[UIImageView alloc]initWithFrame:CGRectMake(_userNameLab.frame.origin.x, 37, 11, 11)];
    posImg.image = [UIImage imageNamed:@"dizhi"];
    [tapV addSubview:posImg];
    
    _positionLab = [[UILabel alloc]initWithFrame:CGRectMake(_userNameLab.frame.origin.x+16, 37, 100, 11)];
    _positionLab.font = [UIFont systemFontOfSize:12];
    _positionLab.textColor = [UIColor colorWithWhite:0.514 alpha:1.000];
    _positionLab.textAlignment = NSTextAlignmentLeft;
    _positionLab.text = [_xiansuoDic objectForKey:@"area"];
    [tapV addSubview:_positionLab];
    
    UIImageView * renzhImg = [[UIImageView alloc]initWithFrame:CGRectMake(_userNameLab.frame.origin.x+_userNameLab.frame.size.width, 13, 14, 14)];
    renzhImg.image = [[_xiansuoDic objectForKey:@"authen"]intValue]==3?[UIImage imageNamed:@"renzhen"]:[UIImage imageNamed:@"weirenzhen"];
    [tapV addSubview:renzhImg];
    
    _timeLab = [[UILabel alloc]initWithFrame:CGRectMake(jjrV.frame.size.width-160, 7, 150, 20)];
    _timeLab.backgroundColor = [UIColor clearColor];
    _timeLab.font = [UIFont systemFontOfSize:13];
    _timeLab.textColor = [UIColor colorWithWhite:0.514 alpha:1.000];
    _timeLab.textAlignment = NSTextAlignmentRight;
    NSString * timStr = [_xiansuoDic objectForKey:@"createtime"];
    NSTimeInterval time=[timStr doubleValue];
    NSDate *data = [NSDate dateWithTimeIntervalSince1970:time];
    _timeLab.text = [self getDateStringWithDate:data DateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * sjcStr = [self intervalSinceNow:_timeLab.text];
    if ([sjcStr integerValue] <=60) {
        _timeLab.text = @"刚刚";
    }else if ([sjcStr integerValue]<=3600)
    {
        _timeLab.text = [NSString stringWithFormat:@"%ld分钟前",[sjcStr integerValue]/60];
    }else if ([sjcStr integerValue]<=60*60*24)
    {
        _timeLab.text = [NSString stringWithFormat:@"%ld小时前",[sjcStr integerValue]/(60*60)];
    }else if ([sjcStr integerValue]<=60*60*24*3)
    {
        _timeLab.text = [NSString stringWithFormat:@"%ld天前",[sjcStr integerValue]/(60*60*24)];
    }else
    {
        _timeLab.text = [self getDateStringWithDate:data DateFormat:@"MM-dd HH:mm"];
    }

    [tapV addSubview:_timeLab];
    
    //对话背景
    UIView *duihuaV = allocAndInitWithFrame(UIView, frame(0, 61, frameWidth(jjrV), 40));
    duihuaV.backgroundColor = [UIColor colorWithRed:0.976 green:0.965 blue:0.969 alpha:1.000];
    [jjrV addSubview:duihuaV];
    
    UIButton * duihuaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    duihuaBtn.frame = CGRectMake((frameWidth(jjrV) - jjrV.frame.size.width/2-0.5f)/2.0, 61, jjrV.frame.size.width/2-0.5f, 40);
    duihuaBtn.backgroundColor = [UIColor colorWithRed:0.976 green:0.965 blue:0.969 alpha:1.000];
    [duihuaBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [duihuaBtn setImage:[UIImage imageNamed:@"liantianzhuse"] forState:UIControlStateNormal];
    [duihuaBtn setTitle:@"跟Ta对话" forState:UIControlStateNormal];
    [duihuaBtn setTitleColor:[UIColor colorWithRed:0.290 green:0.569 blue:0.973 alpha:1.000]forState:UIControlStateNormal];
    [duihuaBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [duihuaBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [duihuaBtn addTarget: self action:@selector(duihuaAction) forControlEvents:UIControlEventTouchUpInside];
    [jjrV addSubview:duihuaBtn];
    
    //修改状态为99或者20不显示电话联系
    if ([[_xiansuoDic objectForKey:@"state"] intValue]!= 99&&[[_xiansuoDic objectForKey:@"state"] intValue]!= 20)
    {
        duihuaBtn.frame = CGRectMake(0, 61, jjrV.frame.size.width/2-0.5f, 40);
        
        UIButton * lianxiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        lianxiBtn.frame = CGRectMake((jjrV.frame.size.width/2)+0.5,61, (jjrV.frame.size.width/2)-0.5f, 40);
        lianxiBtn.backgroundColor = [UIColor colorWithRed:0.976 green:0.965 blue:0.969 alpha:1.000];
        [lianxiBtn setTitle:@"电话联系" forState:UIControlStateNormal];
        [lianxiBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
        [lianxiBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [lianxiBtn setTitleColor:[UIColor colorWithRed:0.290 green:0.569 blue:0.973 alpha:1.000] forState:UIControlStateNormal];
        [lianxiBtn addTarget:self action:@selector(lianxiAction) forControlEvents:UIControlEventTouchUpInside];
        [lianxiBtn setImage:[UIImage imageNamed:@"shouji"] forState:UIControlStateNormal];
        [jjrV addSubview:lianxiBtn];
        UIView * btnSxV = [[UIView alloc]initWithFrame:CGRectMake(jjrV.frame.size.width/2-0.5f, 61, 1, 40)];
        btnSxV.backgroundColor = BACKCOLOR;
        [jjrV addSubview:btnSxV];
    }
    
    [self addTheXSV:jjrV.frame.size.height+jjrV.frame.origin.y+10];
    

}
-(void)lianxiAction
{
    
    NSString * telstr = [NSString stringWithFormat:@"tel://%@",[_xiansuoDic objectForKey:@"tel"]];
    UIWebView * webV =  [[UIWebView alloc]initWithFrame:CGRectZero];
    [webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:telstr]]];
    [self.view addSubview:webV];
}
#pragma mark--发布线索的经纪人跳转
-(void)jjrTapAction
{
    JJRDetailVC * jjrV = allocAndInit(JJRDetailVC);
    jjrV.jjrID = [_xiansuoDic objectForKey:@"brokerid"];
    PushView(self, jjrV);
    
    
}
#pragma mark  View
-(void)addTheXSV:(CGFloat)orgY
{
    xsDetailV = [[UIView alloc]initWithFrame:CGRectMake(10, orgY, SCREEN_WIDTH-20, 185)];
    xsDetailV.backgroundColor = [UIColor whiteColor];
    [_btmScr addSubview:xsDetailV];
    
    UILabel * qwbcLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, (xsDetailV.frame.size.width-20)/2, 30)];
    qwbcLab.font = [UIFont systemFontOfSize:13];
    qwbcLab.textColor = [UIColor colorWithRed:0.757 green:0.761 blue:0.765 alpha:1.000];
    qwbcLab.textAlignment = NSTextAlignmentLeft;
    qwbcLab.text = [NSString stringWithFormat:@"成交报酬:%@元",[_xiansuoDic objectForKey:@"cost"]];
    [xsDetailV addSubview:qwbcLab];
    
    UILabel * xqLab = [[UILabel alloc]initWithFrame:CGRectMake((xsDetailV.frame.size.width-20)/2, 10, (xsDetailV.frame.size.width-20)/2, 30)];
    xqLab.font = [UIFont systemFontOfSize:13];
    xqLab.textColor = [UIColor colorWithRed:0.757 green:0.761 blue:0.765 alpha:1.000];
    xqLab.textAlignment = NSTextAlignmentRight;
    if ([[_xiansuoDic objectForKey:@"confidence_n"]intValue] == 3) {
        xqLab.text = @"需求强度:很强";
    }else if ([[_xiansuoDic objectForKey:@"confidence_n"]intValue] == 2)
    {
        xqLab.text = @"需求强度:强";
    }else
    {
        xqLab.text = @"需求强度:一般";
    }
    [xsDetailV addSubview:xqLab];
    
    UILabel * titLab = [[UILabel alloc]initWithFrame:CGRectMake(30, xqLab.frame.size.height+15, xsDetailV.frame.size.width-60, 30)];
    titLab.font = [UIFont systemFontOfSize:16];
    titLab.textColor = [UIColor blackColor];
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.text = [_xiansuoDic objectForKey:@"title"];
    [xsDetailV addSubview:titLab];
    
  
   
    
    
    UILabel * detailLab = [[UILabel alloc]initWithFrame:CGRectMake(3, titLab.frame.size.height+titLab.frame.origin.y+5, xsDetailV.frame.size.width-6, 60)];
    detailLab.textColor = [UIColor colorWithWhite:0.502 alpha:1.000];
    detailLab.textAlignment = NSTextAlignmentCenter;
    detailLab.userInteractionEnabled = NO;
    detailLab.font = [UIFont systemFontOfSize:13];
    detailLab.numberOfLines = 0;
    detailLab.text = [_xiansuoDic objectForKey:@"content"];
    CGSize detailLabsize = [detailLab sizeWithMultiLineContent:detailLab.text rowWidth:frameWidth(detailLab) font:detailLab.font];
    detailLab.lineBreakMode = NSLineBreakByTruncatingTail;
    detailLab.frame = frame(frameX(detailLab), frameY(detailLab), frameWidth(detailLab), detailLabsize.height + 20);
    
    [xsDetailV addSubview:detailLab];
    
    //语音
    
    float soundImgH = CGRectGetMaxY(detailLab.frame);
    if (_xiansuoDic[@"audios"]&&![_xiansuoDic[@"audios"] isEqualToString:@""]) {
        
       UIImageView *soundImg=[[UIImageView alloc]init];//语音button
        UIImage *image = [UIImage imageNamed:@"bofangyuyuying3"];
        soundImg.frame=CGRectMake((frameWidth(xsDetailV) - image.size.width*1.7)/2.0,soundImgH, image.size.width*1.7,  image.size.height*1.7);
        soundImg.image=image;
        soundImg.animationImages = @[[UIImage imageNamed:@"bofangyuyuying1"],[UIImage imageNamed:@"bofangyuyuying2"],[UIImage imageNamed:@"bofangyuyuying3"]];
        soundImg.animationDuration = 1.5;
        soundImg.animationRepeatCount = 0;
        soundImg.tag=1110;
        
        UITapGestureRecognizer *oneTap=[[UITapGestureRecognizer alloc]init];
        [oneTap addTarget:self action:@selector(playAudioBtnClicked:)];
        soundImg.userInteractionEnabled=YES;
        [soundImg addGestureRecognizer:oneTap];
        [xsDetailV addSubview:soundImg];
        
        _url=[NSString stringWithFormat:@"%@%@",ImageURLS,_xiansuoDic[@"audios"]];
        
        soundImgH = soundImg.frame.size.height+soundImg.frame.origin.y+5;
    }

    
    UIView * sxV = [[UIView alloc]initWithFrame:CGRectMake(10,soundImgH , xsDetailV.frame.size.width-20, 1)];
    sxV.backgroundColor = [UIColor colorWithRed:0.925 green:0.925 blue:0.929 alpha:1.000];
    [xsDetailV addSubview:sxV];
    
    float height = CGRectGetMaxY(sxV.frame);
    
    if ([_xiansuoDic objectForKey:@"remark_cus"]&&![[_xiansuoDic objectForKey:@"remark_cus"] isEqualToString:@""]) {
        
        UILabel * detailLabdec = [[UILabel alloc]initWithFrame:CGRectMake(3,height, xsDetailV.frame.size.width-6, 60)];
        detailLabdec.textColor = [UIColor colorWithWhite:0.502 alpha:1.000];
        detailLabdec.textAlignment = NSTextAlignmentCenter;
        detailLabdec.userInteractionEnabled = NO;
        detailLabdec.font = [UIFont systemFontOfSize:13];
        detailLabdec.numberOfLines = 0;
        detailLabdec.text = [_xiansuoDic objectForKey:@"remark_cus"];
        CGSize detailLabdecsize = [detailLabdec sizeWithMultiLineContent:detailLabdec.text rowWidth:frameWidth(detailLabdec) font:detailLabdec.font];
        detailLabdec.lineBreakMode = NSLineBreakByTruncatingTail;
        detailLabdec.frame = frame(frameX(detailLabdec), frameY(detailLabdec), frameWidth(detailLabdec), detailLabdecsize.height + 20);
        
        [xsDetailV addSubview:detailLabdec];
        
        UIView * sxVdec = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(detailLabdec.frame), xsDetailV.frame.size.width-20, 1)];
        sxVdec.backgroundColor = [UIColor colorWithRed:0.925 green:0.925 blue:0.929 alpha:1.000];
        [xsDetailV addSubview:sxVdec];
        
        height = CGRectGetMaxY(sxVdec.frame);
    }

    
    UILabel * lqLab = [[UILabel alloc]initWithFrame:CGRectMake(10, height, 75, 30)];
    NSString * qwStr = @"领取人";
    NSString * moneyStr = [NSString stringWithFormat:@"(%@)",[_xiansuoDic objectForKey:@"coopnum"]];
    NSString * qwbcStr = [qwStr stringByAppendingString:moneyStr];
    NSMutableAttributedString * qwbcAtr = [[NSMutableAttributedString alloc]initWithString:qwbcStr];
    [qwbcAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.514 alpha:1.000] range:NSMakeRange(0, [qwStr length])];
    [qwbcAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1.000 green:0.518 blue:0.224 alpha:1.000] range:NSMakeRange([qwStr length], [moneyStr length])];
    [qwbcAtr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, [qwStr length])];
    [qwbcAtr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange([qwStr length], [moneyStr length])];
    lqLab.attributedText = qwbcAtr;
    UITapGestureRecognizer * lqTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lqrTapAction)];
    lqTap.numberOfTapsRequired = 1;
    lqTap.numberOfTouchesRequired = 1;
    lqLab.userInteractionEnabled = YES;
    [lqLab addGestureRecognizer:lqTap];
    [xsDetailV addSubview:lqLab];
    
    UILabel * xsplLab = [[UILabel alloc]initWithFrame:CGRectMake(xsDetailV.frame.size.width-95, frameY(lqLab), 85, 30)];
    [xsplLab setTextAlignment:NSTextAlignmentRight];
    NSString * xqStr = @"线索评论";
    NSString * qdStr = [NSString stringWithFormat:@"(%@)",[_xiansuoDic objectForKey:@"commentnum"]];
    NSString * xqqdStr = [xqStr stringByAppendingString:qdStr];
    NSMutableAttributedString * xqqdAtr = [[NSMutableAttributedString alloc]initWithString:xqqdStr];
    [xqqdAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.514 alpha:1.000] range:NSMakeRange(0, [xqStr length])];
    [xqqdAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1.000 green:0.518 blue:0.224 alpha:1.000] range:NSMakeRange([xqStr length], [qdStr length])];
    [xqqdAtr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, [xqStr length])];
    [xqqdAtr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange([xqStr length], [qdStr length])];
    xsplLab.attributedText = xqqdAtr;
    UITapGestureRecognizer * xsTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(xsplTapAction)];
    xsTap.numberOfTapsRequired = 1;
    xsTap.numberOfTouchesRequired = 1;
    xsplLab.userInteractionEnabled = YES;
    [xsplLab addGestureRecognizer:xsTap];
    
    [xsDetailV addSubview:xsplLab];
    
    xsDetailV.frame = frame(frameX(xsDetailV), frameY(xsDetailV), frameWidth(xsDetailV), CGRectGetMaxY(xsplLab.frame));
    
    if ([[_xiansuoDic objectForKey:@"state"] intValue]== 10 ||[[_xiansuoDic objectForKey:@"state"] intValue]== 20) {
        _viewType = dengdai_Type;
        [self customDDXZV:xsDetailV.frame.size.height+xsDetailV.frame.origin.y+10];
    }else if ([[_xiansuoDic objectForKey:@"state"] intValue]== 99||[[_xiansuoDic objectForKey:@"state"] intValue]== 98)
    {
       
        _viewType = weixz_Type;
        [self addTheLQV:xsDetailV.frame.size.height+xsDetailV.frame.origin.y+10];
    }else
    {
        if ([[_xiansuoDic objectForKey:@"self"]intValue] == 1) {
            [self customNextV:xsDetailV.frame.size.height+xsDetailV.frame.origin.y+10];
        }else{
            _viewType = weixz_Type;
            [self addTheLQV:xsDetailV.frame.size.height+xsDetailV.frame.origin.y+10];

        }
    }
}
-(void)customDDXZV:(CGFloat)orgY
{
    UIView * wbxzV = [[UIView alloc]initWithFrame:CGRectMake(10, orgY, SCREEN_WIDTH-20, 100)];
    wbxzV.backgroundColor = [UIColor whiteColor];
    [_btmScr addSubview:wbxzV];
    UIImageView * gthImg = [[UIImageView alloc]initWithFrame:CGRectMake((wbxzV.frame.size.width-36)/2, 15, 36, 36)];
    gthImg.image = [UIImage imageNamed:@"dengdaixuanzhe"];
    [wbxzV addSubview:gthImg];
    UILabel * wbxzLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, wbxzV.frame.size.width, 30)];
    wbxzLab.textColor = [UIColor colorWithRed:0.733 green:0.737 blue:0.741 alpha:1.000];
    wbxzLab.textAlignment = NSTextAlignmentCenter;
    wbxzLab.text = @"等待发布者选择";
    wbxzLab.font = [UIFont systemFontOfSize:15];
    [wbxzV addSubview:wbxzLab];
    
    _btmScr.frame = CGRectMake(0, 64.5, SCREEN_WIDTH, SCREEN_HEIGHT-64.5);
    _btmScr.contentSize = CGSizeMake(SCREEN_WIDTH, wbxzV.frame.size.height+wbxzV.frame.origin.y);
    //判断是否需要取消
    if ([_xiansuoDic[@"cancel"] boolValue]) {
        _btmScr.frame = CGRectMake(0, 64.5, SCREEN_WIDTH, SCREEN_HEIGHT-64.5-40);
        _btmScr.contentSize = CGSizeMake(SCREEN_WIDTH, wbxzV.frame.size.height+wbxzV.frame.origin.y);
        [self addTheQXLQBtn];
    }
    

}
-(void)customNextV:(CGFloat)orgY
{
    if ([[_xiansuoDic objectForKey:@"isevaluate"]intValue] == 0) {
        UIView * wbxzV = [[UIView alloc]initWithFrame:CGRectMake(10, orgY, SCREEN_WIDTH-20, 120)];
        wbxzV.backgroundColor = [UIColor whiteColor];
        [_btmScr addSubview:wbxzV];
        UIImageView * gthImg = [[UIImageView alloc]initWithFrame:CGRectMake((wbxzV.frame.size.width-36)/2, 15, 36, 36)];
        gthImg.image = [UIImage imageNamed:@"beixuanzhong"];
        [wbxzV addSubview:gthImg];
        UILabel * wbxzLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, wbxzV.frame.size.width, 30)];
        wbxzLab.textColor = [UIColor colorWithRed:0.255 green:0.557 blue:1.000 alpha:1.000];
        wbxzLab.textAlignment = NSTextAlignmentCenter;
        wbxzLab.text = @"您已被选中";
        wbxzLab.font = [UIFont systemFontOfSize:15];
        [wbxzV addSubview:wbxzLab];
        
        UILabel * msLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 90, wbxzLab.frame.size.width, 20)];
        msLab.textAlignment = NSTextAlignmentCenter;
        msLab.textColor = [UIColor colorWithRed:0.827 green:0.831 blue:0.835 alpha:1.000];
        msLab.font = [UIFont systemFontOfSize:13];
        msLab.text = @"可联系发布者或对合作进行评价";
        [wbxzV addSubview:msLab];
        _btmScr.contentSize = CGSizeMake(SCREEN_WIDTH, wbxzV.frame.size.height+wbxzV.frame.origin.y);
        [self addThePjBtn];
    }else
    {
        if ([[_xiansuoDic objectForKey:@"evaluate"]intValue] == 1) {
            [self customManyiV:orgY];
        }else
        {
            [self customBMYV:orgY ];
        }
    }
    
}
-(void)customBMYV:(CGFloat)orgY
{
    UIView * bmanyiV = [[UIView alloc]initWithFrame:CGRectMake(10, orgY, SCREEN_WIDTH-20, 70)];
    bmanyiV.backgroundColor = [UIColor whiteColor];
    [_btmScr addSubview:bmanyiV];
    UIButton * bmanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bmanBtn.frame = CGRectMake(10, 15, 40, 40);
    bmanBtn.layer.cornerRadius = bmanBtn.bounds.size.width/2;
    bmanBtn.backgroundColor = [UIColor colorWithRed:0.980 green:0.435 blue:0.176 alpha:1.000];
    [bmanBtn setTitle:@"评价" forState:UIControlStateNormal];
    bmanBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    bmanBtn.userInteractionEnabled = NO;
    [bmanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bmanyiV addSubview:bmanBtn];
    
    UILabel * bmyLab = [[UILabel alloc]initWithFrame:CGRectMake(60, 15, 200, 20)];
    bmyLab.font = [UIFont systemFontOfSize:14];
    bmyLab.textAlignment = NSTextAlignmentLeft;
    bmyLab.textColor = [UIColor colorWithRed:0.984 green:0.435 blue:0.176 alpha:1.000];
    bmyLab.text = @"不满意";
    [bmanyiV addSubview:bmyLab];
    
    UILabel * msLab = [[UILabel alloc]initWithFrame:CGRectMake(60, 35, bmanyiV.frame.size.width-60-5, 20)];
    msLab.font = [UIFont systemFontOfSize:13];
    msLab.textAlignment = NSTextAlignmentLeft;
    msLab.textColor = [UIColor colorWithRed:0.537 green:0.541 blue:0.545 alpha:1.000];
    msLab.text = [_xiansuoDic objectForKey:@"evaluatecontent"];
    [bmanyiV addSubview:msLab];
        if ([[_xiansuoDic objectForKey:@"state" ]intValue] == 55) {
        bmanyiV.frame = CGRectMake(10, orgY, SCREEN_WIDTH-20, 140);
        UIButton * kfBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        kfBtn.frame = CGRectMake(10, 80, 40, 40);
        kfBtn.layer.cornerRadius = kfBtn.bounds.size.width/2;
        kfBtn.backgroundColor = [UIColor colorWithRed:0.984 green:0.435 blue:0.176 alpha:1.000];
        [kfBtn setTitle:@"客服" forState:UIControlStateNormal];
        kfBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [kfBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        kfBtn.userInteractionEnabled = NO;
        [bmanyiV addSubview:kfBtn];
        
        UILabel * kfLab = [[UILabel alloc]initWithFrame:CGRectMake(60, 80, 200, 20)];
        kfLab.font = [UIFont systemFontOfSize:14];
        kfLab.textAlignment = NSTextAlignmentLeft;
        kfLab.textColor = [UIColor colorWithRed:0.984 green:0.435 blue:0.176 alpha:1.000];
        kfLab.text = @"知脉客服介入";
        [bmanyiV addSubview:kfLab];
        
        UILabel * msLab2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 100, bmanyiV.frame.size.width-60-5, 20)];
        msLab2.font = [UIFont systemFontOfSize:13];
        msLab2.textAlignment = NSTextAlignmentLeft;
        msLab2.textColor = [UIColor colorWithRed:0.537 green:0.541 blue:0.545 alpha:1.000];
        msLab2.text = @"正在为双方解决不满意问题!";
        [bmanyiV addSubview:msLab2];
        
        UIView * sxV = [[UIView alloc]initWithFrame:CGRectMake(30, 55, 0.5, 25)];
        sxV.backgroundColor = [UIColor colorWithRed:0.813 green:0.816 blue:0.825 alpha:1.000];
        [bmanyiV addSubview:sxV];
        
        UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(10, 0, bmanyiV.frame.size.width-20, 0.5)];
        hxV.backgroundColor = [UIColor colorWithRed:0.813 green:0.816 blue:0.825 alpha:1.000];
        [bmanyiV addSubview:hxV];
        [_btmScr setContentSize: CGSizeMake(SCREEN_WIDTH, bmanyiV.frame.size.height+bmanyiV.frame.origin.y)];

    }
    if ([[_xiansuoDic objectForKey:@"state" ]intValue] > 55) {
        
        bmanyiV.frame = CGRectMake(10, orgY, SCREEN_WIDTH-20, 140);
        UIButton * jgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        jgBtn.frame = CGRectMake(10, 80, 40, 40);
        jgBtn.layer.cornerRadius = jgBtn.bounds.size.width/2;
        jgBtn.backgroundColor = [UIColor colorWithRed:0.239 green:0.549 blue:1.000 alpha:1.000];
        [jgBtn setTitle:@"结果" forState:UIControlStateNormal];
        jgBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [jgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        jgBtn.userInteractionEnabled = NO;
        [bmanyiV addSubview:jgBtn];
        
        UILabel * jgLab = [[UILabel alloc]initWithFrame:CGRectMake(60, 80, 200, 20)];
        jgLab.font = [UIFont systemFontOfSize:14];
        jgLab.textAlignment = NSTextAlignmentLeft;
        jgLab.textColor = [UIColor blackColor];
        jgLab.text = @"知脉客服调解结果";
        [bmanyiV addSubview:jgLab];
        
        UILabel * msLab3 = [[UILabel alloc]initWithFrame:CGRectMake(60, 100, bmanyiV.frame.size.width-60, 20)];
        msLab3.font = [UIFont systemFontOfSize:12];
        msLab3.textAlignment = NSTextAlignmentLeft;
        msLab3.textColor = [UIColor colorWithRed:0.537 green:0.541 blue:0.545 alpha:1.000];
        msLab3.text = [_xiansuoDic objectForKey:@"remark"];
        [bmanyiV addSubview:msLab3];
        
        UIView * sxV2 = [[UIView alloc]initWithFrame:CGRectMake(30, 55, 0.5, 25)];
        sxV2.backgroundColor = [UIColor colorWithRed:0.813 green:0.816 blue:0.825 alpha:1.000];
        [bmanyiV addSubview:sxV2];
        [_btmScr setContentSize: CGSizeMake(SCREEN_WIDTH, bmanyiV.frame.size.height+bmanyiV.frame.origin.y)];
//        bmanyiV .frame = CGRectMake(10, orgY, SCREEN_WIDTH-20, 275);
        [_btmScr setContentSize: CGSizeMake(SCREEN_WIDTH, bmanyiV.frame.size.height+bmanyiV.frame.origin.y)];
        
        //修改 state=90 且result=0
        if ([[_xiansuoDic objectForKey:@"state" ]intValue] == 90&&[[_xiansuoDic objectForKey:@"result"]intValue]==0)
        {
           [jgBtn setTitle:@"申述" forState:UIControlStateNormal];
            jgBtn.backgroundColor = [UIColor colorWithRed:0.984 green:0.435 blue:0.176 alpha:1.000];
            jgLab.text = @"不申述";
            jgLab.textColor =[UIColor colorWithRed:0.984 green:0.435 blue:0.176 alpha:1.000];
            msLab3.text = @"对方不申述，定金已退回";
        }
        
        //修改 state=90 且result=0
        if ([[_xiansuoDic objectForKey:@"state" ]intValue] == 90&&[[_xiansuoDic objectForKey:@"result"]intValue]!=0) {
            bmanyiV .frame = CGRectMake(10, orgY, SCREEN_WIDTH-20, 210);
            UIButton * jsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            jsBtn.frame = CGRectMake(10, 145, 40, 40);
            jsBtn.layer.cornerRadius = jsBtn.bounds.size.width/2;
            jsBtn.backgroundColor = [UIColor colorWithRed:0.239 green:0.549 blue:1.000 alpha:1.000];
            [jsBtn setTitle:@"评价" forState:UIControlStateNormal];
            jsBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [jsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            jsBtn.userInteractionEnabled = NO;
            [bmanyiV addSubview:jsBtn];
            
            UILabel * pjLab2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 145, 200, 20)];
            pjLab2.font = [UIFont systemFontOfSize:14];
            pjLab2.textAlignment = NSTextAlignmentLeft;
            pjLab2.textColor = [UIColor blackColor];
            if ([[_xiansuoDic objectForKey:@"evaluateF"] intValue]== -1) {
               pjLab2.text = @"不满意";
               jsBtn.backgroundColor = [UIColor colorWithRed:0.984 green:0.435 blue:0.176 alpha:1.000];
                pjLab2.textColor = [UIColor colorWithRed:0.984 green:0.435 blue:0.176 alpha:1.000];
            }else
            {
                pjLab2.text = @"满意";
            }
            
            [bmanyiV addSubview:pjLab2];

            UIView * sxV2 = [[UIView alloc]initWithFrame:CGRectMake(30, 120, 0.5, 25)];
            sxV2.backgroundColor = [UIColor colorWithRed:0.813 green:0.816 blue:0.825 alpha:1.000];
            [bmanyiV addSubview:sxV2];
            
            UILabel * msLab3 = [[UILabel alloc]initWithFrame:CGRectMake(60, 165, bmanyiV.frame.size.width-60-5, 20)];
            msLab3.font = [UIFont systemFontOfSize:13];
            msLab3.textAlignment = NSTextAlignmentLeft;
            msLab3.textColor = [UIColor colorWithRed:0.537 green:0.541 blue:0.545 alpha:1.000];
            msLab3.text = [_xiansuoDic objectForKey:@"evaluatecontentF"];
            [bmanyiV addSubview:msLab3];
            [_btmScr setContentSize: CGSizeMake(SCREEN_WIDTH, bmanyiV.frame.size.height+bmanyiV.frame.origin.y)];

           }
        
    }
}
-(void)customManyiV:(CGFloat)orgY
{
    _btmScr.frame = CGRectMake(0, 64.5, SCREEN_WIDTH, SCREEN_HEIGHT-64.5);
    UIView * manyiV = [[UIView alloc]initWithFrame:CGRectMake(10, orgY, SCREEN_WIDTH-20, 140)];
    if ([[_xiansuoDic objectForKey:@"state"]intValue] == 90) {
        manyiV.frame = CGRectMake(10, orgY, SCREEN_WIDTH-20, 210);
    }
    manyiV.backgroundColor = [UIColor whiteColor];
    [_btmScr addSubview:manyiV];
    UIButton * bmanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bmanBtn.frame = CGRectMake(10, 15, 40, 40);
    bmanBtn.layer.cornerRadius = bmanBtn.bounds.size.width/2;
    bmanBtn.backgroundColor = [UIColor colorWithRed:0.239 green:0.549 blue:1.000 alpha:1.000];
    [bmanBtn setTitle:@"评价" forState:UIControlStateNormal];
    bmanBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    bmanBtn.userInteractionEnabled = NO;
    [bmanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [manyiV addSubview:bmanBtn];
    
    UILabel * myLab = [[UILabel alloc]initWithFrame:CGRectMake(60, 15, 200, 20)];
    myLab.font = [UIFont systemFontOfSize:14];
    myLab.textAlignment = NSTextAlignmentLeft;
    myLab.textColor = [UIColor blackColor];
    myLab.text = @"满意";
    [manyiV addSubview:myLab];
    
    UILabel * msLab = [[UILabel alloc]initWithFrame:CGRectMake(60, 35, manyiV.frame.size.width-60-5, 20)];
    msLab.font = [UIFont systemFontOfSize:13];
    msLab.textAlignment = NSTextAlignmentLeft;
    msLab.textColor = [UIColor colorWithRed:0.537 green:0.541 blue:0.545 alpha:1.000];
    msLab.text = [_xiansuoDic objectForKey:@"evaluatecontent"];
    [manyiV addSubview:msLab];
    
    
    UIButton * wkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wkBtn.frame = CGRectMake(10, 80, 40, 40);
    wkBtn.layer.cornerRadius = wkBtn.bounds.size.width/2;
    wkBtn.backgroundColor = [UIColor colorWithRed:0.243 green:0.545 blue:0.996 alpha:1.000];
    [wkBtn setTitle:@"尾款" forState:UIControlStateNormal];
    wkBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [wkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    wkBtn.userInteractionEnabled = NO;
    [manyiV addSubview:wkBtn];
    
    UILabel * wkLab = [[UILabel alloc]initWithFrame:CGRectMake(60, 80, 200, 20)];
    wkLab.font = [UIFont systemFontOfSize:14];
    wkLab.textAlignment = NSTextAlignmentLeft;
    wkLab.textColor = [UIColor blackColor];
    if ([[_xiansuoDic objectForKey:@"state"]intValue] == 40) {
        wkLab.text = @"未付尾款";
        UILabel * msLab2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 100, manyiV.frame.size.width-60-5, 20)];
        msLab2.font = [UIFont systemFontOfSize:13];
        msLab2.textAlignment = NSTextAlignmentLeft;
        msLab2.textColor = [UIColor colorWithRed:0.537 green:0.541 blue:0.545 alpha:1.000];
        msLab2.text = [NSString stringWithFormat:@"还需支付尾款%@,给发布者!" ,[_xiansuoDic objectForKey:@"fee"]];
        [manyiV addSubview:msLab2];
        [_btmScr setContentSize: CGSizeMake(SCREEN_WIDTH, manyiV.frame.size.height+manyiV.frame.origin.y)];
        [self addTheZFWKBtn];

    }else if([[_xiansuoDic objectForKey:@"state"]intValue] == 65){
        wkLab.text = @"客服催缴";
        wkBtn.backgroundColor = [UIColor colorWithRed:0.984 green:0.435 blue:0.176 alpha:1.000];
        UILabel * msLab2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 100, manyiV.frame.size.width-60-5, 20)];
        msLab2.font = [UIFont systemFontOfSize:13];
        msLab2.textAlignment = NSTextAlignmentLeft;
        msLab2.textColor = [UIColor colorWithRed:0.537 green:0.541 blue:0.545 alpha:1.000];
        msLab2.text = [NSString stringWithFormat:@"为了您能正常领取线索,请尽快支付尾款!"];
        [manyiV addSubview:msLab2];
        [_btmScr setContentSize: CGSizeMake(SCREEN_WIDTH, manyiV.frame.size.height+manyiV.frame.origin.y)];
        [self addTheZFWKBtn];

    }else if([[_xiansuoDic objectForKey:@"state"]intValue] == 70 )
    {
        wkLab.text = @"已付尾款";
        UILabel * msLab2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 100, manyiV.frame.size.width-60-5, 20)];
        msLab2.font = [UIFont systemFontOfSize:13];
        msLab2.textAlignment = NSTextAlignmentLeft;
        msLab2.textColor = [UIColor colorWithRed:0.537 green:0.541 blue:0.545 alpha:1.000];
        msLab2.text = [NSString stringWithFormat:@"您已付尾款!" ];
        [manyiV addSubview:msLab2];

    }else if([[_xiansuoDic objectForKey:@"state"]intValue] > 70)
    {
        wkLab.text = @"到账";
        UILabel * msLab2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 100, manyiV.frame.size.width-60-5, 20)];
        msLab2.font = [UIFont systemFontOfSize:13];
        msLab2.textAlignment = NSTextAlignmentLeft;
        msLab2.textColor = [UIColor colorWithRed:0.537 green:0.541 blue:0.545 alpha:1.000];
        msLab2.text = [NSString stringWithFormat:@"尾款已到对方账户" ];
        [manyiV addSubview:msLab2];
    }
    [manyiV addSubview:wkLab];
    
    UIView * sxV = [[UIView alloc]initWithFrame:CGRectMake(30, 55, 0.5, 25)];
    sxV.backgroundColor = [UIColor colorWithRed:0.813 green:0.816 blue:0.825 alpha:1.000];
    [manyiV addSubview:sxV];
    
    UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(10, 0, manyiV.frame.size.width-20, 0.5)];
    hxV.backgroundColor = [UIColor colorWithRed:0.813 green:0.816 blue:0.825 alpha:1.000];
    [manyiV addSubview:hxV];
    [_btmScr setContentSize: CGSizeMake(SCREEN_WIDTH, manyiV.frame.size.height+manyiV.frame.origin.y)];
    if ([[_xiansuoDic objectForKey:@"state"]intValue] == 90) {
        UIButton * jsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        jsBtn.frame = CGRectMake(10, 145, 40, 40);
        jsBtn.layer.cornerRadius = jsBtn.bounds.size.width/2;
        jsBtn.backgroundColor = [UIColor colorWithRed:0.243 green:0.545 blue:0.996 alpha:1.000];
        [jsBtn setTitle:@"评价" forState:UIControlStateNormal];
        jsBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [jsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        jsBtn.userInteractionEnabled = NO;
        [manyiV addSubview:jsBtn];
        
        UIView * sxV2 = [[UIView alloc]initWithFrame:CGRectMake(30, 120, 0.5, 25)];
        sxV2.backgroundColor = [UIColor colorWithRed:0.813 green:0.816 blue:0.825 alpha:1.000];
        [manyiV addSubview:sxV2];
        
        UILabel * manyiLab2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 145, manyiV.frame.size.width-60-5, 20)];
        manyiLab2.font = [UIFont systemFontOfSize:13];
        manyiLab2.textAlignment = NSTextAlignmentLeft;
        manyiLab2.textColor = [UIColor colorWithRed:0.537 green:0.541 blue:0.545 alpha:1.000];
        manyiLab2.text = @"满意";
        [manyiV addSubview:manyiLab2];

        UILabel * msLab3 = [[UILabel alloc]initWithFrame:CGRectMake(60, 165, manyiV.frame.size.width-60-5, 20)];
        msLab3.font = [UIFont systemFontOfSize:13];
        msLab3.textAlignment = NSTextAlignmentLeft;
        msLab3.textColor = [UIColor colorWithRed:0.537 green:0.541 blue:0.545 alpha:1.000];
        msLab3.text = [_xiansuoDic objectForKey:@"evaluatecontentF"];
        [manyiV addSubview:msLab3];
        [_btmScr setContentSize: CGSizeMake(SCREEN_WIDTH, manyiV.frame.size.height+manyiV.frame.origin.y)];
    }

}
-(void)addTheZFWKBtn
{
    _btmScr.frame = CGRectMake(0, 64.5, SCREEN_WIDTH, SCREEN_HEIGHT-64.5);
    UIButton * bssBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bssBtn.frame = CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH, 40);
    bssBtn.backgroundColor = [UIColor colorWithRed:0.239 green:0.549 blue:1.000 alpha:1.000];
    [bssBtn setTitle:@"支付尾款" forState:UIControlStateNormal];
    [bssBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bssBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [bssBtn addTarget:self action:@selector(zfwkAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bssBtn];
    UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH, 0.5)];
    hxV.backgroundColor = [UIColor colorWithRed:0.867 green:0.875 blue:0.878 alpha:1.000];
    [self.view addSubview:hxV];

}
-(void)zfwkAction
{
    PayDingJinVC * paywkV = [[PayDingJinVC alloc]init];
    paywkV.zfymType = WeiKuanZhiFu;
    paywkV.xsID = [_xiansuoDic objectForKey:@"id"];
    paywkV.jineStr = [_xiansuoDic objectForKey:@"fee"];
    [self.navigationController pushViewController:paywkV animated:YES];
}
-(void)addThePjBtn
{
     _btmScr.frame = CGRectMake(0, 64.5, SCREEN_WIDTH, SCREEN_HEIGHT-64.5-40);
    UIButton * bssBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bssBtn.frame = CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH/2, 40);
    bssBtn.backgroundColor = [UIColor whiteColor];
    [bssBtn setTitle:@"不满意" forState:UIControlStateNormal];
    [bssBtn setTitleColor:[UIColor colorWithRed:0.239 green:0.549 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
    bssBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [bssBtn addTarget:self action:@selector(bmyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bssBtn];
    
    UIButton * ssBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ssBtn.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-40, SCREEN_WIDTH/2, 40);
    ssBtn.backgroundColor = [UIColor colorWithRed:0.239 green:0.549 blue:1.000 alpha:1.000];
    [ssBtn setTitle:@"满意" forState:UIControlStateNormal];
    [ssBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ssBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [ssBtn addTarget:self action:@selector(myAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ssBtn];
    UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH, 0.5)];
    hxV.backgroundColor = [UIColor colorWithRed:0.867 green:0.875 blue:0.878 alpha:1.000];
    [self.view addSubview:hxV];

}
-(void)bmyAction
{
    WBPingJiaVC * wbpjV = [[WBPingJiaVC alloc]init];
    wbpjV.pjStr = @"不满意";
    wbpjV.type = 0;
    wbpjV.xiansuoID = [_xiansuoDic objectForKey:@"coopid"];
    [self.navigationController pushViewController:wbpjV animated:YES];
}
-(void)myAction
{
    WBPingJiaVC * wbpjV = [[WBPingJiaVC alloc]init];
    wbpjV.pjStr = @"满意";
    wbpjV.type = 0;
    wbpjV.xiansuoID = [_xiansuoDic objectForKey:@"coopid"];
    [self.navigationController pushViewController:wbpjV animated:YES];

}
-(void)addTheLQV:(CGFloat)orgY
{
    UIView * wbxzV = [[UIView alloc]initWithFrame:CGRectMake(10, orgY, SCREEN_WIDTH-20, 120)];
    wbxzV.backgroundColor = [UIColor whiteColor];
    [_btmScr addSubview:wbxzV];
    UIImageView * gthImg = [[UIImageView alloc]initWithFrame:CGRectMake((wbxzV.frame.size.width-36)/2, 15, 36, 36)];
    gthImg.image = [UIImage imageNamed:@"weibaixuanzhong"];
    [wbxzV addSubview:gthImg];
    UILabel * wbxzLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, wbxzV.frame.size.width, 30)];
    wbxzLab.textColor = [UIColor colorWithRed:0.733 green:0.737 blue:0.741 alpha:1.000];
    wbxzLab.textAlignment = NSTextAlignmentCenter;
    if ([[_xiansuoDic objectForKey:@"state"] intValue]== 98) {
        wbxzLab.text = @"您已取消领取";
    }else{
    wbxzLab.text = @"未被选中";
    }
    wbxzLab.font = [UIFont systemFontOfSize:15];
    [wbxzV addSubview:wbxzLab];
    
    UILabel * msLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 90, wbxzLab.frame.size.width, 20)];
    msLab.textAlignment = NSTextAlignmentCenter;
    msLab.textColor = [UIColor colorWithRed:0.827 green:0.831 blue:0.835 alpha:1.000];
    msLab.font = [UIFont systemFontOfSize:13];
    if ([[_xiansuoDic objectForKey:@"state"] intValue]== 98) {
        msLab.text = @"您已取消领取,定金已返还您的账户";
    }else{
    msLab.text = @"您未被选中定金已返还您的账户";
    }
    [wbxzV addSubview:msLab];
    _btmScr.contentSize = CGSizeMake(SCREEN_WIDTH, wbxzV.frame.size.height+wbxzV.frame.origin.y);
}
-(void)addTheQXLQBtn
{
    UIButton * bssBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bssBtn.frame = CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH, 40);
    bssBtn.backgroundColor = [UIColor colorWithRed:0.965 green:0.965 blue:0.969 alpha:1.000];
    [bssBtn setTitle:@"取消领取" forState:UIControlStateNormal];
    [bssBtn setTitleColor:[UIColor colorWithRed:0.349 green:0.608 blue:0.992 alpha:1.000] forState:UIControlStateNormal];
    bssBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [bssBtn addTarget:self action:@selector(qxlqAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bssBtn];
    UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH, 0.5)];
    hxV.backgroundColor = [UIColor colorWithRed:0.867 green:0.875 blue:0.878 alpha:1.000];
    [self.view addSubview:hxV];
}
-(void)qxlqAction
{
    [[ToolManager shareInstance]showAlertViewTitle:@"您确定取消领取吗?" contentText:@"取消领取后,定金将返还您的账户" showAlertViewBlcok:^{
        [[MyKuaJieInfo shareInstance]quxiaolquWithID:[_xiansuoDic objectForKey:@"coopid"] andCallBack:^(BOOL issucced, NSString *info, NSDictionary *jsonDic) {
            [[ToolManager shareInstance] showAlertMessage:info];
            if (issucced == YES) {
                [[ToolManager shareInstance]showAlertMessage:@"取消成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                [[ToolManager shareInstance]showAlertMessage:info];
            }
        }];

    }];
    }
-(void)lqrTapAction
{
    LinQuRenVC * lqV = [[LinQuRenVC alloc]init];
    lqV.xiansID = [_xiansuoDic objectForKey:@"id"];
    [self.navigationController pushViewController:lqV animated:YES];
}
#pragma mark----------线索评论
-(void)xsplTapAction
{
    ClueCommunityViewController * comuniV = [[ClueCommunityViewController alloc]init];
    comuniV.clueID = [_xiansuoDic objectForKey:@"id"];
    [self.navigationController pushViewController:comuniV animated:YES];
}
-(void)duihuaAction
{
    CommunicationViewController * comunV = [[CommunicationViewController alloc]init];
    comunV.senderid = [_xiansuoDic objectForKey:@"brokerid"];
    comunV.chatType = ChatMessageTpye;
    [self.navigationController pushViewController:comunV animated:YES];
}
-(void)customScro
{
    _btmScr = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64.5, SCREEN_WIDTH, SCREEN_HEIGHT-64.5)];
    _btmScr.backgroundColor = BACKCOLOR;
    _btmScr.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*2);
    _btmScr.showsVerticalScrollIndicator = NO;
    _btmScr.userInteractionEnabled = YES;
    [self.view addSubview:_btmScr];
}
-(void)setNav
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = YES;
   
    UIView * navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 60, 44);
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    backBtn.imageView.contentMode = UIViewContentModeLeft;

    [backBtn setImage:[UIImage imageNamed:@"iconfont-fanhui"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(SCREEN_WIDTH-50, 30, 50, 24);
    [rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    [rightBtn setTitle:@"举报" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [navView addSubview:rightBtn];
    
    UILabel * titLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 20, 120, 44)];
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.textColor = [UIColor blackColor];
    titLab.text = @"线索详情";
    titLab.font = [UIFont systemFontOfSize:16];
    [navView addSubview:titLab];
    UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0.5)];
    hxV.backgroundColor = [UIColor colorWithRed:0.816 green:0.820 blue:0.827 alpha:1.000];
    [self.view addSubview:hxV];
    
}
#pragma mark - 语音点击按钮
-(void)playAudioBtnClicked:(UIGestureRecognizer *)sender
{
//    _url = @"http://pic.lmlm.cn/record/201607/22/146915727469518.mp3";
    NSArray *pathArrays = [_url componentsSeparatedByString:@"/"];
    NSString *topath;
    if (pathArrays.count>0) {
        topath = pathArrays[pathArrays.count-1];
    }
    
    if (sender.view.tag==1110) {
        [[MP3PlayerManager shareInstance] downLoadAudioWithUrl:_url  finishDownLoadBloak:^(BOOL succeed) {
            if (succeed) {
                [(UIImageView *)sender.view startAnimating];
                sender.view.tag=1111;
                
                [[MP3PlayerManager shareInstance] audioPlayerWithURl:topath];
                [MP3PlayerManager shareInstance].playFinishBlock = ^(BOOL succeed)
                {
                    if (succeed) {
                        sender.view.tag=1110;
                        [(UIImageView *)sender.view stopAnimating];
                    }
                    
                };

            }
            
        }];
        
    }else if (sender.view.tag==1111){
        sender.view.tag=1110;
        [[MP3PlayerManager shareInstance] pausePlayer];
        [(UIImageView *)sender.view stopAnimating];
    }
    
    


}

-(void)backAction
{
    [[MP3PlayerManager shareInstance]playerNil];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction
{
    _jibaoV.hidden = !_jibaoV.hidden;
    _dangzhuV.hidden = !_dangzhuV.hidden;
}

-(void)customJbV
{
    _jibaoV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _jibaoV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    _jibaoV.hidden = YES;
    [_btmScr addSubview:_jibaoV];
    
    UIView * detailV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    detailV.backgroundColor = [UIColor whiteColor];
    [_jibaoV addSubview:detailV];
    NSArray * arr = @[@"涉黄涉暴力",@"虚假线索",@"广告"];
    for (int i = 0; i<3; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 300+i;
        btn.backgroundColor = [UIColor clearColor];
        btn.frame = CGRectMake(0, 50*i, SCREEN_WIDTH, 50);
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithWhite:0.310 alpha:1.000] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(jubaoAction:) forControlEvents:UIControlEventTouchUpInside];
        [detailV addSubview:btn];
    }
    
    UIView * kongbaiV = [[UIView alloc]initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, _jibaoV.frame.size.height-150)];
    kongbaiV.backgroundColor = [UIColor clearColor];
    kongbaiV.userInteractionEnabled = YES;
    [_jibaoV addSubview:kongbaiV];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidenAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [kongbaiV addGestureRecognizer:tap];
    
    _dangzhuV = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-42, SCREEN_WIDTH, 42)];
    _dangzhuV.backgroundColor = [UIColor clearColor];
    _dangzhuV.userInteractionEnabled = NO;
    _dangzhuV.hidden = YES;
    _dangzhuV.userInteractionEnabled = YES;
    UITapGestureRecognizer * meiyiyitap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidenAction)];
    [_dangzhuV addGestureRecognizer:meiyiyitap];
    [self.view addSubview:_dangzhuV];
}
-(void)hidenAction
{
    _jibaoV.hidden = YES;
    _dangzhuV.hidden = YES;
}
-(void)jubaoAction:(UIButton *)sender
{
    [[XianSuoDetailInfo shareInstance]xsjbWithID:_xiansuoID andTitle:[_xiansuoDic objectForKey:@"title"] andType:sender.titleLabel.text andAuthorID:[_xiansuoDic objectForKey:@"brokerid"] andCallBack:^(BOOL issucced, NSString *info, NSDictionary *jsonDic) {
        if (issucced == YES) {
            [[ToolManager shareInstance]showAlertMessage:@"举报成功"];
            _jibaoV.hidden = YES;
            _dangzhuV.hidden = YES;
        }else
        {
            [[ToolManager shareInstance]showAlertMessage:info];
        }
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *)getDateStringWithDate:(NSDate *)date
                        DateFormat:(NSString *)formatString
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formatString];
    NSString *dateString = [dateFormat stringFromDate:date];
    //     NSLog(@"date: %@", dateString);
    
    return dateString;
}
- (NSString *)intervalSinceNow: (NSString *) theDate
{
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
    
    timeString = [NSString stringWithFormat:@"%f", cha];
    timeString = [timeString substringToIndex:timeString.length-7];
    timeString=[NSString stringWithFormat:@"%@", timeString];
    
    return timeString;
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
