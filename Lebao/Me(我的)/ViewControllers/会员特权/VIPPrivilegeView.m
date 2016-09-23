//
//  VIPPrivilegeView.m
//  Lebao
//
//  Created by adnim on 16/9/23.
//  Copyright © 2016年 David. All rights reserved.
//

#import "VIPPrivilegeView.h"

@implementation VIPPrivilegeView



-(void)awakeFromNib
{
//
//    _icoudImgV.clipsToBounds=YES;
//    _icoudImgV.layer.cornerRadius=_icoudImgV.width/2.0;
//
//          _renzhenImgV.image=[UIImage imageNamed:@"[iconprofileweirenzhen]"];
//
//    
//    _VIPImgV.image=[UIImage imageNamed:@"[iconprofilevipweikaitong]"];
//    _privilegeImgV.contentMode=UIViewContentModeScaleAspectFit;
//    
}
-(void)configWithModel:(MeViewModal *)modal
{
    
    _icoudImgV.clipsToBounds=YES;
    _icoudImgV.layer.cornerRadius=_icoudImgV.width/2.0;
    [[ToolManager shareInstance] imageView:_icoudImgV setImageWithURL:modal.imgurl placeholderType:PlaceholderTypeUserHead];
    _nameLab.text=modal.realname;
    if(modal.authen==3){
        _renzhenImgV.image=[UIImage imageNamed:@"[iconprofilerenzhen]"];
    }else{
        _renzhenImgV.image=[UIImage imageNamed:@"[iconprofileweirenzhen]"];
    }
    
    _VIPImgV.image=[UIImage imageNamed:@"[iconprofilevipweikaitong]"];
    _privilegeImgV.contentMode=UIViewContentModeScaleAspectFit;
    _privilegeImgV.image=[UIImage imageNamed:@"VIPprivilege.jpg"];
    
}


@end
