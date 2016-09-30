//
//  WantMeetLayout.m
//  Lebao
//
//  Created by adnim on 16/9/12.
//  Copyright © 2016年 David. All rights reserved.
//

#import "WantMeetLayout.h"
#import "LWTextParser.h"
#import "Gallop.h"
#import "Parameter.h"
#import "NSString+Extend.h"
@implementation WantMeetLayout


- (WantMeetLayout *)initCellLayoutWithModel:(MeetingData *)model andMeetBtn:(BOOL)meetBtn andTelBtn:(BOOL)TelBtn
{
    self = [super init];
    if (self) {
        //用户头像
        _model = model;
        LWImageStorage *_avatarStorage = [[LWImageStorage alloc]initWithIdentifier:@"avatar"];
        _avatarStorage.tag = 888;
        _avatarStorage.frame = CGRectMake(10, 13, 44, 44);
        model.imgurl = [[ToolManager shareInstance] urlAppend:model.imgurl];
        _avatarStorage.contents = model.imgurl;
        _avatarStorage.placeholder = [UIImage imageNamed:@"defaulthead"];
        if ([model.imgurl isEqualToString:ImageURLS]) {
            
            _avatarStorage.contents = [UIImage imageNamed:@"defaulthead"];
            
        }
        _avatarStorage.cornerRadius = _avatarStorage.width/2.0;
        
        
        
        NSString *authen;
        if ([model.authen isEqualToString:@"3"]) {
            authen = @"[iconprofilerenzhen]";
        }
        else
        {
            authen = @"[iconprofileweirenzhen]";
        }
        NSString *vip;
        if ([model.vip boolValue]) {
            vip = @"[iconprofilevip]";
        }
        else
        {
            vip = @"[iconprofilevipweikaitong]";
        }
        //名字模型 nameTextStorage
        LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
        nameTextStorage.text = [NSString stringWithFormat:@"%@ %@ %@",model.realname,authen,vip];
        nameTextStorage.font = Size(28.0);
        nameTextStorage.frame = CGRectMake(_avatarStorage.right + 10, 12.0, SCREEN_WIDTH - (_avatarStorage.right), CGFLOAT_MAX);
        [nameTextStorage lw_addLinkWithData:[NSString stringWithFormat:@"%@",model.userid]
                                      range:NSMakeRange(0,model.realname.length)
                                  linkColor:BlackTitleColor
                             highLightColor:RGB(0, 0, 0, 0.15)];
        
        [LWTextParser parseEmojiWithTextStorage:nameTextStorage];
        
        
        //行业
        LWTextStorage* industryTextStorage = [[LWTextStorage alloc] init];
        if (model.industry&&model.industry.length>0) {
            industryTextStorage.text =[NSString stringWithFormat:@"%@  ",[Parameter industryForChinese:model.industry]];
        }
        if (model.workyears&&model.workyears.length>0) {
            industryTextStorage.text=[NSString stringWithFormat:@"%@从业%@年",industryTextStorage.text,model.workyears];
        }
        
        
        industryTextStorage.textColor = [UIColor colorWithRed:0.549 green:0.5569 blue:0.5608 alpha:1.0];
        industryTextStorage.font = Size(24.0);
        industryTextStorage.frame = CGRectMake(nameTextStorage.left, nameTextStorage.bottom + 8, nameTextStorage.width, CGFLOAT_MAX);
        
        if (meetBtn) {
            //约见按钮
            _meetBtnRect = CGRectMake(APPWIDTH-70, 20, 60, 30);
        }
        if (TelBtn) {
            _telBtnRect=CGRectMake(APPWIDTH-45, 20, 30, 30);
            _messageBtnRect=CGRectMake(APPWIDTH-83, 20, 30, 30);
        }
        
        _line1Rect  = CGRectMake(0, _avatarStorage.bottom + 10, APPWIDTH, 0.5);
        if (model.audio&&model.audio!=nil) {//语音按钮
            _audioBtnRect=CGRectMake(5, _line1Rect.origin.y, nameTextStorage.left-10, nameTextStorage.left-10);
        }
        
        
        //约见理由
        LWTextStorage *meetReasonTextStorage=[[LWTextStorage alloc]init];
        meetReasonTextStorage.text=@"约见理由";
        meetReasonTextStorage.font=Size(26.0);
        meetReasonTextStorage.frame=CGRectMake(nameTextStorage.left, _line1Rect.origin.y+10, 52, CGFLOAT_MAX);
        meetReasonTextStorage.textColor = [UIColor colorWithRed:0.522 green:0.525 blue:0.529 alpha:1.000];
        
        float meetReasonStorageheight = meetReasonTextStorage.bottom;
        
        if (model.remark&&![model.remark isEqualToString:@""]) {
            
            LWTextStorage *meetReason=[[LWTextStorage alloc]init];
            meetReason.text=model.remark;
            meetReason.font=Size(26.0);
            meetReason.frame=CGRectMake(meetReasonTextStorage.right+10, _line1Rect.origin.y+10, 52, CGFLOAT_MAX);
            meetReason.textColor = [UIColor colorWithRed:0.522 green:0.525 blue:0.529 alpha:1.000];
            meetReasonStorageheight = meetReason.bottom;
            [self addStorage:meetReason];
        }
        
        
        
        LWTextStorage *MeetGiveTextStorage=[[LWTextStorage alloc]init];
        MeetGiveTextStorage.text=@"约见打赏";
        MeetGiveTextStorage.font=Size(26.0);
        MeetGiveTextStorage.frame=CGRectMake(nameTextStorage.left, meetReasonStorageheight + 10, 52, CGFLOAT_MAX);
        MeetGiveTextStorage.textColor = [UIColor colorWithRed:0.522 green:0.525 blue:0.529 alpha:1.000];
        float MeetGiveTextStorageheight = MeetGiveTextStorage.bottom;
        if (model.reward&&![model.reward isEqualToString:@""]) {
            
            LWTextStorage *money=[[LWTextStorage alloc]init];
            money.text=[NSString stringWithFormat:@"%@元",model.reward];
            money.font=Size(26.0);
            money.frame=CGRectMake(MeetGiveTextStorage.right + 10, MeetGiveTextStorage.top, SCREEN_WIDTH - (MeetGiveTextStorage.right) - 20, CGFLOAT_MAX);
            money.textColor = [UIColor colorWithRed:0.522 green:0.525 blue:0.529 alpha:1.000];
            meetReasonStorageheight = money.bottom;
            [self addStorage:money];
            
            
        }
        
        _line2Rect  = CGRectMake(0, MeetGiveTextStorageheight + 10, APPWIDTH, 0.5);
        
        float distance=[model.distance floatValue]/1000.00;
        LWTextStorage* distanceLab=[[LWTextStorage alloc]initWithFrame:CGRectMake(_avatarStorage.left,_line2Rect.origin.y+8, nameTextStorage.width, nameTextStorage.height)];
        distanceLab.text=[NSString stringWithFormat:@"%.2lfkm",distance];
        distanceLab.textColor=[UIColor colorWithRed:0.482 green:0.486 blue:0.494 alpha:1.000];
        LWTextStorage* timerLab=[[LWTextStorage alloc]initWithFrame:CGRectMake(0, distanceLab.top, APPWIDTH-10, distanceLab.height)];
        
        
        timerLab.text=[NSString stringWithFormat:@"%@有空",[model.time updateTime]];
        
        timerLab.textAlignment=NSTextAlignmentRight;
        timerLab.textColor=[UIColor colorWithRed:0.482 green:0.486 blue:0.494 alpha:1.000];
        timerLab.font=Size(26.0);
        [self addStorage:_avatarStorage];
        [self addStorage:nameTextStorage];
        [self addStorage:industryTextStorage];
        [self addStorage:meetReasonTextStorage];
        [self addStorage:MeetGiveTextStorage];
        [self addStorage:distanceLab];
        [self addStorage:timerLab];
        self.cellHeight = [self suggestHeightWithBottomMargin:20];
        self.cellMarginsRect = frame(0, self.cellHeight - 10, APPWIDTH, 10);
        
        
        
    }
    
    return self;
    
}


@end


