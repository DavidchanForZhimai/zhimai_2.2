//
//  FnyApplyForCellLayout.m
//  Lebao
//
//  Created by adnim on 16/11/2.
//  Copyright © 2016年 David. All rights reserved.
//

#import "FnyApplyForCellLayout.h"
#import "LWTextParser.h"
#import "Gallop.h"
#import "Parameter.h"
#import "NSString+Extend.h"
@implementation FnyApplyForCellLayout
- (FnyApplyForCellLayout *)initCellLayoutWithModel:(MeetingData *)model
{
    self = [super init];
    if (self) {
        //用户头像
        _model = model;
        LWImageStorage *_avatarStorage = [[LWImageStorage alloc]initWithIdentifier:@"avatar"];
        _avatarStorage.frame = CGRectMake(10, 13, 44, 44);
        model.imgurl = [[ToolManager shareInstance] urlAppend:model.imgurl];
        _avatarStorage.tag =888;
        _avatarStorage.contents = model.imgurl;
        _avatarStorage.placeholder = [UIImage imageNamed:@"defaulthead"];
        if ([model.imgurl isEqualToString:ImageURLS]) {
            
            _avatarStorage.contents = [UIImage imageNamed:@"defaulthead"];
            
        }
        _avatarStorage.cornerRadius = _avatarStorage.width/2.0;
        //用户名
        NSString *authen;
        if ([model.authen isEqualToString:@"3"]) {
            authen = @"[iconprofilerenzhen]";
        }
        else
        {
            authen = @"";
        }
        NSString *vip;
        if ([model.vip isEqualToString:@"1"]) {
            vip = @"[iconprofilevip]";
        }
        else
        {
            vip = @"";
        }
        //名字模型 nameTextStorage
        LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
        nameTextStorage.text = [NSString stringWithFormat:@"%@ %@ %@",model.realname,authen,vip];
        nameTextStorage.font = Size(28.0);
        nameTextStorage.frame = CGRectMake(_avatarStorage.right + 10, 15.0, SCREEN_WIDTH - (_avatarStorage.right), CGFLOAT_MAX);
        [nameTextStorage lw_addLinkWithData:[NSString stringWithFormat:@"%@",model.userid]
                                      range:NSMakeRange(0,model.realname.length)
                                  linkColor:BlackTitleColor
                             highLightColor:RGB(0, 0, 0, 0.15)];
        
        [LWTextParser parseEmojiWithTextStorage:nameTextStorage];
        
        
        _cancelBtnRect = CGRectMake(APPWIDTH-70, 20, 60, 30);
        
        //职业
        LWTextStorage* industryTextStorage = [[LWTextStorage alloc] init];
        
        if (model.position.length>0) {
            if (model.position.length>10) {
                industryTextStorage.text=[model.position substringToIndex:10];
                industryTextStorage.text=[industryTextStorage.text stringByAppendingString:@"...  "];
            }else{
                industryTextStorage.text =[NSString stringWithFormat:@"%@  ",model.position];
            }
        }
        else{
            industryTextStorage.text=@"";
        }
        if (model.workyears.length>0&&![model.workyears isEqualToString:@"0"]) {
            industryTextStorage.text=[NSString stringWithFormat:@"%@从业%@年",industryTextStorage.text,model.workyears];
        }
        
        
        industryTextStorage.textColor = [UIColor colorWithRed:0.549 green:0.5569 blue:0.5608 alpha:1.0];
        industryTextStorage.font = Size(24.0);
        industryTextStorage.frame = CGRectMake(nameTextStorage.left, nameTextStorage.bottom + 8, nameTextStorage.width, CGFLOAT_MAX);
        //公司
        LWTextStorage* addressStorage = [[LWTextStorage alloc] init];
        if (model.address.length>0) {
            if (model.address.length>15) {
                addressStorage.text=[model.address substringToIndex:15];
                addressStorage.text=[addressStorage.text stringByAppendingString:@"..."];
            }else{
                addressStorage.text =[NSString stringWithFormat:@"%@",model.address];
            }
        }
        addressStorage.textColor = [UIColor colorWithRed:0.549 green:0.5569 blue:0.5608 alpha:1.0];
        addressStorage.font = Size(24.0);
        
        addressStorage.frame = CGRectMake(industryTextStorage.left, industryTextStorage.bottom + 8, industryTextStorage.width, CGFLOAT_MAX);
        if ((![model.service isEqualToString:@""]&&model.service)||(![model.resource isEqualToString:@""]&&model.resource)) {
            if (addressStorage.text.length>0) {
                _line1Rect  = CGRectMake(0, addressStorage.bottom + 10, APPWIDTH, 0.5);
            }else if (industryTextStorage.text.length>0){
                addressStorage.frame = CGRectMake(industryTextStorage.left, industryTextStorage.bottom, industryTextStorage.width, 0);
                _line1Rect  = CGRectMake(0, industryTextStorage.bottom + 10, APPWIDTH, 0.5);
            }
        }else {
            _line1Rect  = CGRectMake(0, _avatarStorage.bottom + 10, APPWIDTH, 0.5);
        }
        
        [self addStorage:_avatarStorage];
        [self addStorage:nameTextStorage];
        [self addStorage:industryTextStorage];
        [self addStorage:addressStorage];
        
        
        
        if([model.reward intValue]>0){
            LWTextStorage* rewardStorage=[[LWTextStorage alloc]initWithFrame:CGRectMake(_avatarStorage.left,_line1Rect.origin.y+8, nameTextStorage.width, nameTextStorage.height)];
            rewardStorage.text=[NSString stringWithFormat:@"人脉打赏    %@元",model.reward];
            rewardStorage.font=Size(24.0);
            rewardStorage.frame=CGRectMake(_avatarStorage.left,_line1Rect.origin.y+8, [rewardStorage.text sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(APPWIDTH,13)].width+5, CGFLOAT_MAX);
            rewardStorage.textColor=[UIColor colorWithRed:0.549 green:0.5569 blue:0.5608 alpha:1.0];
            [self addStorage:rewardStorage];
            }
        
            LWTextStorage* timerLab=[[LWTextStorage alloc]initWithFrame:CGRectMake(0,_line1Rect.origin.y+8, APPWIDTH-10, CGFLOAT_MAX)];
            timerLab.text=[NSString stringWithFormat:@"%@",[model.time timeformatString:@"yyyy-MM-dd HH:mm"]];
            timerLab.textAlignment=NSTextAlignmentRight;
            timerLab.textColor=[UIColor colorWithRed:0.549 green:0.5569 blue:0.5608 alpha:1.0];
            timerLab.font=Size(24.0);
        
            [self addStorage:timerLab];
        }
        self.cellHeight = [self suggestHeightWithBottomMargin:20];
        self.cellMarginsRect = frame(0, self.cellHeight - 10, APPWIDTH, 10);
    
    
    return self;
    
}
@end
