//
//  MessageCell.m
//  Lebao
//
//  Created by David on 15/12/10.
//  Copyright © 2015年 David. All rights reserved.
//

#import "MessageCell.h"
#import "ToolManager.h"
#import "UILabel+Extend.h"
#import "NSString+Extend.h"
@implementation MessageCell
{
    
    UILabel *_userName;
    UILabel *_descripLb;
    UILabel *_time;
    
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor =[UIColor clearColor];
        _userIcon = allocAndInitWithFrame(UIImageView, frame(10, (cellHeight - 33)/2.0, 33, 33));
        [self addSubview:_userIcon];
        
        _userName = [UILabel createLabelWithFrame:frame(CGRectGetMaxX(_userIcon.frame) + 10,11, cellWidth - CGRectGetMaxX(_userIcon.frame)  -100,24*SpacedFonts) text:@""fontSize:24*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:self];
        
        _message = [UILabel createLabelWithFrame:frame(CGRectGetMaxX(_userIcon.frame) - 8, frameY(_userIcon) - 4, 12, 12) text:@"1" fontSize:16*SpacedFonts textColor:WhiteColor textAlignment:NSTextAlignmentCenter inView:self];
      
        _message.backgroundColor = [UIColor colorWithRed:0.8627 green:0.098 blue:0.1333 alpha:1.0];
        
        _descripLb =[UILabel createLabelWithFrame:frame(frameX(_userName),CGRectGetMaxY(_userName.frame) +10,cellWidth -frameX(_userName) - 10, 20*SpacedFonts) text:@""fontSize:20*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:self];
        
        
        _time =[UILabel createLabelWithFrame:frame(cellWidth - 70,frameY(_userName),60, 20*SpacedFonts) text:@""fontSize:20*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentRight inView:self];
        
        [UILabel CreateLineFrame:frame(45, cellHeight - 0.5, cellWidth-45, 0) inView:self];
        
    
    }
    return self;
    
}
- (void)setData:(NotificationData *)modal
{
    
    if (![modal.imgurl isEqualToString:@"AppIconLogo"]) {
        [[ToolManager shareInstance] imageView:_userIcon setImageWithURL:modal.imgurl placeholderType:PlaceholderTypeUserHead];
        [_userIcon setRound];
    }
    else
    {
        self.userIcon.image = [UIImage imageNamed:@"AppIconLogo"];
        [self.userIcon setRadius:1];
    }
   
    _userName.text = modal.realname;
    _descripLb.text = modal.content;
    _time.text = [modal.createtime timeformatString:@"yyyy-MM-dd"];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
