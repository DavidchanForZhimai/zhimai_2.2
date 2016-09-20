//
//  MyXSDetailVC.m
//  KuaJie
//
//  Created by 严文斌 on 16/5/24.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import "MyXSDetailVC.h"
#import "WxhzCell.h"
#import "JJRCell.h"
#import "LinQuRenVC.h"
#import "WBShenSuVC.h"
#import "MyKuaJieInfo.h"
#import "ToolManager.h"
#import "WBPingJiaVC.h"
#import "JJRDetailVC.h"
#import "ClueCommunityViewController.h"
#import "DXAlertView.h"
#import "CommunicationViewController.h"
#import "MP3PlayerManager.h"
#define WHZTABTAG 110
#define XTTJTABTAG 129
@interface MyXSDetailVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *_url;
}
@property (strong,nonatomic)UIScrollView * bottmScr;
@property (strong,nonatomic)UITableView * whzTab;
@property (strong,nonatomic)UITableView * commendTab;
@property (strong,nonatomic) UIImageView * headImg;
@property (strong,nonatomic) UILabel     * userNameLab;
@property (strong,nonatomic) UILabel     * positionLab;
@property (strong,nonatomic) UILabel     * timeLab;
@property (strong,nonatomic)NSDictionary * xiansDic;
@property (strong ,nonatomic)NSMutableArray * coopArr;
@property (strong,nonatomic)NSMutableArray * recomArr;
@property (strong,nonatomic)NSDictionary * allDic;
@end

@implementation MyXSDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKCOLOR;
    _coopArr = [[NSMutableArray alloc]init];
    _recomArr = [[NSMutableArray alloc]init];
    [self setNav];
    [self getJsonWithID:_xiansuoID];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
    [[MP3PlayerManager shareInstance] stopPlayer];
}
-(void)getJsonWithID:(NSString *)xsID
{
    [[MyKuaJieInfo shareInstance]getFaBuDetailXianSuoWithID:xsID andCallBack:^(BOOL issucced, NSString *info, NSDictionary *jsonDic) {
        if (issucced == YES) {
            for (NSDictionary * dic in [jsonDic objectForKey:@"coops"]) {
                [_coopArr addObject:dic];
            }
            for (NSDictionary * dic in [jsonDic objectForKey:@"recommend"]) {
                [_recomArr addObject:dic];
            }
            _xiansDic = [NSDictionary dictionaryWithDictionary:[jsonDic objectForKey:@"demand"]];
            _allDic = [NSDictionary dictionaryWithDictionary:jsonDic];
          [self customView];
        }else
        {
            [[ToolManager shareInstance] showAlertMessage:info];
        
        }
    }];
}
-(void)customView
{
    _bottmScr = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 74.5, SCREEN_WIDTH, SCREEN_HEIGHT-74.5)];
    _bottmScr.backgroundColor = [UIColor clearColor];
    _bottmScr.showsVerticalScrollIndicator = NO;
    _bottmScr.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_bottmScr];
    
    
    [self addTheXSV];

    
  }
