//
//  FnyApplyForCellLayout.h
//  Lebao
//
//  Created by adnim on 16/11/2.
//  Copyright © 2016年 David. All rights reserved.
//

#import "LWLayout.h"
#import "MeetingModel.h"
@interface FnyApplyForCellLayout : LWLayout
@property(nonatomic,strong)MeetingData *model;
@property (nonatomic,assign) CGRect cancelBtnRect;
@property (nonatomic,assign) CGRect line1Rect;
@property (nonatomic,assign) CGRect cellMarginsRect;
@property(nonatomic,assign)float cellHeight;

- (FnyApplyForCellLayout *)initCellLayoutWithModel:(MeetingData *)model;
@end
