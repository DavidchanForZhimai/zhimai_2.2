//
//  DWLable.h
//  Lebao
//
//  Created by David on 16/6/16.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;
@interface DWLable : UILabel
{
@private VerticalAlignment _verticalAlignment;
}
@property (nonatomic, assign) UIEdgeInsets textInsets; // 控制字体与控件边界的间隙
@property (nonatomic) VerticalAlignment verticalAlignment;



@end




