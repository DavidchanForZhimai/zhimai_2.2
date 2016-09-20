//
//  ClueCommunityCell.m
//  Lebao
//
//  Created by David on 16/5/23.
//  Copyright © 2016年 David. All rights reserved.
//

#import "ClueCommunityCell.h"
#import "UILabel+Extend.h"
#import "ToolManager.h"
#import "NSString+Extend.h"
#import "BaseButton.h"
@implementation ClueCommunityCell
{
    BaseButton *userIcon;
    UILabel *userNameLb;
    UILabel *userContent;
    UIImageView *isAuthen;
    UILabel *releaseTime;
    UIView *cell;
    UILabel *line;
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth{
    
    self =[self initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        cell = allocAndInitWithFrame(UIView, frame(10, 0, cellWidth - 20, cellHeight));
        cell.backgroundColor = WhiteColor;
        [self addSubview:cell];
        
        userIcon = [[BaseButton alloc]initWithFrame:frame(10, (cellHeight - 42)/2.0, 42, 42) backgroundImage:nil iconImage:nil highlightImage:nil inView:cell];
        userIcon.backgroundColor = WhiteColor;
        [userIcon setRound];
   
        userNameLb = [UILabel createLabelWithFrame:frame(CGRectGetMaxX(userIcon.frame) + 10, 17, frameWidth(cell) - (75+CGRectGetMaxX(userIcon.frame)) , 24*SpacedFonts) text:@"" fontSize:24*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
        
        userContent =[UILabel createLabelWithFrame:frame(frameX(userNameLb), CGRectGetMaxY(userNameLb.frame) + 10, frameWidth(cell) - (20+CGRectGetMaxX(userIcon.frame)) , 24*SpacedFonts) text:@"" fontSize:24*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
        userContent.numberOfLines = 0;
        
        isAuthen =allocAndInitWithFrame(UIImageView, frame(CGRectGetMaxX(userNameLb.frame) + 4,frameY(userNameLb), 12, 12));
        
        releaseTime = [UILabel createLabelWithFrame:frame(frameWidth(cell) - 90, frameY(userNameLb), 80, 24*SpacedFonts) text:@"" fontSize:22*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentRight inView:cell];
        
       line = [UILabel CreateLineFrame:frame(5, frameHeight(cell) - 0.5, frameWidth(cell) - 10, 0.5) inView:cell];
        [cell addSubview:isAuthen];
        
    }
    
    return self;
}

- (void)setModal:(ClueCommunityData *)data clueCommunityBlock:(ClueCommunityBlock)clueCommunityBlock
{
    userNameLb.text = data.realname;

    if (data.authen ==3) {
        isAuthen.image = [UIImage imageNamed:@"renzhen"];
       
        
    }
    else
    {
        isAuthen.image = [UIImage imageNamed:@"weirenzhen"];
    }
    CGSize size = [data.realname sizeWithFont:userNameLb.font maxSize:CGSizeMake(100, 24*SpacedFonts)];
    isAuthen.frame = frame(frameX(userNameLb) + size.width + 5, frameY(isAuthen), frameWidth(isAuthen), frameHeight(isAuthen));
    
    userContent.text = data.content;
    CGSize size2 = [userContent.text sizeWithFont:Size(24) maxSize:CGSizeMake(frameWidth(userContent), 1000)];
    
    if (size2.height>24*SpacedFonts) {
        userContent.frame = frame(frameX(userContent), frameY(userContent), frameWidth(userContent),size2.height);
        cell.frame = frame(frameX(cell), frameY(cell), frameWidth(cell), 62 -24*SpacedFonts + size2.height);
        line.frame =frame(frameX(line), frameHeight(cell) - 1, frameWidth(line), frameHeight(line));
    }
    
    [[ToolManager shareInstance] imageView:userIcon setImageWithURL:data.imgurl placeholderType:PlaceholderTypeUserHead];
    userIcon.didClickBtnBlock = ^
    {
        clueCommunityBlock(data.ID);
    };
    releaseTime.text = [[NSString stringWithFormat:@"%i",data.createtime] updateTime];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
