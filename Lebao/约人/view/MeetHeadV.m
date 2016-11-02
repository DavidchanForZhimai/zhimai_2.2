//
//  MeetHeadV.m
//  Lebao
//
//  Created by adnim on 16/8/26.
//  Copyright © 2016年 David. All rights reserved.
//

#import "MeetHeadV.h"
#import "CanmeetTabVC.h"
#import "MeWantMeetVC.h"
#import "WantMeetMeVC.h"
#import "GzHyViewController.h"
#import "CALayer+WebCache.h"
#import "MyDetialViewController.h"
@implementation MeetHeadV
{
    NSArray *frameArr;
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
        
        
    }
    return self;
}
-(NSMutableArray *)headLayer
{
    if (!_headLayer) {
        _headLayer=[[NSMutableArray alloc]init];
    }
    return _headLayer;
}
-(void)creatUI
{
    
    CALayer *bgImgV=[[CALayer alloc]init];
    bgImgV.contents=(id)[UIImage imageNamed:@"wodeBG"].CGImage;
    bgImgV.frame=CGRectMake(0, 0, APPWIDTH, 200);
    [self.layer addSublayer:bgImgV];
    
    _vlayer1=[[CALayer alloc]init];
    _vlayer1.shouldRasterize=YES;
    _vlayer1.frame=CGRectMake((bgImgV.frame.size.width-110)/2.0, (bgImgV.frame.size.height-110)/2.0, 110, 110);
    _vlayer1.backgroundColor=[UIColor colorWithWhite:1.000 alpha:0.18].CGColor;
    _vlayer1.cornerRadius=_vlayer1.frame.size.width/2.0;
    [bgImgV addSublayer:_vlayer1];

    _vlayer2=[[CALayer alloc]init];
    _vlayer2.shouldRasterize=YES;
    _vlayer2.frame=CGRectMake((bgImgV.frame.size.width-95)/2.0, (bgImgV.frame.size.height-95)/2.0, 95, 95);
    _vlayer2.backgroundColor=[UIColor colorWithWhite:1.000 alpha:0.18].CGColor;
    _vlayer2.cornerRadius=_vlayer2.frame.size.width/2.0;
    [bgImgV addSublayer:_vlayer2];

    _vlayer3=[[CALayer alloc]init];
    _vlayer3.shouldRasterize=YES;
    _vlayer3.frame=CGRectMake((bgImgV.frame.size.width-80)/2.0, (bgImgV.frame.size.height-80)/2.0, 80, 80);
    _vlayer3.backgroundColor=[UIColor colorWithWhite:1.000 alpha:0.18].CGColor;
    _vlayer3.cornerRadius=_vlayer3.frame.size.width/2.0;
    [bgImgV addSublayer:_vlayer3];

    [self shakeToShow:_vlayer1];
    [self shakeToShow:_vlayer2];
    [self shakeToShow:_vlayer3];
    
    CALayer *underView=[[CALayer alloc]init];
    underView.frame=CGRectMake(0, CGRectGetMaxY(bgImgV.frame), APPWIDTH, 45);
    underView.backgroundColor=[UIColor whiteColor].CGColor;
    [self.layer addSublayer:underView];
    _nearManLab=[[UILabel alloc]init];
    _nearManLab.frame=CGRectMake(15, CGRectGetMaxY(bgImgV.frame)+15, 160, 15);
    _nearManLab.textColor=[UIColor colorWithRed:0.424 green:0.427 blue:0.431 alpha:1.000];
    _nearManLab.textAlignment=NSTextAlignmentLeft;
    _nearManLab.font=[UIFont systemFontOfSize:15];
    
    [self addSubview:_nearManLab];
    
    
    UIButton *genduoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    genduoBtn.frame=CGRectMake(APPWIDTH-45, 200, 45, 45);
    [genduoBtn setImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateNormal];
    [genduoBtn addTarget:self action:@selector(genduoAction:)  forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:genduoBtn];
    
    
    _wantMeBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    _wantMeBtn.frame=CGRectMake(20, bgImgV.frame.size.height-80, 60, 60);
    _wantMeBtn.layer.cornerRadius=30;
    _wantMeBtn.layer.borderWidth=2;
    
    _wantMeBtn.layer.borderColor=[UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
    [_wantMeBtn setTintColor:WhiteColor];
    _wantMeBtn.titleLabel.font = Size(20);
    _wantMeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [_wantMeBtn addTarget:self action:@selector(wantMeClick:) forControlEvents:UIControlEventTouchUpInside];
    _wantMeBtn.tag=1000;
    [self addSubview:_wantMeBtn];
    
    _meWantBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    _meWantBtn.frame=CGRectMake(APPWIDTH-80, bgImgV.frame.size.height-80, 60, 60);
    _meWantBtn.layer.cornerRadius=30;
    _meWantBtn.layer.borderWidth=2;
    [_meWantBtn setTintColor:WhiteColor];
    _meWantBtn.layer.borderColor=[UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
    
    _meWantBtn.titleLabel.font = Size(20);
    _meWantBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [_meWantBtn addTarget:self action:@selector(IwantClick:) forControlEvents:UIControlEventTouchUpInside];
    _meWantBtn.tag=1001;
    [self addSubview:_meWantBtn];
    
    
    //    CAShapeLayer*layer1=[[CAShapeLayer alloc]init];
    //    layer1.frame=_meWantBtn.frame;
    //    layer1.strokeStart=0;
    //    layer1.position=_wantMeBtn.center;
    //    layer1.fillColor=[UIColor clearColor].CGColor;
    //    layer1.strokeColor=[UIColor whiteColor].CGColor;
    //    layer1.strokeEnd=1.0;
    //    layer1.lineWidth=2;
    //    layer1.shouldRasterize=YES;
    //    UIBezierPath *bezier1=[UIBezierPath bezierPathWithOvalInRect:layer1.bounds];
    //    layer1.path=bezier1.CGPath;
    //    [bgImgV addSublayer:layer1];
    //
    //    CAShapeLayer*layer2=[[CAShapeLayer alloc]init];
    //    layer2.frame=_meWantBtn.frame;
    //    layer2.strokeStart=0;
    //    layer2.position=_meWantBtn.center;
    //    layer2.fillColor=[UIColor clearColor].CGColor;
    //    layer2.strokeColor=[UIColor whiteColor].CGColor;
    //    layer2.strokeEnd=1.0;
    //    layer2.lineWidth=2;
    //    layer2.shouldRasterize=YES;
    //    UIBezierPath *bezier2=[UIBezierPath bezierPathWithOvalInRect:layer2.bounds];
    //    layer2.path=bezier2.CGPath;
    //
    //    [bgImgV addSublayer:layer2];
    //
    
    _midBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    _midBtn.frame=CGRectMake((bgImgV.frame.size.width-105)/2.0, (bgImgV.frame.size.height-105)/2.0, 105, 105);
    _midBtn.backgroundColor=[UIColor colorWithRed:0.835 green:0.937 blue:0.988 alpha:1.000];
    _midBtn.layer.cornerRadius=_midBtn.width/2.0;
    _midBtn.layer.borderWidth=10;
    _midBtn.layer.borderColor=[UIColor colorWithRed:0.314 green:0.686 blue:0.988 alpha:0.72].CGColor;
    
    _midBtn.titleLabel.font=Size(22);
    [_midBtn setTintColor:AppMainColor];
    _midBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    _midBtn.titleLabel.numberOfLines=0;
    [_midBtn addTarget:self action:@selector(midBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:_midBtn];
    frameArr=@[NSStringFromCGRect(CGRectMake(_midBtn.x-10, _midBtn.y, 20,20)),
               NSStringFromCGRect(CGRectMake(_midBtn.x+30, 10, 23, 23)),

               NSStringFromCGRect(CGRectMake(CGRectGetMaxX(_midBtn.frame)-15, 30, 30, 30)),
                NSStringFromCGRect(CGRectMake(CGRectGetMaxX(_midBtn.frame)+30, _midBtn.y+30, 18, 18)),
                              NSStringFromCGRect(CGRectMake(CGRectGetMaxX(_midBtn.frame)+10, CGRectGetMaxY(_midBtn.frame)-40, 22, 22)),
               NSStringFromCGRect(CGRectMake(CGRectGetMaxX(_midBtn.frame)-40,CGRectGetMaxY(_midBtn.frame), 20, 20)),
              
               NSStringFromCGRect(CGRectMake(_midBtn.x-10, CGRectGetMaxY(_midBtn.frame)-8, 25, 25)),
               NSStringFromCGRect(CGRectMake(_midBtn.x-40, _midBtn.y+50, 17, 17))];
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    //设置边框颜色
    shapelayer.strokeColor = [[UIColor colorWithWhite:1.000 alpha:0.15]CGColor];
    //设置填充颜色 如果只要边 可以把里面设置成[UIColor ClearColor]
    shapelayer.fillColor = [[UIColor clearColor]CGColor];
    //就是这句话在关联彼此（UIBezierPath和CAShapeLayer）：
    UIBezierPath *apath=[UIBezierPath bezierPath];
    for (int i=0;i<8; i++) {
        CGRect rect = CGRectFromString(frameArr[i]);
        [apath moveToPoint:CGPointMake(rect.origin.x+rect.size.width/2.0, rect.origin.y+rect.size.height/2.0)];
        
        for (int j=i+1;j<8; j++) {
            if (j-i==4||j-i==1||j-i==7||j-i==5||(i==3&&j==5)||(i==0&&j==6)) {
                CGRect rect1 = CGRectFromString(frameArr[j]);
                [apath addLineToPoint:CGPointMake(rect1.origin.x+rect1.size.width/2.0, rect1.origin.y+rect1.size.height/2.0)];
                [apath closePath];
                shapelayer.path = apath.CGPath;
                [self.layer addSublayer:shapelayer];
            }
        }
    }
     _midBtn.layer.zPosition=20;
    
}

-(void)addEightImgView
{
    if (self.headLayer.count==0) {
        for (int i=0;i<8; i++) {
            CGRect rect = CGRectFromString(frameArr[i]);
            CALayer *layer=[CALayer layer];
            layer.masksToBounds=YES;
            layer.frame=rect;
            layer.cornerRadius=layer.frame.size.width/2.0;
            layer.borderWidth=2;
            layer.borderColor=[UIColor colorWithWhite:1.000 alpha:0.2].CGColor;
            layer.shouldRasterize=YES;
            if (i>=_headimgsArr.count&&i<8) {
                layer.contents=(id)[UIImage imageNamed:@"defaulthead"].CGImage;
            }else{
                [layer sd_setImageWithURL:[NSURL URLWithString:[[ToolManager shareInstance]urlAppend:_headimgsArr[i]]]placeholderImage:[UIImage imageNamed:@"defaulthead"]];}
            [self.layer addSublayer:layer];
            [self.headLayer addObject:layer];
        }
    }else
    {
        for (int i=0;i<self.headimgsArr.count&&i<8;i++) {
            [self.headLayer[i] sd_setImageWithURL:[NSURL URLWithString:[[ToolManager shareInstance]urlAppend:_headimgsArr[i]]]placeholderImage:[UIImage imageNamed:@"defaulthead"]];
        }
    }
   
    UITapGestureRecognizer *oneTG=[[UITapGestureRecognizer alloc]init];
    [oneTG addTarget:self action:@selector(toch:)];
    [self addGestureRecognizer:oneTG];
}
-(void)toch:(UITapGestureRecognizer *)sender//头像点击
{
    CGPoint point = [sender locationInView:self];
    
    for (int i=0; i<_headimgsArr.count&&i<8; i++) {
        CGRect rect = CGRectFromString(frameArr[i]);
        if(point.x>rect.origin.x&&point.x<(rect.origin.x+rect.size.width)&&point.y>rect.origin.y&&point.y<(rect.origin.y+rect.size.height)){
            if ([self.delegate respondsToSelector:@selector(pushView:userInfo:)]&&[self.delegate conformsToProtocol:@protocol(MeetHeadVDelegate)]) {
                MyDetialViewController *myDetialViewCT=allocAndInit(MyDetialViewController);
                myDetialViewCT.userID=_userIdArr[i];
                [_delegate pushView:myDetialViewCT userInfo:nil];
            }
        }
    }
}
-(void)wantMeClick:(UIButton *)sender
{
    
    if ([self.delegate respondsToSelector:@selector(pushView:userInfo:)]&&[self.delegate conformsToProtocol:@protocol(MeetHeadVDelegate)]) {
        WantMeetMeVC *mewantMeetVC=[[WantMeetMeVC alloc]init];
        [_delegate pushView:mewantMeetVC userInfo:nil];
    }
}
-(void)IwantClick:(UIButton *)sender
{
    
    if ([self.delegate respondsToSelector:@selector(pushView:userInfo:)]&&[self.delegate conformsToProtocol:@protocol(MeetHeadVDelegate)]) {
        MeWantMeetVC *mewantMeetVC=[[MeWantMeetVC alloc]init];
        [_delegate pushView:mewantMeetVC userInfo:nil];
    }
    
    
}

-(void)midBtnClick:(UIButton *)sender
{
    
    if ([self.delegate respondsToSelector:@selector(pushView:userInfo:)]&&[self.delegate conformsToProtocol:@protocol(MeetHeadVDelegate)]) {
        [_delegate pushView:allocAndInit(CanmeetTabVC) userInfo:nil];
    }
    
}
//查看行业
-(void)genduoAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(pushView:userInfo:)]&&[self.delegate conformsToProtocol:@protocol(MeetHeadVDelegate)]) {
        GzHyViewController *gzHyVC=[[GzHyViewController alloc]init];
        [_delegate pushView:gzHyVC userInfo:nil];
    }
}



- (void) shakeToShow:(CALayer *)clayer
{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 3.0;
    animation.repeatCount = CGFLOAT_MAX;
    animation.autoreverses = NO;
    animation.fromValue = [NSNumber numberWithFloat:1.1];
    animation.toValue = [NSNumber numberWithFloat:1.9];
    [clayer addAnimation:animation forKey:@"scale-layer"];
    
    CABasicAnimation*_anim1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    _anim1.duration= 3.0;
    _anim1.fromValue= [NSNumber numberWithFloat:1.0];
    _anim1.toValue= [NSNumber numberWithFloat:0.4];
    _anim1.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _anim1.repeatCount= CGFLOAT_MAX;
    _anim1.autoreverses= NO;
    [clayer addAnimation:_anim1 forKey:nil];
    
    _anim1=nil;
    animation=nil;
}


@end
