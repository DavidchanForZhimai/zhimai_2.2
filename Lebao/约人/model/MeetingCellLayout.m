//
//  MeetingCellLayout.m
//  Lebao
//
//  Created by adnim on 16/9/9.
//  Copyright © 2016年 David. All rights reserved.
//

#import "MeetingCellLayout.h"
#import "LWTextParser.h"
#import "Gallop.h"
#import "Parameter.h"
#import "NSString+Extend.h"
@implementation MeetingCellLayout

- (MeetingCellLayout *)initCellLayoutWithModel:(MeetingData *)model andMeetBtn:(BOOL)meetBtn andMessageBtn:(BOOL)messageBtn andOprationBtn:(BOOL)oprationBtn andTime:(BOOL)isTime andReward:(BOOL)reward
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
            
            if (model.sex==2) {
                _avatarStorage.contents = [UIImage imageNamed:@"defaulthead_nv"];
            }
            else
            {
                _avatarStorage.contents = [UIImage imageNamed:@"defaulthead"];
            }
            
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
        
        
        //职业
        LWTextStorage* industryTextStorage = [[LWTextStorage alloc] init];
        
        if (model.position.length>0) {
            if (model.position.length>5&&APPWIDTH<375) {
                industryTextStorage.text=[model.position substringToIndex:5];
                industryTextStorage.text=[industryTextStorage.text stringByAppendingString:@"...  "];
                
            }
            else if (model.position.length>10) {
                industryTextStorage.text=[model.position substringToIndex:10];
                industryTextStorage.text=[industryTextStorage.text stringByAppendingString:@"...  "];
            }
            else{
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
        
        if ((model.service.length==0)||(model.resource.length==0)) {
            if (addressStorage.text.length>0) {
                _line1Rect  = CGRectMake(0, addressStorage.bottom + 10, APPWIDTH, 0.5);
            }else if (industryTextStorage.text.length>0){
                addressStorage.frame = CGRectMake(industryTextStorage.left, industryTextStorage.bottom, industryTextStorage.width, 0);
                _line1Rect  = CGRectMake(0, industryTextStorage.bottom + 10, APPWIDTH, 0.5);
            }else {
                _line1Rect  = CGRectMake(0, _avatarStorage.bottom + 10, APPWIDTH, 0.5);
            }
        }else{
            _line1Rect  = CGRectMake(0, addressStorage.bottom + 10, APPWIDTH, 0.5);
        }
        
        if(meetBtn){
            //约见按钮
            _meetBtnRect = CGRectMake(APPWIDTH-70, 20, 60, 30);
        }
        
        if (messageBtn) {
            _messageBtnRect = CGRectMake(APPWIDTH-70, 20, 60, 30);
        }
        
        [self addStorage:_avatarStorage];
        [self addStorage:nameTextStorage];
        [self addStorage:industryTextStorage];
        [self addStorage:addressStorage];
        
        
        if (oprationBtn) {
            _refuseBtnRect=CGRectMake(APPWIDTH-120, 20, 50, 30);
            _agreeBtnRect=CGRectMake(APPWIDTH-60, 20, 50, 30);
        }
        

        
       float productLbStorageheight =[self addStorageWithStr:@"产品服务" andFrameX:_avatarStorage.left andFrameY:_line1Rect.origin.y+10 andTagStr:model.service];
       float resourceTextStorageheight=[self addStorageWithStr:@"人脉资源" andFrameX:_avatarStorage.left andFrameY:productLbStorageheight+10 andTagStr:model.resource];
        
        
        if (isTime) {

            if ((model.service.length==0)&&(model.resource.length==0)) {
                _line2Rect  = CGRectMake(0, addressStorage.bottom + 10, APPWIDTH, 0.5);;
            }else{
                _line2Rect  = CGRectMake(0, resourceTextStorageheight + 10, APPWIDTH, 0.5);
            }
            float distance=[model.distance floatValue]/1000.00;
            LWTextStorage* distanceLab=[[LWTextStorage alloc]initWithFrame:CGRectMake(_avatarStorage.left,_line2Rect.origin.y+10, nameTextStorage.width, CGFLOAT_MAX)];
            distanceLab.text=[NSString stringWithFormat:@"%.2lfkm",distance];
            distanceLab.font=Size(24.0);
            distanceLab.textColor=[UIColor colorWithRed:0.549 green:0.5569 blue:0.5608 alpha:1.0];
            LWTextStorage* timerLab=[[LWTextStorage alloc]initWithFrame:CGRectMake(0,_line2Rect.origin.y+10, APPWIDTH-10, CGFLOAT_MAX)];
            timerLab.text=[NSString stringWithFormat:@"%@有空",[model.time updateTimeForHourAndMiniter]];
            
            timerLab.textAlignment=NSTextAlignmentRight;
            timerLab.textColor=[UIColor colorWithRed:0.549 green:0.5569 blue:0.5608 alpha:1.0];
            timerLab.font=Size(24.0);
            
            [self addStorage:distanceLab];
            [self addStorage:timerLab];
        }
        if (reward) {
            if ((model.service.length==0)&&(model.resource.length==0)) {
                _line2Rect  = CGRectMake(0, addressStorage.bottom + 10, APPWIDTH, 0.5);;
            }else{
                _line2Rect  = CGRectMake(0, resourceTextStorageheight + 10, APPWIDTH, 0.5);
            }
            LWTextStorage *rewardStorage=[[LWTextStorage alloc]init];
            if([model.reward intValue]>0){
                rewardStorage.text=[NSString stringWithFormat:@"人脉打赏    %@元",model.reward];
                
            }else{
                rewardStorage.text=@"人脉打赏    无";
            }
            rewardStorage.font=Size(26.0);
            rewardStorage.frame=CGRectMake(_avatarStorage.left, _line2Rect.origin.y+10, [rewardStorage.text sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(APPWIDTH,13)].width+5, CGFLOAT_MAX);
            resourceTextStorageheight = rewardStorage.bottom;
            rewardStorage.textColor = [UIColor colorWithWhite:0.400 alpha:1.000];
            [self addStorage:rewardStorage];
            
            LWTextStorage* timerLab=[[LWTextStorage alloc]initWithFrame:CGRectMake(0,_line2Rect.origin.y+10, APPWIDTH-10, CGFLOAT_MAX)];
            timerLab.text=[NSString stringWithFormat:@"%@",[model.time timeformatString:@"yyyy-MM-dd HH:mm"]];
            
            timerLab.textAlignment=NSTextAlignmentRight;
            timerLab.textColor=[UIColor colorWithRed:0.549 green:0.5569 blue:0.5608 alpha:1.0];
            timerLab.font=Size(24.0);
            [self addStorage:timerLab];
            
                    }
        
        
        self.cellHeight = [self suggestHeightWithBottomMargin:20];
        self.cellMarginsRect = frame(0, self.cellHeight - 10, APPWIDTH, 10);
        
        
        
    }
    
    return self;
    
}
-(float)addStorageWithStr:(NSString*)str andFrameX:(float)frameX andFrameY:(float)frameY andTagStr:(NSString*)tagStr{
    LWTextStorage *productTextStorage=[[LWTextStorage alloc]init];
    float productLbStorageheight;
    if (![tagStr isEqualToString:@""]&&tagStr) {
        productTextStorage.text=str;
        productTextStorage.font=Size(26.0);
        productTextStorage.frame=CGRectMake(frameX, frameY, [productTextStorage.text sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(APPWIDTH,13)].width+5, CGFLOAT_MAX);
        productLbStorageheight = productTextStorage.bottom;
        productTextStorage.textColor = [UIColor colorWithWhite:0.400 alpha:1.000];
        
        
        
        NSArray *productArr=[tagStr componentsSeparatedByString:@"/"];
        NSMutableString *productStr = allocAndInit(NSMutableString);
        CGFloat height1=0;
        CGFloat wid1=0;
        for (int i=0; i<productArr.count; i++) {
            if([productArr[i] length]==0){//去空格
                continue;
            }else{
                NSString *trimedString = [productArr[i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if([trimedString length]==0){
                    continue;
                }
            }  //去空格
            UIImage *img=[UIImage imageNamed:@"[biaoqian]"];
            NSString *text = [NSString stringWithFormat:@"  %@   ",productArr[i]];
            CGSize expectSize=[text sizeWithFont:Size(24) maxSize:CGSizeMake(1000,900)];
            wid1 += (img.size.width + expectSize.width);
            if (wid1>(SCREEN_WIDTH - (productTextStorage.right) - 10)||i==productArr.count-1) {//如果长度过长,换行
                if (i==productArr.count-1&&wid1<=(SCREEN_WIDTH - (productTextStorage.right) - 10)) {
                    [productStr appendFormat:@"[biaoqian]  %@   ",productArr[i]];
                }
                LWTextStorage* productLbStorage = [[LWTextStorage alloc] init];
                productLbStorage.font = Size(24.0);
                productLbStorage.textColor = [UIColor colorWithWhite:0.400 alpha:1.000];
                productLbStorage.text = productStr;
                productLbStorage.frame = CGRectMake(productTextStorage.right + 10, productTextStorage.top+height1, SCREEN_WIDTH - (productTextStorage.right) - 20, CGFLOAT_MAX);
                [LWTextParser parseEmojiWithTextStorage:productLbStorage];
                [self addStorage:productLbStorage];
                productLbStorageheight = productLbStorage.bottom;
                height1+=(10+productTextStorage.height);
                productStr=allocAndInit(NSMutableString);
                
                if (i==productArr.count-1&&wid1>(SCREEN_WIDTH - (productTextStorage.right) - 10)) {
                    LWTextStorage* productLbStorage = [[LWTextStorage alloc] init];
                    productLbStorage.font = Size(24.0);
                    productLbStorage.textColor = [UIColor colorWithWhite:0.400 alpha:1.000];
                    productLbStorage.text = [NSString stringWithFormat:@"[biaoqian]  %@   ",productArr[i]];
                    productLbStorage.frame = CGRectMake(productTextStorage.right + 10, productTextStorage.top+height1, SCREEN_WIDTH - (productTextStorage.right) - 20, CGFLOAT_MAX);
                    [LWTextParser parseEmojiWithTextStorage:productLbStorage];
                    [self addStorage:productLbStorage];
                    productLbStorageheight = productLbStorage.bottom;
                    
                    
                }
                wid1 =(img.size.width + expectSize.width+10);
            }
            [productStr appendFormat:@"[biaoqian]  %@   ",productArr[i]];
        }
        [self addStorage:productTextStorage];
    }else{

        productLbStorageheight = _line1Rect.origin.y;
    }
    return productLbStorageheight;
}

@end
