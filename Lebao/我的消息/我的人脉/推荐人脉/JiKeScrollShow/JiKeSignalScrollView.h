//
//  JiKeScrollView.h
//  JiKeScrollView
//
//  Created by 李龙 on 16/11/23.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JiKeSignalScrollView : UIView

-(instancetype)initWithFrame:(CGRect)frame withScrollLabelSize:(CGSize)labelSize;

@property (nonatomic,strong) NSArray *myFirstShowImageLinkArray;
@property (nonatomic,strong) NSArray *myFirstShowLabelDesArray;
@property (nonatomic,strong) NSArray *mySecondShowLabelDesArray;

@property (nonatomic,copy) NSString *myNextShowImageLink;
@property (nonatomic,copy) NSString *myNextShowLabelDes;
@property (nonatomic,copy) NSString *myNextSecondShowLabelDes;

@end
