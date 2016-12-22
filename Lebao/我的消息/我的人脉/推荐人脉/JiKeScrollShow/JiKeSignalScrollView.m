//
//  JiKeScrollView.m
//  JiKeScrollView
//
//  Created by 李龙 on 16/11/23.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "JiKeSignalScrollView.h"
#import "UIView+Frame.h"
#import "JiKeScrollImageView.h"
#import "JiKeScrollLabel.h"
#import "Cionfig.h"

@interface JiKeSignalScrollView ()

@property (nonatomic,strong) JiKeScrollImageView *myJiKeScrollImageView;
@property (nonatomic,strong) JiKeScrollLabel *myJiKeScrollLabel;
@property (nonatomic,strong) JiKeScrollLabel *myJiKeScrollLabel2;
@property (nonatomic,strong) UIView *mySignleShowView;

//模拟数据
@property (nonatomic,strong) NSArray *tempDataArray;
@end


@implementation JiKeSignalScrollView{
    int dataShowIndex;
}

-(instancetype)initWithFrame:(CGRect)frame withScrollLabelSize:(CGSize)labelSize{
    
    if (self = [super initWithFrame:frame]) {
        //初始化控件
        [self initSubViewsWithLabelSize:labelSize];
    }
    return self;
}



- (void)initSubViewsWithLabelSize:(CGSize)LabelSize{
    
    //滚动图
    _myJiKeScrollImageView = ({
        JiKeScrollImageView *scrollImageView = [[JiKeScrollImageView alloc] initWithFrame:(CGRect){0,0,self.frame.size.width/2.0,self.frame.size.width/2.0}];
        [self addSubview:scrollImageView];
        scrollImageView;
    });
    
    CGSize labelSize = [LLTool getSizeWithStrig:@"测试" font:[UIFont systemFontOfSize:14] maxSize:(CGSize){self.frame.size.width,15}];
    //滚动文字
    _myJiKeScrollLabel = ({
        CGFloat scrollLabelY = _myJiKeScrollImageView.height+LLverticalMargin;
        JiKeScrollLabel *scrollLabel = [[JiKeScrollLabel alloc] initWithFrame:(CGRect){0,scrollLabelY,self.frame.size.width,labelSize.height*2}];
        [scrollLabel addTextColor:[UIColor blackColor] andTextFont:[UIFont systemFontOfSize:14]];
        [self addSubview:scrollLabel];
        scrollLabel;
    });
    //滚动文字
    _myJiKeScrollLabel2 = ({
        CGFloat scrollLabelY = CGRectGetMaxY(_myJiKeScrollLabel.frame)-5;
        JiKeScrollLabel *scrollLabel = [[JiKeScrollLabel alloc] initWithFrame:(CGRect){0,scrollLabelY,self.frame.size.width,LabelSize.height*2}];
        [scrollLabel addTextColor:[UIColor colorWithWhite:0.400 alpha:1.000] andTextFont:[UIFont systemFontOfSize:12]];
        [self addSubview:scrollLabel];
        scrollLabel;
    });

}




//初始化数据
-(void)setMyFirstShowLabelDesArray:(NSArray *)myFirstShowLabelDesArray{
    _myJiKeScrollLabel.myFirstShowLabelDesArray = myFirstShowLabelDesArray;
}
-(void)setMySecondShowLabelDesArray:(NSArray *)mySecondShowLabelDesArray{
    _myJiKeScrollLabel2.myFirstShowLabelDesArray = mySecondShowLabelDesArray;
}
-(void)setMyFirstShowImageLinkArray:(NSArray *)myFirstShowImageLinkArray{
    _myJiKeScrollImageView.myFirstShowImageLinkArray = myFirstShowImageLinkArray;
}



//执行下一次显示动画
-(void)setMyNextShowLabelDes:(NSString *)myNextShowLabelDes{
    _myJiKeScrollLabel.myNextShowLabelDes = myNextShowLabelDes;
}
-(void)setMyNextSecondShowLabelDes:(NSString *)myNextSecondShowLabelDes{
    _myJiKeScrollLabel2.myNextShowLabelDes = myNextSecondShowLabelDes;
}
-(void)setMyNextShowImageLink:(NSString *)myNextShowImageLink{
    _myJiKeScrollImageView.myNextShowImageLink = myNextShowImageLink;
}








@end
