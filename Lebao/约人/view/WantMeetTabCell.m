//
//  WantMeetTabCell.m
//  Lebao
//
//  Created by adnim on 16/9/12.
//  Copyright © 2016年 David. All rights reserved.
//

#import "WantMeetTabCell.h"

#import "Gallop.h"
@interface  WantMeetTabCell()<LWAsyncDisplayViewDelegate>
@property (nonatomic,strong) LWAsyncDisplayView* asyncDisplayView;

@property (nonatomic,strong) CALayer *cellline;
@property (nonatomic,strong) CALayer *line1;
@property (nonatomic,strong) CALayer *line2;
@end
@implementation WantMeetTabCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.asyncDisplayView];
        [self.contentView addSubview:self.meetingBtn];
        [self.contentView addSubview:self.telBtn];
        [self.contentView addSubview:self.messageBtn];
        [self.contentView.layer addSublayer:self.cellline];
        [self.contentView.layer addSublayer:self.line1];
        [self.contentView addSubview:self.audioBtn];
        [self.contentView.layer addSublayer:self.line2];
        
    }
    return self;
}
#pragma mark
#pragma mark set some  frame
- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.asyncDisplayView.frame = CGRectMake(0,0,SCREEN_WIDTH,self.cellLayout.cellHeight);
    self.cellline.frame = self.cellLayout.cellMarginsRect;
    self.meetingBtn.frame = self.cellLayout.meetBtnRect;
    self.line1.frame = self.cellLayout.line1Rect;
    self.audioBtn.frame=self.cellLayout.audioBtnRect;
    self.telBtn.frame=self.cellLayout.telBtnRect;
    self.messageBtn.frame=self.cellLayout.messageBtnRect;
    self.line2.frame = self.cellLayout.line2Rect;
}

#pragma mark - Draw and setup
- (void)setCellLayout:(WantMeetLayout *)cellLayout {
    if (_cellLayout == cellLayout) {
        return;
    }
    _cellLayout = cellLayout;
    self.asyncDisplayView.layout = self.cellLayout;
    
}

#pragma mark - Getter
- (LWAsyncDisplayView *)asyncDisplayView {
    if (!_asyncDisplayView) {
        _asyncDisplayView = [[LWAsyncDisplayView alloc] initWithFrame:CGRectZero];
        _asyncDisplayView.delegate = self;
    }
    return _asyncDisplayView;
}
- (CALayer *)cellline {
    if (!_cellline) {
        _cellline = [[CALayer alloc] init];
        _cellline.backgroundColor = AppViewBGColor.CGColor;
    }
    
    return _cellline;
}
- (UIButton *)meetingBtn
{
    if (!_meetingBtn) {
        _meetingBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _meetingBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        _meetingBtn.backgroundColor=AppMainColor;
        [_meetingBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_meetingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _meetingBtn.layer.cornerRadius=12;
        [_meetingBtn addTarget:self action:@selector(meettingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _meetingBtn;
    
}
- (UIButton *)telBtn
{
    if (!_telBtn) {
        _telBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_telBtn setImage:[UIImage  imageNamed:@"tonghua"] forState:UIControlStateNormal];
        [_telBtn addTarget:self action:@selector(TelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _telBtn;
    
}
- (UIButton *)messageBtn
{
    if (!_messageBtn) {
        _messageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_messageBtn setImage:[UIImage imageNamed:@"duihua"] forState:UIControlStateNormal];
        [_messageBtn addTarget:self action:@selector(messageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _messageBtn;
    
}
-(UIButton *)audioBtn
{
    if (!_audioBtn) {
        _audioBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _audioBtn.tag=1110;
        [_audioBtn setImage:[UIImage imageNamed:@"meet_yuyin"] forState:UIControlStateNormal];
        [_audioBtn addTarget:self action:@selector(audioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _audioBtn;
}
- (CALayer *)line1
{
    if (!_line1) {
        _line1 = [[CALayer alloc] init];
        _line1.backgroundColor = AppViewBGColor.CGColor;
    }
    
    return _line1;
}
- (CALayer *)line2
{
    if (!_line2) {
        _line2 = [[CALayer alloc] init];
        _line2.backgroundColor = AppViewBGColor.CGColor;
    }
    
    return _line2;
}

#pragma mark
#pragma mark - some button actions
- (void)meettingBtnClick:(UIButton *)sender
{
    if ([_delegate conformsToProtocol:@protocol(MeettingTableViewDelegate)]&&[_delegate respondsToSelector:@selector(tableViewCellDidSeleteMeetingBtn: andIndexPath:)]) {
        [_delegate tableViewCellDidSeleteMeetingBtn:sender andIndexPath:_indexPath];
    }
}
-(void)audioBtnClick:(UIButton *)sender
{
    if ([_delegate conformsToProtocol:@protocol(MeettingTableViewDelegate)]&&[_delegate respondsToSelector:@selector(tableViewCellDidSeleteAudioBtn: andIndexPath:)]) {
        [_delegate tableViewCellDidSeleteAudioBtn:sender andIndexPath:_indexPath];
    }
}
-(void)TelBtnClick:(UIButton *)sender
{
    if ([_delegate conformsToProtocol:@protocol(MeettingTableViewDelegate)]&&[_delegate respondsToSelector:@selector(tableViewCellDidSeleteAudioBtn: andIndexPath:)]) {
        [_delegate tableViewCellDidSeleteTelBtn:sender andIndexPath:_indexPath];
    }
}
-(void)messageBtnClick:(UIButton *)sender
{
    if ([_delegate conformsToProtocol:@protocol(MeettingTableViewDelegate)]&&[_delegate respondsToSelector:@selector(tableViewCellDidSeleteAudioBtn: andIndexPath:)]) {
        [_delegate tableViewCellDidSeleteMessageBtn:sender andIndexPath:_indexPath];
    }
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
