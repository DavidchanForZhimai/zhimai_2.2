//
//  DWActionSheetView.m
//  Lebao
//
//  Created by David on 16/1/12.
//  Copyright © 2016年 David. All rights reserved.
//

#import "DWActionSheetView.h"
#import "ToolManager.h"
#import "UILabel+Extend.h"
#define kRowHeight 48.0f
#define kRowLineHeight 0.5f
#define kSeparatorHeight 5.0f

#define kTitleFontSize 13.0f
#define kButtonTitleFontSize 17.0f

#define kTextViewHight 67.0f
@interface DWActionSheetView ()<UITextViewDelegate>
{
    UIView      *_backView;
    UIView *_actionSheetView;
    CGFloat _actionSheetHeight;
    BOOL        _isShow;
    
    UITextView  *_textView;
    UILabel     *_placeTextView;
}

@property (nonatomic, copy)  NSString *title;
@property (nonatomic, copy)  NSString *cancelButtonTitle;
@property (nonatomic, copy)  NSString *destructiveButtonTitle;
@property (nonatomic, copy) NSArray *otherButtonTitles;
@property (nonatomic, copy) DWActionSheetViewDidSelectButtonBlock selectRowBlock;
@property (nonatomic, copy) DWShareViewDidSelectButtonBlock selectShareViewRowBlock;
@end


@implementation DWActionSheetView