-(void)addTheXSV
{
    UIView * xsDetailV = [[UIView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 185)];
    xsDetailV.backgroundColor = [UIColor whiteColor];
    [_bottmScr addSubview:xsDetailV];
    
    UILabel * qwbcLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, (xsDetailV.frame.size.width-20)/2, 30)];
    qwbcLab.font = [UIFont systemFontOfSize:13];
    qwbcLab.textColor = [UIColor colorWithRed:0.757 green:0.761 blue:0.765 alpha:1.000];
    qwbcLab.textAlignment = NSTextAlignmentLeft;
    qwbcLab.text = [NSString stringWithFormat:@"成交报酬:%@元",[_xiansDic objectForKey:@"cost"]];
    [xsDetailV addSubview:qwbcLab];
  
    UILabel * xqLab = [[UILabel alloc]initWithFrame:CGRectMake((xsDetailV.frame.size.width-20)/2, 10, (xsDetailV.frame.size.width-20)/2, 30)];
    xqLab.font = [UIFont systemFontOfSize:13];
    xqLab.textColor = [UIColor colorWithRed:0.757 green:0.761 blue:0.765 alpha:1.000];
    xqLab.textAlignment = NSTextAlignmentRight;
    
    if ([[_xiansDic objectForKey:@"confidence_n"] intValue] == 3) {
        xqLab.text = @"需求强度:很强";
    }else if ([[_xiansDic objectForKey:@"confidence_n"] intValue] == 2)
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
    titLab.text = [_xiansDic objectForKey:@"title"];
    [xsDetailV addSubview:titLab];
    
    


    
    UILabel * detailLab = [[UILabel alloc]initWithFrame:CGRectMake(3, titLab.frame.size.height+titLab.frame.origin.y+5, xsDetailV.frame.size.width-6, 60)];
    detailLab.textColor = [UIColor colorWithWhite:0.502 alpha:1.000];
    detailLab.textAlignment = NSTextAlignmentCenter;
    detailLab.userInteractionEnabled = NO;
    detailLab.font = [UIFont systemFontOfSize:13];
    detailLab.numberOfLines = 0;
    detailLab.text = [_xiansDic objectForKey:@"content"];
    CGSize detailLabsize = [detailLab sizeWithMultiLineContent:detailLab.text rowWidth:frameWidth(detailLab) font:detailLab.font];
    detailLab.lineBreakMode = NSLineBreakByTruncatingTail;
    detailLab.frame = frame(frameX(detailLab), frameY(detailLab), frameWidth(detailLab), detailLabsize.height + 20);
    
    [xsDetailV addSubview:detailLab];
    
    //语音
    
    float soundImgH = CGRectGetMaxY(detailLab.frame);
    if (_xiansDic[@"audios"]&&![_xiansDic[@"audios"] isEqualToString:@""]) {
        
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
        
        _url=[NSString stringWithFormat:@"%@%@",ImageURLS,_xiansDic[@"audios"]];
        
        soundImgH =soundImg.frame.size.height+soundImg.frame.origin.y+5;
    }

    
    UIView * sxV = [[UIView alloc]initWithFrame:CGRectMake(10, soundImgH , xsDetailV.frame.size.width-20, 1)];
    sxV.backgroundColor = [UIColor colorWithRed:0.925 green:0.925 blue:0.929 alpha:1.000];
    [xsDetailV addSubview:sxV];
    
    float height = CGRectGetMaxY(sxV.frame);
    
    if ([_xiansDic objectForKey:@"remark_cus"]&&![[_xiansDic objectForKey:@"remark_cus"] isEqualToString:@""]) {
        
        UILabel * detailLabdec = [[UILabel alloc]initWithFrame:CGRectMake(3,height, xsDetailV.frame.size.width-6, 60)];
        detailLabdec.textColor = [UIColor colorWithWhite:0.502 alpha:1.000];
        detailLabdec.textAlignment = NSTextAlignmentCenter;
        detailLabdec.userInteractionEnabled = NO;
        detailLabdec.font = [UIFont systemFontOfSize:13];
        detailLabdec.numberOfLines = 0;
        detailLabdec.text = [_xiansDic objectForKey:@"remark_cus"];
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
    NSString * moneyStr = [NSString stringWithFormat:@"(%@)",[_xiansDic objectForKey:@"coopnum"] ];
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
    NSString * qdStr = [NSString stringWithFormat:@"(%@)",[_xiansDic objectForKey:@"commentnum"] ];
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
   
    switch ([[_xiansDic objectForKey:@"state"]intValue]) {
        case 10:
        case 20:
            _viewType = weiHeZuo_Type;
            break;
        case 65:
        case 70:
        case 80:
        case 90:
            _viewType = weiCaoZuo_Type;
            break;
        case 98:
        case 99:
            _viewType = weiHeZuo_Type;
            break;
        default:
            _viewType = yiheZuo_Type;
            break;
    }
    xsDetailV.frame = frame(frameX(xsDetailV), frameY(xsDetailV), frameWidth(xsDetailV), CGRectGetMaxY(xsplLab.frame));
    if (_viewType == weiHeZuo_Type) {
        [self addTheLQV:xsDetailV.frame.size.height+xsDetailV.frame.origin.y+10];
    }else
    {
        [self customNextV:xsDetailV.frame.size.height+xsDetailV.frame.origin.y+10];
    }
    

}
-(void)lqrTapAction
{
    if ([[_xiansDic objectForKey:@"coopnum"]intValue ] == 0) {
        [[ToolManager shareInstance]showAlertMessage:@"暂无领取人"];
        return;
    }
    LinQuRenVC * lqV = [[LinQuRenVC alloc]init];
    lqV.xiansID = [_xiansDic objectForKey:@"id"];
    [self.navigationController pushViewController:lqV animated:YES];
}
#pragma mark----------线索评论
-(void)xsplTapAction
{
    ClueCommunityViewController * comuniV = [[ClueCommunityViewController alloc]init];
    comuniV.clueID = [_xiansDic objectForKey:@"id"];
    [self.navigationController pushViewController:comuniV animated:YES];

}
-(void)customNextV:(CGFloat)orgY
{
    UIView * lqrV = [[UIView alloc]initWithFrame:CGRectMake(10, orgY, SCREEN_WIDTH-20, 61)];
    lqrV.backgroundColor = [UIColor whiteColor];
    [_bottmScr addSubview:lqrV];
    UITapGestureRecognizer * lqrTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jjrDetaolAction)];
    lqrTap.numberOfTouchesRequired = 1;
    lqrTap.numberOfTapsRequired = 1;
    lqrV.userInteractionEnabled = YES;
    [lqrV addGestureRecognizer:lqrTap];
    _headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 41, 41)];
    NSString * imgUrl;
    if ([[_coopArr[0] objectForKey:@"imgurl"] rangeOfString:@"http"].location != NSNotFound) {
        imgUrl = [_coopArr[0] objectForKey:@"imgurl"];
    }else{
        imgUrl = [NSString stringWithFormat:@"%@%@",IMG_URL,[_coopArr[0] objectForKey:@"imgurl"]];
    }
    
    [[ToolManager shareInstance]imageView:_headImg setImageWithURL:imgUrl placeholderType:PlaceholderTypeUserHead];
 

    UIImageView * xzImg = [[UIImageView alloc]initWithFrame:CGRectMake(51-15, 15, 15, 15)];
    xzImg.image = [UIImage imageNamed:@"xuanzhong"];
    [lqrV addSubview:_headImg];
    [lqrV addSubview:xzImg];
    
    
    _userNameLab = [[UILabel alloc]initWithFrame:CGRectMake(_headImg.frame.origin.x+_headImg.frame.size.width+10, 12, 55, 25)];
    _userNameLab.font = [UIFont systemFontOfSize:15];
    _userNameLab.textColor = [UIColor blackColor];
    _userNameLab.textAlignment = NSTextAlignmentLeft;
    _userNameLab.text = [_coopArr[0] objectForKey:@"realname"];
    [lqrV addSubview:_userNameLab];
    
    _positionLab = [[UILabel alloc]initWithFrame:CGRectMake(_userNameLab.frame.origin.x, 42, 80, 11)];
    _positionLab.font = [UIFont systemFontOfSize:12];
    _positionLab.textColor = [UIColor colorWithWhite:0.514 alpha:1.000];
    _positionLab.textAlignment = NSTextAlignmentLeft;
    NSString * str1 = @"定金:";
    NSString * str2 = [NSString stringWithFormat:@"%@元",[_coopArr[0] objectForKey:@"deposit"]];
    NSString * dingjinStr = [str1 stringByAppendingString:str2];
    NSMutableAttributedString * diingjAtr = [[NSMutableAttributedString alloc]initWithString:dingjinStr];
    [diingjAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.467 green:0.471 blue:0.475 alpha:1.000] range:NSMakeRange(0, [str1 length])];
    [diingjAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.529 green:0.678 blue:0.847 alpha:1.000] range:NSMakeRange([str1 length], [str2 length])];
    [lqrV addSubview:_positionLab];
    _positionLab.attributedText = diingjAtr;
    [lqrV addSubview:_positionLab];
    UIImageView * renzhImg = [[UIImageView alloc]initWithFrame:CGRectMake(_userNameLab.frame.origin.x+_userNameLab.frame.size.width, 18, 14, 14)];
    renzhImg.image = [[_coopArr[0] objectForKey:@"authen"]intValue]==3?[UIImage imageNamed:@"renzhen"]:[UIImage imageNamed:@"weirenzhen"];
    [lqrV addSubview:renzhImg];
    
    _timeLab = [[UILabel alloc]initWithFrame:CGRectMake(lqrV.frame.size.width-160, 15, 150, 20)];
    _timeLab.backgroundColor = [UIColor clearColor];
    _timeLab.font = [UIFont systemFontOfSize:12];
    _timeLab.textColor = [UIColor colorWithWhite:0.514 alpha:1.000];
    _timeLab.textAlignment = NSTextAlignmentRight;
    NSString * timStr = [_coopArr[0] objectForKey:@"createtime"];
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

    [lqrV addSubview:_timeLab];
    UIButton * duihuaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    duihuaBtn.frame = CGRectMake(10, lqrV.frame.size.height + lqrV.frame.origin.y+1, (SCREEN_WIDTH-20)/2, 40);
    duihuaBtn.backgroundColor = [UIColor whiteColor];
    [duihuaBtn setTitle:@"跟Ta对话" forState:UIControlStateNormal];
     [duihuaBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [duihuaBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [duihuaBtn setTitleColor:[UIColor colorWithRed:0.290 green:0.569 blue:0.973 alpha:1.000] forState:UIControlStateNormal];
    [duihuaBtn addTarget:self action:@selector(gentaduihuaAction) forControlEvents:UIControlEventTouchUpInside];
    [duihuaBtn setImage:[UIImage imageNamed:@"liantianzhuse"] forState:UIControlStateNormal];
    [_bottmScr addSubview:duihuaBtn];
    UIButton * lianxiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lianxiBtn.frame = CGRectMake((SCREEN_WIDTH-20)/2+10.5f, lqrV.frame.size.height + lqrV.frame.origin.y+1, (SCREEN_WIDTH-20)/2-0.5f, 40);
    lianxiBtn.backgroundColor = [UIColor whiteColor];
    [lianxiBtn setTitle:@"电话联系" forState:UIControlStateNormal];
    [lianxiBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [lianxiBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [lianxiBtn setTitleColor:[UIColor colorWithRed:0.290 green:0.569 blue:0.973 alpha:1.000] forState:UIControlStateNormal];
    [lianxiBtn addTarget:self action:@selector(lianxiAction) forControlEvents:UIControlEventTouchUpInside];
    [lianxiBtn setImage:[UIImage imageNamed:@"shouji"] forState:UIControlStateNormal];
    [_bottmScr addSubview:lianxiBtn];

    [_bottmScr setContentSize:CGSizeMake(SCREEN_WIDTH, duihuaBtn.frame.size.height+duihuaBtn.frame.origin.y)];
    if ([[_allDic objectForKey:@"isevaluate"]intValue ]==0) {
        _viewType = weiCaoZuo_Type;
    }else
    {
        if ([[_allDic objectForKey:@"evaluate"] intValue ]==1) {
            _viewType = manYi_Type;
        }else
        {
            if ([[_xiansDic objectForKey:@"state"]intValue]>45) {
                _viewType =BMYYSS_Type;
            }else
            {
                _viewType =BMYWSS_Type;
            }
        }
    }
    
    switch (_viewType) {
        case manYi_Type:
            [self customManyiView:duihuaBtn.frame.size.height+duihuaBtn.frame.origin.y];
            break;
        case BMYWSS_Type:
            [self customBMYWSSV:duihuaBtn.frame.size.height+duihuaBtn.frame.origin.y];
            break;
        case BMYYSS_Type:
            [self customBMMYSSV:duihuaBtn.frame.size.height+duihuaBtn.frame.origin.y];
            break;
        default:
            break;
    }
}
-(void)lianxiAction
{
    NSString * telstr = [NSString stringWithFormat:@"tel://%@",[_coopArr[0] objectForKey:@"tel"]];
    UIWebView * webV =  [[UIWebView alloc]initWithFrame:CGRectZero];
    [webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:telstr]]];
    [self.view addSubview:webV];
}
-(void)gentaduihuaAction
{
    CommunicationViewController * comunV = [[CommunicationViewController alloc]init];
    comunV.senderid = [_coopArr[0] objectForKey:@"brokerid"];
    comunV.chatType = ChatMessageTpye;
    [self.navigationController pushViewController:comunV animated:YES];
}
#pragma mark--领取人经纪人详情页面跳转
-(void)jjrDetaolAction
{
    JJRDetailVC * jjrV = allocAndInit(JJRDetailVC);
    jjrV.jjrID = [_coopArr[0] objectForKey:@"brokerid"];
    PushView(self, jjrV);
    

}
-(void)customBMMYSSV:(CGFloat)orgY
{
  
    UIView * bmanyiV = [[UIView alloc]initWithFrame:CGRectMake(10, orgY, SCREEN_WIDTH-20, 140)];
//    NSLog(@"_allDic = %@",_allDic);
    //修改 state=90 且result=0
    if ([[_xiansDic objectForKey:@"state"]intValue] == 90&&[[_xiansDic objectForKey:@"result"]intValue]!=0) {
         bmanyiV.frame = CGRectMake(10, orgY, SCREEN_WIDTH-20, 210);
    }

    bmanyiV.backgroundColor = [UIColor whiteColor];
    [_bottmScr addSubview:bmanyiV];
    UIButton * bmanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bmanBtn.frame = CGRectMake(10, 15, 40, 40);
    bmanBtn.layer.cornerRadius = bmanBtn.bounds.size.width/2;
    bmanBtn.backgroundColor = [UIColor colorWithRed:0.984 green:0.435 blue:0.176 alpha:1.000];
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
    if ([[_allDic objectForKey:@"isevaluate"]intValue] == 1) {
        msLab.text = [_allDic objectForKey:@"evaluatecontent"];
    }else{

    msLab.text = @"";
    }
    [bmanyiV addSubview:msLab];
    
    
    UIButton * kfBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    kfBtn.frame = CGRectMake(10, 80, 40, 40);
    kfBtn.layer.cornerRadius = kfBtn.bounds.size.width/2;
    kfBtn.backgroundColor = [UIColor colorWithRed:0.239 green:0.549 blue:1.000 alpha:1.000];
    if ([[_xiansDic objectForKey:@"state"]intValue] == 55) {
        [kfBtn setTitle:@"客服" forState:UIControlStateNormal];
        kfBtn.backgroundColor = [UIColor colorWithRed:0.984 green:0.435 blue:0.176 alpha:1.000];
    }
    //修改 state=90 且result=0
    else if ([[_xiansDic objectForKey:@"state"]intValue] == 90&&[[_xiansDic objectForKey:@"result"]intValue]==0)
    {
        [kfBtn setTitle:@"申述" forState:UIControlStateNormal];
        kfBtn.backgroundColor = [UIColor colorWithRed:0.984 green:0.435 blue:0.176 alpha:1.000];
    }
    else{
    [kfBtn setTitle:@"结果" forState:UIControlStateNormal];
    }
    
    kfBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [kfBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    kfBtn.userInteractionEnabled = NO;
    [bmanyiV addSubview:kfBtn];
    
    UILabel * kfLab = [[UILabel alloc]initWithFrame:CGRectMake(60, 80, 200, 20)];
    kfLab.font = [UIFont systemFontOfSize:14];
    kfLab.textAlignment = NSTextAlignmentLeft;
    kfLab.textColor = [UIColor colorWithRed:0.537 green:0.541 blue:0.545 alpha:1.000];
    if([[_xiansDic objectForKey:@"state"]intValue] == 55)
    {
        kfLab.text = @"知脉客服介入";
        kfLab.textColor = [UIColor colorWithRed:0.984 green:0.435 blue:0.176 alpha:1.000];
    }
    //修改 state=90 且result=0
    else if ([[_xiansDic objectForKey:@"state"]intValue] == 90&&[[_xiansDic objectForKey:@"result"]intValue]==0)
    {
        kfLab.text = @"不申诉";
        kfLab.textColor = [UIColor colorWithRed:0.984 green:0.435 blue:0.176 alpha:1.000];
    }
    else{
    kfLab.text = @"知脉客服调解结果";
    }
    [bmanyiV addSubview:kfLab];
    
    UILabel * msLab2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 100, bmanyiV.frame.size.width-60-5, 20)];
    msLab2.font = [UIFont systemFontOfSize:13];
    msLab2.textAlignment = NSTextAlignmentLeft;
    msLab2.textColor = [UIColor colorWithRed:0.537 green:0.541 blue:0.545 alpha:1.000];
    if ([[_xiansDic objectForKey:@"state"]intValue] == 55) {
        msLab2.text = @"正在为双方解决不满意问题!";
    }
    //修改 state=90 且result=0
    else if ([[_xiansDic objectForKey:@"state"]intValue] == 90&&[[_xiansDic objectForKey:@"result"]intValue]==0)
    {
        msLab2.text = @"您已放弃申述，诚意金已退回!";
    }
    else{
        if ([[_xiansDic objectForKey:@"remark"]isEqualToString:@""]) {
            msLab2.text = @"已解决";
        }else{
            msLab2.text = [_xiansDic objectForKey:@"remark"];
        }
        if ([[_xiansDic objectForKey:@"state"]intValue] ==65) {
            msLab2.text = @"双方经过知脉客服,对问题无异议";
        }
    }
    [bmanyiV addSubview:msLab2];
    
    UIView * sxV = [[UIView alloc]initWithFrame:CGRectMake(30, 55, 0.5, 25)];
    sxV.backgroundColor = [UIColor colorWithRed:0.813 green:0.816 blue:0.825 alpha:1.000];
    [bmanyiV addSubview:sxV];
    
    UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(10, 0, bmanyiV.frame.size.width-20, 0.5)];
    hxV.backgroundColor = [UIColor colorWithRed:0.813 green:0.816 blue:0.825 alpha:1.000];
    [bmanyiV addSubview:hxV];
    [_bottmScr setContentSize: CGSizeMake(SCREEN_WIDTH, bmanyiV.frame.size.height+bmanyiV.frame.origin.y)];
    if ([[_xiansDic objectForKey:@"state"]intValue] == 80) {
        [self addThePJBtn];
    }
    if ([[_xiansDic objectForKey:@"state"]intValue] == 90 &&[[_xiansDic objectForKey:@"result"]intValue] != 0) {
        UIButton * jsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        jsBtn.frame = CGRectMake(10, 145, 40, 40);
        jsBtn.layer.cornerRadius = jsBtn.bounds.size.width/2;
        if ([[_allDic objectForKey:@"evaluateF"] intValue] == 1) {
           jsBtn.backgroundColor = [UIColor colorWithRed:0.239 green:0.549 blue:1.000 alpha:1.000];
        }else{
        jsBtn.backgroundColor = [UIColor colorWithRed:0.984 green:0.435 blue:0.176 alpha:1.000];
        }
        [jsBtn setTitle:@"评价" forState:UIControlStateNormal];
        jsBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [jsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        jsBtn.userInteractionEnabled = NO;
        [bmanyiV addSubview:jsBtn];
        
        UIView * sxV3 = [[UIView alloc]initWithFrame:CGRectMake(30, 120, 0.5, 25)];
        sxV3.backgroundColor = [UIColor colorWithRed:0.813 green:0.816 blue:0.825 alpha:1.000];
        [bmanyiV addSubview:sxV3];
        
        UILabel * msLab3 = [[UILabel alloc]initWithFrame:CGRectMake(60, 145, bmanyiV.frame.size.width-60-5, 20)];
        msLab3.font = [UIFont systemFontOfSize:13];
        msLab3.textAlignment = NSTextAlignmentLeft;
        msLab3.textColor = [UIColor colorWithRed:0.537 green:0.541 blue:0.545 alpha:1.000];
        msLab3.text = @"评价内容";
        [bmanyiV addSubview:msLab3];
        UILabel * msLab4 = [[UILabel alloc]initWithFrame:CGRectMake(60, 165, bmanyiV.frame.size.width-60-5, 20)];
        msLab4.font = [UIFont systemFontOfSize:13];
        msLab4.textAlignment = NSTextAlignmentLeft;
        msLab4.textColor = [UIColor colorWithRed:0.537 green:0.541 blue:0.545 alpha:1.000];
        if ([[_allDic objectForKey:@"evaluatecontentF"] isEqualToString:@""]) {
            
        }else{
        msLab4.text = [_allDic objectForKey:@"evaluatecontentF"];
        }
        [bmanyiV addSubview:msLab4];

         [_bottmScr setContentSize: CGSizeMake(SCREEN_WIDTH, bmanyiV.frame.size.height+bmanyiV.frame.origin.y)];
    }


}
-(void)customBMYWSSV:(CGFloat)orgY
{
    _bottmScr.frame = CGRectMake(0, 74.5, SCREEN_WIDTH, SCREEN_HEIGHT-74.5-40);
    
    UIView * bmanyiV = [[UIView alloc]initWithFrame:CGRectMake(10, orgY, SCREEN_WIDTH-20, 70)];
    bmanyiV.backgroundColor = [UIColor whiteColor];
    [_bottmScr addSubview:bmanyiV];
    UIButton * pjBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pjBtn.frame = CGRectMake(10, 15, 40, 40);
    pjBtn.layer.cornerRadius = pjBtn.bounds.size.width/2;
    pjBtn.backgroundColor = [UIColor colorWithRed:0.984 green:0.435 blue:0.176 alpha:1.000];
    [pjBtn setTitle:@"评价" forState:UIControlStateNormal];
    pjBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    pjBtn.userInteractionEnabled = NO;
    [pjBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bmanyiV addSubview:pjBtn];
    
    UILabel * bmyLab = [[UILabel alloc]initWithFrame:CGRectMake(60, 15, 200, 20)];
    bmyLab.font = [UIFont systemFontOfSize:14];
    bmyLab.textAlignment = NSTextAlignmentLeft;
    bmyLab.textColor = [UIColor blackColor];
    bmyLab.text = @"不满意";
    [bmanyiV addSubview:bmyLab];
    
    UILabel * msLab = [[UILabel alloc]initWithFrame:CGRectMake(60, 35, bmanyiV.frame.size.width-60-5, 20)];
    msLab.font = [UIFont systemFontOfSize:13];
    msLab.textAlignment = NSTextAlignmentLeft;
    msLab.textColor = [UIColor colorWithRed:0.537 green:0.541 blue:0.545 alpha:1.000];
    if ([[_allDic objectForKey:@"isevaluate"]intValue] == 1) {
        msLab.text = [_allDic objectForKey:@"evaluatecontent"];
    }else{
    msLab.text = @"";
    }
    [bmanyiV addSubview:msLab];
    
    UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(10, 0, bmanyiV.frame.size.width-20, 0.5)];
    hxV.backgroundColor = [UIColor colorWithRed:0.813 green:0.816 blue:0.825 alpha:1.000];
    [bmanyiV addSubview:hxV];
    [_bottmScr setContentSize: CGSizeMake(SCREEN_WIDTH, bmanyiV.frame.size.height+bmanyiV.frame.origin.y)];
    [self addTheTwoBtn];
}
-(void)addThePJBtn
{
    _bottmScr.frame = CGRectMake(0, 74.5, SCREEN_WIDTH, SCREEN_HEIGHT-74.5-40);
    UIButton * bssBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bssBtn.frame = CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH/2, 40);
    bssBtn.backgroundColor = [UIColor whiteColor];
    [bssBtn setTitle:@"不满意" forState:UIControlStateNormal];
    [bssBtn setTitleColor:[UIColor colorWithRed:0.239 green:0.549 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
    bssBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [bssBtn addTarget:self action:@selector(bumanyiAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bssBtn];
    
    UIButton * ssBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ssBtn.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-40, SCREEN_WIDTH/2, 40);
    ssBtn.backgroundColor = [UIColor colorWithRed:0.239 green:0.549 blue:1.000 alpha:1.000];
    [ssBtn setTitle:@"满意" forState:UIControlStateNormal];
    [ssBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ssBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [ssBtn addTarget:self action:@selector(manyiAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ssBtn];
    UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH, 0.5)];
    hxV.backgroundColor = [UIColor colorWithRed:0.867 green:0.875 blue:0.878 alpha:1.000];
    [self.view addSubview:hxV];

}
-(void)bumanyiAction
{
    WBPingJiaVC * wbpj = [[WBPingJiaVC alloc]init];
    wbpj.type = 1;
    wbpj.xiansuoID = [_coopArr[0] objectForKey:@"id"];
    wbpj.pjStr = @"不满意";
    [self.navigationController pushViewController:wbpj animated:YES];
}
-(void)manyiAction
{
    WBPingJiaVC * wbpj = [[WBPingJiaVC alloc]init];
    wbpj.type = 1;
    wbpj.xiansuoID = [_coopArr[0] objectForKey:@"id"];
    wbpj.pjStr = @"满意";
    [self.navigationController pushViewController:wbpj animated:YES];
}
-(void)addTheTwoBtn
{
    UIButton * bssBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bssBtn.frame = CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH/2, 40);
    bssBtn.backgroundColor = [UIColor whiteColor];
    [bssBtn setTitle:@"不申诉" forState:UIControlStateNormal];
    [bssBtn setTitleColor:[UIColor colorWithRed:0.239 green:0.549 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
    bssBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [bssBtn addTarget:self action:@selector(bssAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bssBtn];
    
    UIButton * ssBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ssBtn.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-40, SCREEN_WIDTH/2, 40);
    ssBtn.backgroundColor = [UIColor colorWithRed:0.239 green:0.549 blue:1.000 alpha:1.000];
    [ssBtn setTitle:@"申诉" forState:UIControlStateNormal];
    [ssBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ssBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [ssBtn addTarget:self action:@selector(ssAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ssBtn];
    UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH, 0.5)];
    hxV.backgroundColor = [UIColor colorWithRed:0.867 green:0.875 blue:0.878 alpha:1.000];
    [self.view addSubview:hxV];
}
-(void)bssAction
{
    [[MyKuaJieInfo shareInstance]buShensuWithID:[_coopArr[0] objectForKey:@"id"] andCallBack:^(BOOL issucced, NSString *info, NSDictionary *jsonDic) {
        [[ToolManager shareInstance] showAlertMessage:info];
        if (issucced == YES) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else
        {
            [[ToolManager shareInstance]showAlertMessage:info];
        }
        

    }];
}
-(void)ssAction
{
    WBShenSuVC * ssV = [[WBShenSuVC alloc]init];
    ssV.xsID = [_coopArr[0] objectForKey:@"id"];
    [self.navigationController pushViewController:ssV animated:YES];
}
-(void)customManyiView:(CGFloat)orgY
{
    
    UIView * manyiV = [[UIView alloc]initWithFrame:CGRectMake(10, orgY, SCREEN_WIDTH-20, 140)];
    if ([[_xiansDic objectForKey:@"state"]intValue] == 90) {
        manyiV.frame = CGRectMake(10, orgY, SCREEN_WIDTH-20, 210);
    }
    manyiV.backgroundColor = [UIColor whiteColor];
    [_bottmScr addSubview:manyiV];
    UIButton * manBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    manBtn.frame = CGRectMake(10, 15, 40, 40);
    manBtn.layer.cornerRadius = manBtn.bounds.size.width/2;
    manBtn.backgroundColor = [UIColor colorWithRed:0.239 green:0.549 blue:1.000 alpha:1.000];
    [manBtn setTitle:@"评价" forState:UIControlStateNormal];
    manBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    manBtn.userInteractionEnabled = NO;
    [manBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [manyiV addSubview:manBtn];
    
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
    msLab.text = [_allDic objectForKey:@"evaluatecontent"];
    [manyiV addSubview:msLab];
    
    
    UIButton * wkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wkBtn.frame = CGRectMake(10, 80, 40, 40);
    wkBtn.layer.cornerRadius = manBtn.bounds.size.width/2;
    wkBtn.backgroundColor = [UIColor colorWithRed:0.239 green:0.549 blue:1.000 alpha:1.000];
    [wkBtn setTitle:@"尾款" forState:UIControlStateNormal];
    wkBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [wkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    wkBtn.userInteractionEnabled = NO;
    [manyiV addSubview:wkBtn];

    UILabel * wkLab = [[UILabel alloc]initWithFrame:CGRectMake(60, 80, 200, 20)];
    wkLab.font = [UIFont systemFontOfSize:14];
    wkLab.textAlignment = NSTextAlignmentLeft;
    wkLab.textColor = [UIColor blackColor];
    if ([[_xiansDic objectForKey:@"state"]intValue] == 40) {
        wkLab.text = @"未付尾款";
        
    }else if ([[_xiansDic objectForKey:@"state"]intValue] == 65)
    {
        wkLab.text = @"尾款催缴";
        wkBtn.backgroundColor = [UIColor colorWithRed:0.984 green:0.435 blue:0.176 alpha:1.000];
    }
    else if([[_xiansDic objectForKey:@"state"]intValue] == 70)
    {
        wkLab.text = @"已支付尾款";
    }
    else{
    wkLab.text = @"收到尾款";
        if ([[_xiansDic objectForKey:@"state"]intValue] == 90) {
            
        }else{
        [self addThePJBtn];
        }
    }
    [manyiV addSubview:wkLab];
    
    UILabel * msLab2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 100, manyiV.frame.size.width-60-5, 20)];
    msLab2.font = [UIFont systemFontOfSize:13];
    msLab2.textAlignment = NSTextAlignmentLeft;
    msLab2.textColor = [UIColor colorWithRed:0.537 green:0.541 blue:0.545 alpha:1.000];
    if ([[_xiansDic objectForKey:@"state"]intValue] == 65) {
        msLab2.text = @"客服已给对方发出催缴通知!";
    }else if ([[_xiansDic objectForKey:@"state"]intValue] == 40)
    {
        msLab2.text = @"等待对方付尾款,您可以提醒对方付款!";
    }
    else if([[_xiansDic objectForKey:@"state"]intValue] == 70){
    msLab2.text = @"对方已付尾款!";
    }else
    {
        msLab2.text = @"尾款已到账,请注意查收!";
    }
    [manyiV addSubview:msLab2];
    
    UIView * sxV = [[UIView alloc]initWithFrame:CGRectMake(30, 55, 0.5, 25)];
    sxV.backgroundColor = [UIColor colorWithRed:0.813 green:0.816 blue:0.825 alpha:1.000];
    [manyiV addSubview:sxV];
    
    if ([[_xiansDic objectForKey:@"state"]intValue] == 90) {
        UIButton * jsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        jsBtn.frame = CGRectMake(10, 145, 40, 40);
        jsBtn.layer.cornerRadius = jsBtn.bounds.size.width/2;
        jsBtn.backgroundColor = [UIColor colorWithRed:0.239 green:0.549 blue:1.000 alpha:1.000];
        [jsBtn setTitle:@"评价" forState:UIControlStateNormal];
        jsBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [jsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        jsBtn.userInteractionEnabled = NO;
        [manyiV addSubview:jsBtn];
        
        UIView * sxV2 = [[UIView alloc]initWithFrame:CGRectMake(30, 120, 0.5, 25)];
        sxV2.backgroundColor = [UIColor colorWithRed:0.813 green:0.816 blue:0.825 alpha:1.000];
        [manyiV addSubview:sxV2];
        
        UILabel * msLab3 = [[UILabel alloc]initWithFrame:CGRectMake(60, 145, manyiV.frame.size.width-60-5, 20)];
        msLab3.font = [UIFont systemFontOfSize:13];
        msLab3.textAlignment = NSTextAlignmentLeft;
        msLab3.textColor = [UIColor colorWithRed:0.537 green:0.541 blue:0.545 alpha:1.000];
        msLab3.text = @"评价内容";
        [manyiV addSubview:msLab3];
        
        UILabel * msLab4 = [[UILabel alloc]initWithFrame:CGRectMake(60, 165, manyiV.frame.size.width-60-5, 20)];
        msLab4.font = [UIFont systemFontOfSize:13];
        msLab4.textAlignment = NSTextAlignmentLeft;
        msLab4.textColor = [UIColor colorWithRed:0.537 green:0.541 blue:0.545 alpha:1.000];
        if ([[_allDic objectForKey:@"evaluatecontentF"]isEqualToString:@""]) {
            
        }else{
        msLab4.text = [_allDic objectForKey:@"evaluatecontentF"];
        }
        [manyiV addSubview:msLab4];

    }
    UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(10, 0, manyiV.frame.size.width-20, 0.5)];
    hxV.backgroundColor = [UIColor colorWithRed:0.813 green:0.816 blue:0.825 alpha:1.000];
    [manyiV addSubview:hxV];
    [_bottmScr setContentSize: CGSizeMake(SCREEN_WIDTH, manyiV.frame.size.height+manyiV.frame.origin.y)];
}
-(void)addTheLQV:(CGFloat)orgY
{
    if ([[_xiansDic objectForKey:@"state"]intValue] == 99) {
        UIView * wbxzV = [[UIView alloc]initWithFrame:CGRectMake(10, orgY, SCREEN_WIDTH-20, 90)];
        wbxzV.backgroundColor = [UIColor whiteColor];
        [_bottmScr addSubview:wbxzV];
        UIImageView * gthImg = [[UIImageView alloc]initWithFrame:CGRectMake((wbxzV.frame.size.width-36)/2, 15, 36, 36)];
        gthImg.image = [UIImage imageNamed:@"weibaixuanzhong"];
        [wbxzV addSubview:gthImg];
        UILabel * wbxzLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, wbxzV.frame.size.width, 30)];
        wbxzLab.textColor = [UIColor colorWithRed:0.733 green:0.737 blue:0.741 alpha:1.000];
        wbxzLab.textAlignment = NSTextAlignmentCenter;
        wbxzLab.text = @"未通过审核";
        wbxzLab.font = [UIFont systemFontOfSize:15];
        [wbxzV addSubview:wbxzLab];
        _bottmScr.contentSize = CGSizeMake(SCREEN_WIDTH, wbxzV.frame.size.height+wbxzV.frame.origin.y);
    }else if ([[_xiansDic objectForKey:@"state"]intValue] == 20)
    {
        
        _whzTab = [[UITableView alloc]initWithFrame:CGRectMake(0, orgY, SCREEN_WIDTH, 119*_coopArr.count)];
        _whzTab.scrollEnabled = NO;
        _whzTab.backgroundColor = [UIColor clearColor];
        _whzTab.delegate = self;
        _whzTab.dataSource = self;
        _whzTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _whzTab.tag = WHZTABTAG;
        [_bottmScr addSubview:_whzTab];
        [self addTheCommendV:orgY + _whzTab.frame.size.height +10];

    }
    else{
        UIView * shV = [[UIView alloc]initWithFrame:CGRectMake(10, orgY, SCREEN_WIDTH-20, 90)];
        shV.backgroundColor = [UIColor whiteColor];
        [_bottmScr addSubview:shV];
        UIImageView * gthImg = [[UIImageView alloc]initWithFrame:CGRectMake((shV.frame.size.width-36)/2, 15, 36, 36)];
        gthImg.image = [UIImage imageNamed:@"dengdaixuanzhe"];
        [shV addSubview:gthImg];
        UILabel * wbxzLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, shV.frame.size.width, 30)];
        wbxzLab.textColor = [UIColor colorWithRed:0.733 green:0.737 blue:0.741 alpha:1.000];
        wbxzLab.textAlignment = NSTextAlignmentCenter;
        wbxzLab.text = @"等待审核中";
        wbxzLab.font = [UIFont systemFontOfSize:15];
        [shV addSubview:wbxzLab];
        _bottmScr.contentSize = CGSizeMake(SCREEN_WIDTH, shV.frame.size.height+shV.frame.origin.y);
    _whzTab = [[UITableView alloc]initWithFrame:CGRectMake(0, orgY+90+10, SCREEN_WIDTH, 119*_coopArr.count)];
    _whzTab.scrollEnabled = NO;
    _whzTab.backgroundColor = [UIColor clearColor];
    _whzTab.delegate = self;
    _whzTab.dataSource = self;
    _whzTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    _whzTab.tag = WHZTABTAG;
    [_bottmScr addSubview:_whzTab];
    [self addTheCommendV:orgY + _whzTab.frame.size.height + 110];
    }
}
-(void)addTheCommendV:(CGFloat)orgY
{
    if (_recomArr.count == 0) {
        return;
    }
    UILabel * commendLab = [[UILabel alloc]initWithFrame:CGRectMake(10, orgY, SCREEN_WIDTH-20, 30)];
    commendLab.backgroundColor = [UIColor whiteColor];
    commendLab.text = @"   系统推荐";
    commendLab.textColor = [UIColor blackColor];
    commendLab.textAlignment = NSTextAlignmentLeft;
    commendLab.font = [UIFont systemFontOfSize:13];
    [_bottmScr addSubview:commendLab];
    _commendTab = [[UITableView alloc]initWithFrame:CGRectMake(0, orgY + 31, SCREEN_WIDTH, 119*_recomArr.count)];
    _commendTab.delegate = self;
    _commendTab.dataSource = self;
    _commendTab.scrollEnabled = NO;
    _commendTab.tag = XTTJTABTAG;
    _commendTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    _commendTab.backgroundColor = [UIColor clearColor];
    [_bottmScr addSubview:_commendTab];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == WHZTABTAG) {
        return _coopArr.count;
    }else
    {
        return _recomArr.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == WHZTABTAG) {
        return 98;
    }else
    {
        return 119;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == WHZTABTAG) {
        static NSString * idenfStr = @"jjrCell";
        WxhzCell * cell = [tableView dequeueReusableCellWithIdentifier:idenfStr];
        if (!cell) {
            cell = [[WxhzCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 119)];
            cell.backgroundColor = [UIColor clearColor];
            NSString * imgUrl;
            if ([[_coopArr[indexPath.row]objectForKey:@"imgurl"] rangeOfString:@"http"].location != NSNotFound) {
                imgUrl = [_coopArr[indexPath.row] objectForKey:@"imgurl"];
            }else{
                imgUrl = [NSString stringWithFormat:@"%@%@",IMG_URL,[_coopArr[indexPath.row]objectForKey:@"imgurl"]];
            }

            cell.renzhImg.image = [[_coopArr[indexPath.row]objectForKey:@"authen"]intValue] == 3?[UIImage imageNamed:@"renzhen"]:[UIImage imageNamed:@"weirenzhen"];
            [[ToolManager shareInstance]imageView:cell.headImg setImageWithURL:imgUrl placeholderType:PlaceholderTypeUserHead];
            cell.userNameLab.text = [_coopArr[indexPath.row]objectForKey:@"realname"];
            cell.positionLab.text = [_coopArr[indexPath.row]objectForKey:@"area"];
            NSString * timStr = [_coopArr[indexPath.row] objectForKey:@"createtime"];
            NSTimeInterval time=[timStr doubleValue];
            NSDate *data = [NSDate dateWithTimeIntervalSince1970:time];
            cell.timeLab.text = [self getDateStringWithDate:data DateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString * sjcStr = [self intervalSinceNow:cell.timeLab.text];
            if ([sjcStr integerValue] <=60) {
                cell.timeLab.text = @"刚刚";
            }else if ([sjcStr integerValue]<=3600)
            {
                cell.timeLab.text = [NSString stringWithFormat:@"%ld分钟前",[sjcStr integerValue]/60];
            }else if ([sjcStr integerValue]<=60*60*24)
            {
                cell.timeLab.text = [NSString stringWithFormat:@"%ld小时前",[sjcStr integerValue]/(60*60)];
            }else if ([sjcStr integerValue]<=60*60*24*3)
            {
                cell.timeLab.text = [NSString stringWithFormat:@"%ld天前",[sjcStr integerValue]/(60*60*24)];
            }
            cell.xthzBtn.tag = 300+indexPath.row;
            UITapGestureRecognizer * whzTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(whzDetaolAction:)];
            whzTap.numberOfTouchesRequired = 1;
            whzTap.numberOfTapsRequired = 1;
            cell.nextV.tag = 700+indexPath.row;
            [cell.nextV addGestureRecognizer:whzTap];

            [cell.xthzBtn addTarget:self action:@selector(guanzhuAction:) forControlEvents:UIControlEventTouchUpInside];
            CGRect frame1 = _whzTab.frame;
            frame1.size.height = _whzTab.contentSize.height;
            _whzTab.frame = frame1;
            if (_bottmScr.contentSize.height>frame1.origin.y+frame1.size.height) {
                
            }else{
            _bottmScr.contentSize = CGSizeMake(SCREEN_WIDTH, frame1.size.height+frame1.origin.y);
            }
        }
        return cell;

    }else
    {
        static NSString * idenfStr = @"xttjCell";
        JJRCell * cell = [tableView dequeueReusableCellWithIdentifier:idenfStr];
        if (!cell) {
            cell = [[JJRCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 98)];
            
            cell.backgroundColor = [UIColor clearColor];
            cell.renzhImg.image = [[_recomArr[indexPath.row]objectForKey:@"authen"] intValue]==3?[UIImage imageNamed:@"renzhen"]:[UIImage imageNamed:@"weirenzhen"];

            NSString * imgUrl;
            if ([[_recomArr[indexPath.row]objectForKey:@"imgurl"] rangeOfString:@"http"].location != NSNotFound) {
                imgUrl = [_recomArr[indexPath.row] objectForKey:@"imgurl"];
            }else{
                imgUrl = [NSString stringWithFormat:@"%@%@",IMG_URL,[_recomArr[indexPath.row]objectForKey:@"imgurl"]];
            }
 
             [[ToolManager shareInstance]imageView:cell.headImg setImageWithURL:imgUrl placeholderType:PlaceholderTypeUserHead];
            cell.userNameLab.text = [_recomArr[indexPath.row]objectForKey:@"realname"];
            cell.positionLab.text = [_recomArr[indexPath.row]objectForKey:@"area"];
            if ([[_recomArr[indexPath.row]objectForKey:@"industry"] isEqualToString:BAOXIAN]) {
                cell.hanyeLab.text = @"保险" ;
            }else if ([[_recomArr[indexPath.row]objectForKey:@"industry"] isEqualToString:JINRONG])
            {
                cell.hanyeLab.text = @"金融" ;
            }else if ([[_recomArr[indexPath.row]objectForKey:@"industry"] isEqualToString:FANGCHANG])
            {
                cell.hanyeLab.text = @"房产" ;
            }else if ([[_recomArr[indexPath.row]objectForKey:@"industry"] isEqualToString:CHEHANG])
            {
                cell.hanyeLab.text = @"车行" ;
            }
            cell.fuwuLab.text = [NSString stringWithFormat:@"服务:%@", [_recomArr[indexPath.row]objectForKey:@"receivenum"]];
            cell.fansLab.text = [NSString stringWithFormat:@"粉丝:%@", [_recomArr[indexPath.row]objectForKey:@"fansnum"]];
            [cell.guanzhuBtn setTitle:@"  通知Ta" forState:UIControlStateNormal];
            [cell.guanzhuBtn setImage:[UIImage imageNamed:@"tongzhi"] forState:UIControlStateNormal];
            cell.guanzhuBtn.tag = 1000+indexPath.row;
            [cell.guanzhuBtn addTarget:self action:@selector(tongzhiAction:) forControlEvents:UIControlEventTouchUpInside];
            CGRect frame = _commendTab.frame;
            
            frame.size.height = _commendTab.contentSize.height;
            _commendTab.frame = frame;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jjrAction:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            cell.nextV.tag = 500+indexPath.row;
            [cell.nextV addGestureRecognizer:tap];

            if (_bottmScr.contentSize.height>frame.origin.y+frame.size.height) {
                
            }else{
               [_bottmScr setContentSize:CGSizeMake(SCREEN_WIDTH, frame.origin.y+frame.size.height)];
            }

        }
        return cell;
    }
    
};
#pragma mark - 语音点击按钮
-(void)playAudioBtnClicked:(UIGestureRecognizer *)sender
{

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
        [[MP3PlayerManager shareInstance] pausePlayer];
         sender.view.tag=1110;
        [(UIImageView *)sender.view stopAnimating];
    }

}
-(void)whzDetaolAction:(UITapGestureRecognizer *)sender
{
    JJRDetailVC * jjrV = allocAndInit(JJRDetailVC);
    jjrV.jjrID = [_coopArr[sender.view.tag-700] objectForKey:@"brokerid"];
    [self.navigationController pushViewController:jjrV animated:YES];
}
-(void)jjrAction:(UIGestureRecognizer *)sender
{
    JJRDetailVC * jjrV = [[JJRDetailVC alloc]init];
    jjrV.jjrID = [_recomArr[sender.view.tag-500] objectForKey:@"id"];
    [self.navigationController pushViewController:jjrV animated:YES];
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
#pragma mark--通知ta
-(void)tongzhiAction:(UIButton *)sender
{
    if (sender.tag - 1000<_recomArr.count) {
    
        [[MyKuaJieInfo shareInstance]getNotificationAtOtherWithId:_recomArr[sender.tag - 1000][@"id"] andDemandid:_xiansDic[@"id"] andCallBack:^(BOOL issucced, NSString *info, NSDictionary *jsonDic) {
            if (issucced) {
                [[ToolManager shareInstance] showSuccessWithStatus:@"通知成功！"];
                
            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus:info];;
            }
            
        }];
    }
   
}
-(void)guanzhuAction:(UIButton *)sender
{
    NSString * str = [NSString stringWithFormat:@"您确定要选 %@ 合作吗",[_coopArr[sender.tag-300] objectForKey:@"realname"]];
    DXAlertView * alert = [[DXAlertView alloc]initWithTitle:@"您确定要选" contentText:str leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
    alert.rightBlock = ^{
        [[MyKuaJieInfo shareInstance]xuanzeHeZuoWithID:[_coopArr[sender.tag-300] objectForKey:@"id"] andCallBack:^(BOOL issucced, NSString *info, NSDictionary *jsonDic) {
            [[ToolManager shareInstance]showAlertMessage:info];
            if (issucced == YES) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else
            {
                [[ToolManager shareInstance]showAlertMessage:info];
            }
        }];

    };
    [alert show];
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
-(void)backAction
{
    [[MP3PlayerManager shareInstance]playerNil];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//转换时间戳
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
