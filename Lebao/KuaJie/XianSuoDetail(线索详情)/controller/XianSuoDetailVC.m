//
//  XianSuoDetailVC.m
//  KuaJie
//
//  Created by 严文斌 on 16/5/17.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import "XianSuoDetailVC.h"
#import "LinQuCell.h"
#import "JJRDetailVC.h"
#import "PayDingJinVC.h"
#import "XianSuoDetailInfo.h"
#import "ToolManager.h"
#import "CommunicationViewController.h"
#import "LinQuRenVC.h"
#import "ClueCommunityViewController.h"
#import "AuthenticationViewController.h"
#import "NSString+Extend.h"
#import "MP3PlayerManager.h"
@interface XianSuoDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

{
    NSString *_url;
}
@property (strong,nonatomic)NSDictionary * xiansDic;
@property (strong ,nonatomic)NSMutableArray * coopArr;
@property (strong,nonatomic)UIView * lqhxV;

@end

@implementation XianSuoDetailVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(infoAction)name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     [self removeNoti];
    [[MP3PlayerManager shareInstance] stopPlayer];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getJsonWithID:_xs_id];
    _coopArr = [[NSMutableArray alloc]init];
    self.view.backgroundColor = BACKCOLOR;
    [self setNav];
    [self addTheTwoBtn];
}
-(void)getJsonWithID:(NSString *)xsID
{
    [[XianSuoDetailInfo shareInstance]getDetailXianSuoWithID:xsID andCallBack:^(BOOL issucced, NSString *info, NSDictionary *jsonDic) {
        if (issucced == YES) {
            for (NSDictionary * dic in [jsonDic objectForKey:@"coops"]) {
                [_coopArr addObject:dic];
            }
            _xiansDic = [NSDictionary dictionaryWithDictionary:[jsonDic objectForKey:@"datas"]];
//            NSLog(@"_xiansDic =%@",_xiansDic,HttpURL);
            [self addButtomScro];
            
            
            
            
            if ([[_xiansDic objectForKey:@"iscoop"] intValue ]==1) {
                _linqBtn.selected = YES;
                _linqBtn.backgroundColor = [UIColor clearColor];
            }else
            {
                _linqBtn.selected = NO;
                _linqBtn.backgroundColor = [UIColor colorWithRed:0.239 green:0.549 blue:1.000 alpha:1.000];
            }
            if ([[_xiansDic objectForKey:@"state"]intValue] >= 30) {
                _linqBtn.hidden = YES;
                 _lqhxV.hidden =YES;
            }else
            {
                _linqBtn.hidden = NO;
                _lqhxV.hidden = NO;
            }

            [self customDjV];
            [self customJbV];
        }else
        {
            [[ToolManager shareInstance]showAlertMessage:info];
     
        }
    }];
}
-(void)customDjV
{
    _zfdjV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _zfdjV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self.view addSubview:_zfdjV];
    UIView * cleaV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-210)];
    cleaV.backgroundColor = [UIColor clearColor];
    cleaV.userInteractionEnabled = YES;
    [_zfdjV addSubview:cleaV];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [cleaV addGestureRecognizer:tap];
    
    //提示字的高度
    NSString *text =@"1.成交报酬，是指该条线索带来的客户成交后，发布者希望拿到的报酬\n2.领取者未被选中合作，或者合作未成交且双方无异议，定金将会退回\n3.领取者的定金在合作成交后作为报酬的一部分支付给发布者";
    CGSize size = [text sizeWithFont:Size(24) maxSize:CGSizeMake(SCREEN_WIDTH - 40, 1000 )];
    UIView * djV = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-(210 + size.height), SCREEN_WIDTH, 210 + size.height)];
    
    djV.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resposAction)];
    tap2.numberOfTapsRequired = 1;
    tap2.numberOfTouchesRequired = 1;
    [djV addGestureRecognizer:tap2];
    [_zfdjV addSubview:djV];
    UILabel * msLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 30)];
    msLab.textAlignment = NSTextAlignmentCenter;
    msLab.textColor = [UIColor colorWithWhite:0.294 alpha:1.000];
    msLab.font = [UIFont systemFontOfSize:15];
    msLab.text = @"您需要支付一定的定金";
    [djV addSubview:msLab];
    UILabel * biliLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 50, 20)];
    biliLab.textAlignment = NSTextAlignmentLeft;
    biliLab.font = [UIFont systemFontOfSize:12];
    biliLab.textColor = [UIColor colorWithWhite:0.639 alpha:1.000];
    biliLab.text = @"定金比例";
    [djV addSubview:biliLab];
    
    _subtraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _subtraBtn.layer.cornerRadius = 10;
    _subtraBtn.layer.borderWidth = 0.5f;
        _subtraBtn.userInteractionEnabled = NO;
       _subtraBtn.layer.borderColor = [[UIColor colorWithWhite:0.902 alpha:1.000] CGColor];
    [_subtraBtn setTitle:@"一" forState:UIControlStateNormal];
    [_subtraBtn setTitleColor:[UIColor colorWithWhite:0.584 alpha:1.000] forState:UIControlStateNormal];
    _subtraBtn.backgroundColor = [UIColor colorWithRed:0.976 green:0.965 blue:0.969 alpha:1.000];
    _subtraBtn.frame = CGRectMake(90, 50, 52, 40);
    _subtraBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_subtraBtn addTarget:self action:@selector(subAction:) forControlEvents:UIControlEventTouchUpInside];
    [djV addSubview:_subtraBtn];
    
    _plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _plusBtn.layer.cornerRadius = 10;
    _plusBtn.layer.borderWidth = 0.5f;
    _plusBtn.layer.borderColor = [[UIColor colorWithWhite:0.902 alpha:1.000] CGColor];
    [_plusBtn setTitle:@"+" forState:UIControlStateNormal];
    [_plusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _plusBtn.titleLabel.font  = [UIFont systemFontOfSize:22];
    _plusBtn.backgroundColor = [UIColor colorWithRed:0.243 green:0.553 blue:1.000 alpha:1.000];
    _plusBtn.frame = CGRectMake(207, 50, 51, 40);
    
    if ([_bfbTex.text isEqualToString:@"100%"]) {
        _plusBtn.userInteractionEnabled = YES;
    }else
    {
        _plusBtn.userInteractionEnabled = YES;
    }
    [_plusBtn addTarget:self action:@selector(plusAction:) forControlEvents:UIControlEventTouchUpInside];
    _plusBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [djV addSubview:_plusBtn];
    
    _bfbTex = [[UITextField alloc]initWithFrame:CGRectMake(134, 50, 80, 40)];
    _bfbTex.delegate = self;
    _bfbTex.textColor = [UIColor blackColor];
    _bfbTex.backgroundColor = [UIColor whiteColor];
    _bfbTex.layer.borderWidth = 0.5f;
    _bfbTex.layer.borderColor = [[UIColor colorWithWhite:0.902 alpha:1.000] CGColor];
    _bfbTex.textAlignment = NSTextAlignmentCenter;
    _bfbTex.font = [UIFont systemFontOfSize:14];
    _bfbTex.text = @"0%";
    _bfbTex.keyboardType = UIKeyboardTypeDecimalPad;
    [djV addSubview:_bfbTex];
    
    UILabel * zfmoneyLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 110, 50, 20)];
    zfmoneyLab.textAlignment = NSTextAlignmentLeft;
    zfmoneyLab.font = [UIFont systemFontOfSize:12];
    zfmoneyLab.textColor = [UIColor colorWithWhite:0.639 alpha:1.000];
    zfmoneyLab.text = @"支付定金";
    [djV addSubview:zfmoneyLab];

    _howMuchLab = [[UILabel alloc]initWithFrame:CGRectMake(90, 105, 168, 30)];
    _howMuchLab.textColor = [UIColor blackColor];
    _howMuchLab.font = [UIFont systemFontOfSize:18];
    _howMuchLab.textAlignment = NSTextAlignmentCenter;
    _howMuchLab.text = @"0.00";
    [djV addSubview:_howMuchLab];
    
    UILabel * textLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 160, SCREEN_WIDTH -40, size.height)];
    textLabel.backgroundColor = WhiteColor;
    textLabel.font = Size(24);
    textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    textLabel.numberOfLines = 0;
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.textColor = [UIColor colorWithWhite:0.522 alpha:1.000];
    textLabel.text =text;
    [djV addSubview:textLabel];
    
  
    UIButton * quxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quxBtn.backgroundColor = [UIColor colorWithRed:0.976 green:0.965 blue:0.969 alpha:1.000];
    [quxBtn setTitle:@"取消" forState:UIControlStateNormal];
    [quxBtn setTitleColor:[UIColor colorWithWhite:0.612 alpha:1.000] forState:UIControlStateNormal];
    quxBtn.frame = CGRectMake(0, djV.frame.size.height-42, SCREEN_WIDTH/2, 42);
    quxBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [djV addSubview:quxBtn];
    [quxBtn addTarget:self action:@selector(quxiaoAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * quedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quedBtn.backgroundColor = [UIColor colorWithRed:0.243 green:0.553 blue:1.000 alpha:1.000];
    [quedBtn setTitle:@"确定" forState:UIControlStateNormal];
    [quedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    quedBtn.frame = CGRectMake(SCREEN_WIDTH/2, djV.frame.size.height-42, SCREEN_WIDTH/2, 42);
    quedBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [quedBtn addTarget:self action:@selector(quedingAction) forControlEvents:UIControlEventTouchUpInside];
    [djV addSubview:quedBtn];
    _zfdjV.hidden = YES;
}
-(void)infoAction
{
    if ([_bfbTex.text isEqualToString:@"0"]||[_bfbTex.text isEqualToString:@""]) {
        
    }else{
    float bfb = [[_bfbTex.text stringByReplacingOccurrencesOfString:@"%" withString:@""] intValue]/100.0f;
    _howMuchLab.text = [NSString stringWithFormat:@"%.2f",bfb * [[_xiansDic objectForKey:@"cost"] floatValue]];
        _plusBtn.userInteractionEnabled = YES;
        _subtraBtn.userInteractionEnabled = YES;
        [_subtraBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _subtraBtn.backgroundColor = [UIColor colorWithRed:0.243 green:0.553 blue:1.000 alpha:1.000];
        [_plusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _plusBtn.backgroundColor = [UIColor colorWithRed:0.243 green:0.553 blue:1.000 alpha:1.000];
    }
    }
-(void)resposAction
{
    if ([_bfbTex isFirstResponder]) {
        [_bfbTex resignFirstResponder];
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self addNoti];
    textField.text = @"";
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text intValue]<100 &&[textField.text intValue] >0) {
        textField.text = [NSString stringWithFormat:@"%@%%",textField.text];
        _plusBtn.userInteractionEnabled = YES;
        _subtraBtn.userInteractionEnabled = YES;
        [_subtraBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _subtraBtn.backgroundColor = [UIColor colorWithRed:0.243 green:0.553 blue:1.000 alpha:1.000];
        [_plusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _plusBtn.backgroundColor = [UIColor colorWithRed:0.243 green:0.553 blue:1.000 alpha:1.000];
    }else
    {
        textField.text = @"0%";
        _subtraBtn.userInteractionEnabled = NO;
        [_subtraBtn setTitleColor:[UIColor colorWithWhite:0.584 alpha:1.000] forState:UIControlStateNormal];
        _subtraBtn.backgroundColor = [UIColor colorWithRed:0.976 green:0.965 blue:0.969 alpha:1.000];
        [_plusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _plusBtn.backgroundColor = [UIColor colorWithRed:0.243 green:0.553 blue:1.000 alpha:1.000];
        _plusBtn.userInteractionEnabled = YES;
        _howMuchLab.text = @"0.00";
    }
}

-(void)addNoti{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyBoardShow:(NSNotification *)sender{
    //     NSLog(@"sender=%@",sender);
    CGRect keyboard_bounds = [sender.userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    float keyboard_h = keyboard_bounds.size.height;
    float keyboard_y = SCREEN_HEIGHT-keyboard_h;
    //     NSLog(@"keyboard_y=%.2f",keyboard_y);
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    CGRect rect = [firstResponder convertRect:firstResponder.bounds toView:self.view];
    float field_maxy = CGRectGetMaxY(rect);
    //     NSLog(@"field_maxy=%.2f",field_maxy);
    
    float keyboard_hide = (field_maxy - keyboard_y)>0?field_maxy - keyboard_y:0;
    //     NSLog(@"keyboard_hide=%.2f",keyboard_hide);
    if (IPHONE_4_SCREEN) {
      self.view.transform=CGAffineTransformMakeTranslation(0, -keyboard_hide+72);
    }else{
    self.view.transform=CGAffineTransformMakeTranslation(0, -keyboard_hide+72);
    }
    
}
-(void)firstResponder
{
    
}
-(void)keyBoardHide:(NSNotificationCenter *)sender{
    
    self.view.transform = CGAffineTransformIdentity;
}

-(void)removeNoti{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)customJbV
{
    _jibaoV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64.5)];
    _jibaoV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    _jibaoV.hidden = YES;
    [_bottomScr addSubview:_jibaoV];
    
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
    _dangzhuV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    _dangzhuV.userInteractionEnabled = NO;
    _dangzhuV.hidden = YES;
    _dangzhuV.userInteractionEnabled = YES;
    UITapGestureRecognizer * meiyiyitap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidenAction)];
    [_dangzhuV addGestureRecognizer:meiyiyitap];
    [self.view addSubview:_dangzhuV];
}

-(void)jubaoAction:(UIButton *)sender
{
    [[XianSuoDetailInfo shareInstance]xsjbWithID:_xs_id andTitle:[_xiansDic objectForKey:@"title"] andType:sender.titleLabel.text andAuthorID:[_xiansDic objectForKey:@"brokerid"] andCallBack:^(BOOL issucced, NSString *info, NSDictionary *jsonDic) {
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
-(void)hidenAction
{
    _jibaoV.hidden = YES;
    _dangzhuV.hidden = YES;
}
-(void)dismissAction
{
    if ([_bfbTex isFirstResponder]) {
        [_bfbTex resignFirstResponder];
    }else{
    _zfdjV.hidden = YES;
    }
}
-(void)quxiaoAction
{
    _zfdjV.hidden = YES;
}
-(void)quedingAction
{
    if ([_howMuchLab.text isEqualToString:@"0.00"]) {
      
        [[ToolManager shareInstance] showAlertMessage:@"请支付一点定金"];
        return;
    }
    _zfdjV.hidden = YES;
    PayDingJinVC * payV = [[PayDingJinVC alloc]init];
    payV.jineStr = _howMuchLab.text;
    payV.zfymType = LingQuZhiFu;
    payV.xsID = [_xiansDic objectForKey:@"id"];
    payV.bfb = _bfbTex.text;
    [self.navigationController pushViewController:payV animated:YES];
}
-(void)subAction:(UIButton *)sender
{
    NSString * str =  [_bfbTex.text stringByReplacingOccurrencesOfString:@"%" withString:@""];
    if ([str intValue] -1<=0) {
        _subtraBtn.userInteractionEnabled = NO;
        [_subtraBtn setTitleColor:[UIColor colorWithWhite:0.584 alpha:1.000] forState:UIControlStateNormal];
        _subtraBtn.backgroundColor = [UIColor colorWithRed:0.976 green:0.965 blue:0.969 alpha:1.000];
        _plusBtn.userInteractionEnabled = YES;
        [_plusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _plusBtn.backgroundColor = [UIColor colorWithRed:0.243 green:0.553 blue:1.000 alpha:1.000];
        _bfbTex.text = [NSString stringWithFormat:@"%d%%",[str intValue]-1];
        
    }else
    {
        _bfbTex.text = [NSString stringWithFormat:@"%d%%",[str intValue]-1];
    }
    if ([str intValue] ==100) {
        _plusBtn.userInteractionEnabled = YES;
        [_plusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _plusBtn.backgroundColor = [UIColor colorWithRed:0.243 green:0.553 blue:1.000 alpha:1.000];
    }
    float bfb = [[_bfbTex.text stringByReplacingOccurrencesOfString:@"%" withString:@""] intValue]/100.0f;
    _howMuchLab.text = [NSString stringWithFormat:@"%.2f",bfb * [[_xiansDic objectForKey:@"cost"] floatValue]];
}
-(void)plusAction:(UIButton *)sender
{
    NSLog(@"加一下");
    NSString * str =  [_bfbTex.text stringByReplacingOccurrencesOfString:@"%" withString:@""];
    if ([str intValue] +1>=100) {
        _plusBtn.userInteractionEnabled = NO;
        [_plusBtn setTitleColor:[UIColor colorWithWhite:0.584 alpha:1.000] forState:UIControlStateNormal];
        _plusBtn.backgroundColor = [UIColor colorWithRed:0.976 green:0.965 blue:0.969 alpha:1.000];
        _subtraBtn.userInteractionEnabled = YES;
        [_subtraBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _subtraBtn.backgroundColor = [UIColor colorWithRed:0.243 green:0.553 blue:1.000 alpha:1.000];
        _bfbTex.text = [NSString stringWithFormat:@"%d%%",[str intValue]+1];
    }else
    {
        _bfbTex.text = [NSString stringWithFormat:@"%d%%",[str intValue]+1];
    }
    if ([str intValue] ==0) {
        _subtraBtn.userInteractionEnabled = YES;
        [_subtraBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _subtraBtn.backgroundColor = [UIColor colorWithRed:0.243 green:0.553 blue:1.000 alpha:1.000];
    }
    float bfb = [[_bfbTex.text stringByReplacingOccurrencesOfString:@"%" withString:@""] intValue]/100.0f;
    _howMuchLab.text = [NSString stringWithFormat:@"%.2f",bfb * [[_xiansDic objectForKey:@"cost"] floatValue]];

}
-(void)addButtomScro
{
    _bottomScr = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64.5, SCREEN_WIDTH, SCREEN_HEIGHT-64.5-42)];
    _bottomScr.backgroundColor = BACKCOLOR;
    _bottomScr.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*2);
    _bottomScr.showsVerticalScrollIndicator = NO;
    _bottomScr.userInteractionEnabled = YES;
    [self.view addSubview:_bottomScr];
    [self addTheTouXiangV];
    [self addTheXsV];
}
-(void)addTheTouXiangV
{
    _txV = [[UIView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 61)];
    _txV.backgroundColor = [UIColor whiteColor];
    [_bottomScr addSubview:_txV];
    UIImageView * headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 41, 41)];
    headImg.contentMode = UIViewContentModeScaleAspectFill;
    headImg.userInteractionEnabled = YES;
    NSString * imgUrl;
    if ([[_xiansDic objectForKey:@"imgurl"] rangeOfString:@"http"].location != NSNotFound) {
        imgUrl = [_xiansDic objectForKey:@"imgurl"];
    }else{
        imgUrl = [NSString stringWithFormat:@"%@%@",IMG_URL,[_xiansDic objectForKey:@"imgurl"]];
    }


    [[ToolManager shareInstance] imageView:headImg setImageWithURL:imgUrl placeholderType:PlaceholderTypeUserHead];
    [_txV addSubview:headImg];
    UITapGestureRecognizer * txTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touxiangAction)];
    txTap.numberOfTouchesRequired = 1;
    txTap.numberOfTapsRequired = 1;
    [headImg addGestureRecognizer:txTap];
    
    UILabel * userNameLab = [[UILabel alloc]initWithFrame:CGRectMake(headImg.frame.origin.x+headImg.frame.size.width+10, 7, 55, 25)];
    userNameLab.font = [UIFont systemFontOfSize:15];
    userNameLab.textColor = [UIColor blackColor];
    userNameLab.text =[_xiansDic objectForKey:@"realname"];
    userNameLab.textAlignment = NSTextAlignmentLeft;
    [_txV addSubview:userNameLab];
    
    UIImageView * posImg = [[UIImageView alloc]initWithFrame:CGRectMake(userNameLab.frame.origin.x, 37, 11, 11)];
    posImg.image = [UIImage imageNamed:@"dizhi"];
    [_txV addSubview:posImg];
    
    _positionLab = [[UILabel alloc]initWithFrame:CGRectMake(userNameLab.frame.origin.x+16, 37, 80, 11)];
    _positionLab.font = [UIFont systemFontOfSize:12];
    _positionLab.textColor = [UIColor colorWithWhite:0.514 alpha:1.000];
    _positionLab.textAlignment = NSTextAlignmentLeft;
    _positionLab.text = [_xiansDic objectForKey:@"area"];
    [_txV addSubview:_positionLab];
    
    UIImageView * renzhImg = [[UIImageView alloc]initWithFrame:CGRectMake(userNameLab.frame.origin.x+userNameLab.frame.size.width, 13, 14, 14)];
    renzhImg.image = [[_xiansDic objectForKey:@"authen"] intValue]==3?[UIImage imageNamed:@"renzhen"]:[UIImage imageNamed:@"weirenzhen"];
    [_txV addSubview:renzhImg];

    UILabel * timeLab = [[UILabel alloc]initWithFrame:CGRectMake(_txV.frame.size.width-160, 7, 150, 20)];
    timeLab.backgroundColor = [UIColor clearColor];
    timeLab.font = [UIFont systemFontOfSize:13];
    timeLab.textColor = [UIColor colorWithWhite:0.514 alpha:1.000];
    timeLab.textAlignment = NSTextAlignmentRight;
    NSString * timStr = [_xiansDic objectForKey:@"createtime"];
    NSTimeInterval time=[timStr doubleValue];
    NSDate *data = [NSDate dateWithTimeIntervalSince1970:time];
    timeLab.text = [self getDateStringWithDate:data DateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * sjcStr = [self intervalSinceNow:timeLab.text];
    if ([sjcStr integerValue] <=60) {
        timeLab.text = @"刚刚";
    }else if ([sjcStr integerValue]<=3600)
    {
        timeLab.text = [NSString stringWithFormat:@"%ld分钟前",[sjcStr integerValue]/60];
    }else if ([sjcStr integerValue]<=60*60*24)
    {
        timeLab.text = [NSString stringWithFormat:@"%ld小时前",[sjcStr integerValue]/(60*60)];
    }else if ([sjcStr integerValue]<=60*60*24*3)
    {
        timeLab.text = [NSString stringWithFormat:@"%ld天前",[sjcStr integerValue]/(60*60*24)];
    }else
    {
        timeLab.text = [self getDateStringWithDate:data DateFormat:@"MM-dd HH:mm"];
    }
    


    [_txV addSubview:timeLab];
    [self addTheDuiHuaV:_txV.frame.origin.y+_txV.frame.size.height];
}
-(void)touxiangAction
{
    JJRDetailVC * jjrV = allocAndInit(JJRDetailVC);
    jjrV.jjrID  = [_xiansDic objectForKey:@"brokerid"];
    [self.navigationController pushViewController:jjrV animated:YES];
    

}
-(void)addTheDuiHuaV:(CGFloat)orgY
{
    _duihuaV = [[UIView alloc]initWithFrame:CGRectMake(10, orgY, SCREEN_WIDTH-20, 36)];
    _duihuaV.backgroundColor = [UIColor colorWithRed:0.976 green:0.965 blue:0.969 alpha:1.000];
    [_bottomScr addSubview:_duihuaV];
    UIButton * duihuaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    duihuaBtn.frame = CGRectMake((_duihuaV.frame.size.width-150)/2, 5, 150, 31);
    duihuaBtn.backgroundColor = [UIColor clearColor];
    [duihuaBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [duihuaBtn setImage:[UIImage imageNamed:@"liantianzhuse"] forState:UIControlStateNormal];
    [duihuaBtn setTitle:@"跟Ta对话" forState:UIControlStateNormal];
    [duihuaBtn setTitleColor:[UIColor colorWithRed:0.290 green:0.569 blue:0.973 alpha:1.000]forState:UIControlStateNormal];
      [duihuaBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [duihuaBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [duihuaBtn addTarget: self action:@selector(duihuaAction) forControlEvents:UIControlEventTouchUpInside];
    [_duihuaV addSubview:duihuaBtn];
}
#pragma mark 线索View
-(void)addTheXsV
{
    _xsDetailV = [[UIView alloc]initWithFrame:CGRectMake(10, 181-64, SCREEN_WIDTH-20, 0)];
    _xsDetailV.backgroundColor = [UIColor whiteColor];
    [_bottomScr addSubview:_xsDetailV];
    
    UILabel * titLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, _xsDetailV.frame.size.width, 30)];//标题lab
    titLab.font = [UIFont systemFontOfSize:16];
    titLab.textColor = [UIColor blackColor];
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.text = [_xiansDic objectForKey:@"title"];
    [_xsDetailV addSubview:titLab];
    

    
    UILabel * detailLab = [[UILabel alloc]initWithFrame:CGRectMake(3, 45, _xsDetailV.frame.size.width-6, 60)];//内容lab
    detailLab.textColor = [UIColor colorWithWhite:0.502 alpha:1.000];
    detailLab.textAlignment = NSTextAlignmentCenter;
    detailLab.userInteractionEnabled = NO;
    detailLab.font = [UIFont systemFontOfSize:13];
    detailLab.numberOfLines = 0;
    detailLab.text = [_xiansDic objectForKey:@"content"];
    CGSize detailLabsize = [detailLab sizeWithMultiLineContent:detailLab.text rowWidth:frameWidth(detailLab) font:detailLab.font];
    detailLab.lineBreakMode = NSLineBreakByTruncatingTail;
    detailLab.frame = frame(frameX(detailLab), frameY(detailLab), frameWidth(detailLab), detailLabsize.height + 10);
    
    [_xsDetailV addSubview:detailLab];
    
    
    float soundImgH = CGRectGetMaxY(detailLab.frame);
    if (_xiansDic[@"audios"]&&![_xiansDic[@"audios"] isEqualToString:@""]) {
       UIImageView *soundImg=[[UIImageView alloc]init];//语音button
        UIImage *image = [UIImage imageNamed:@"bofangyuyuying3"];
        soundImg.frame=CGRectMake((frameWidth(_xsDetailV) - image.size.width*1.7)/2.0,soundImgH, image.size.width*1.7,  image.size.height*1.7);
        soundImg.image=image;
        soundImg.animationImages = @[[UIImage imageNamed:@"bofangyuyuying1"],[UIImage imageNamed:@"bofangyuyuying2"],[UIImage imageNamed:@"bofangyuyuying3"]];
        soundImg.animationDuration = 1.5;
        soundImg.animationRepeatCount = 0;
        soundImg.tag=1110;
        
        UITapGestureRecognizer *oneTap=[[UITapGestureRecognizer alloc]init];
        [oneTap addTarget:self action:@selector(soundBtnClicked:)];
        soundImg.userInteractionEnabled=YES;
        [soundImg addGestureRecognizer:oneTap];
        [_xsDetailV addSubview:soundImg];
        
        _url=[NSString stringWithFormat:@"%@%@",ImageURLS,_xiansDic[@"audios"]];
        
        soundImgH = CGRectGetMaxY(soundImg.frame);
    }

    
    UIView * sxV = [[UIView alloc]initWithFrame:CGRectMake(10,soundImgH , _xsDetailV.frame.size.width-20, 1)];
    sxV.backgroundColor = [UIColor colorWithRed:0.925 green:0.925 blue:0.929 alpha:1.000];
    [_xsDetailV addSubview:sxV];
    
    float height = CGRectGetMaxY(sxV.frame);
    if ([_xiansDic objectForKey:@"remark_cus"]&&![[_xiansDic objectForKey:@"remark_cus"] isEqualToString:@""]) {
        
        UILabel * detailLabdec = [[UILabel alloc]initWithFrame:CGRectMake(3,height, _xsDetailV.frame.size.width-6, 60)];
        detailLabdec.textColor = [UIColor colorWithWhite:0.502 alpha:1.000];
        detailLabdec.textAlignment = NSTextAlignmentCenter;
        detailLabdec.userInteractionEnabled = NO;
        detailLabdec.font = [UIFont systemFontOfSize:13];
        detailLabdec.numberOfLines = 0;
        detailLabdec.text = [_xiansDic objectForKey:@"remark_cus"];
        CGSize detailLabdecsize = [detailLabdec sizeWithMultiLineContent:detailLabdec.text rowWidth:frameWidth(detailLabdec) font:detailLabdec.font];
        detailLabdec.lineBreakMode = NSLineBreakByTruncatingTail;
        detailLabdec.frame = frame(frameX(detailLabdec), frameY(detailLabdec), frameWidth(detailLabdec), detailLabdecsize.height + 20);
        
        [_xsDetailV addSubview:detailLabdec];
        
        UIView * sxVdec = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(detailLabdec.frame), _xsDetailV.frame.size.width-20, 1)];
        sxVdec.backgroundColor = [UIColor colorWithRed:0.925 green:0.925 blue:0.929 alpha:1.000];
        [_xsDetailV addSubview:sxVdec];

        height = CGRectGetMaxY(sxVdec.frame);
    }
    
    
    UILabel * qwLab = [[UILabel alloc]initWithFrame:CGRectMake(10, height, 130, 30)];
    NSString * qwStr = @"成交报酬:";
    NSString * moneyStr = [NSString stringWithFormat:@" %@",[_xiansDic objectForKey:@"cost"]];
    NSString * qwbcStr = [qwStr stringByAppendingString:moneyStr];
    NSMutableAttributedString * qwbcAtr = [[NSMutableAttributedString alloc]initWithString:qwbcStr];
    [qwbcAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.514 alpha:1.000] range:NSMakeRange(0, [qwStr length])];
    [qwbcAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1.000 green:0.518 blue:0.224 alpha:1.000] range:NSMakeRange([qwStr length], [moneyStr length])];
    [qwbcAtr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, [qwStr length])];
    [qwbcAtr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange([qwStr length], [moneyStr length])];
    qwLab.attributedText = qwbcAtr;
    [_xsDetailV addSubview:qwLab];
    
    UILabel * xqLab = [[UILabel alloc]initWithFrame:CGRectMake(_xsDetailV.frame.size.width-95, frameY(qwLab), 85, 30)];
    [xqLab setTextAlignment:NSTextAlignmentRight];
    NSString * xqStr = @"需求强度:";
    NSString * qdStr;
    if ([[_xiansDic objectForKey:@"confidence_n"] intValue]==3) {
        qdStr = @" 很强";
    }else if ([[_xiansDic objectForKey:@"confidence_n"] intValue]==2)
    {
        qdStr = @" 强";
    }else
    {
        qdStr = @" 一般";
    }
    NSString * xqqdStr = [xqStr stringByAppendingString:qdStr];
    NSMutableAttributedString * xqqdAtr = [[NSMutableAttributedString alloc]initWithString:xqqdStr];
    [xqqdAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.514 alpha:1.000] range:NSMakeRange(0, [xqStr length])];
    [xqqdAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1.000 green:0.518 blue:0.224 alpha:1.000] range:NSMakeRange([xqStr length], [qdStr length])];
    [xqqdAtr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, [xqStr length])];
    [xqqdAtr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange([xqStr length], [qdStr length])];
    xqLab.attributedText = xqqdAtr;
    [_xsDetailV addSubview:xqLab];
    _xsDetailV.frame = frame(frameX(_xsDetailV), frameY(_xsDetailV), frameWidth(_xsDetailV), CGRectGetMaxY(xqLab.frame));
    [self addTheLQV:_xsDetailV.frame.size.height+_xsDetailV.frame.origin.y+10];
}
-(void)addTheLQV:(CGFloat)orgY
{
    _lqLab = [[UILabel alloc]initWithFrame:CGRectMake(10, orgY, (SCREEN_WIDTH-20)/2, 25)];
    _lqLab.backgroundColor = [UIColor whiteColor];
    _lqLab.textAlignment = NSTextAlignmentLeft;
    _lqLab.font =[UIFont systemFontOfSize:13];
    _lqLab.userInteractionEnabled = YES;
    NSString * str1 = [NSString stringWithFormat:@"   %@人领取",[_xiansDic objectForKey:@"coopnum"]];
    NSString * str2;
    if ([[_xiansDic objectForKey:@"isconfirm"]intValue] == 1) {
        str2 = @"(已选)";
    }else{
    str2 = @"(未选)";
    }
    NSString * lqStr = [str1 stringByAppendingString:str2];
    NSMutableAttributedString * lqAtr = [[NSMutableAttributedString alloc]initWithString:lqStr];
    [lqAtr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, [lqStr length])];
    [lqAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.169 alpha:1.000] range:NSMakeRange(0, [str1 length])];
    if ([[_xiansDic objectForKey:@"isconfirm"]intValue] == 1) {
    [lqAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.984 green:0.435 blue:0.176 alpha:1.000] range:NSMakeRange([str1 length], [str2 length])];

    }else{
    [lqAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.608 alpha:1.000] range:NSMakeRange([str1 length], [str2 length])];
    }
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lqrAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    _lqLab.attributedText = lqAtr;
    [_lqLab addGestureRecognizer:tap];
    [_bottomScr addSubview:_lqLab];
   
    UILabel * plLab = [[UILabel alloc]initWithFrame:CGRectMake(10+(SCREEN_WIDTH-20)/2, orgY, (SCREEN_WIDTH-20)/2, 25)];
    plLab.backgroundColor = [UIColor clearColor];
    plLab.textAlignment = NSTextAlignmentRight;
    plLab.font =[UIFont systemFontOfSize:13];
    plLab.userInteractionEnabled = YES;
    NSString * str3 = [NSString stringWithFormat:@"线索评论"];
    NSString * str4 = [NSString stringWithFormat:@"(%@)",[_xiansDic objectForKey:@"commentnum"]];
    NSString * plStr = [str3 stringByAppendingString:str4];
    NSMutableAttributedString * plAtr = [[NSMutableAttributedString alloc]initWithString:plStr];
    [plAtr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, [plStr length])];
    [plAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.169 alpha:1.000] range:NSMakeRange(0, [str3 length])];
    
    [plAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.984 green:0.435 blue:0.176 alpha:1.000] range:NSMakeRange([str3 length], [str4 length])];
        
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(plAction:)];
    tap2.numberOfTapsRequired = 1;
    tap2.numberOfTouchesRequired = 1;
    [plLab addGestureRecognizer:tap2];
    plLab.attributedText = plAtr;
    [_bottomScr addSubview:plLab];

    [self addTheLQTab:orgY+25+1];
}
-(void)plAction:(UIGestureRecognizer *)sender
{
    ClueCommunityViewController * comuniV = [[ClueCommunityViewController alloc]init];
    comuniV.clueID = [_xiansDic objectForKey:@"id"];
    [self.navigationController pushViewController:comuniV animated:YES];
}
-(void)lqrAction:(UITapGestureRecognizer *)sender
{
    LinQuRenVC * lqV = [[LinQuRenVC alloc]init];
    lqV.xiansID = [_xiansDic objectForKey:@"id"];
    [self.navigationController pushViewController:lqV animated:YES];
}
-(void)addTheLQTab:(CGFloat)orgY
{
    _lqTab = [[UITableView alloc]initWithFrame:CGRectMake(10, orgY, SCREEN_WIDTH-20, 61*_coopArr.count) style:UITableViewStylePlain];
    _lqTab.delegate = self;
    _lqTab.dataSource = self;
    _lqTab.scrollEnabled = NO;
    _lqTab.tableFooterView = [[UIView alloc]init];
    _lqTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_bottomScr addSubview:_lqTab];
    _lqLab.backgroundColor = [UIColor clearColor];
    [_bottomScr setContentSize:CGSizeMake(SCREEN_WIDTH, orgY + 61*_coopArr.count)];
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _coopArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"linquCell";
    LinQuCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[LinQuCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 61)];
        NSString * imgUrl;
        if ([[_coopArr[indexPath.row]objectForKey:@"imgurl"] rangeOfString:@"http"].location != NSNotFound) {
            imgUrl = [_coopArr[indexPath.row] objectForKey:@"imgurl"];
        }else{
            imgUrl = [NSString stringWithFormat:@"%@%@",IMG_URL,[_coopArr[indexPath.row]objectForKey:@"imgurl"]];
        }
        cell.renzhImg.image = [[_coopArr[indexPath.row]objectForKey:@"authen"] intValue]==3?[UIImage imageNamed:@"renzhen"]:[UIImage imageNamed:@"weirenzhen"];
       [[ToolManager shareInstance] imageView:cell.headImg setImageWithURL:imgUrl placeholderType:PlaceholderTypeUserHead];
        cell.headImg.tag = 200+indexPath.row;
        cell.headImg.userInteractionEnabled = YES;
        if ([[_coopArr[indexPath.row] objectForKey:@"selected"] intValue] == 1) {
            UIImageView * xzImg = [[UIImageView alloc]initWithFrame:CGRectMake(51-15, 10, 15, 15)];
            xzImg.image = [UIImage imageNamed:@"xuanzhong"];
            [cell addSubview:xzImg];
        }

        UITapGestureRecognizer * txTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(txTapAction:)];
        txTap.numberOfTouchesRequired = 1;
        txTap.numberOfTapsRequired = 1;
        [cell.headImg addGestureRecognizer:txTap];
        cell.userNameLab.text = [_coopArr[indexPath.row]objectForKey:@"realname"];
        NSString * str1 = @"定金:";
        NSString * str2 = [_coopArr[indexPath.row]objectForKey:@"deposit"];
        NSString * djStr = [str1 stringByAppendingString:str2];
        NSMutableAttributedString * djAtr = [[NSMutableAttributedString alloc]initWithString:djStr];
        [djAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.545 green:0.549 blue:0.557 alpha:1.000] range:NSMakeRange(0, [str1 length])];
        [djAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.353 green:0.608 blue:0.992 alpha:1.000] range:NSMakeRange([str1 length], [str2 length])];
        [djAtr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, [djStr length])];
        cell.dingjLab.attributedText = djAtr;
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
        }else
        {
            cell.timeLab.text = [self getDateStringWithDate:data DateFormat:@"MM-dd HH:mm"];
        }

        }
    return cell;
}
-(void)txTapAction:(UITapGestureRecognizer *)sender
{
    
    JJRDetailVC* jjrV =  [[JJRDetailVC alloc]init];
    jjrV.jjrID = [_coopArr[sender.view.tag - 200] objectForKey:@"id"];
    
    PushView(self, jjrV);
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}
-(void)duihuaAction
{
    CommunicationViewController * comunV = [[CommunicationViewController alloc]init];
    comunV.senderid = [_xiansDic objectForKey:@"brokerid"];
    comunV.chatType = ChatMessageTpye;
    [self.navigationController pushViewController:comunV animated:YES];
}
-(void)setNav
{
    self.automaticallyAdjustsScrollViewInsets = NO;
   
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
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(SCREEN_WIDTH-50, 30, 50, 24);
    [_rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_rightBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    [_rightBtn setTitle:@"举报" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [navView addSubview:_rightBtn];
    
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
-(void)addTheTwoBtn
{
    _linqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _linqBtn.frame = CGRectMake(0, SCREEN_HEIGHT-42, SCREEN_WIDTH, 42);
    _linqBtn.backgroundColor = [UIColor colorWithRed:0.239 green:0.549 blue:1.000 alpha:1.000];
    [_linqBtn setTitle:@"领取" forState:UIControlStateNormal];
    [_linqBtn setTitle:@"已领取" forState:UIControlStateSelected];
    [_linqBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_linqBtn setTitleColor:[UIColor colorWithRed:0.741 green:0.745 blue:0.753 alpha:1.000] forState:UIControlStateSelected];
    _linqBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_linqBtn addTarget:self action:@selector(linqAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_linqBtn];
    _lqhxV = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-42, SCREEN_WIDTH, 0.5)];
    _lqhxV.backgroundColor = [UIColor colorWithRed:0.867 green:0.875 blue:0.878 alpha:1.000];
    [self.view addSubview:_lqhxV];
}

#pragma mark - 语音点击按钮
-(void)soundBtnClicked:(UIGestureRecognizer *)sender
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


-(void)linqAction:(UIButton *)sender
{
    //增加判断是否发布过线索
    if ([[_xiansDic objectForKey:@"isAlert"] intValue]==1) {
        
        [[ToolManager shareInstance] showAlertViewTitle:@"提示" contentText:[_xiansDic objectForKey:@"alertContent"] showAlertViewBlcok:^{
            
            if ([[_xiansDic objectForKey:@"isredirect"] intValue]==1) {
                
                PushView(self, allocAndInit(AuthenticationViewController));
            }
            
        }];
        
        return;
    }
    
    if ([[_xiansDic objectForKey:@"isconfirm"]intValue] == 1) {
        [[ToolManager shareInstance]showAlertMessage:@"已被选中"];
        return;
    }
    _zfdjV.hidden = NO;
 
}
-(void)rightAction
{
    _jibaoV.hidden = !_jibaoV.hidden;
    _dangzhuV.hidden = !_dangzhuV.hidden;
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
