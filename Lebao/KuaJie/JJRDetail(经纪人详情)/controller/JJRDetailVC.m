//
//  JJRDetailVC.m
//  KuaJie
//
//  Created by 严文斌 on 16/5/16.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import "JJRDetailVC.h"
#import "MoreFuwuVC.h"
#import "MoreXianSuoVC.h"
#import "JJRDetailInfo.h"
#import "ToolManager.h"
#import "HomeInfo.h"
#import "CommunicationViewController.h"

#import "LWImageBrowser.h"
//产品
#import "MyContentDetailViewController.h"
#import "MyProductDetailViewController.h"
#import "TheSecondaryHouseViewController.h"
#import "TheSecondCarHomeViewController.h"
#import "WetChatShareManager.h"

#import "MyLQDetailVC.h"
#import "MyXSDetailVC.h"
#import "NSString+Extend.h"

#import "OtherDynamicdViewController.h"
@interface JJRDetailVC ()
{
    UIScrollView * bottomScr;
    UIView * biaoQianV;
    UIButton * guanzhuBtn;
    UIButton * duihuaBtn;
    UIView  * twoBtnsxV;
    
    NSDictionary *fuwuDic;
    UIImageView *fuwuImg;
}
@property (strong,nonatomic)NSMutableArray * gdxsArr;
@property (strong,nonatomic)NSMutableArray * gdfwArr;
@property (strong,nonatomic)NSDictionary * jjrJsonDic;
@property (strong,nonatomic)NSDictionary * jjrDic;
@end
@implementation JJRDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _gdfwArr = [[NSMutableArray alloc]init];
    _gdxsArr = [[NSMutableArray alloc]init];
    self.view.backgroundColor = BACKCOLOR;
    [self addButtomScro];
    [self addTheTwoBtn];
    [self setNav];
    [self getJson];
    // Do any additional setup after loading the view from its nib.
}
-(void)getJson
{
    [[JJRDetailInfo shareInstance]getJJRDetailWithJjrId:_jjrID andCallBack:^(BOOL issucced, NSString *info, NSDictionary *jsonDic) {
        if (issucced == YES) {
            _jjrDic = jsonDic;
            for (NSDictionary * dic in [[jsonDic objectForKey:@"datas"] objectForKey:@"clue"]) {
                [_gdxsArr addObject:dic];
            }
            for (NSDictionary * dic in [[jsonDic objectForKey:@"datas"] objectForKey:@"server"]) {
                [_gdfwArr addObject:dic];
            }
            _jjrJsonDic = [NSDictionary dictionaryWithDictionary:[jsonDic objectForKey:@"userinfo"]];
            if ([[_jjrJsonDic objectForKey:@"isself"]intValue] == 1) {
                guanzhuBtn.hidden = YES;
                duihuaBtn.hidden = YES;
                twoBtnsxV.hidden = YES;
                bottomScr.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            }
            if ([[_jjrJsonDic objectForKey:@"isfollow"]intValue ]==1) {
                guanzhuBtn.backgroundColor =  [UIColor whiteColor];
                guanzhuBtn.selected = YES;
                
                
            }else
            {
                guanzhuBtn.backgroundColor =  [UIColor colorWithRed:0.239 green:0.549 blue:1.000 alpha:1.000];
                guanzhuBtn.selected = NO;
            }
             [self customXQview];
        }else
        {
            [[ToolManager shareInstance]showAlertMessage:info];
        }
    }];
}
-(void)addTheTwoBtn
{
    guanzhuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    guanzhuBtn.frame = CGRectMake(0, SCREEN_HEIGHT-42, SCREEN_WIDTH/2, 42);
    guanzhuBtn.backgroundColor = [UIColor colorWithRed:0.239 green:0.549 blue:1.000 alpha:1.000];
    [guanzhuBtn setTitle:@"关注Ta" forState:UIControlStateNormal];
    [guanzhuBtn setTitle:@"已关注Ta" forState:UIControlStateSelected];
    [guanzhuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [guanzhuBtn setTitleColor:[UIColor colorWithRed:0.263 green:0.569 blue:0.988 alpha:1.000] forState:UIControlStateSelected];
    guanzhuBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [guanzhuBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [guanzhuBtn setImage:[UIImage imageNamed:@"guanztada"] forState:UIControlStateNormal];
    [guanzhuBtn setImage:[UIImage imageNamed:@"yiguanzda"] forState:UIControlStateSelected];
    [guanzhuBtn addTarget:self action:@selector(guanzhuAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:guanzhuBtn];
    
    duihuaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    duihuaBtn.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-42, SCREEN_WIDTH/2, 42);
    duihuaBtn.backgroundColor = [UIColor colorWithRed:0.239 green:0.549 blue:1.000 alpha:1.000];
    [duihuaBtn setTitle:@"跟Ta对话" forState:UIControlStateNormal];
    [duihuaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    duihuaBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [duihuaBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [duihuaBtn setImage:[UIImage imageNamed:@"liantian"] forState:UIControlStateNormal];
    [duihuaBtn addTarget:self action:@selector(duihuaAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:duihuaBtn];
    twoBtnsxV = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-35, 1, 28)];
    twoBtnsxV.backgroundColor = [UIColor colorWithRed:0.380 green:0.627 blue:0.996 alpha:1.000];
    [self.view addSubview:twoBtnsxV];
}
-(void)guanzhuAction:(UIButton *)sender
{
    NSString * target_id = _jjrID;
    //isfollow:1代表取消关注,0代表关注
    int isfollow;
    if (sender.selected == YES) {
        isfollow = 1;
    }else
    {
        isfollow = 0;
    }
    [[HomeInfo shareInstance]guanzhuTargetID:[target_id intValue] andIsFollow:isfollow andcallBack:^(BOOL issucced, NSString *info, NSDictionary *jsonArr) {
        if (issucced == YES) {
            sender.selected = !sender.selected;
            if (sender.selected == YES) {
                sender.backgroundColor= [UIColor whiteColor];
            }else
            {
                 sender.backgroundColor= [UIColor colorWithRed:0.239 green:0.549 blue:1.000 alpha:1.000];
            }
        }else
        {
            HUDText(info);
        }
        
    }];
}
-(void)duihuaAction
{
    CommunicationViewController * comunV = [[CommunicationViewController alloc]init];
    comunV.senderid = [_jjrJsonDic objectForKey:@"id"];
    comunV.chatType = ChatMessageTpye;
    [self.navigationController pushViewController:comunV animated:YES];
  
}
-(void)addButtomScro
{
    bottomScr = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-42)];
    bottomScr.backgroundColor = BACKCOLOR;
    bottomScr.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*2);
    bottomScr.showsVerticalScrollIndicator = NO;
    bottomScr.userInteractionEnabled = YES;
    [self.view addSubview:bottomScr];
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
    titLab.text = @"经纪人详情";
    titLab.font = [UIFont systemFontOfSize:16];
    [navView addSubview:titLab];
}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)customXQview
{
    UIView * xqV  = [[UIView alloc]initWithFrame:CGRectMake(10, 74, SCREEN_WIDTH-20, 248)];
    xqV.backgroundColor = [UIColor whiteColor];
    [bottomScr addSubview:xqV];
    [self addTxBtn:xqV];
    [self addTheRoundView:xqV];
    [self adddongtaiV:xqV];
    [self addJianJieV:xqV];
    [self addBiaoQianV:xqV];
    
    [self addTheXsView:CGRectGetMaxY(xqV.frame) + 10];
}
-(void)addTxBtn:(UIView *)sender//头像那一栏
{
    UIImageView * headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 41, 41)];
    NSString * imgUrl =[_jjrJsonDic objectForKey:@"imgurl"];
