//
//  FnyApplyForCell.m
//  Lebao
//
//  Created by adnim on 16/11/2.
//  Copyright © 2016年 David. All rights reserved.
//

#import "FnyApplyForCell.h"
#import "Gallop.h"

@interface  FnyApplyForCell()<LWAsyncDisplayViewDelegate>
@property (nonatomic,strong) LWAsyncDisplayView* asyncDisplayView;
@property (nonatomic,strong) CALayer *cellline;
@property (nonatomic,strong) CALayer *line1;
@end
@implementation FnyApplyForCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.asyncDisplayView];
        [self.contentView addSubview:self.cancelBtn];
        [self.contentView.layer addSublayer:self.cellline];
        [self.contentView.layer addSublayer:self.line1];
        
        
    }
    return self;
}
#pragma mark
#pragma mark set some  frame
- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.asyncDisplayView.frame = CGRectMake(0,0,SCREEN_WIDTH,self.cellLayout.cellHeight);
    self.cellline.frame = self.cellLayout.cellMarginsRect;
    self.cancelBtn.frame = self.cellLayout.cancelBtnRect;
    self.line1.frame = self.cellLayout.line1Rect;
}

#pragma mark - Draw and setup
- (void)setCellLayout:(FnyApplyForCellLayout *)cellLayout{
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
        if ([_delegate respondsToSelector:@selector(tableViewCellDidSeleteHeadImg: layout:)] &&[_delegate conformsToProtocol:@protocol(FnyApplyForCellDelegate)]) {
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
- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        _cancelBtn.backgroundColor=AppMainColor;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelBtn.layer.cornerRadius=12;
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cancelBtn;
    
}

- (CALayer *)line1
{
    if (!_line1) {
        _line1 = [[CALayer alloc] init];
        _line1.backgroundColor = AppViewBGColor.CGColor;
    }
    
    return _line1;
}

#pragma mark
#pragma mark - some button actions
- (void)cancelBtnClick:(UIButton *)sender
{
    if ([_delegate conformsToProtocol:@protocol(FnyApplyForCellDelegate)]&&[_delegate respondsToSelector:@selector(tableViewCellDidSeleteCancelBtn:layout:)]) {
        [_delegate tableViewCellDidSeleteCancelBtn:sender layout:_cellLayout];
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
