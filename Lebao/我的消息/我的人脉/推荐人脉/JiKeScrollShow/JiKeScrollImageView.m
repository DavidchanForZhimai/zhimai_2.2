//
//  JiKeScrollImageView.m
//  JikePictureShow
//
//  Created by 李龙 on 16/11/21.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "JiKeScrollImageView.h"
#import "JiKeAnimationStatus.h"
#import "UIView+Frame.h"
#import "Cionfig.h"
#import "NSString+File.h"
@interface JiKeScrollImageView ()

//图片
@property (nonatomic,strong) UIImageView *myImageView0;
@property (nonatomic,strong) UIImageView *myImageView1;
@property (nonatomic,strong) UIView *myCoverView;
@property (nonatomic,strong) NSArray *myImageViewArray;
@end


@implementation JiKeScrollImageView{
    int _scrollIndex;
    
    CGFloat _originalTopY;
    CGFloat _originalCenterY;
    CGFloat _originalDownY;
    
    //动画执行标记
    JiKeAnimationStatus animStatus;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //初始化控件
        [self initSubViews];
    }
    return self;
}




- (NSArray *)myImageViewArray
{
    if (!_myImageViewArray) {
        UIImageView *iconView0 = [[UIImageView alloc] init];
        iconView0.image = [UIImage imageNamed:@"tempBack"];
        iconView0.layer.cornerRadius = 5;
        iconView0.layer.masksToBounds = YES;
        
        UIImageView *iconView1 = [[UIImageView alloc] init];
        iconView1.image = [UIImage imageNamed:@"tempBack"];
        iconView1.layer.cornerRadius = 5;
        iconView1.layer.masksToBounds = YES;
        
        _myImageViewArray = [NSArray arrayWithObjects:iconView0,iconView1, nil];
    }
    return _myImageViewArray;
}



- (void)initSubViews{
    
    
    CGFloat topMargin = LLTBMargin;
    CGFloat iconWH = self.frame.size.width;
    
    _originalTopY = -iconWH;
    _originalCenterY = 0;
    _originalDownY = iconWH;
    
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(iconWH/2.0, topMargin, iconWH, iconWH)];
    backView.clipsToBounds = YES;
    [self addSubview:backView];
    
    
    _myImageView0 = ({
        UIImageView *iconView0 = self.myImageViewArray[0];
        iconView0.contentMode = UIViewContentModeScaleAspectFill;
        iconView0.frame = (CGRect){0,_originalCenterY,iconWH,iconWH};
        [backView addSubview:iconView0];
        iconView0;
    });
    
    
    _myImageView1 = ({
        UIImageView *iconView1 = self.myImageViewArray[1];
        iconView1.frame = (CGRect){0,_originalTopY,iconWH,iconWH};
        iconView1.contentMode = UIViewContentModeScaleAspectFill;
        [backView addSubview:iconView1];
        iconView1;
    });
    
    
    _myCoverView = ({
        UIView *coverView = [UIView new];
        coverView.frame = _myImageView0.frame;
        coverView.backgroundColor = [UIColor clearColor];
        coverView.alpha = 0.f;
        coverView.layer.cornerRadius = 5;
        coverView.hidden = YES;
        [backView addSubview:coverView];
        coverView;
    });
    
    _scrollIndex = 0;
}


- (void)beiginScrollDown{
    _scrollIndex++;
    
    [self runAnimation];
}


- (void)runAnimation{
    if (_scrollIndex == 2) {
        [[ToolManager shareInstance]imageView:_myImageView0 setImageWithURL:[NSString stringWithFormat:@"%@%@",ImageURLS,_myNextShowImageLink] placeholderType:PlaceholderTypeUserHead];
    }else if(_scrollIndex == 1){
        [[ToolManager shareInstance]imageView:_myImageView1 setImageWithURL:[NSString stringWithFormat:@"%@%@",ImageURLS,_myNextShowImageLink] placeholderType:PlaceholderTypeUserHead];
    }
    //蒙版归位
    //            _myCoverView.hidden = YES;
    //            _myCoverView.alpha = 0.f;
    //            _myCoverView.y =_originalCenterY;
    

    void (^changeBlock)() = ^(){
        animStatus = STATUS_RUNNING;
        
        if (_scrollIndex == 1) {
            _myImageView1.y = _originalCenterY;
            _myImageView0.y = _originalDownY;
            
        }else if(_scrollIndex == 2){
            
            _myImageView1.y = _originalDownY;
            _myImageView0.y = _originalCenterY;
            
            _scrollIndex = 0;
        }
        
        //蒙版
//        _myCoverView.hidden = NO;
//        _myCoverView.alpha = 0.3f;
//        _myCoverView.y =_originalDownY;
    };
    
    
    void (^completionBlock)(BOOL) = ^(BOOL finished){
        
        if(finished){
            if (_scrollIndex == 1) {
                _myImageView0.y = _originalTopY;
//                [[ToolManager shareInstance]imageView:_myImageView0 setImageWithURL:[NSString stringWithFormat:@"%@%@",ImageURLS,_myNextShowImageLink] placeholderType:PlaceholderTypeUserHead];
            }else if(_scrollIndex == 0){
                _myImageView1.y = _originalTopY;
//                        [[ToolManager shareInstance]imageView:_myImageView1 setImageWithURL:[NSString stringWithFormat:@"%@%@",ImageURLS,_myNextShowImageLink] placeholderType:PlaceholderTypeUserHead];
            }
            //蒙版归位
//            _myCoverView.hidden = YES;
//            _myCoverView.alpha = 0.f;
//            _myCoverView.y =_originalCenterY;
            
            animStatus = STATUS_END;
        }
    };
    
    [self doAnimation:changeBlock completion:completionBlock];

}



- (void)doAnimation:(void(^)())changeBK completion:(void(^)(BOOL finished))competionBK{
    [UIView animateWithDuration:0.6f delay:0.1f options:UIViewAnimationOptionCurveEaseInOut animations:changeBK completion:competionBK];
}



#pragma mark ================ 传入数据处理 ================
-(void)setMyFirstShowImageLinkArray:(NSArray *)myFirstShowImageLinkArray{
//    if(myFirstShowImageLinkArray == nil || myFirstShowImageLinkArray.count < 2)
//        ULog(@"请设置两张初始化图片");
    
    _myFirstShowImageLinkArray = myFirstShowImageLinkArray;
//    _myImageView0.image = [UIImage imageNamed:myFirstShowImageLinkArray[0]];
    [[ToolManager shareInstance]imageView:_myImageView0 setImageWithURL:[NSString stringWithFormat:@"%@%@",ImageURLS,myFirstShowImageLinkArray[0]] placeholderType:PlaceholderTypeUserHead];
    
//    _myImageView1.image = [UIImage imageNamed:myFirstShowImageLinkArray[1]];

        [[ToolManager shareInstance]imageView:_myImageView1 setImageWithURL:[NSString stringWithFormat:@"%@%@",ImageURLS,myFirstShowImageLinkArray[1]] placeholderType:PlaceholderTypeUserHead];
    
}


//在设置myFirstShowImageLink之后,传入后自动调用下一个张操作
-(void)setMyNextShowImageLink:(NSString *)myNextShowImageLink{
    //保证动画当前顺序执行
    if (animStatus == STATUS_RUNNING)
        return;
    
    //处理数据
//    if(_myFirstShowImageLinkArray == nil || _myFirstShowImageLinkArray.count < 2)
//        ULog(@"还是先设置两张初始化图片吧");
    
    _myNextShowImageLink = myNextShowImageLink;
    
    [self beiginScrollDown];
}

@end
