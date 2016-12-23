//
//  MyVisitorCell.m
//  Lebao
//
//  Created by adnim on 2016/12/19.
//  Copyright © 2016年 David. All rights reserved.
//

#import "MyVisitorCell.h"
#import "NSString+Extend.h"

@implementation MyVisitorCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLab=[YYLabel new];
        _headImgV=[UIImageView new];
        _companyLab=[YYLabel new];
        _positionAndYearsLab=[YYLabel new];
        _renzhImg=[UIImageView new];
        _vipImg=[UIImageView new];
        _timeLab=[YYLabel new];
        [self creatUI];
    }
    return self;
}

-(void)creatUI
{
    _headImgV.frame=CGRectMake(17.5, 17.5, 55, 55);
    [self addSubview:_headImgV];
    _nameLab.frame=CGRectMake(CGRectGetMaxX(_headImgV.frame)+15, 15, APPWIDTH-CGRectGetMaxX(_headImgV.frame)-25, 15);
    _nameLab.font=[UIFont systemFontOfSize:15];
    _positionAndYearsLab.frame=CGRectMake(_nameLab.x, CGRectGetMaxY(_nameLab.frame)+10, _nameLab.width, 13);
    _positionAndYearsLab.textColor=[UIColor colorWithRed:0.549 green:0.5569 blue:0.5608 alpha:1.0];
    _positionAndYearsLab.font=[UIFont systemFontOfSize:13];
    _companyLab.frame=CGRectMake(_nameLab.x, CGRectGetMaxY(_positionAndYearsLab.frame)+10, _nameLab.width, 13);
    _companyLab.textColor=[UIColor colorWithRed:0.549 green:0.5569 blue:0.5608 alpha:1.0];
    _companyLab.font=[UIFont systemFontOfSize:13];
    _timeLab.frame=CGRectMake(APPWIDTH/2.0, 17,APPWIDTH/2.0-10, 13);
    _timeLab.textColor=[UIColor colorWithRed:0.549 green:0.5569 blue:0.5608 alpha:1.0];
    _timeLab.font=[UIFont systemFontOfSize:12];
    _timeLab.textAlignment=NSTextAlignmentRight;
     [self addSubview:_nameLab];
    [self addSubview:_positionAndYearsLab];
    [self addSubview:_companyLab];
    [self addSubview:_renzhImg];
    [self addSubview:_vipImg];
    [self addSubview:_timeLab];
    
}
-(void)configCellWithModel:(MeetingData *)model
{
    
    if ([model.imgurl isEqualToString:ImageURLS]) {
    
        if (model.sex==2) {
            _headImgV.image = [UIImage imageNamed:@"defaulthead_nv"];
        }
        else
        {
            _headImgV.image = [UIImage imageNamed:@"defaulthead"];
        }
    }else {
    NSString *imagUrl;
    imagUrl=[NSString stringWithFormat:@"%@%@",ImageURLS,model.imgurl];
        [[ToolManager shareInstance] imageView:_headImgV  setImageWithURL:imagUrl placeholderType:PlaceholderTypeUserHead];
    }
    

    _nameLab.text=model.realname;
    _nameLab.frame = CGRectMake(_nameLab.x,12, [_nameLab.text sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(APPWIDTH/2.0, _nameLab.size.height)].width, _nameLab.height);
    if ([model.authen intValue]==3) {
        _renzhImg.image = [UIImage imageNamed:@"[iconprofilerenzhen]"];
        _renzhImg.frame =CGRectMake(_nameLab.frame.origin.x+_nameLab.frame.size.width+5,(_nameLab.height-[UIImage imageNamed:@"[iconprofilerenzhen]"].size.height)/2.0+_nameLab.y, [UIImage imageNamed:@"[iconprofilerenzhen]"].size.width,[UIImage imageNamed:@"[iconprofilerenzhen]"].size.height);
    }else{
        _renzhImg.image = nil;
        _renzhImg.frame =CGRectMake(_nameLab.frame.origin.x+_nameLab.frame.size.width,(_nameLab.height-[UIImage imageNamed:@"[iconprofilerenzhen]"].size.height)/2.0+_nameLab.y, 0, 0);
    }
    if ([model.vip intValue]==1) {
        _vipImg.image = [UIImage imageNamed:@"[iconprofilevip]"];
        _vipImg.frame =CGRectMake(_renzhImg.frame.origin.x+_renzhImg.frame.size.width+5,(_nameLab.height-[UIImage imageNamed:@"[iconprofilerenzhen]"].size.height)/2.0+_nameLab.y, [UIImage imageNamed:@"[iconprofilerenzhen]"].size.width,[UIImage imageNamed:@"[iconprofilerenzhen]"].size.height);
    }else{
        _vipImg.image = nil;
        _vipImg.frame =CGRectMake(0, 0, 0, 0);
    }

    _companyLab.text=model.address;
    
    if (![model.workyears isEqualToString:@""]&&![model.workyears isEqualToString:@"0"]&&model.workyears) {
            _positionAndYearsLab.text=[NSString stringWithFormat:@"%@ 从业%@年",model.position,model.workyears];
        if ([model.position isEqualToString:@""]) {
            _positionAndYearsLab.text=[NSString stringWithFormat:@"从业%@年",model.workyears];
        }
    }else{
        _positionAndYearsLab.text=model.position;
        
    }
    
    _timeLab.text=[model.updatetime updateTime];
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
