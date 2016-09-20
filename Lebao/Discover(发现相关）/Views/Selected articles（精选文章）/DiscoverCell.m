//
//  DiscoverCell.m
//  Lebao
//
//  Created by David on 15/12/7.
//  Copyright © 2015年 David. All rights reserved.
//

#import "DiscoverCell.h"
//工具类
#import "ToolManager.h"
#import "UILabel+Extend.h"
#import "NSString+Extend.h"
@implementation DiscoverCell
{
   
    DWLable *_descrip;
    UILabel *_time;
    
    UIImageView  *_share;
    UILabel      *_sharenum;
    UIImageView  *_browse;
    UILabel      *_num;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor =[UIColor clearColor];
        UIView *cell = allocAndInitWithFrame(UIView, frame(0, 0, cellWidth, cellHeight));
        cell.backgroundColor =[UIColor whiteColor];
        [self addSubview:cell];
        
        _icon = allocAndInitWithFrame(UIImageView, frame(10, (frameHeight(cell) - 72)/2.0, 72, 63));
        _icon.layer.masksToBounds = YES;
        _icon.layer.cornerRadius = 8;
        _icon.contentMode =ViewContentMode;
        [cell addSubview:_icon];
        
        _descrip = [DWLable createLabelWithFrame:frame(CGRectGetMaxX(_icon.frame) + 6, frameY(_icon), cellWidth - (CGRectGetMaxX(_icon.frame) + 15), 48.0*SpacedFonts+5) text:@"" fontSize:24.0*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
        _descrip.numberOfLines = 0;
        _descrip.verticalAlignment = VerticalAlignmentTop;
    
        
        _time = [UILabel createLabelWithFrame:frame(frameX(_descrip), CGRectGetMaxY(_icon.frame)  - 20*SpacedFonts, 150*SpacedFonts, 20.0*SpacedFonts) text:@"2015-11-19" fontSize:20.0*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
        
         UIImage *imageShare =[UIImage imageNamed:@"icon_discover_font-share"];
         UIImage *image =[UIImage imageNamed:@"icon_discover_shoucang"];
        
        _share = allocAndInitWithFrame(UIImageView, frame(cellWidth - 15 -80*SpacedFonts - imageShare.size.width, frameY(_time) +(20.0*SpacedFonts  - imageShare.size.height)/2.0, imageShare.size.width, imageShare.size.height));
        _share.image = imageShare;
        [cell addSubview:_share];
        
        _sharenum =[UILabel createLabelWithFrame:frame(CGRectGetMaxX(_share.frame) + 5, frameY(_time), 80.0*SpacedFonts,frameHeight(_time)) text:@"363次" fontSize:20.0*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
        
       
        _browse = allocAndInitWithFrame(UIImageView, frame(frameX(_share) - 25 - 80*SpacedFonts -image.size.width, frameY(_share), image.size.width, image.size.height));
        _browse.image = image;
        [cell addSubview:_browse];
        
        _num =[UILabel createLabelWithFrame:frame(CGRectGetMaxX(_browse.frame) +5, frameY(_time), 80.0*SpacedFonts, frameHeight(_time)) text:@"562人" fontSize:20.0*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
        
        [UILabel CreateLineFrame:frame(0, cellHeight - 0.5, APPWIDTH, 0.5) inView:cell];
    }
    
    return self;
}
- (void)setModel:(DiscoverDataModel *)model
{
    [[ToolManager shareInstance] imageView:_icon setImageWithURL:model.imgurl placeholderType:PlaceholderTypeOther];
    
    _descrip.text =model.title;
    _time.text = [model.createtime timeformatString:@"yyyy-MM-dd"];
    _sharenum.text = model.forwardcount;
    _num.text = model.readcount;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation DiscoverFirstCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth datas:(NSMutableArray *)datas
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        self.backgroundColor =[UIColor whiteColor];
    
        _banner = [[WHC_Banner alloc] initWithFrame:frame(0, 0, cellWidth, 0.4*cellWidth)];
        
        _banner.backgroundColor = WhiteColor;
        _banner.imageUrls  = allocAndInit(NSMutableArray);
        _banner.imageTitles = allocAndInit(NSMutableArray);
        
        for (DiscoverImageDataModel *data in datas) {
            if (data.upimgurl) {
                [_banner.imageUrls addObject:data.upimgurl];
            }
            else
            {
                [_banner.imageUrls addObject:@""];
            }
           
            if (data.title) {
                [_banner.imageTitles addObject:data.title];
            }
            else
            {
                [_banner.imageTitles addObject:@""];
            }

            
        }
       // NSLog(@"imageTitles =%@ upimgurl =%@",_banner.imageTitles,_banner.imageUrls);
        [_banner setNetworkLoadingImageBlock:^(UIImageView *imageView, NSString *url, NSInteger index) {
            
            [[ToolManager shareInstance] imageView:imageView setImageWithURL:url placeholderType:PlaceholderTypeImageUnProcessing];
        }];
               
        [_banner startBanner];
        [self addSubview:_banner];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end

