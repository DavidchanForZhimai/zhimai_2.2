//
//  MeetingCellLayout.h
//  Lebao
//
//  Created by adnim on 16/9/9.
//  Copyright © 2016年 David. All rights reserved.
//

#import "LWLayout.h"
#import "MeetingModel.h"
@interface MeetingCellLayout : LWLayout
@property(nonatomic,strong)MeetingData *model;
@property (nonatomic,assign) CGRect meetBtnRect;
@property (nonatomic,assign) CGRect messageBtnRect;
@property (nonatomic,assign) CGRect refuseBtnRect;
@property (nonatomic,assign) CGRect agreeBtnRect;
@property (nonatomic,assign) CGRect line1Rect;
@property (nonatomic,assign) CGRect line2Rect;
@property (nonatomic,assign) CGRect cellMarginsRect;
@property(nonatomic,assign)float cellHeight;

- (MeetingCellLayout *)initCellLayoutWithModel:(MeetingData *)model andMeetBtn:(BOOL)meetBtn andMessageBtn:(BOOL)messageBtn andOprationBtn:(BOOL)oprationBtn andTime:(BOOL)isTime andReward:(BOOL)reward;
@end