- (void)dealloc
{
    self.title= nil;
    self.cancelButtonTitle = nil;
    self.destructiveButtonTitle = nil;
    self.otherButtonTitles = nil;
    self.selectRowBlock = nil;
    self.selectShareViewRowBlock =nil;
    
    _actionSheetView = nil;
    _backView = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        CGRect frame = [UIScreen mainScreen].bounds;
        self.frame = frame;
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles handler:(DWActionSheetViewDidSelectButtonBlock)block;
{
    self = [self init];
    
    if (self)
    {
        _title = title;
        _cancelButtonTitle = cancelButtonTitle;
        _destructiveButtonTitle = destructiveButtonTitle;
        _otherButtonTitles = otherButtonTitles;
        _selectRowBlock = block;
        
        _backView = [[UIView alloc] initWithFrame:self.frame];
        _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        _backView.alpha = 0.0f;
        [self addSubview:_backView];
        
        _actionSheetView = [[UIView alloc] init];
        _actionSheetView.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
        [self addSubview:_actionSheetView];
        
        CGFloat offy = 0;
        CGFloat width = self.frame.size.width;
        
        UIImage *normalImage = [self imageWithColor:[UIColor whiteColor]];
        UIImage *highlightedImage = [self imageWithColor:[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        
        if (_title && _title.length>0)
        {
            CGFloat spacing = 15.0f;
            
            CGFloat titleHeight = ceil([_title boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kTitleFontSize]} context:nil].size.height) + spacing*2;
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, titleHeight)];
            titleLabel.backgroundColor = [UIColor whiteColor];
            titleLabel.textColor = [UIColor colorWithRed:111.0f/255.0f green:111.0f/255.0f blue:111.0f/255.0f alpha:1.0f];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
            titleLabel.numberOfLines = 0;
            titleLabel.text = _title;
            [_actionSheetView addSubview:titleLabel];
            
            offy += titleHeight+kRowLineHeight;
        }
        
        if ([_otherButtonTitles count] > 0)
        {
            for (int i = 0; i < _otherButtonTitles.count; i++)
            {
                UIButton *btn = [[UIButton alloc] init];
                btn.frame = CGRectMake(0, offy, width, kRowHeight);
                btn.tag = i;
                btn.backgroundColor = [UIColor whiteColor];
                btn.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn setTitle:_otherButtonTitles[i] forState:UIControlStateNormal];
                [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
                [btn setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
                [btn addTarget:self action:@selector(didSelectAction:) forControlEvents:UIControlEventTouchUpInside];
                [_actionSheetView addSubview:btn];
                
                offy += kRowHeight+kRowLineHeight;
            }
            
            offy -= kRowLineHeight;
        }
        
        if (_destructiveButtonTitle && _destructiveButtonTitle.length>0)
        {
            offy += kRowLineHeight;
            
            UIButton *destructiveButton = [[UIButton alloc] init];
            destructiveButton.frame = CGRectMake(0, offy, width, kRowHeight);
            destructiveButton.tag = [_otherButtonTitles count] ?: 0;
            destructiveButton.backgroundColor = [UIColor whiteColor];
            destructiveButton.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize];
            [destructiveButton setTitleColor:[UIColor colorWithRed:255.0f/255.0f green:10.0f/255.0f blue:10.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [destructiveButton setTitle:_destructiveButtonTitle forState:UIControlStateNormal];
            [destructiveButton setBackgroundImage:normalImage forState:UIControlStateNormal];
            [destructiveButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
            [destructiveButton addTarget:self action:@selector(didSelectAction:) forControlEvents:UIControlEventTouchUpInside];
            [_actionSheetView addSubview:destructiveButton];
            
            offy += kRowHeight;
        }
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, offy, width, kSeparatorHeight)];
        separatorView.backgroundColor = [UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
        [_actionSheetView addSubview:separatorView];
        
        offy += kSeparatorHeight;
        
        
        UIButton *cancelBtn = [[UIButton alloc] init];
        cancelBtn.frame = CGRectMake(0, offy, width, kRowHeight);
        cancelBtn.tag = -1;
        cancelBtn.backgroundColor = [UIColor whiteColor];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn setTitle:_cancelButtonTitle ?: @"取消" forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:normalImage forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
        [cancelBtn addTarget:self action:@selector(didSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [_actionSheetView addSubview:cancelBtn];
        
        offy += kRowHeight;
        
        _actionSheetHeight = offy;
        
        _actionSheetView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), _actionSheetHeight);
    }
    
    return self;
}

+ (DWActionSheetView *)showActionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles handler:(DWActionSheetViewDidSelectButtonBlock)block;
{
    DWActionSheetView *actionSheetView = [[DWActionSheetView alloc] initWithTitle:title cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles handler:block];
    
    return actionSheetView;
}



//分享按钮

- (instancetype)initShareViewWithTitle:(NSString *)title otherButtonTitles:(NSArray *)otherButtonTitles handler:(DWShareViewDidSelectButtonBlock)block
{
    self = [self init];
    
    if (self)
    {
        _title = title;

        _otherButtonTitles = otherButtonTitles;
        _selectShareViewRowBlock = block;
        
        _backView = [[UIView alloc] initWithFrame:self.frame];
        _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        _backView.alpha = 0.0f;
        [self addSubview:_backView];
        
        _actionSheetView = [[UIView alloc] init];
        _actionSheetView.backgroundColor = WhiteColor;
        [self addSubview:_actionSheetView];
        
        CGFloat offy = 0;
        CGFloat width = self.frame.size.width;
        
        
        
//        if (_title && _title.length>0)
//        {
//            
//            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 31, width, 28*SpacedFonts)];
//            titleLabel.backgroundColor = [UIColor whiteColor];
//            titleLabel.textColor = AppMainColor;
//            titleLabel.textAlignment = NSTextAlignmentCenter;
//            titleLabel.font = [UIFont systemFontOfSize:28*SpacedFonts];
//            titleLabel.numberOfLines = 0;
//            titleLabel.text = _title;
//            [_actionSheetView addSubview:titleLabel];
//            
//            offy += CGRectGetMaxY(titleLabel.frame)+18;
//        }
//        
//        //
//        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        cancelBtn.tag = -1;
//        cancelBtn.frame =CGRectMake(width - 50, 0, 50, 35);
//        [cancelBtn setImage:[UIImage imageNamed:@"chacha"] forState:UIControlStateNormal];
//        [cancelBtn addTarget:self action:@selector(didSelectAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_actionSheetView addSubview:cancelBtn];
//        
//        //
//        _textView = allocAndInitWithFrame(UITextView, frame(10, offy, width -20, kTextViewHight));
//        _textView.layer.borderColor = LineBg.CGColor;
//        _textView.layer.borderWidth = 0.5;
//        _textView.layer.cornerRadius = 8;
//        _textView.font =[UIFont systemFontOfSize:24*SpacedFonts];
//        _textView.textColor =BlackTitleColor;
//        _textView.delegate =self;
//         [_actionSheetView addSubview:_textView];
//        
//        _placeTextView = [UILabel createLabelWithFrame:frame(5, 10, frameWidth(_textView) -10, 24*SpacedFonts) text:@"请输入您想说的" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:_textView];
//        _placeTextView.enabled = NO;

         offy += frameHeight(_textView) + 23;
        
        if ([_otherButtonTitles count] > 0)
        {
            [UILabel CreateLineFrame:frame(10, offy, 115*
                                           ScreenMultiple, 0.5) inView:_actionSheetView];
            [UILabel CreateLineFrame:frame(width - 115*ScreenMultiple -10 , offy, 115*ScreenMultiple, 0.5) inView:_actionSheetView];
            
            [UILabel createLabelWithFrame:frame(0, offy - 5, width, 24*SpacedFonts) text:@"分享到" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:_actionSheetView];
            
            offy += 21;
            for (int i = 0; i < _otherButtonTitles.count; i++)
            {
                UIButton *btn = [[UIButton alloc] init];
                
                btn.tag = i;
                btn.backgroundColor = [UIColor whiteColor];

                [btn setBackgroundImage:[UIImage imageNamed:_otherButtonTitles[i]] forState:UIControlStateNormal];
                btn.frame = CGRectMake((width - 96*ScreenMultiple - 53*ScreenMultiple)/2 + (48 +53)*ScreenMultiple*i, offy, 48*ScreenMultiple, 48*ScreenMultiple);
                btn.layer.cornerRadius = frameWidth(btn)/2.0;
                btn.layer.masksToBounds =YES;
                [btn addTarget:self action:@selector(didSelectAction:) forControlEvents:UIControlEventTouchUpInside];
                
                [_actionSheetView addSubview:btn];
                
            
            }
           

        }
        
        offy += 22 + 48*ScreenMultiple;
        _actionSheetHeight = offy;
        
        _actionSheetView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), _actionSheetHeight);
    }
    
    return self;

    
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length==0) {
       _placeTextView.text = @"请输入您想说的";
    }
    else
    {
      _placeTextView.text =@"";
    }
    
}
+ (DWActionSheetView *)showShareViewWithTitle:(NSString *)title otherButtonTitles:(NSArray *)otherButtonTitles handler:(DWShareViewDidSelectButtonBlock)block
{
    
    DWActionSheetView *actionSheetView = [[DWActionSheetView alloc] initShareViewWithTitle:title otherButtonTitles:otherButtonTitles handler:block];
    return actionSheetView;
}




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:_backView];
    if (!CGRectContainsPoint([_actionSheetView frame], point))
    {
        [self dismiss];
    }
}

- (void)didSelectAction:(UIButton *)button
{
    if (_selectRowBlock)
    {
        NSInteger index = button.tag;
        
        _selectRowBlock(self, index);
    }
    
    if (_selectShareViewRowBlock) {
        _selectShareViewRowBlock(self,button.tag,_textView.text);
    }
    
    [self dismiss];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark - public

- (void)show
{
    if(_isShow) return;
    
    _isShow = YES;
    
    [UIView animateWithDuration:0.35f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
        
        [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
        _backView.alpha = 1.0;
        
        _actionSheetView.frame = CGRectMake(0, CGRectGetHeight(self.frame)-_actionSheetHeight, CGRectGetWidth(self.frame), _actionSheetHeight);
    } completion:NULL];
}

- (void)dismiss
{
    _isShow = NO;
    
    [UIView animateWithDuration:0.35f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
        
        _backView.alpha = 0.0;
        
        _actionSheetView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), _actionSheetHeight);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
