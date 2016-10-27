//
//  EvaluateLayout.m
//  Lebao
//
//  Created by adnim on 16/10/26.
//  Copyright © 2016年 David. All rights reserved.
//

#import "EvaluateLayout.h"
#import "LWTextParser.h"
#import "Gallop.h"
#import "Parameter.h"
#import "NSString+Extend.h"
@implementation EvaluateLayout
-(EvaluateLayout *)initCellLayoutWithModel:(MeetingData *)model
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
        
                //名字模型 nameTextStorage
        LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
        nameTextStorage.text = [NSString stringWithFormat:@"%@",model.realname];
        nameTextStorage.font = Size(28.0);
        nameTextStorage.frame = CGRectMake(_avatarStorage.right + 10, 15.0, SCREEN_WIDTH - (_avatarStorage.right), CGFLOAT_MAX);
        
        LWTextStorage* timeTextStorage = [[LWTextStorage alloc] init];
        timeTextStorage.text = [NSString stringWithFormat:@"%@",[model.create_at timeformatString:@"MM-dd HH:mm"]];
        timeTextStorage.textColor = [UIColor colorWithRed:0.549 green:0.5569 blue:0.5608 alpha:1.0];
        timeTextStorage.font = Size(24.0);
        timeTextStorage.frame = CGRectMake(APPWIDTH/2.0, 18,APPWIDTH/2.0-10, CGFLOAT_MAX);
        timeTextStorage.textAlignment=NSTextAlignmentRight;

        LWTextStorage* evaluateStorage = [[LWTextStorage alloc] init];
        evaluateStorage.text = [NSString stringWithFormat:@"%@",model.content];
        evaluateStorage.textColor = [UIColor colorWithRed:0.549 green:0.5569 blue:0.5608 alpha:1.0];
        evaluateStorage.font = Size(26.0);
        evaluateStorage.frame = CGRectMake(nameTextStorage.left, 40, nameTextStorage.width, CGFLOAT_MAX);
        
        _lineV1Rect=CGRectMake(0, evaluateStorage.bottom+10, APPWIDTH, 0.5);
        
        LWTextStorage* startStorage = [[LWTextStorage alloc] init];
        NSString *start=@"     ";
        for (int i=0; i<model.scord; i++) {
           start =[start stringByAppendingString:@"[pingjia]     "];
        }for (int i=0; i<(5-model.scord); i++) {
            start =[start stringByAppendingString:@"[weixuanpingjia]     "];
        }
        startStorage.text = start;
        startStorage.textColor = [UIColor colorWithRed:0.549 green:0.5569 blue:0.5608 alpha:1.0];
        startStorage.font = Size(28.0);
        startStorage.frame = CGRectMake(0, evaluateStorage.bottom+20.5, APPWIDTH, 40);
        startStorage.textAlignment=NSTextAlignmentCenter;
        [LWTextParser parseEmojiWithTextStorage:startStorage];
        
        [self addStorage:_avatarStorage];
        [self addStorage:nameTextStorage];
        [self addStorage:timeTextStorage];
        [self addStorage:evaluateStorage];
        [self addStorage:startStorage];
        self.cellHeight = [self suggestHeightWithBottomMargin:20];
        self.cellMarginsRect = frame(0, self.cellHeight - 10, APPWIDTH, 10);
        
        
        
    }
    
    return self;
    
}


@end
