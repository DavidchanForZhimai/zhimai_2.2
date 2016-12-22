//
//  ExhibitionIndustryCell.m
//  Lebao
//
//  Created by David on 15/11/27.
//  Copyright © 2015年 David. All rights reserved.
//

#import "ExhibitionIndustryCell.h"
//工具类
#import "ToolManager.h"
#import "BaseButton.h"
#import "UILabel+Extend.h"
#import "NSString+Extend.h"
@implementation ExhibitionIndustryCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation ExhibitionRedPaperCell
{

    DWLable *_descrip;
    BaseButton *_redPaper;
    BaseButton *_time;
    BaseButton  *_browse;
    BaseButton  *_read;
   

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth
{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        _icon = allocAndInitWithFrame(UIImageView, frame(10*ScreenMultiple, (cellHeight - 63*ScreenMultiple)/2.0, 79*ScreenMultiple, 63*ScreenMultiple));
        [self addSubview:_icon];
        
        _descrip = [DWLable createLabelWithFrame:frame(CGRectGetMaxX(_icon.frame) + 5*ScreenMultiple, _icon.y, cellWidth - (CGRectGetMaxX(_icon.frame) + 70*ScreenMultiple), 30*ScreenMultiple) text:@"" fontSize:12*ScreenMultiple textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:self];
        _descrip.numberOfLines = 0;
        _descrip.verticalAlignment = VerticalAlignmentTop;
        
        UIImage *imagetime =[UIImage imageNamed:@"exhibition_createtime"];
        UILabel *time =allocAndInit(UILabel);
        CGSize sizeTime = [time sizeWithContent:@" 22:00 " font:[UIFont systemFontOfSize:12]];
        
        _time = [[BaseButton alloc]initWithFrame:frame(frameX(_descrip), cellHeight - _icon.y - 12 , imagetime.size.width + 5*ScreenMultiple + sizeTime.width, imagetime.size.height)  setTitle:@"" titleSize:22*SpacedFonts titleColor:hexColor(c9c9c9) backgroundImage:nil iconImage:imagetime highlightImage:nil setTitleOrgin:CGPointMake(0,5*ScreenMultiple) setImageOrgin:CGPointMake(0,0)  inView:self];
        _time.shouldAnmial = NO;
        
        
        UIImage *image =[UIImage imageNamed:@"exhibition_redPaper"];
        CGSize sizebrowse = [time sizeWithContent:@"¥2015" font:[UIFont systemFontOfSize:15]];
        
        _redPaper = [[BaseButton alloc]initWithFrame:frame(CGRectGetMaxX(_descrip.frame) + 5*ScreenMultiple, _descrip.y, image.size.width + 5*ScreenMultiple + sizebrowse.width, image.size.height)  setTitle:@"¥20" titleSize:15 titleColor:hexColor(ff4545) backgroundImage:nil iconImage:image highlightImage:nil setTitleOrgin:CGPointMake(0,5*ScreenMultiple) setImageOrgin:CGPointMake(0,0)  inView:self];
        _redPaper.shouldAnmial = NO;
        
        
        UIImage *_collectionImage =[UIImage imageNamed:@"exhibition_home_zhuanfa"];
        
        _browse = [[BaseButton alloc]initWithFrame:frame(CGRectGetMaxX(_icon.frame) + (cellWidth - CGRectGetMaxX(_icon.frame))/3.0, frameY(_time), (cellWidth - CGRectGetMaxX(_icon.frame))/3.0, _collectionImage.size.height)  setTitle:@"22" titleSize:22*SpacedFonts titleColor:hexColor(c9c9c9) backgroundImage:nil iconImage:_collectionImage highlightImage:nil setTitleOrgin:CGPointMake(1,5) setImageOrgin:CGPointMake(0,0)  inView:self];
        _browse.shouldAnmial = NO;
        
        
         UIImage *_readIamge =[UIImage imageNamed:@"exhibition_home_yuedu"];
        
        _read = [[BaseButton alloc]initWithFrame:frame(CGRectGetMaxX(_browse.frame), frameY(_time), _browse.width, _collectionImage.size.height)  setTitle:@"22" titleSize:22*SpacedFonts titleColor:hexColor(c9c9c9) backgroundImage:nil iconImage:_readIamge highlightImage:nil setTitleOrgin:CGPointMake(1,5) setImageOrgin:CGPointMake(0,0)  inView:self];
        _read.shouldAnmial = NO;
       
        UIView *line =  [[UIView alloc]initWithFrame:CGRectMake(10, cellHeight -0.5,cellWidth - 10, 0.5)];
        line.backgroundColor = AppViewBGColor;
        [self addSubview:line];
    }
    
    return self;
}
- (void)setData:(ExhibitionIndustryRewarddatas *)model communityBlock:(void (^)(ExhibitionIndustryRewarddatas *data))communityBlock
{
  
    [[ToolManager shareInstance] imageView:_icon setImageWithURL:model.imgurl placeholderType:PlaceholderTypeOther];
    _descrip.text = model.title;
    
    NSString *_timeStr;
     
    if ([[[NSString stringWithFormat:@"%i",(int)model.rewardtime] countdownFormTimeInterval] intValue] ==-1) {
        _timeStr = @"已结束";
        [_time setImage:nil forState:UIControlStateNormal];
    }
    else
    {
        _timeStr =[[NSString stringWithFormat:@"%i",(int)model.rewardtime] countdownFormTimeInterval];
        [_time setImage:[UIImage imageNamed:@"exhibition_createtime"] forState:UIControlStateNormal];
    }
    [_time setTitle:_timeStr forState:UIControlStateNormal];
    
    
    [_browse setTitle:[NSString stringWithFormat:@"%@人",model.rewardforward] forState:UIControlStateNormal];
    [_browse textAndImageCenter];
    [_read setTitle:[NSString stringWithFormat:@"%@人",model.readcount] forState:UIControlStateNormal];
    [_read textAndImageCenter];
    
    [_redPaper setTitle:model.reward forState:UIControlStateNormal];
    [_redPaper textAndImageCenter];
    _redPaper.frame = CGRectMake(APPWIDTH - [_redPaper textAndImageCenter] - 5, _redPaper.y, [_redPaper textAndImageCenter], _redPaper.height);
    _descrip.frame = CGRectMake(_descrip.x, _descrip.y, APPWIDTH -_descrip.x- [_redPaper textAndImageCenter] -5 , _descrip.height);
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

