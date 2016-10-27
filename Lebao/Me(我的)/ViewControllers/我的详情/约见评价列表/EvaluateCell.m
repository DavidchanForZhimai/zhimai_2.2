//
//  EvaluateCell.m
//  Lebao
//
//  Created by adnim on 16/10/26.
//  Copyright © 2016年 David. All rights reserved.
//

#import "EvaluateCell.h"
@interface  EvaluateCell()<LWAsyncDisplayViewDelegate>
@property (nonatomic,strong) LWAsyncDisplayView* asyncDisplayView;
@end
@implementation EvaluateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.asyncDisplayView];
        [self.contentView.layer addSublayer:self.cellline];
        [self.contentView.layer addSublayer:self.lineV];
        
    }
    return self;
}
#pragma mark
#pragma mark set some  frame
- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.asyncDisplayView.frame = CGRectMake(0,0,SCREEN_WIDTH,self.evaluateLayout.cellHeight);
    self.cellline.frame = self.evaluateLayout.cellMarginsRect;
    self.lineV.frame = self.evaluateLayout.lineV1Rect;
}

#pragma mark - Draw and setup
- (void)setEvaluateLayout:(EvaluateLayout *)evaluateLayout{
    if (_evaluateLayout == evaluateLayout) {
        return;
    }
    
    _evaluateLayout = evaluateLayout;
    self.asyncDisplayView.layout = self.evaluateLayout;
    
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

- (CALayer *)lineV
{
    if (!_lineV) {
        _lineV= [[CALayer alloc] init];
        _lineV.backgroundColor = AppViewBGColor.CGColor;
    }
    
    return _lineV;
}

#pragma mark -  LWAsyncDisplayViewDelegate
- (void)lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView didCilickedImageStorage:(LWImageStorage *)imageStorage touch:(UITouch *)touch
{
    //    NSLog(@"lwAsyncDisplayView.tag=%li",imageStorage.tag);
    if (imageStorage.tag == 888) {
        if ([_delegat respondsToSelector:@selector(tableViewCellDidSeleteHeadImg:layout:)] &&[_delegat conformsToProtocol:@protocol(EvaluateTableViewDelegate)]) {
            [_delegat tableViewCellDidSeleteHeadImg:imageStorage layout:_evaluateLayout];
        }
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
