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
{
    
    DWLable *_descrip;
    
    BaseButton *_time;
    BaseButton  *_browse;
//    BaseButton *_collection;
    UILabel *_author;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth
{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        _icon = allocAndInitWithFrame(UIImageView, frame(10, (cellHeight - 57)/2.0, 78, 57));
         [_icon setRadius:8];
        [self addSubview:_icon];
    
        _descrip = [DWLable createLabelWithFrame:frame(CGRectGetMaxX(_icon.frame) + 10, 10, cellWidth - (CGRectGetMaxX(_icon.frame) + 20), cellHeight - 22*SpacedFonts - 15) text:@"" fontSize:26*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:self];
        _descrip.numberOfLines = 0;
        _descrip.verticalAlignment = VerticalAlignmentTop;
        
        UIImage *imagetime =[UIImage imageNamed:@"exhibition_time"];
        UILabel *time =allocAndInit(UILabel);
        CGSize sizeTime = [time sizeWithContent:@"2015 - 12 - 31" font:[UIFont systemFontOfSize:22*SpacedFonts]];
        
        _time = [[BaseButton alloc]initWithFrame:frame(frameX(_descrip), cellHeight - 8 -imagetime.size.height , imagetime.size.width + 5 + sizeTime.width, imagetime.size.height-2)  setTitle:@"" titleSize:22*SpacedFonts titleColor:LightBlackTitleColor backgroundImage:nil iconImage:imagetime highlightImage:nil setTitleOrgin:CGPointMake(0,5) setImageOrgin:CGPointMake(0,0)  inView:self];
        _time.shouldAnmial = NO;
    
        
        UIImage *image =[UIImage imageNamed:@"exhibition_brose"];
        CGSize sizebrowse = [time sizeWithContent:@"2015" font:[UIFont systemFontOfSize:22*SpacedFonts]];
        
        _browse = [[BaseButton alloc]initWithFrame:frame(cellWidth - image.size.width - sizebrowse.width - 15, frameY(_time), image.size.width + 5 + sizebrowse.width, image.size.height)  setTitle:@"" titleSize:22*SpacedFonts titleColor:LightBlackTitleColor backgroundImage:nil iconImage:image highlightImage:nil setTitleOrgin:CGPointMake(1,5) setImageOrgin:CGPointMake(0,0)  inView:self];
       _browse.shouldAnmial = NO;
        
        
//        UIImage *_collectionImage =[UIImage imageNamed:@"icon_discover_shoucang"];
//        CGSize sizecollection = [time sizeWithContent:@"2015" font:[UIFont systemFontOfSize:22*SpacedFonts]];
        
//        _collection = [[BaseButton alloc]initWithFrame:frame(frameX(_browse) - _collectionImage.size.width - sizecollection.width - 15, frameY(_time), _collectionImage.size.width + 5 + sizecollection.width, _collectionImage.size.height)  setTitle:@"22" titleSize:22*SpacedFonts titleColor:LightBlackTitleColor backgroundImage:nil iconImage:_collectionImage highlightImage:nil setTitleOrgin:CGPointMake(1,5) setImageOrgin:CGPointMake(0,0)  inView:self];
//        _collection.shouldAnmial = NO;
        _author = [UILabel createLabelWithFrame:frame(CGRectGetMaxX(_time.frame) + 2, frameY(_time), 6*22*SpacedFonts, 25*SpacedFonts) text:@"作者:" fontSize:22*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:self];
        
    }
   
    return self;
}
- (void)setData:(ExhibitionIndustryReadmost *)model
{
   
    
    [[ToolManager shareInstance] imageView:_icon setImageWithURL:model.imgurl  placeholderType:PlaceholderTypeOther];
    
    [_time setTitle:[[NSString stringWithFormat:@"%i",(int)model.createdate] timeformatString:@"yyyy-MM-dd"] forState:UIControlStateNormal];
    
    _descrip.text = model.title;
    CGSize size = [_descrip sizeWithContent:_descrip.text font:[UIFont systemFontOfSize:26*SpacedFonts]];
    _descrip.frame = frame(frameX(_descrip), frameY(_descrip),frameWidth(_descrip), 2*size.height + 5);

    [_browse setTitle:model.readcover forState:UIControlStateNormal];
    _author.text = [NSString stringWithFormat:@"作者:%@",model.author];
//     CGSize size =[_num sizeWithContent:model.number font:[UIFont systemFontOfSize:9*SpacedFonts]];
//    _browse.frame = frame(APPWIDTH - 22*ScreenMultiple - size.width - _browse.image.size.width, frameY(_browse), frameWidth(_browse), frameHeight(_browse));
//    
//    _num.frame = frame(CGRectGetMaxX(_browse.frame) +3*ScreenMultiple, frameY(_num), size.width, frameHeight(_num));
    
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation ExhibitionRedPaperCell
{

    DWLable *_descrip;
    BaseButton *_time;
    BaseButton  *_browse;
    BaseButton *_redPaper;
    BaseButton *_communicationsBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth
{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        _icon = allocAndInitWithFrame(UIImageView, frame(10, (cellHeight - 57)/2.0, 78, 57));
         [_icon setRadius:5];
        [self addSubview:_icon];
        
        _descrip = [DWLable createLabelWithFrame:frame(CGRectGetMaxX(_icon.frame) + 10, 10, cellWidth - (CGRectGetMaxX(_icon.frame) + 70), cellHeight - 22*SpacedFonts - 15) text:@"" fontSize:26*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:self];
        _descrip.numberOfLines = 0;
        _descrip.verticalAlignment = VerticalAlignmentTop;
        
        UIImage *imagetime =[UIImage imageNamed:@"exhibition_createtime"];
        UILabel *time =allocAndInit(UILabel);
        CGSize sizeTime = [time sizeWithContent:@" 22:00 " font:[UIFont systemFontOfSize:22*SpacedFonts]];
        
        _time = [[BaseButton alloc]initWithFrame:frame(frameX(_descrip), cellHeight - 8 -imagetime.size.height , imagetime.size.width + 5 + sizeTime.width, imagetime.size.height-2)  setTitle:@"" titleSize:22*SpacedFonts titleColor:LightBlackTitleColor backgroundImage:nil iconImage:imagetime highlightImage:nil setTitleOrgin:CGPointMake(0,5) setImageOrgin:CGPointMake(0,0)  inView:self];
        _time.shouldAnmial = NO;
        
        
        UIImage *image =[UIImage imageNamed:@"exhibition_redPaper"];
        CGSize sizebrowse = [time sizeWithContent:@"¥2015" font:[UIFont systemFontOfSize:22*SpacedFonts]];
        
        _redPaper = [[BaseButton alloc]initWithFrame:frame(cellWidth - image.size.width - sizebrowse.width - 15, frameY(_descrip) + 10, image.size.width + 5 + sizebrowse.width, image.size.height)  setTitle:@"¥20" titleSize:22*SpacedFonts titleColor:[UIColor redColor] backgroundImage:nil iconImage:image highlightImage:nil setTitleOrgin:CGPointMake(1,5) setImageOrgin:CGPointMake(0,0)  inView:self];
        _redPaper.shouldAnmial = NO;
        
        
        UIImage *_collectionImage =[UIImage imageNamed:@"exhibition_clueNum"];
        CGSize sizecollection = [time sizeWithContent:@"2015人" font:[UIFont systemFontOfSize:22*SpacedFonts]];
        
        _browse = [[BaseButton alloc]initWithFrame:frame(CGRectGetMaxX(_time.frame) + 25, frameY(_time), _collectionImage.size.width + 5 + sizecollection.width, _collectionImage.size.height)  setTitle:@"22" titleSize:22*SpacedFonts titleColor:LightBlackTitleColor backgroundImage:nil iconImage:_collectionImage highlightImage:nil setTitleOrgin:CGPointMake(1,5) setImageOrgin:CGPointMake(0,0)  inView:self];
        _browse.shouldAnmial = NO;
        
        
        UIImage *_communicationImgs =[UIImage imageNamed:@"across_home_communication"];
         CGSize size  =[[NSString stringWithFormat:@"(1234)"] sizeWithFont:Size(20) maxSize:CGSizeMake(0, _communicationImgs.size.height)];
        
        _communicationsBtn = [[BaseButton alloc]initWithFrame:frame(cellWidth - 25- size.width - _communicationImgs.size.width, frameY(_browse), 15 +size.width + _communicationImgs.size.width , _communicationImgs.size.height) setTitle:@"(20)" titleSize:20*SpacedFonts titleColor:LightBlackTitleColor backgroundImage:nil iconImage:_communicationImgs highlightImage:nil setTitleOrgin:CGPointMake(0, 17) setImageOrgin:CGPointMake(0, 10 ) inView:self ];
        _communicationsBtn.exclusiveTouch = YES;
        
    }
    
    return self;
}
- (void)setData:(ExhibitionIndustryRewarddatas *)model communityBlock:(void (^)(ExhibitionIndustryRewarddatas *data))communityBlock
{
  
    [[ToolManager shareInstance] imageView:_icon setImageWithURL:model.imgurl placeholderType:PlaceholderTypeOther];
    
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
    
    _descrip.text = model.title;
    CGSize size = [_descrip sizeWithContent:_descrip.text font:[UIFont systemFontOfSize:26*SpacedFonts]];
    _descrip.frame = frame(frameX(_descrip), frameY(_descrip),frameWidth(_descrip), 2*size.height + 5);
    
    [_browse setTitle:[NSString stringWithFormat:@"%@人",model.rewardforward] forState:UIControlStateNormal];
    
    [_redPaper setTitle:model.reward forState:UIControlStateNormal];
    
    if (model.istalk) {
        [_communicationsBtn setTitleColor:AppMainColor forState:UIControlStateNormal];
        [_communicationsBtn setImage:[UIImage imageNamed:@"across_home_communication"] forState:UIControlStateNormal];
    }
    else
    {
        [_communicationsBtn setTitleColor:LightBlackTitleColor forState:UIControlStateNormal];
        [_communicationsBtn setImage:[UIImage imageNamed:@"across_home_communication"] forState:UIControlStateNormal];
    }
    [_communicationsBtn setTitle:[NSString stringWithFormat:@"(%@)",model.comsum] forState:UIControlStateNormal];
    
    if (model.isspread) {
        
        _communicationsBtn.didClickBtnBlock = ^
        {
            
            communityBlock(model);

        };
        
    }
    else
    {
        _communicationsBtn.didClickBtnBlock = ^
        {
            [[ToolManager shareInstance] showAlertViewTitle:nil contentText:@"传播转发才能交流" showAlertViewBlcok:^{
                
            }];
  
        };
    }
    
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

