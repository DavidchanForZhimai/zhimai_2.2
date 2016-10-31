//
//  MeettingTableViewCell.m
//  Lebao
//
//  Created by adnim on 16/9/9.
//  Copyright © 2016年 David. All rights reserved.
//

#import "MeettingTableViewCell.h"
#import "Gallop.h"
@interface  MeettingTableViewCell()<LWAsyncDisplayViewDelegate>
@property (nonatomic,strong) LWAsyncDisplayView* asyncDisplayView;

@property (nonatomic,strong) CALayer *cellline;
@property (nonatomic,strong) CALayer *line1;
@property (nonatomic,strong) CALayer *line2;
@end
@implementation MeettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.asyncDisplayView];
        [self.contentView addSubview:self.meetingBtn];
        [self.contentView addSubview:self.messageBtn];
        [self.contentView addSubview:self.refuseBtn];
        [self.contentView addSubview:self.agreeBtn];
        [self.contentView.layer addSublayer:self.cellline];
        [self.contentView.layer addSublayer:self.line1];
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
    self.messageBtn.frame=self.cellLayout.messageBtnRect;
    self.agreeBtn.frame=self.cellLayout.agreeBtnRect;
    self.refuseBtn.frame=self.cellLayout.refuseBtnRect;
    self.line1.frame = self.cellLayout.line1Rect;
    self.line2.frame = self.cellLayout.line2Rect;
}

#pragma mark - Draw and setup
- (void)setCellLayout:(MeetingCellLayout *)cellLayout {
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
#pragma mark -  LWAsyncDisplayViewDelegate
- (void)lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView didCilickedImageStorage:(LWImageStorage *)imageStorage touch:(UITouch *)touch
{
//    NSLog(@"lwAsyncDisplayView.tag=%li",imageStorage.tag);
    if (imageStorage.tag == 888) {
        if ([_delegate respondsToSelector:@selector(tableViewCellDidSeleteHeadImg: layout:)] &&[_delegate conformsToProtocol:@protocol(MeettingTableViewDelegate)]) {
            [_delegate tableViewCellDidSeleteHeadImg:imageStorage layout:_cellLayout];
        }
    }

    
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
        [_meetingBtn setTitle:@"约见" forState:UIControlStateNormal];
        [_meetingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _meetingBtn.layer.cornerRadius=12;
        [_meetingBtn addTarget:self action:@selector(meettingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _meetingBtn;
    
}
- (UIButton *)messageBtn
{
    if (!_messageBtn) {
        _messageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_messageBtn setImage:[UIImage imageNamed:@"duihua"] forState:UIControlStateNormal];
        _messageBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        _messageBtn.layer.cornerRadius=15;
        [_messageBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_messageBtn addTarget:self action:@selector(messageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _messageBtn;
    
}
- (UIButton *)refuseBtn
{
    if (!_refuseBtn) {
        _refuseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _refuseBtn.titleLabel.font=[UIFont systemFontOfSize:13];
        _refuseBtn.backgroundColor=[UIColor orangeColor];
        [_refuseBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        [_refuseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _refuseBtn.layer.cornerRadius=12;
        _refuseBtn.tag=2222;
        [_refuseBtn addTarget:self action:@selector(agreeAndrefuseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _refuseBtn;
    
}
- (UIButton *)agreeBtn
{
    if (!_agreeBtn) {
        _agreeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _agreeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
        _agreeBtn.backgroundColor=AppMainColor;
        [_agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        [_agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _agreeBtn.layer.cornerRadius=12;
        _agreeBtn.tag=2221;
        [_agreeBtn addTarget:self action:@selector(agreeAndrefuseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _agreeBtn;
    
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
- (void)messageBtnClick:(UIButton *)sender
{
    if ([_delegate conformsToProtocol:@protocol(MeettingTableViewDelegate)]&&[_delegate respondsToSelector:@selector(tableViewCellDidSeleteMessageBtn: andIndexPath:)]) {
        [_delegate tableViewCellDidSeleteMessageBtn:sender andIndexPath:_indexPath];
    }
}
- (void)agreeAndrefuseBtnClick:(UIButton *)sender
{
   
    if ([_delegate conformsToProtocol:@protocol(MeettingTableViewDelegate)]&&[_delegate respondsToSelector:@selector(tableViewCellDidSeleteAgreeAndRefuseBtn: layout:)]) {
        [_delegate tableViewCellDidSeleteAgreeAndRefuseBtn:sender layout:_cellLayout];
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
