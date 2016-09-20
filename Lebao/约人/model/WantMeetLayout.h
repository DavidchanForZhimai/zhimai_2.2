//
//  WantMeetLayout.h
//  Lebao
//
//  Created by adnim on 16/9/12.
//  Copyright © 2016年 David. All rights reserved.
//

#import "LWLayout.h"
#import "MeetingModel.h"
@interface WantMeetLayout : LWLayout
@property(nonatomic,strong)MeetingData *model;
@property (nonatomic,assign) CGRect meetBtnRect;
@property (nonatomic,assign) CGRect telBtnRect;
@property (nonatomic,assign) CGRect messageBtnRect;
@property (nonatomic,assign) CGRect line1Rect;
@property (nonatomic,assign) CGRect line2Rect;
@property (nonatomic,assign) CGRect cellMarginsRect;
@property (nonatomic,assign)float cellHeight;
@property (nonatomic,assign)CGRect audioBtnRect;
- (WantMeetLayout *)initCellLayoutWithModel:(MeetingData *)model andBtn:(BOOL )Btn andTelBtn:(BOOL )TelBtn;

@end