//    NSLog(@"_jjrJsonDic =%@",_jjrJsonDic);
    
    [[ToolManager shareInstance]imageView:headImg setImageWithURL:imgUrl placeholderType:PlaceholderTypeUserHead];
    UIGestureRecognizer *TapOneGr=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapOne:)];
    [headImg addGestureRecognizer:TapOneGr];
    headImg.userInteractionEnabled=YES;

    [sender addSubview:headImg];
  
    UILabel * userNameLab = [[UILabel alloc]initWithFrame:CGRectMake(headImg.frame.origin.x+headImg.frame.size.width+10, 7, 55, 25)];
    userNameLab.text = [_jjrJsonDic objectForKey:@"realname"];
    userNameLab.font = [UIFont systemFontOfSize:15];
    userNameLab.textColor = [UIColor blackColor];
    userNameLab.textAlignment = NSTextAlignmentLeft;
    [sender addSubview:userNameLab];

    UIImageView * renzhImg = [[UIImageView alloc]initWithFrame:CGRectMake(userNameLab.frame.origin.x+userNameLab.frame.size.width, 13, 14, 14)];
    renzhImg.image = [[_jjrJsonDic objectForKey:@"authen"]intValue]==3?[UIImage imageNamed:@"renzhen"]:[UIImage imageNamed:@"weirenzhen"];
    [sender addSubview:renzhImg];

    UIImageView * posImg = [[UIImageView alloc]initWithFrame:CGRectMake(userNameLab.frame.origin.x, 37, 11, 11)];
    posImg.image = [UIImage imageNamed:@"dizhi"];
    [sender addSubview:posImg];
    
    UILabel * positionLab = [[UILabel alloc]initWithFrame:CGRectMake(userNameLab.frame.origin.x+16, 37, 89, 11)];
    positionLab.text = [_jjrJsonDic objectForKey:@"area"];
    positionLab.font = [UIFont systemFontOfSize:12];
    positionLab.textColor = [UIColor colorWithWhite:0.514 alpha:1.000];
    positionLab.textAlignment = NSTextAlignmentLeft;
    [sender addSubview:positionLab];
    
    UILabel * baoxLab = [[UILabel alloc]initWithFrame:CGRectMake(sender.frame.size.width-70, 7, 60, 20)];
    if ([[_jjrJsonDic objectForKey:@"industry"] isEqualToString:BAOXIAN]) {
        baoxLab.text = @"保险";
    }else if ([[_jjrJsonDic objectForKey:@"industry"] isEqualToString:JINRONG])
    {
        baoxLab.text = @"金融";
    }else if ([[_jjrJsonDic objectForKey:@"industry"] isEqualToString:FANGCHANG])
    {
        baoxLab.text = @"房产";
    }else if ([[_jjrJsonDic objectForKey:@"industry"] isEqualToString:CHEHANG])
    {
        baoxLab.text = @"车行";
    }
    baoxLab.backgroundColor = [UIColor clearColor];
    baoxLab.font = [UIFont systemFontOfSize:13];
    baoxLab.textColor = [UIColor colorWithWhite:0.514 alpha:1.000];
    baoxLab.textAlignment = NSTextAlignmentRight;
    [sender addSubview:baoxLab];

    UILabel * nianxLab = [[UILabel alloc]initWithFrame:CGRectMake(sender.frame.size.width-130, 31.5, 120, 20)];
    nianxLab.text = [NSString stringWithFormat:@"从业年限:%@年",[_jjrJsonDic objectForKey:@"workyears"]];
    nianxLab.backgroundColor = [UIColor clearColor];
    nianxLab.textAlignment = NSTextAlignmentRight;
    nianxLab.font = [UIFont systemFontOfSize:12];
    nianxLab.textColor = [UIColor colorWithWhite:0.514 alpha:1.000];
    [sender addSubview:nianxLab];
    
    UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(10, 60, sender.frame.size.width-20, 1)];
    hxV.backgroundColor = BACKCOLOR;
    [sender addSubview:hxV];
    
}
-(void)addTheRoundView:(UIView *)sender //发布领取满意度
{
    UIView * gRuondV = [[UIView alloc]initWithFrame:CGRectMake(0, 61, sender.frame.size.width, 70)];
    gRuondV.backgroundColor = [UIColor clearColor];
    [sender addSubview:gRuondV];
    CGFloat width = (sender.frame.size.width-230)/3;
    [gRuondV addSubview:[self customViewWithFrame:CGRectMake(15, 10, 50, 50) andTitle:@"发布" andNumb:[_jjrJsonDic objectForKey:@"demandnum" ]]];
    [gRuondV addSubview:[self customViewWithFrame:CGRectMake(65+width, 10, 50, 50) andTitle:@"领取" andNumb:[_jjrJsonDic objectForKey:@"receivenum" ]]];
    [gRuondV addSubview:[self customViewWithFrame:CGRectMake(115+width*2, 10, 50, 50) andTitle:@"满意度" andNumb:[_jjrJsonDic objectForKey:@"regrade" ]]];
    [gRuondV addSubview:[self customViewWithFrame:CGRectMake(165+width*3, 10, 50, 50) andTitle:@"粉丝" andNumb:[_jjrJsonDic objectForKey:@"fansnum" ]]];
    
    UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(10, 69, gRuondV.frame.size.width-20, 1)];
    hxV.backgroundColor = BACKCOLOR;
    [gRuondV addSubview:hxV];
}


