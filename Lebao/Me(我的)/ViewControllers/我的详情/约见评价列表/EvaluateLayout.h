//
//  EvaluateLayout.h
//  Lebao
//
//  Created by adnim on 16/10/26.
//  Copyright © 2016年 David. All rights reserved.
//

#import "LWLayout.h"
#import "MeetingModel.h"
@interface EvaluateLayout : LWLayout
@property(nonatomic,strong)MeetingData *model;
@property (nonatomic,assign)float cellHeight;
@property (nonatomic,assign) CGRect cellMarginsRect;
@property(nonatomic,assign)CGRect lineV1Rect;
- (EvaluateLayout *)initCellLayoutWithModel:(MeetingData *)model;

@end
