//
//  MessageCell.m
//  QQ聊天布局
//
//  Created by TianGe-ios on 14-8-19.
//  Copyright (c) 2014年 TianGe-ios. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CommunityMessageCell.h"
#import "CellFrameModel.h"
#import "MessageModel.h"
#import "UIImage+Extend.h"
#import "ToolManager.h"
#import "BaseButton.h"
@interface CommunityMessageCell()
{
    UILabel *_timeLabel;
    BaseButton*_iconView;
    UIButton *_textView;
}
@end

@implementation CommunityMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = nil;
        self.backgroundColor = [UIColor clearColor];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = BlackTitleColor;
        _timeLabel.font = [UIFont systemFontOfSize:20*SpacedFonts];
        [self.contentView addSubview:_timeLabel];
        
        _iconView = [[BaseButton alloc] initWithFrame:CGRectZero backgroundImage:nil iconImage:nil highlightImage:nil inView:self.contentView];
       
        
        _textView = [UIButton buttonWithType:UIButtonTypeCustom];
        _textView.titleLabel.numberOfLines = 0;
        _textView.titleLabel.font = [UIFont systemFontOfSize:24*SpacedFonts];
        _textView.contentEdgeInsets = UIEdgeInsetsMake(textPadding, textPadding, textPadding, textPadding);
        [self.contentView addSubview:_textView];
    }
    return self;
}

- (void)setCellFrame:(CellFrameModel *)cellFrame
{
    _cellFrame = cellFrame;
    MessageModel *message = cellFrame.message;
    
    _timeLabel.frame = cellFrame.timeFrame;
    _timeLabel.text = message.time;
    
    _iconView.frame = cellFrame.iconFrame;

    [[ToolManager shareInstance] imageView:_iconView setImageWithURL:message.imageurl placeholderType:PlaceholderTypeUserHead];
    __weak typeof(self) weakSelf = self;
    _iconView.didClickBtnBlock = ^{
        if (weakSelf.didClickIcon) {
            weakSelf.didClickIcon(cellFrame);
        }
    };
    
    _textView.frame = cellFrame.textFrame;
    NSString *textBg = message.type ? @"chat_recive_nor" : @"chat_send_nor";
    UIColor *textColor = message.type ? [UIColor blackColor] : [UIColor whiteColor];
    [_textView setTitleColor:textColor forState:UIControlStateNormal];
    [_textView setBackgroundImage:[UIImage resizeImage:textBg] forState:UIControlStateNormal];
    [_textView setTitle:message.text forState:UIControlStateNormal];
}

@end
