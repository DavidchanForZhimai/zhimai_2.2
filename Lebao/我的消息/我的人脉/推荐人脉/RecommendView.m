//
//  RecommendView.m
//  Lebao
//
//  Created by adnim on 2016/12/19.
//  Copyright © 2016年 David. All rights reserved.
//

#import "RecommendView.h"

@implementation RecommendView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        self.frame=CGRectMake(frame.origin.x, frame.origin.y, (APPWIDTH-40)/3, (APPWIDTH-40)/3*1.22);
        _nameLab=[YYLabel new];
        _positionLab=[YYLabel new];
        _headView=[UIImageView new];
        self.layer.borderWidth=1;
        self.layer.borderColor=[UIColor colorWithRed:0.549 green:0.5569 blue:0.5608 alpha:0.6].CGColor;
        self.layer.cornerRadius=5;
        [self creatUi];
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTouch)];
        [self addGestureRecognizer:tapGesture];
        self.userInteractionEnabled=YES;

    }
    return self;
}
-(void)creatUi
{
    _headView.frame=CGRectMake(self.width/4.0, self.width/4.0-10, self.width/2.0, self.width/2.0);
    _headView.userInteractionEnabled=YES;
    _nameLab.frame=CGRectMake(0, CGRectGetMaxY(_headView.frame)+15, self.width, 14);
    _nameLab.font=[UIFont systemFontOfSize:14];
    _nameLab.textAlignment=NSTextAlignmentCenter;
    _positionLab.frame=CGRectMake(0, CGRectGetMaxY(_nameLab.frame)+10, self.width, 12);
    _positionLab.font=[UIFont systemFontOfSize:12];
    _positionLab.textColor=[UIColor colorWithRed:0.549 green:0.5569 blue:0.5608 alpha:1.0];
    _positionLab.textAlignment=NSTextAlignmentCenter;
    [self addSubview:_headView];
    [self addSubview:_nameLab];
    [self addSubview:_positionLab];
}

-(void)configWithData:(MeetingData *)data
{
    _data=data;
    if ([data.imgurl isEqualToString:ImageURLS]||[data.imgurl isEqualToString:@""]) {
        
        if (data.sex==2) {
            _headView.image = [UIImage imageNamed:@"defaulthead_nv"];
        }
        else
        {
            _headView.image = [UIImage imageNamed:@"defaulthead"];
        }
    }else {
        NSString *imagUrl;
        imagUrl=[NSString stringWithFormat:@"%@%@",ImageURLS,data.imgurl];
        [[ToolManager shareInstance] imageView:_headView  setImageWithURL:imagUrl placeholderType:PlaceholderTypeUserHead];
    }
    _nameLab.text=data.realname;
    _positionLab.text=data.position;

}
-(void)viewTouch
{
    if ([_delegate conformsToProtocol:@protocol(RecommendViewDelegate)]&&[_delegate respondsToSelector:@selector(didSelectRecommendViewWithModel:)]) {
        [_delegate didSelectRecommendViewWithModel:_data];
    }
}

@end