-(void)adddongtaiV:(UIView *)sender
{
    UIView * dongtaiV = [[UIView alloc]initWithFrame:CGRectMake(0, 131, sender.frame.size.width, 40)];
    dongtaiV.backgroundColor = [UIColor clearColor];
    [sender addSubview:dongtaiV];
    
    UILabel * dongtaiLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 75, 40)];
    dongtaiLab.textColor = [UIColor colorWithRed:0.584 green:0.584 blue:0.596 alpha:1.000];
    dongtaiLab.textAlignment = NSTextAlignmentLeft;
    dongtaiLab.text = @"他的动态";
    dongtaiLab.font = [UIFont systemFontOfSize:12];
    [dongtaiV addSubview:dongtaiLab];
    
    UIImage *lookMoreimage = [UIImage imageNamed:@"jjr_gengduo"];
    NSString *str = [NSString stringWithFormat:@"%@个",_jjrDic[@"count_dynamic"] ];
    CGSize size = [str sizeWithFont:Size(28*SpacedFonts) maxSize:CGSizeMake(50, 40)];
    BaseButton * lookMoreBtn = [[BaseButton alloc]initWithFrame:CGRectMake(dongtaiV.frame.size.width-10 -(lookMoreimage.size.width +size.width + 15), 10, lookMoreimage.size.width +size.width + 15 , 28*SpacedFonts) setTitle:str titleSize:28*SpacedFonts titleColor:[UIColor colorWithWhite:0.7141 alpha:1.0] backgroundImage:nil iconImage:lookMoreimage highlightImage:lookMoreimage setTitleOrgin:CGPointMake(0, -lookMoreimage.size.width) setImageOrgin:CGPointMake(4, size.width + 15) inView:dongtaiV];
    
    [lookMoreBtn addTarget:self action:@selector(lookMoreDongtai) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *oneMore=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookMoreDongtai)];
    [dongtaiV addGestureRecognizer:oneMore];
    
    UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(10, 40, dongtaiV.frame.size.width-20, 1)];
    hxV.backgroundColor = [UIColor colorWithRed:0.965 green:0.965 blue:0.969 alpha:1.000];
    [dongtaiV addSubview:hxV];
    



}
-(void)addJianJieV:(UIView *)sender
{
    UIView * jianjieV = [[UIView alloc]initWithFrame:CGRectMake(0, 171, sender.frame.size.width, 40)];
    jianjieV.backgroundColor = [UIColor clearColor];
    [sender addSubview:jianjieV];
    

    
    UILabel * jianjieLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 75, 40)];
    jianjieLab.textColor = [UIColor colorWithRed:0.584 green:0.584 blue:0.596 alpha:1.000];
    jianjieLab.textAlignment = NSTextAlignmentLeft;
    jianjieLab.text = @"个人简介";
    jianjieLab.font = [UIFont systemFontOfSize:12];
    [jianjieV addSubview:jianjieLab];
    
    UILabel * contenLab = [[UILabel alloc]initWithFrame:CGRectMake(85, 0, sender.frame.size.width-95, 40)];
    contenLab.textAlignment = NSTextAlignmentLeft;
    contenLab.textColor = [UIColor colorWithWhite:0.086 alpha:1.000];
    contenLab.font = [UIFont systemFontOfSize:13];
    if ([[_jjrJsonDic objectForKey:@"synopsis"] isEqualToString:@""]) {
        contenLab.text = @"这个人太懒了,什么也没留下";
    }else{
    contenLab.text = [_jjrJsonDic objectForKey:@"synopsis"];
    }
    [jianjieV addSubview:contenLab];
    
    UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(10, 210, sender.frame.size.width-20, 1)];
    hxV.backgroundColor = BACKCOLOR;
    [sender addSubview:hxV];
}
-(void)addBiaoQianV:(UIView *)sender
{
    biaoQianV = [[UIView alloc]initWithFrame:CGRectMake(0, 211, sender.frame.size.width, sender.frame.size.height-211)];
    [sender addSubview:biaoQianV];
    UILabel * biaoqianLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 75, 40)];
    biaoqianLab.textColor = [UIColor colorWithRed:0.584 green:0.584 blue:0.596 alpha:1.000];
    biaoqianLab.textAlignment = NSTextAlignmentLeft;
    biaoqianLab.text = @"人物标签";
    biaoqianLab.font = [UIFont systemFontOfSize:14];
    [biaoQianV addSubview:biaoqianLab];
   NSString * biaoqStr =  [_jjrJsonDic objectForKey:@"labels"];
    NSMutableArray *biaoqArr=[[NSMutableArray alloc]initWithArray: [biaoqStr componentsSeparatedByString:@","]];
   
    for (int i = 0; i<biaoqArr.count; i++) {
        
        if ([biaoqArr[i] length]==0) {
            [biaoqArr removeObjectAtIndex:i];
        }
    }
   
    if (![[_jjrJsonDic objectForKey:@"labels"] isEqualToString:@""]) {
               CGFloat  wid = 85.f;
        CGFloat height = 0.f;
        int j = 0;
        for (int i = 0; i<biaoqArr.count; i++) {
    
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
            btn.layer.masksToBounds = YES;
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [[UIColor colorWithRed:0.878 green:0.882 blue:0.886 alpha:1.000] CGColor];
            btn.layer.cornerRadius = 12;
            btn.userInteractionEnabled = NO;
            [btn setTitleColor:[UIColor colorWithWhite:0.086 alpha:1.000] forState:UIControlStateNormal];
            [btn setTitle:biaoqArr[i] forState:UIControlStateNormal];
            
            //重要的是下面这部分哦！
            CGSize titleSize = [biaoqArr[i] sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:btn.titleLabel.font.fontName size:btn.titleLabel.font.pointSize]}];
            titleSize.width += 20;
            btn.frame = CGRectMake(wid+10*i, 5+height, titleSize.width,25);
            wid += btn.frame.size.width;
            if (btn.frame.size.width+btn.frame.origin.x>= biaoQianV.frame.size.width) {
                j = i;
                wid = 85.f;
                height += 30;
                btn.frame = CGRectMake(wid, 5+height, titleSize.width,25);
                wid += btn.frame.size.width-10*j;
            }
            [biaoQianV addSubview:btn];
            if (i == biaoqArr.count-1) {
                CGFloat bqHeigh = 10+btn.frame.size.height + btn.frame.origin.y;
                CGRect frame = biaoQianV.frame;
                frame.size.height = bqHeigh;
                [biaoQianV setFrame:frame];
                CGRect xqFrame = sender.frame;
                xqFrame.size.height = biaoQianV.frame.size.height+biaoQianV.frame.origin.y;
                [sender setFrame:xqFrame];
            }
        }
    }else
    {
        UILabel * mbiaoqLab = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, biaoQianV.frame.size.width-100, 40)];
        mbiaoqLab.text = @"还未填写标签";
        mbiaoqLab.textColor = [UIColor blackColor];
        mbiaoqLab.textAlignment = NSTextAlignmentLeft;
        mbiaoqLab.font = [UIFont systemFontOfSize:14];
        [biaoQianV addSubview:mbiaoqLab];
        CGRect frame = biaoQianV.frame;
        frame.size.height = mbiaoqLab.frame.size.height;
        [biaoQianV setFrame:frame];

    }
    
    
}
-(void)addTheFuWuV:(CGFloat)orgY
{
    UIView * fuwuV = [[UIView alloc]initWithFrame:CGRectMake(10, orgY, SCREEN_WIDTH-20, 255)];
    fuwuV.backgroundColor = [UIColor whiteColor];
    [bottomScr addSubview:fuwuV];
    
    UILabel * taLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 30)];
    taLab.textAlignment = NSTextAlignmentLeft;
    taLab.textColor = [UIColor colorWithWhite:0.7141 alpha:1.0];
    taLab.text = @"Ta的服务";
    taLab.font = [UIFont systemFontOfSize:15];
    [fuwuV addSubview:taLab];
    

    UIImage *lookMoreimage = [UIImage imageNamed:@"jjr_gengduo"];
    NSString *str = [NSString stringWithFormat:@"%@个",_jjrDic[@"count_server"] ];
    CGSize size = [str sizeWithFont:Size(28*SpacedFonts) maxSize:CGSizeMake(50, 30)];
    BaseButton * lookMoreBtn = [[BaseButton alloc]initWithFrame:CGRectMake(fuwuV.frame.size.width-10 -(lookMoreimage.size.width +size.width + 15), 8, lookMoreimage.size.width +size.width + 15 , 28*SpacedFonts) setTitle:str titleSize:28*SpacedFonts titleColor:[UIColor colorWithWhite:0.7141 alpha:1.0] backgroundImage:nil iconImage:lookMoreimage highlightImage:lookMoreimage setTitleOrgin:CGPointMake(0, -lookMoreimage.size.width) setImageOrgin:CGPointMake(4, size.width + 15) inView:fuwuV];
    
    [lookMoreBtn addTarget:self action:@selector(lookMoreFuwu) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *oneMore=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookMoreFuwu)];
    [fuwuV addGestureRecognizer:oneMore];
    
    UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(0, 34, fuwuV.frame.size.width, 1)];
    hxV.backgroundColor = [UIColor colorWithRed:0.965 green:0.965 blue:0.969 alpha:1.000];
    [fuwuV addSubview:hxV];
    
   [self addTheThreeFuwu:fuwuV];
    
    
}
-(void)addTheXsView:(CGFloat)orgY
{
    UIView * xianSuoV = [[UIView alloc]initWithFrame:CGRectMake(10, orgY, SCREEN_WIDTH-20, 195)];
    [bottomScr setContentSize:CGSizeMake(SCREEN_WIDTH, orgY + 195)];
    xianSuoV.backgroundColor = [UIColor whiteColor];
    [bottomScr addSubview:xianSuoV];
    UILabel * taLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 30)];
    taLab.textAlignment = NSTextAlignmentLeft;
    taLab.textColor = [UIColor colorWithWhite:0.7141 alpha:1.0];
    taLab.text = @"Ta的线索";
    taLab.font = [UIFont systemFontOfSize:15];
    [xianSuoV addSubview:taLab];
    
    UIImage *lookMoreimage = [UIImage imageNamed:@"jjr_gengduo"];
    NSString *str = [NSString stringWithFormat:@"%@个",_jjrDic[@"count_clue"] ];
    CGSize size = [str sizeWithFont:Size(28*SpacedFonts) maxSize:CGSizeMake(50, 30)];
    BaseButton * lookMoreBtn = [[BaseButton alloc]initWithFrame:CGRectMake(xianSuoV.frame.size.width-10 -(lookMoreimage.size.width +size.width + 15), 8, lookMoreimage.size.width +size.width + 15 , 28*SpacedFonts) setTitle:str titleSize:28*SpacedFonts titleColor:[UIColor colorWithWhite:0.7141 alpha:1.0] backgroundImage:nil iconImage:lookMoreimage highlightImage:lookMoreimage setTitleOrgin:CGPointMake(0, -lookMoreimage.size.width) setImageOrgin:CGPointMake(4, size.width + 15) inView:xianSuoV];

    [lookMoreBtn addTarget:self action:@selector(lookMoreXianSuo) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *oneMore=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookMoreXianSuo)];
    [xianSuoV addGestureRecognizer:oneMore];

    UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(0, 34, xianSuoV.frame.size.width, 1)];
    hxV.backgroundColor = [UIColor colorWithRed:0.965 green:0.965 blue:0.969 alpha:1.000];
    [xianSuoV addSubview:hxV];
    
    [self addTheThreeXianSuoV:xianSuoV];
    
    [self addTheFuWuV:CGRectGetMaxY(xianSuoV.frame)+10];
}
#pragma mark 查看更多动态
-(void)lookMoreDongtai
{
    if ([_jjrDic[@"count_dynamic"] integerValue]>0) {
        OtherDynamicdViewController *otherDynamicdViewController = allocAndInit(OtherDynamicdViewController);
        otherDynamicdViewController.dynamicdID = _jjrID;
        otherDynamicdViewController.dynamicdName =[_jjrJsonDic objectForKey:@"realname"];
        PushView(self, otherDynamicdViewController);

    }
    else
    {
        [[ToolManager shareInstance] showInfoWithStatus:@"暂无他的动态"];
    }
    
}
-(void)lookMoreXianSuo
{
    if (_gdxsArr.count<=0) {
        [[ToolManager shareInstance]showAlertMessage:@"暂无他的线索"];
        return;
    }

    MoreXianSuoVC * morexsV = [[MoreXianSuoVC alloc]init];
    morexsV.jjrID = [_gdxsArr[0] objectForKey:@"userid"];
    [self.navigationController pushViewController:morexsV animated:YES];
}
-(void)addTheThreeXianSuoV:(UIView *)sender
{
  
    for (int i = 0 ;i<_gdxsArr.count ; i++) {
       
        UIView *cell = allocAndInitWithFrame(UIView, frame(0, 35 + i* 58, sender.frame.size.width, 58));
        cell.backgroundColor =WhiteColor;
        [sender addSubview:cell];
        
        UIImageView *cellIcon = allocAndInitWithFrame(UIImageView, frame(10, 10, 50 , frameHeight(cell) - 20));
        NSString *imageName = @"";
        if ([_gdxsArr[i][@"industry"] isEqualToString:BAOXIAN]) {
           
            imageName  = @"jjr_baoxian";
        }
        else if ([_gdxsArr[i][@"industry"] isEqualToString:JINRONG])
        {
            imageName  = @"jjr_jingrong";
            
        }
        else if ([_gdxsArr[i][@"industry"] isEqualToString:FANGCHANG])
        {
            imageName  = @"jjr_fanchan";
        }
        else
        {
            imageName  = @"jjr_chehang";
        }
        cellIcon.image =[UIImage imageNamed:imageName];
        [cell addSubview:cellIcon];
        
        [UILabel createLabelWithFrame:frame(CGRectGetMaxX(cellIcon.frame) + 8, frameY(cellIcon), frameWidth(cell) -CGRectGetMaxX(cellIcon.frame) - 20 , 28*SpacedFonts) text:_gdxsArr[i][@"title"] fontSize: 28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
        
        UILabel *status = [UILabel createLabelWithFrame:frame(CGRectGetMaxX(cellIcon.frame) + 8, CGRectGetMaxY(cellIcon.frame) - 24*SpacedFonts, frameWidth(cell) -CGRectGetMaxX(cellIcon.frame) - 20 , 24*SpacedFonts) text:@"已结束" fontSize:24*SpacedFonts textColor:[UIColor colorWithRed:0.7882 green:0.7922 blue:0.7961 alpha:1.0] textAlignment:NSTextAlignmentLeft inView:cell];
        if ([_gdxsArr[i][@"state"] intValue]<90) {
            
            [status setText:@"进行中"];
            [status setTextColor:[UIColor colorWithRed:0.9843 green:0.6314 blue:0.4431 alpha:1.0]];
        }

        UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(10, frameHeight(cell) - 1, frameWidth(cell)- 20, 1)];
        hxV.backgroundColor = [UIColor colorWithRed:0.965 green:0.965 blue:0.969 alpha:1.000];
        [cell addSubview:hxV];
        
        CGRect frame = sender.frame;
        frame.size.height = CGRectGetMaxY(cell.frame);
        [sender setFrame:frame];
      
        //增加点击事件
        UITapGestureRecognizer *labTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labTap:)];
        cell.userInteractionEnabled = YES;
        labTap.numberOfTapsRequired = 1;
        cell.tag = 1000+i;
        [cell addGestureRecognizer:labTap];
        
    }
    if (_gdxsArr.count<=0) {
        
        UIImage *kongImage = [UIImage imageNamed:@"jjr_zanwu"];
        UIImageView *kongStatu = allocAndInitWithFrame(UIImageView, frame((frameWidth(sender) - kongImage.size.width)/2.0, 55, kongImage.size.width, kongImage.size.height));
        kongStatu.image =kongImage;
        [sender addSubview:kongStatu];
        
        UILabel * nothingLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(kongStatu.frame), sender.frame.size.width, 30)];
        nothingLab.textColor = [UIColor colorWithWhite:0.7873 alpha:1.0];
        nothingLab.backgroundColor = [UIColor whiteColor];
        nothingLab.textAlignment = NSTextAlignmentCenter;
        nothingLab.text = @"暂无线索";
        nothingLab.font = [UIFont systemFontOfSize:28*SpacedFonts];
        [sender addSubview:nothingLab];
        CGRect frame = sender.frame;
        frame.size.height = CGRectGetMaxY(nothingLab.frame) + 10;
        [sender setFrame:frame];
        
    }

}
#pragma mark
#pragma mark - labTap
- (void)labTap:(UITapGestureRecognizer *)sender
{
    if (_gdxsArr.count>sender.view.tag - 1000) {
        if ([[_gdxsArr[sender.view.tag-1000] objectForKey:@"iscoop"] intValue] == 1) {
            //跳转我的领取线索详情
            MyLQDetailVC* myLqV =  [[MyLQDetailVC alloc]init];
            myLqV.xiansuoID = [_gdxsArr[sender.view.tag - 1000] objectForKey:@"id"];
            [self.navigationController pushViewController:myLqV animated:YES];
            return;
        }
        if ([[_gdxsArr[sender.view.tag-1000] objectForKey:@"isself"] intValue] == 1) {
            //跳转我的发布线索详情
            MyXSDetailVC* myxiansuoV =  [[MyXSDetailVC alloc]init];
            myxiansuoV.xiansuoID = [_gdxsArr[sender.view.tag - 1000] objectForKey:@"id"];
            [self.navigationController pushViewController:myxiansuoV animated:YES];
            
            return;
        }
        XianSuoDetailVC * xiansuoV =  [[XianSuoDetailVC alloc]init];
        xiansuoV.xs_id = [_gdxsArr[sender.view.tag - 1000] objectForKey:@"id"];
        [self.navigationController pushViewController:xiansuoV animated:YES];
        
    }
}
#pragma mark
-(void)addTheThreeFuwu:(UIView *)sender
{
    for (int i = 0 ; i<_gdfwArr.count; i++) {

        UIView *cell = allocAndInitWithFrame(UIView, frame(0, 35 + i* 58, sender.frame.size.width, 58));
        cell.backgroundColor =WhiteColor;
        [sender addSubview:cell];
        
        UIImageView *cellIcon = allocAndInitWithFrame(UIImageView, frame(10, 10, 50 , frameHeight(cell) - 20));//头像
        [[ToolManager shareInstance] imageView:cellIcon setImageWithURL:_gdfwArr[i][@"imgurl"] placeholderType:PlaceholderTypeOther];
                [cell addSubview:cellIcon];
        
        [UILabel createLabelWithFrame:frame(CGRectGetMaxX(cellIcon.frame) + 8, frameY(cellIcon), frameWidth(cell) -CGRectGetMaxX(cellIcon.frame) - 20 , 28*SpacedFonts) text:_gdfwArr[i][@"title"] fontSize: 28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
        
        NSString *time = _gdfwArr[i][@"createdate"];
        [UILabel createLabelWithFrame:frame(CGRectGetMaxX(cellIcon.frame) + 8, CGRectGetMaxY(cellIcon.frame) - 24*SpacedFonts, frameWidth(cell) -CGRectGetMaxX(cellIcon.frame) - 20 , 24*SpacedFonts) text:[time timeformatString:@"yyyy-MM-dd"] fontSize:24*SpacedFonts textColor:[UIColor colorWithRed:0.5137 green:0.5137 blue:0.5216 alpha:1.0] textAlignment:NSTextAlignmentLeft inView:cell];
        UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(10, frameHeight(cell) - 1, frameWidth(cell)- 20, 1)];
        hxV.backgroundColor = [UIColor colorWithRed:0.965 green:0.965 blue:0.969 alpha:1.000];
        [cell addSubview:hxV];
        
        CGRect frame = sender.frame;
        frame.size.height = CGRectGetMaxY(cell.frame);
        [sender setFrame:frame];
        [bottomScr setContentSize:CGSizeMake(SCREEN_WIDTH, sender.frame.size.height+sender.frame.origin.y+35)];
        
        //增加点击事件
        UITapGestureRecognizer *backVTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backVTap:)];
        cell.userInteractionEnabled = YES;
        backVTap.numberOfTapsRequired = 1;
        cell.tag = 1000+i;
        [cell addGestureRecognizer:backVTap];

    }
    if (_gdfwArr.count<=0) {
       
        UIImage *kongImage = [UIImage imageNamed:@"jjr_zanwu"];
        UIImageView *kongStatu = allocAndInitWithFrame(UIImageView, frame((frameWidth(sender) - kongImage.size.width)/2.0, 55, kongImage.size.width, kongImage.size.height));
        kongStatu.image =kongImage;
        [sender addSubview:kongStatu];
        
        UILabel * nothingLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(kongStatu.frame), sender.frame.size.width, 30)];
        nothingLab.textColor = [UIColor colorWithWhite:0.8024 alpha:1.0];
        nothingLab.backgroundColor = [UIColor whiteColor];
        nothingLab.textAlignment = NSTextAlignmentCenter;
        nothingLab.text = @"暂无服务";
        nothingLab.font = [UIFont systemFontOfSize:28*SpacedFonts];
        [sender addSubview:nothingLab];
        CGRect frame = sender.frame;
        frame.size.height = CGRectGetMaxY(nothingLab.frame) + 10;
        [sender setFrame:frame];
        [bottomScr setContentSize:CGSizeMake(SCREEN_WIDTH, sender.frame.size.height+sender.frame.origin.y)];
       
    }
}
#pragma mark -头像点击事件
-(void)TapOne:(UITapGestureRecognizer *)tap
{
    
    NSMutableArray* tmp = [[NSMutableArray alloc] initWithCapacity:1];
   
    UIView *cellImageView = [tap view];
    NSString *url = [_jjrJsonDic objectForKey:@"imgurl"];
    NSString *yuantu =url;
    if (url.length==0){
        [[ToolManager shareInstance]showAlertMessage:@"没有头像"];
        return;
        
    }
    if (url.length>0) {
        NSArray *arr=[url componentsSeparatedByString:@"/"];
        if ([arr[arr.count - 1] hasPrefix:@"s"]) {
                       NSString *substring=[arr[arr.count - 1] substringFromIndex:1];
            url=@"";
            for (int i=0;i<(arr.count-1);i++) {
                
                url =[url stringByAppendingString:arr[i]];
                url=[url stringByAppendingString:@"/"];
            }
            url =[url stringByAppendingString:substring];
        
        }
  
    }
    
    LWImageBrowserModel* imageModel = [[LWImageBrowserModel alloc] initWithplaceholder:nil
                                                                              thumbnailURL:[NSURL URLWithString: [[ToolManager shareInstance] urlAppend:yuantu] ]
                                                                                     HDURL:[NSURL URLWithString:[[ToolManager shareInstance] urlAppend:url]]
                                                                        imageViewSuperView:cellImageView.superview
                                                                       positionAtSuperView:cellImageView.frame
                                                                                     index:0];
    [tmp addObject:imageModel];
    
    LWImageBrowser* imageBrowser = [[LWImageBrowser alloc] initWithParentViewController:self
                                                                            imageModels:tmp
                                                                           currentIndex:0];
    imageBrowser.view.backgroundColor = [UIColor blackColor];
    [imageBrowser show];


}
#pragma mark - labTap
- (void)backVTap:(UITapGestureRecognizer *)sender
{

    if (_gdfwArr.count>sender.view.tag - 1000) {
        fuwuDic = _gdfwArr[sender.view.tag - 1000];
        fuwuImg= (UIImageView *)[sender.view viewWithTag:100];
    if ([fuwuDic[@"actype"] isEqualToString:@"article"]) {
        MyContentDetailViewController *detail = allocAndInit(MyContentDetailViewController);
        detail.shareImage = fuwuImg.image;
        detail.isNoEdit = YES;
        detail.ID =fuwuDic[@"id"];
        detail.uid =fuwuDic[@"userid"];
        detail.imageurl = fuwuDic[@"imgurl"];
        PushView(self, detail);
        }
        else if([fuwuDic[@"industry"] isEqualToString:@"insurance"]||[fuwuDic[@"industry"] isEqualToString:@"finance"]||[fuwuDic[@"industry"] isEqualToString:@"other"])
        {
        MyProductDetailViewController *detail = allocAndInit(MyProductDetailViewController);
        detail.shareImage = fuwuImg.image;
        detail.isNoEdit = YES;
        detail.ID =fuwuDic[@"id"];
        detail.uid =fuwuDic[@"userid"];
        detail.imageurl =fuwuDic[@"imgurl"];
        PushView(self, detail);
        
        }
                //这是房产的产品
        else if([fuwuDic[@"industry"] isEqualToString:@"property"])
        {
        
            BaseButton *share = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 50, StatusBarHeight, 50, NavigationBarHeight) backgroundImage:nil iconImage:[UIImage imageNamed:@"icon_widelyspreaddetail_share"] highlightImage:nil inView:self.view];
            
            share.didClickBtnBlock = ^
            {
                
                
               [[WetChatShareManager shareInstance] shareToWeixinApp:fuwuDic[@"title"] desc:@"" image:fuwuImg.image  shareID:fuwuDic[@"id"] isWxShareSucceedShouldNotice:NO isAuthen:[fuwuDic[@"isgetclue"] boolValue]];
                
                
            };
            
            [[ToolManager shareInstance] loadWebViewWithUrl:[NSString stringWithFormat:@"%@show/estate?acid=%@",HttpURL,[NSString stringWithFormat:@"%@",fuwuDic[@"id"]]] title:@"产品详情" pushView:self rightBtn:share];
        
            }
        
                //这是车行的产品
            else if([fuwuDic[@"industry"] isEqualToString:@"car"])
            {
        
                BaseButton *share = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 50, StatusBarHeight, 50, NavigationBarHeight) backgroundImage:nil iconImage:[UIImage imageNamed:@"icon_widelyspreaddetail_share"] highlightImage:nil inView:self.view];
                
                share.didClickBtnBlock = ^
                {
                    
                    
                    [[WetChatShareManager shareInstance] shareToWeixinApp:fuwuDic[@"title"] desc:@"" image:fuwuImg.image  shareID:fuwuDic[@"id"] isWxShareSucceedShouldNotice:NO isAuthen:[fuwuDic[@"isgetclue"] boolValue]];
                    
                    
                };
                
                [[ToolManager shareInstance] loadWebViewWithUrl:[NSString stringWithFormat:@"%@show/car?acid=%@",HttpURL,[NSString stringWithFormat:@"%@",fuwuDic[@"id"]]] title:@"产品详情" pushView:self rightBtn:share];
                    
                }
 
    }
    
    
}

