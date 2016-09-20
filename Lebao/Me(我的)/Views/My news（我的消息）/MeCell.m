//
//  MeCell.m
//  Lebao
//
//  Created by David on 15/12/7.
//  Copyright © 2015年 David. All rights reserved.
//

#import "MeCell.h"
#import "ToolManager.h"
#import "UILabel+Extend.h"
@implementation MeCell
{
    UIImageView *_leftImages;
    UILabel   *_title;
    UILabel *_line;
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        
        self.backgroundColor =[UIColor whiteColor];
        _leftImages = allocAndInitWithFrame(UIImageView, frame(0, 0, 0, 0));
        [self addSubview:_leftImages];
        
        _title = [UILabel createLabelWithFrame:frame(45,0, 28.0*SpacedFonts*5, cellHeight) text:@"" fontSize:28.0*SpacedFonts textColor:hexColor(5a5a5a) textAlignment:NSTextAlignmentLeft inView:self];
        
        _detail =[UILabel createLabelWithFrame:frame(CGRectGetMaxX(_title.frame) + 5,0, cellWidth/2.0, cellHeight) text:@"" fontSize:24.0*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:self];
        _detail.hidden = YES;
        
        UIImage *image =[UIImage imageNamed:@"option"];
        UIImageView *assorry =allocAndInitWithFrame(UIImageView, frame(cellWidth - 13 - image.size.width, (cellHeight - image.size.height)/2.0, image.size.width, image.size.height));
        assorry.image = image; 
        [self addSubview:assorry];
        
        _authen =[UILabel createLabelWithFrame:CGRectMake(cellWidth - 80*SpacedFonts - image.size.width -22, (cellHeight - 18)/2.0, 80*SpacedFonts, 18) text:@"未认证" fontSize:20*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:self];
        [_authen setRadius:5.0];
        [_authen setBorder:LightBlackTitleColor width:0.5];
        _authen.hidden = YES;
        
        _message  = [UILabel createLabelWithFrame:frame(cellWidth - image.size.width -25, (cellHeight - 5)/2.0, 5, 5) text:@"" fontSize:0 textColor:[UIColor colorWithRed:0.8667 green:0.0941 blue:0.1255 alpha:1.0] textAlignment:0 inView:self];
        [_message setRound];
        _message.backgroundColor =[UIColor colorWithRed:0.8667 green:0.0941 blue:0.1255 alpha:1.0];
        _message.hidden = YES;
        
       _line = [UILabel CreateLineFrame:frame(frameX(_title) , cellHeight - 0.5, cellWidth -(frameX(_title)), 0.5) inView:self];
        
    }
    
    return self;
    
}

- (void)setLeftImage:(NSString *)img  Title:(NSString *)title isShowLine:(BOOL)isShowLine
{
    _line.hidden = !isShowLine;
    [self setLeftImage:img Title:title rightImage:nil];
}
- (void)setLeftImage:(NSString *)img  Title:(NSString *)title rightImage:(NSString *)rightImg
{
    
    _leftImages.image  =[UIImage imageNamed:img];
    _leftImages.frame = frame(10, (40 - _leftImages.image.size.height)/2.0, _leftImages.image.size.width,_leftImages.image.size.height);
    _title.text  =title;

    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