-(void)lookMoreFuwu
{
    if (_gdfwArr.count<=0) {
        [[ToolManager shareInstance]showAlertMessage:@"暂无他的服务"];
        return;
    }
    
    MoreFuwuVC * morefw = [[MoreFuwuVC alloc]init];
    morefw.jjrid = [_gdfwArr[0] objectForKey:@"userid"];
    [self.navigationController pushViewController:morefw animated:YES];
}
-(UIImageView *)customViewWithFrame:(CGRect)frame andTitle:(NSString *)title andNumb:(NSString *)numb
{
    UIImageView * imgV = [[UIImageView alloc]initWithFrame:frame];
    imgV.image = [UIImage imageNamed:@"yuan"];
    UILabel * numbLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, frame.size.width, (frame.size.height-5)/2-7)];
    numbLab.textColor = [UIColor blackColor];
    numbLab.textAlignment = NSTextAlignmentCenter;
    numbLab.text = numb;
    numbLab.font = [UIFont systemFontOfSize:12];
    [imgV addSubview:numbLab];
    UILabel * titLab = [[UILabel alloc]initWithFrame:CGRectMake(0, numbLab.frame.size.height+numbLab.frame.origin.y, frame.size.width,(frame.size.height-5)/2)];
    titLab.textColor = [UIColor colorWithRed:0.584 green:0.584 blue:0.596 alpha:1.000];
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.text = title;
    titLab.font = [UIFont systemFontOfSize:12];
    [imgV addSubview:titLab];
    return imgV;

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
