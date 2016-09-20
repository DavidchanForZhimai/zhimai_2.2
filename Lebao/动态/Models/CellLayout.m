




/********************* 有任何问题欢迎反馈给我 liuweiself@126.com ****************************************/
/***************  https://github.com/waynezxcv/Gallop 持续更新 ***************************/
/******************** 正在不断完善中，谢谢~  Enjoy ******************************************************/




#import "CellLayout.h"
#import "LWTextParser.h"
#import "Gallop.h"
#import "NSString+Extend.h"
#import "Parameter.h"
#define MAX_TEXT_HEIGHT 120.0f
#define MAX_TEXT_AllHEIGHT 80.0f
@implementation CellLayout

- (id)initWithStatusModel:(StatusDatas *)statusModel
                    index:(NSInteger)index isDetail:(BOOL)isDetail{
    self = [super init];
    if (self) {
        self.statusModel = statusModel;
        //头像模型 avatarImageStorage
        LWImageStorage * _avatarStorage = [[LWImageStorage alloc] initWithIdentifier:@"avatar"];
        _avatarStorage.frame =CGRectMake(10, 10, 40, 40);
        _avatarPosition = CGRectMake(10, 10, 40, 40);

        NSString *renzen;
        if (statusModel.authen==3) {
           renzen = @"[renzhen]";
        }
        else
        {
           renzen=@"[weirenzhen]";
        }
        //名字模型 nameTextStorage
        LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
       
        nameTextStorage.text = [NSString stringWithFormat:@"%@ %@",statusModel.realname,renzen];
        nameTextStorage.font = Size(28.0);
        nameTextStorage.frame = CGRectMake(_avatarStorage.right + 6, 15.0f, SCREEN_WIDTH - (_avatarStorage.right + 6 + 30), CGFLOAT_MAX);
        [nameTextStorage lw_addLinkWithData:[NSString stringWithFormat:@"%ld",statusModel.brokerid]
                                      range:NSMakeRange(0,statusModel.realname.length)
                                  linkColor:BlackTitleColor
                             highLightColor:RGB(0, 0, 0, 0.15)];
       
        [LWTextParser parseEmojiWithTextStorage:nameTextStorage];
        
        
        if (!isDetail||statusModel.me) {
            //更多操作
            LWImageStorage* moreStorage = [[LWImageStorage alloc] initWithIdentifier:@"more"];
            moreStorage.tag = 30;
            moreStorage.frame = CGRectMake(APPWIDTH - 40, 0, 40, 40);
            [self addStorage:moreStorage];
            self.isShowMore = YES;
            
        }
        else
        {
            self.isShowMore = NO;
        }
        
        //行业
        LWTextStorage* industryTextStorage = [[LWTextStorage alloc] init];
        if (statusModel.address.length>0) {
             industryTextStorage.text = [NSString stringWithFormat:@"%@  %@",statusModel.address,statusModel.workyear];
        }
        else
        {
             industryTextStorage.text = [NSString stringWithFormat:@"%@",statusModel.workyear];
        }
       
        industryTextStorage.textColor = [UIColor colorWithRed:0.549 green:0.5569 blue:0.5608 alpha:1.0];
        industryTextStorage.font = Size(24.0);
        industryTextStorage.frame = CGRectMake(nameTextStorage.left, nameTextStorage.bottom + 8, nameTextStorage.width, CGFLOAT_MAX);
        
        //正文内容模型 contentTextStorage
        LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
        contentTextStorage.text = statusModel.content;
        contentTextStorage.font = Size(26.0);
        contentTextStorage.textColor = [UIColor colorWithRed:0.1294 green:0.1333 blue:0.1333 alpha:1.0];
       
        contentTextStorage.frame = CGRectMake(industryTextStorage.left, industryTextStorage.bottom + 10.0f, SCREEN_WIDTH - 80.0f, CGFLOAT_MAX);
        if ([statusModel.address isEqualToString:@""]&&[statusModel.workyear isEqualToString:@""]) {
            contentTextStorage.frame = CGRectMake(nameTextStorage.left, nameTextStorage.bottom + 10.0f, SCREEN_WIDTH - 80.0f, CGFLOAT_MAX);
        }
        
        CGFloat contentBottom = contentTextStorage.bottom;
        //折叠的条件,文字高度超过MAX_TEXT_HEIGHT则折叠
        if (contentTextStorage.bottom - (contentTextStorage.top + 10.0f) > MAX_TEXT_HEIGHT) {
            contentTextStorage.frame = CGRectMake(nameTextStorage.left,
                                                  contentTextStorage.top,
                                                  contentTextStorage.width,
                                                  MAX_TEXT_AllHEIGHT);
            LWTextStorage* openStorage = [[LWTextStorage alloc] init];
            openStorage.font = Size(26.0);
            openStorage.textColor = AppMainColor;
            openStorage.frame = CGRectMake(nameTextStorage.left,
                                           contentTextStorage.bottom + 5.0f,
                                           200.0f,
                                           30.0f);
            openStorage.text = @"全文";
            [openStorage lw_addLinkWithData:@"*openStorage*"
                                      range:NSMakeRange(0, 2)
                                  linkColor:AppMainColor
                             highLightColor:RGB(0, 0, 0, 0.15f)];
            [self addStorage:openStorage];
            contentBottom = openStorage.bottom;
        }
        
        [LWTextParser parseEmojiWithTextStorage:contentTextStorage];
//        [LWTextParser parseTopicWithLWTextStorage:contentTextStorage
//                                        linkColor:RGB(113, 129, 161, 1)
//                                   highlightColor:RGB(0, 0, 0, 0.15)];
        //发布的图片模型 imgsStorage
        CGFloat imageWidth = (SCREEN_WIDTH - 100.0f)/3.0f;
        NSInteger imageCount = [statusModel.pic count];
        NSMutableArray* imageStorageArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
        NSMutableArray* imagePositionArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
       
        if ([self.statusModel.type isEqualToString:@"image"]) {
            NSInteger row = 0;
            NSInteger column = 0;
            if (imageCount == 1) {
                CGRect imageRect = CGRectMake(nameTextStorage.left,
                                              contentBottom + 10.0 + (row * (imageWidth + 7.5f)),
                                              imageWidth*1.7,
                                              imageWidth*1.7);
                NSString* imagePositionString = NSStringFromCGRect(imageRect);
                [imagePositionArray addObject:imagePositionString];
                LWImageStorage* imageStorage = [[LWImageStorage alloc] initWithIdentifier:@"image"];
                imageStorage.tag = 0;
                imageStorage.clipsToBounds = YES;
                imageStorage.frame = imageRect;
                imageStorage.backgroundColor = RGB(240, 240, 240, 1);
                StatusPic *pic = [statusModel.pic objectAtIndex:0];
                NSString* URLString = pic.abbre_imgurl;
                imageStorage.contents = [NSURL URLWithString:URLString];
                [imageStorageArray addObject:imageStorage];
            } else {
                for (NSInteger i = 0; i < imageCount; i ++) {
                    CGRect imageRect = CGRectMake(nameTextStorage.left + (column * (imageWidth + 7.5f)),
                                                  contentBottom + 10.0 +(row * (imageWidth + 7.5f)),
                                                  imageWidth,
                                                  imageWidth);
                    NSString* imagePositionString = NSStringFromCGRect(imageRect);
                    [imagePositionArray addObject:imagePositionString];
                    LWImageStorage* imageStorage = [[LWImageStorage alloc] initWithIdentifier:@"image"];
                    imageStorage.clipsToBounds = YES;
                    imageStorage.tag = i;
                    imageStorage.frame = imageRect;
                    imageStorage.backgroundColor = RGB(240, 240, 240, 1);
                    StatusPic *pic = [statusModel.pic objectAtIndex:i];
                    NSString* URLString = pic.abbre_imgurl;
                    imageStorage.contents = [NSURL URLWithString:URLString];
                    [imageStorageArray addObject:imageStorage];
                    column = column + 1;
                    if (column > 2) {
                        column = 0;
                        row = row + 1;
                    }
                }
            }
            
        }
        else if ([self.statusModel.type isEqualToString:@"website"]) {
            self.websiteRect = CGRectMake(nameTextStorage.left,contentTextStorage.bottom + 5.0f,SCREEN_WIDTH - 80.0f,60.0f);
            LWImageStorage* imageStorage = [[LWImageStorage alloc] init];
            StatusPic *pic = [statusModel.pic objectAtIndex:0];
            NSString* URLString = pic.imgurl;
            imageStorage.contents = [NSURL URLWithString:URLString];
            imageStorage.clipsToBounds = YES;
            imageStorage.frame = CGRectMake(nameTextStorage.left + 5.0f, contentTextStorage.bottom + 10.0f , 50.0f, 50.0f);
            [imageStorageArray addObject:imageStorage];
            
            LWTextStorage* detailTextStorage = [[LWTextStorage alloc] init];
            detailTextStorage.text = statusModel.content;
            detailTextStorage.font = [UIFont fontWithName:@"Heiti SC" size:12.0f];
            detailTextStorage.textColor = RGB(40, 40, 40, 1);
            detailTextStorage.frame = CGRectMake(imageStorage.right + 10.0f, contentTextStorage.bottom + 10.0f, SCREEN_WIDTH - 150.0f, 60.0f);
            detailTextStorage.linespacing = 0.5f;
            [detailTextStorage lw_addLinkForWholeTextStorageWithData:@"https://github.com/waynezxcv/LWAlchemy" linkColor:nil highLightColor:RGB(0, 0, 0, 0.15)];
            [self addStorage:detailTextStorage];
        }
        else if ([self.statusModel.type isEqualToString:@"video"]) {

        }
        
    
        //获取最后一张图片的模型
        LWImageStorage* lastImageStorage = (LWImageStorage *)[imageStorageArray lastObject];
        //生成时间的模型 dateTextStorage
        LWTextStorage* dateTextStorage = [[LWTextStorage alloc] init];
        dateTextStorage.text = [statusModel.createtime updateTime];
    
        dateTextStorage.font = Size(22);
        dateTextStorage.textColor = [UIColor colorWithRed:0.7216 green:0.7294 blue:0.7333 alpha:1.0];
        
        dateTextStorage.frame = CGRectMake(nameTextStorage.left, contentBottom + 10.0f, SCREEN_WIDTH - 80.0f, CGFLOAT_MAX);
        if (lastImageStorage) {
             
        dateTextStorage.frame = CGRectMake(nameTextStorage.left, lastImageStorage.bottom + 10.0f, SCREEN_WIDTH - 80.0f, CGFLOAT_MAX);

        }
        
         self.lineRect = CGRectMake(0, dateTextStorage.bottom + 10.0f,  SCREEN_WIDTH, 0.5f);
        if (statusModel.like.count==0&&statusModel.comment.count==0) {
         self.lineRect = CGRectZero;
        }
        
        //评论位置
        UIImage *commentImage = [UIImage imageNamed:@"dongtai_pinglun"];
        NSString *commentStr = [NSString stringWithFormat:@"%ld评论",statusModel.comment.count];
        if (statusModel.comment.count ==0) {
            commentStr = @"评论";
        }
        CGSize commentsize = [commentStr sizeWithFont:Size(22) maxSize:CGSizeMake(100, 22*SpacedFonts)];
    
        self.commentPosition = frame(APPWIDTH - 15 - commentImage.size.width - commentsize.width,dateTextStorage.top, commentImage.size.width + commentsize.width + 10, 16);
        //点赞位置
       
        UIImage *priseImage = [UIImage imageNamed:@"dongtai_dianzan_normal"];
        NSString *priseStr = [NSString stringWithFormat:@"%ld赞",statusModel.like.count];
        if (statusModel.like.count ==0) {
            priseStr = @"赞";
        }
        CGSize prisesize = [priseStr sizeWithFont:Size(22) maxSize:CGSizeMake(100, 22*SpacedFonts)];
         self.prisePosition = frame(self.commentPosition.origin.x - 25 - priseImage.size.width - prisesize.width,dateTextStorage.top, priseImage.size.width + prisesize.width + 10, 16);
        
        //生成评论背景Storage
        LWImageStorage* commentBgStorage = [[LWImageStorage alloc] init];
        NSArray* commentTextStorages = @[];
        CGRect commentBgPosition = CGRectZero;
        CGRect rect = CGRectMake(nameTextStorage.left - 28,dateTextStorage.bottom + 5.0f, SCREEN_WIDTH - 80, 20);
        CGFloat offsetY = 0.0f;
        //点赞
        LWImageStorage* likeImageSotrage = [[LWImageStorage alloc] init];
        LWImageStorage* moreImageSotrage = [[LWImageStorage alloc] init];
//        NSLog(@"[statusModel.like count] =%ld",[statusModel.like count]);
        NSInteger priseCount = [statusModel.like count];
        NSMutableArray* priseStorageArray = [[NSMutableArray alloc] initWithCapacity:priseCount];
        NSMutableArray* prisePositionArray = [[NSMutableArray alloc] initWithCapacity:priseCount];
        if (self.statusModel.like.count != 0) {
            likeImageSotrage.contents = [UIImage imageNamed:@"dongtai_dianzan_pressed"];
            likeImageSotrage.frame = CGRectMake(rect.origin.x,rect.origin.y + 20.0 + offsetY,20.0, 20.0);
            CGFloat priseWidth = 32.0;
            
            NSInteger count = 0;
            if (priseCount<6) {
                count =priseCount;
            }
            else
            {
                if (!isDetail) {
                    count =5;
                    moreImageSotrage.tag = 20;//更多
                    moreImageSotrage.contents = [UIImage imageNamed:@"dongtai_gengduozan"];
                    moreImageSotrage.frame = CGRectMake(nameTextStorage.left + (5 * (priseWidth + 8.0)),likeImageSotrage.top,20.0, 20.0);
                }
                else
                {
                    count =priseCount;
                }
                

        
            }
            
            int row = 1;
            int rowCount = 0;
            for (int i =0; i<count; i++) {
              
                CGRect priseRect = CGRectMake(nameTextStorage.left + (rowCount * (priseWidth + 7.5f)),
                                              likeImageSotrage.top - 6.0 +(row-1)*(priseWidth + 7.5f),
                                              priseWidth,
                                              priseWidth);
                NSString* prisePositionString = NSStringFromCGRect(priseRect);
                [prisePositionArray addObject:prisePositionString];
                
                LWImageStorage* priseStorage = [[LWImageStorage alloc] initWithIdentifier:@"prise"];
                
                priseStorage.contents = statusModel.like[i].imgurl;
                priseStorage.placeholder = [UIImage imageNamed:@"defaulthead"];
                if ([statusModel.like[i].imgurl isEqualToString:ImageURLS]) {
                    
                    if (statusModel.like[i].sex==1) {
                        priseStorage.contents = [UIImage imageNamed:@"defaulthead"];
                    }
                    else
                    {
                        priseStorage.contents = [UIImage imageNamed:@"defaulthead_nv"];
                        
                    }
                }
                
                priseStorage.cornerRadius = priseWidth/2.0;
                priseStorage.cornerBackgroundColor = [UIColor whiteColor];
                priseStorage.backgroundColor = [UIColor whiteColor];
                priseStorage.frame = priseRect;
                priseStorage.tag = 10+i;

                [priseStorageArray addObject:priseStorage];
                
                rowCount++;
                offsetY =((priseWidth + 7.5)*row - 4);
                if ((nameTextStorage.left + (rowCount + 1)*(priseWidth + 7.5f))>APPWIDTH) {
                    
                    rowCount = 0;
                    row +=1;
                }
            }
            
            
        }
        if (statusModel.comment.count != 0 && statusModel.comment != nil) {
          
        
            NSMutableArray* tmp = [[NSMutableArray alloc] initWithCapacity:statusModel.comment.count];
            
            int count =0;
            if (isDetail||statusModel.comment.count<11) {
               count=(int) statusModel.comment.count;
            }
            else
            {
                count =10;
            }
            for (int i=0; i<count;i++) {
                StatusComment* commentDict = statusModel.comment[i];
                NSString* to = commentDict.info.rep_realname;
                if (to.length != 0) {
                    NSString* commentString = [NSString stringWithFormat:@"%@回复%@: %@",commentDict.info.realname,to,commentDict.info.content];
                    LWTextStorage* commentTextStorage = [[LWTextStorage alloc] init];
                    commentTextStorage.text = commentString;
                    commentTextStorage.font = Size(26.0f);
                    commentTextStorage.textColor = [UIColor colorWithRed:0.3059 green:0.3098 blue:0.3137 alpha:1.0];
                    commentTextStorage.frame = CGRectMake(rect.origin.x, rect.origin.y + 20.0f + offsetY,nameTextStorage.width + 24, CGFLOAT_MAX);
                
                    [commentTextStorage lw_addLinkForWholeTextStorageWithData:commentDict linkColor:nil highLightColor:RGB(0, 0, 0, 0.15)];
                    
                    [commentTextStorage lw_addLinkWithData:[NSString stringWithFormat:@"%ld",commentDict.info.brokerid]
                                                     range:NSMakeRange(0,[(NSString *)commentDict.info.realname length])
                                                 linkColor:AppMainColor
                                            highLightColor:RGB(0, 0, 0, 0.15)];
                    

                    [commentTextStorage lw_addLinkWithData:[NSString stringWithFormat:@"%ld",commentDict.info.rep_brokerid]
                                                     range:NSMakeRange([(NSString *)commentDict.info.realname length] + 2,[(NSString *)commentDict.info.rep_realname length])
                                                 linkColor:AppMainColor
                                            highLightColor:RGB(0, 0, 0, 0.15)];
                    
                    [LWTextParser parseTopicWithLWTextStorage:commentTextStorage
                                                    linkColor:AppMainColor
                                               highlightColor:RGB(0, 0, 0, 0.15)];
                    [LWTextParser parseEmojiWithTextStorage:commentTextStorage];
                    [tmp addObject:commentTextStorage];
                    offsetY += commentTextStorage.height + 5;
                } else {
                    NSString* commentString = [NSString stringWithFormat:@"%@: %@",commentDict.info.realname,commentDict.info.content];
                    LWTextStorage* commentTextStorage = [[LWTextStorage alloc] init];
                    commentTextStorage.text = commentString;
                    commentTextStorage.font = Size(26.0f);
                    commentTextStorage.textColor = [UIColor colorWithRed:0.3059 green:0.3098 blue:0.3137 alpha:1.0];
                    commentTextStorage.textAlignment = NSTextAlignmentLeft;
                    commentTextStorage.linespacing = 2.0f;
                    commentTextStorage.frame = CGRectMake(rect.origin.x, rect.origin.y + 20.0f + offsetY,nameTextStorage.width + 24, CGFLOAT_MAX);
                    
                
                    [commentTextStorage lw_addLinkForWholeTextStorageWithData:commentDict linkColor:nil highLightColor:RGB(0, 0, 0, 0.15)];
                    [commentTextStorage lw_addLinkWithData:[NSString stringWithFormat:@"%ld",commentDict.info.brokerid]
                                                     range:NSMakeRange(0,[(NSString *)commentDict.info.realname length])
                                                 linkColor:AppMainColor
                                            highLightColor:RGB(0, 0, 0, 0.15)];
                    
                    [LWTextParser parseTopicWithLWTextStorage:commentTextStorage
                                                    linkColor:AppMainColor
                                               highlightColor:RGB(0, 0, 0, 0.15)];
                    [LWTextParser parseEmojiWithTextStorage:commentTextStorage];
                    [tmp addObject:commentTextStorage];
                    offsetY += commentTextStorage.height + 5;
                }
            }
            //如果有评论，设置评论背景Storage
            commentTextStorages = tmp;
            commentBgPosition = CGRectMake(60.0f,dateTextStorage.bottom + 5.0f, SCREEN_WIDTH - 80, offsetY + 15.0f);
            commentBgStorage.frame = commentBgPosition;
            commentBgStorage.contents = [UIImage imageNamed:@"comment"];
            [commentBgStorage stretchableImageWithLeftCapWidth:40 topCapHeight:15];
        }
        
        [self addStorage:nameTextStorage];
        [self addStorage:industryTextStorage];
    
        [self addStorage:contentTextStorage];
        [self addStorage:dateTextStorage];
        [self addStorages:commentTextStorages];
        [self addStorage:commentBgStorage];
        
        [self addStorages:imageStorageArray];
        if (priseStorageArray) {
            [self addStorages:priseStorageArray];
            [self addStorage:likeImageSotrage];
            [self addStorage:moreImageSotrage];
        }
        //一些其他属性
//        self.menuPosition = menuPosition;
        self.commentBgPosition = commentBgPosition;
        self.imagePostionArray = imagePositionArray;
        self.prisePostionArray = prisePositionArray;
        self.imageStorageArray = imageStorageArray;
        self.statusModel = statusModel;
        //如果是使用在UITableViewCell上面，可以通过以下方法快速的得到Cell的高度
        
        self.cellHeight = [self suggestHeightWithBottomMargin:25.0f];
        if (statusModel.comment.count>10&&!isDetail) {
            //查看更多
            LWTextStorage* lookMoreStorage = [[LWTextStorage alloc] init];
            lookMoreStorage.text = @"查看更多";
            lookMoreStorage.font = Size(26.0);
            lookMoreStorage.textColor = [UIColor colorWithRed:0.7765 green:0.7843 blue:0.7882 alpha:1.0];
           
            [lookMoreStorage lw_addLinkForWholeTextStorageWithData:[NSDictionary dictionaryWithObjectsAndKeys:@"查看更多",@"key",[NSString stringWithFormat:@"%ld", statusModel.ID],@"id", nil] linkColor:nil highLightColor:RGB(0, 0, 0, 0.15)];
            lookMoreStorage.frame = CGRectMake(SCREEN_WIDTH - 70, self.cellHeight - 20,52, CGFLOAT_MAX);
            [self addStorage:lookMoreStorage];
            self.cellHeight +=10;
        }
        self.cellMarginsRect = frame(0, self.cellHeight - 10, APPWIDTH, 10);
        
    }
    return self;
}
- (id)initContentOpendLayoutWithStatusModel:(StatusDatas *)statusModel
                                      index:(NSInteger)index isDetail:(BOOL)isDetail{
    self = [super init];
    if (self) {
        self.statusModel = statusModel;
        //头像模型 avatarImageStorage
        LWImageStorage * _avatarStorage = [[LWImageStorage alloc] initWithIdentifier:@"avatar"];
        _avatarStorage.frame =CGRectMake(10, 10, 40, 40);
        _avatarPosition = CGRectMake(10, 10, 40, 40);
        
        NSString *renzen;
        if (statusModel.authen==3) {
            renzen = @"[renzhen]";
        }
        else
        {
            renzen=@"[weirenzhen]";
        }
        //名字模型 nameTextStorage
        LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
        
        nameTextStorage.text = [NSString stringWithFormat:@"%@ %@",statusModel.realname,renzen];
        nameTextStorage.font = Size(28.0);
        nameTextStorage.frame = CGRectMake(_avatarStorage.right + 6, 15.0f, SCREEN_WIDTH - (_avatarStorage.right + 6 + 30), CGFLOAT_MAX);
        [nameTextStorage lw_addLinkWithData:[NSString stringWithFormat:@"%ld",statusModel.brokerid]
                                      range:NSMakeRange(0,statusModel.realname.length)
                                  linkColor:BlackTitleColor
                             highLightColor:RGB(0, 0, 0, 0.15)];
        
        [LWTextParser parseEmojiWithTextStorage:nameTextStorage];
        
        
        if (!isDetail||statusModel.me) {
            //更多操作
            LWImageStorage* moreStorage = [[LWImageStorage alloc] initWithIdentifier:@"more"];
            moreStorage.tag = 30;
            moreStorage.frame = CGRectMake(APPWIDTH - 40, 0, 40, 40);
            [self addStorage:moreStorage];
            self.isShowMore = YES;
            
        }
        else
        {
            self.isShowMore = NO;
        }
        
        //行业
        LWTextStorage* industryTextStorage = [[LWTextStorage alloc] init];
        if (statusModel.address.length>0) {
            industryTextStorage.text = [NSString stringWithFormat:@"%@  %@",statusModel.address,statusModel.workyear];
        }
        else
        {
            industryTextStorage.text = [NSString stringWithFormat:@"%@",statusModel.workyear];
        }
        
        industryTextStorage.textColor = [UIColor colorWithRed:0.549 green:0.5569 blue:0.5608 alpha:1.0];
        industryTextStorage.font = Size(24.0);
        industryTextStorage.frame = CGRectMake(nameTextStorage.left, nameTextStorage.bottom + 8, nameTextStorage.width, CGFLOAT_MAX);
        
        //正文内容模型 contentTextStorage
        LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
        contentTextStorage.text = statusModel.content;
        contentTextStorage.font = Size(26.0);
        contentTextStorage.textColor = [UIColor colorWithRed:0.1294 green:0.1333 blue:0.1333 alpha:1.0];
        
        contentTextStorage.frame = CGRectMake(industryTextStorage.left, industryTextStorage.bottom + 10.0f, SCREEN_WIDTH - 80.0f, CGFLOAT_MAX);
        if ([statusModel.address isEqualToString:@""]&&[statusModel.workyear isEqualToString:@""]) {
            contentTextStorage.frame = CGRectMake(nameTextStorage.left, nameTextStorage.bottom + 10.0f, SCREEN_WIDTH - 80.0f, CGFLOAT_MAX);
        }
        
        //折叠文字
        LWTextStorage* closeStorage = [[LWTextStorage alloc] init];
        closeStorage.font = Size(26.0);
        closeStorage.textColor = AppMainColor;
        closeStorage.frame = CGRectMake(nameTextStorage.left,
                                        contentTextStorage.bottom + 5.0f,
                                        200.0f,
                                        30.0f);
        closeStorage.text = @"收起";
        [closeStorage lw_addLinkWithData:@"*closeStorage*"
                                   range:NSMakeRange(0, 2)
                               linkColor:AppMainColor
                          highLightColor:RGB(0, 0, 0, 0.15)];
        [self addStorage:closeStorage];
        CGFloat contentBottom = closeStorage.bottom + 10.0f;
        [LWTextParser parseEmojiWithTextStorage:contentTextStorage];
        //        [LWTextParser parseTopicWithLWTextStorage:contentTextStorage
        //                                        linkColor:RGB(113, 129, 161, 1)
        //                                   highlightColor:RGB(0, 0, 0, 0.15)];
        //发布的图片模型 imgsStorage
        CGFloat imageWidth = (SCREEN_WIDTH - 100.0f)/3.0f;
        NSInteger imageCount = [statusModel.pic count];
        NSMutableArray* imageStorageArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
        NSMutableArray* imagePositionArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
        
        if ([self.statusModel.type isEqualToString:@"image"]) {
            NSInteger row = 0;
            NSInteger column = 0;
            if (imageCount == 1) {
                CGRect imageRect = CGRectMake(nameTextStorage.left,
                                              contentBottom  +(row * (imageWidth + 7.5f)),
                                              imageWidth*1.7,
                                              imageWidth*1.7);
                NSString* imagePositionString = NSStringFromCGRect(imageRect);
                [imagePositionArray addObject:imagePositionString];
                LWImageStorage* imageStorage = [[LWImageStorage alloc] initWithIdentifier:@"image"];
                imageStorage.tag = 0;
                imageStorage.clipsToBounds = YES;
                imageStorage.frame = imageRect;
                imageStorage.backgroundColor = RGB(240, 240, 240, 1);
                StatusPic *pic = [statusModel.pic objectAtIndex:0];
                NSString* URLString = pic.abbre_imgurl;
                imageStorage.contents = [NSURL URLWithString:URLString];
                [imageStorageArray addObject:imageStorage];
            } else {
                for (NSInteger i = 0; i < imageCount; i ++) {
                    CGRect imageRect = CGRectMake(nameTextStorage.left + (column * (imageWidth + 7.5f)),
                                                  contentBottom + (row * (imageWidth + 7.5f)),
                                                  imageWidth,
                                                  imageWidth);
                    NSString* imagePositionString = NSStringFromCGRect(imageRect);
                    [imagePositionArray addObject:imagePositionString];
                    LWImageStorage* imageStorage = [[LWImageStorage alloc] initWithIdentifier:@"image"];
                    imageStorage.clipsToBounds = YES;
                    imageStorage.tag = i;
                    imageStorage.frame = imageRect;
                    imageStorage.backgroundColor = RGB(240, 240, 240, 1);
                    StatusPic *pic = [statusModel.pic objectAtIndex:i];
                    NSString* URLString = pic.abbre_imgurl;
                    imageStorage.contents = [NSURL URLWithString:URLString];
                    [imageStorageArray addObject:imageStorage];
                    column = column + 1;
                    if (column > 2) {
                        column = 0;
                        row = row + 1;
                    }
                }
            }
            
        }
        else if ([self.statusModel.type isEqualToString:@"website"]) {
            self.websiteRect = CGRectMake(nameTextStorage.left,contentTextStorage.bottom + 5.0f,SCREEN_WIDTH - 80.0f,60.0f);
            LWImageStorage* imageStorage = [[LWImageStorage alloc] init];
            StatusPic *pic = [statusModel.pic objectAtIndex:0];
            NSString* URLString = pic.imgurl;
            imageStorage.contents = [NSURL URLWithString:URLString];
            imageStorage.clipsToBounds = YES;
            imageStorage.frame = CGRectMake(nameTextStorage.left + 5.0f, contentTextStorage.bottom + 10.0f , 50.0f, 50.0f);
            [imageStorageArray addObject:imageStorage];
            
            LWTextStorage* detailTextStorage = [[LWTextStorage alloc] init];
            detailTextStorage.text = statusModel.content;
            detailTextStorage.font = [UIFont fontWithName:@"Heiti SC" size:12.0f];
            detailTextStorage.textColor = RGB(40, 40, 40, 1);
            detailTextStorage.frame = CGRectMake(imageStorage.right + 10.0f, contentTextStorage.bottom + 10.0f, SCREEN_WIDTH - 150.0f, 60.0f);
            detailTextStorage.linespacing = 0.5f;
            [detailTextStorage lw_addLinkForWholeTextStorageWithData:@"https://github.com/waynezxcv/LWAlchemy" linkColor:nil highLightColor:RGB(0, 0, 0, 0.15)];
            [self addStorage:detailTextStorage];
        }
        else if ([self.statusModel.type isEqualToString:@"video"]) {
            
        }
    
        
        //获取最后一张图片的模型
        LWImageStorage* lastImageStorage = (LWImageStorage *)[imageStorageArray lastObject];
        //生成时间的模型 dateTextStorage
        LWTextStorage* dateTextStorage = [[LWTextStorage alloc] init];
        dateTextStorage.text = [statusModel.createtime updateTime];
        
        dateTextStorage.font = Size(22);
        dateTextStorage.textColor = [UIColor colorWithRed:0.7216 green:0.7294 blue:0.7333 alpha:1.0];
        
        dateTextStorage.frame = CGRectMake(nameTextStorage.left, contentBottom, SCREEN_WIDTH - 80.0f, CGFLOAT_MAX);
        if (lastImageStorage) {
            
            dateTextStorage.frame = CGRectMake(nameTextStorage.left, lastImageStorage.bottom + 10.0f, SCREEN_WIDTH - 80.0f, CGFLOAT_MAX);
            
        }
        
        self.lineRect = CGRectMake(0, dateTextStorage.bottom + 10.0f,  SCREEN_WIDTH, 0.5f);
        if (statusModel.like.count==0&&statusModel.comment.count==0) {
            self.lineRect = CGRectZero;
        }
        
        //评论位置
        UIImage *commentImage = [UIImage imageNamed:@"dongtai_pinglun"];
        NSString *commentStr = [NSString stringWithFormat:@"%ld评论",statusModel.comment.count];
        if (statusModel.comment.count ==0) {
            commentStr = @"评论";
        }
        CGSize commentsize = [commentStr sizeWithFont:Size(22) maxSize:CGSizeMake(100, 22*SpacedFonts)];
        
        self.commentPosition = frame(APPWIDTH - 15 - commentImage.size.width - commentsize.width,dateTextStorage.top, commentImage.size.width + commentsize.width + 10, 16);
        //点赞位置
        
        UIImage *priseImage = [UIImage imageNamed:@"dongtai_dianzan_normal"];
        NSString *priseStr = [NSString stringWithFormat:@"%ld赞",statusModel.like.count];
        if (statusModel.like.count ==0) {
            priseStr = @"赞";
        }
        CGSize prisesize = [priseStr sizeWithFont:Size(22) maxSize:CGSizeMake(100, 22*SpacedFonts)];
        self.prisePosition = frame(self.commentPosition.origin.x - 25 - priseImage.size.width - prisesize.width,dateTextStorage.top, priseImage.size.width + prisesize.width + 10, 16);
        
        //生成评论背景Storage
        LWImageStorage* commentBgStorage = [[LWImageStorage alloc] init];
        NSArray* commentTextStorages = @[];
        CGRect commentBgPosition = CGRectZero;
        CGRect rect = CGRectMake(nameTextStorage.left - 28,dateTextStorage.bottom + 5.0f, SCREEN_WIDTH - 80, 20);
        CGFloat offsetY = 0.0f;
        //点赞
        LWImageStorage* likeImageSotrage = [[LWImageStorage alloc] init];
        LWImageStorage* moreImageSotrage = [[LWImageStorage alloc] init];
        //        NSLog(@"[statusModel.like count] =%ld",[statusModel.like count]);
        NSInteger priseCount = [statusModel.like count];
        NSMutableArray* priseStorageArray = [[NSMutableArray alloc] initWithCapacity:priseCount];
        NSMutableArray* prisePositionArray = [[NSMutableArray alloc] initWithCapacity:priseCount];
        if (self.statusModel.like.count != 0) {
            likeImageSotrage.contents = [UIImage imageNamed:@"dongtai_dianzan_pressed"];
            likeImageSotrage.frame = CGRectMake(rect.origin.x,rect.origin.y + 20.0 + offsetY,20.0, 20.0);
            CGFloat priseWidth = 32.0;
            
            NSInteger count = 0;
            if (priseCount<6) {
                count =priseCount;
            }
            else
            {
                if (!isDetail) {
                    count =5;
                    moreImageSotrage.tag = 20;//更多
                    moreImageSotrage.contents = [UIImage imageNamed:@"dongtai_gengduozan"];
                    moreImageSotrage.frame = CGRectMake(nameTextStorage.left + (5 * (priseWidth + 8.0)),likeImageSotrage.top,20.0, 20.0);
                }
                else
                {
                    count =priseCount;
                }
                
                
                
            }
            
            int row = 1;
            int rowCount = 0;
            for (int i =0; i<count; i++) {
                
                CGRect priseRect = CGRectMake(nameTextStorage.left + (rowCount * (priseWidth + 7.5f)),
                                              likeImageSotrage.top - 6.0 +(row-1)*(priseWidth + 7.5f),
                                              priseWidth,
                                              priseWidth);
                NSString* prisePositionString = NSStringFromCGRect(priseRect);
                [prisePositionArray addObject:prisePositionString];
                
                LWImageStorage* priseStorage = [[LWImageStorage alloc] initWithIdentifier:@"prise"];
                
                priseStorage.contents = statusModel.like[i].imgurl;
                priseStorage.placeholder = [UIImage imageNamed:@"defaulthead"];
                if ([statusModel.like[i].imgurl isEqualToString:ImageURLS]) {
                    
                    if (statusModel.like[i].sex==1) {
                        priseStorage.contents = [UIImage imageNamed:@"defaulthead"];
                    }
                    else
                    {
                        priseStorage.contents = [UIImage imageNamed:@"defaulthead_nv"];
                        
                    }
                }
                
                priseStorage.cornerRadius = priseWidth/2.0;
                priseStorage.cornerBackgroundColor = [UIColor whiteColor];
                priseStorage.backgroundColor = [UIColor whiteColor];
                priseStorage.frame = priseRect;
                priseStorage.tag = 10+i;
                
                [priseStorageArray addObject:priseStorage];
                
                rowCount++;
                offsetY =((priseWidth + 7.5)*row - 4);
                if ((nameTextStorage.left + (rowCount + 1)*(priseWidth + 7.5f))>APPWIDTH) {
                    
                    rowCount = 0;
                    row +=1;
                }
            }
            
            
        }
        if (statusModel.comment.count != 0 && statusModel.comment != nil) {
            
            
            NSMutableArray* tmp = [[NSMutableArray alloc] initWithCapacity:statusModel.comment.count];
            
            int count =0;
            if (isDetail||statusModel.comment.count<11) {
                count=(int) statusModel.comment.count;
            }
            else
            {
                count =10;
            }
            for (int i=0; i<count;i++) {
                StatusComment* commentDict = statusModel.comment[i];
                NSString* to = commentDict.info.rep_realname;
                if (to.length != 0) {
                    NSString* commentString = [NSString stringWithFormat:@"%@回复%@: %@",commentDict.info.realname,to,commentDict.info.content];
                    LWTextStorage* commentTextStorage = [[LWTextStorage alloc] init];
                    commentTextStorage.text = commentString;
                    commentTextStorage.font = Size(26.0f);
                    commentTextStorage.textColor = [UIColor colorWithRed:0.3059 green:0.3098 blue:0.3137 alpha:1.0];
                    commentTextStorage.frame = CGRectMake(rect.origin.x, rect.origin.y + 20.0f + offsetY,nameTextStorage.width + 24, CGFLOAT_MAX);
                    
                    [commentTextStorage lw_addLinkForWholeTextStorageWithData:commentDict linkColor:nil highLightColor:RGB(0, 0, 0, 0.15)];
                    
                    [commentTextStorage lw_addLinkWithData:[NSString stringWithFormat:@"%ld",commentDict.info.brokerid]
                                                     range:NSMakeRange(0,[(NSString *)commentDict.info.realname length])
                                                 linkColor:AppMainColor
                                            highLightColor:RGB(0, 0, 0, 0.15)];
                    
                    
                    [commentTextStorage lw_addLinkWithData:[NSString stringWithFormat:@"%ld",commentDict.info.rep_brokerid]
                                                     range:NSMakeRange([(NSString *)commentDict.info.realname length] + 2,[(NSString *)commentDict.info.rep_realname length])
                                                 linkColor:AppMainColor
                                            highLightColor:RGB(0, 0, 0, 0.15)];
                    
                    [LWTextParser parseTopicWithLWTextStorage:commentTextStorage
                                                    linkColor:AppMainColor
                                               highlightColor:RGB(0, 0, 0, 0.15)];
                    [LWTextParser parseEmojiWithTextStorage:commentTextStorage];
                    [tmp addObject:commentTextStorage];
                    offsetY += commentTextStorage.height + 5;
                } else {
                    NSString* commentString = [NSString stringWithFormat:@"%@: %@",commentDict.info.realname,commentDict.info.content];
                    LWTextStorage* commentTextStorage = [[LWTextStorage alloc] init];
                    commentTextStorage.text = commentString;
                    commentTextStorage.font = Size(26.0f);
                    commentTextStorage.textColor = [UIColor colorWithRed:0.3059 green:0.3098 blue:0.3137 alpha:1.0];
                    commentTextStorage.textAlignment = NSTextAlignmentLeft;
                    commentTextStorage.linespacing = 2.0f;
                    commentTextStorage.frame = CGRectMake(rect.origin.x, rect.origin.y + 20.0f + offsetY,nameTextStorage.width + 24, CGFLOAT_MAX);
                    
                    
                    [commentTextStorage lw_addLinkForWholeTextStorageWithData:commentDict linkColor:nil highLightColor:RGB(0, 0, 0, 0.15)];
                    [commentTextStorage lw_addLinkWithData:[NSString stringWithFormat:@"%ld",commentDict.info.brokerid]
                                                     range:NSMakeRange(0,[(NSString *)commentDict.info.realname length])
                                                 linkColor:AppMainColor
                                            highLightColor:RGB(0, 0, 0, 0.15)];
                    
                    [LWTextParser parseTopicWithLWTextStorage:commentTextStorage
                                                    linkColor:AppMainColor
                                               highlightColor:RGB(0, 0, 0, 0.15)];
                    [LWTextParser parseEmojiWithTextStorage:commentTextStorage];
                    [tmp addObject:commentTextStorage];
                    offsetY += commentTextStorage.height + 5;
                }
            }
            //如果有评论，设置评论背景Storage
            commentTextStorages = tmp;
            commentBgPosition = CGRectMake(60.0f,dateTextStorage.bottom + 5.0f, SCREEN_WIDTH - 80, offsetY + 15.0f);
            commentBgStorage.frame = commentBgPosition;
            commentBgStorage.contents = [UIImage imageNamed:@"comment"];
            [commentBgStorage stretchableImageWithLeftCapWidth:40 topCapHeight:15];
        }
        
        [self addStorage:nameTextStorage];
        [self addStorage:industryTextStorage];
        
        [self addStorage:contentTextStorage];
        [self addStorage:dateTextStorage];
        [self addStorages:commentTextStorages];
        [self addStorage:commentBgStorage];
        
        [self addStorages:imageStorageArray];
        if (priseStorageArray) {
            [self addStorages:priseStorageArray];
            [self addStorage:likeImageSotrage];
            [self addStorage:moreImageSotrage];
        }
        //一些其他属性
        //        self.menuPosition = menuPosition;
        self.commentBgPosition = commentBgPosition;
        self.imagePostionArray = imagePositionArray;
        self.prisePostionArray = prisePositionArray;
        self.imageStorageArray = imageStorageArray;
        self.statusModel = statusModel;
        //如果是使用在UITableViewCell上面，可以通过以下方法快速的得到Cell的高度
        
        self.cellHeight = [self suggestHeightWithBottomMargin:25.0f];
        if (statusModel.comment.count>10&&!isDetail) {
            //查看更多
            LWTextStorage* lookMoreStorage = [[LWTextStorage alloc] init];
            lookMoreStorage.text = @"查看更多";
            lookMoreStorage.font = Size(26.0);
            lookMoreStorage.textColor = [UIColor colorWithRed:0.7765 green:0.7843 blue:0.7882 alpha:1.0];
            
            [lookMoreStorage lw_addLinkForWholeTextStorageWithData:[NSDictionary dictionaryWithObjectsAndKeys:@"查看更多",@"key",[NSString stringWithFormat:@"%ld", statusModel.ID],@"id", nil] linkColor:nil highLightColor:RGB(0, 0, 0, 0.15)];
            lookMoreStorage.frame = CGRectMake(SCREEN_WIDTH - 70, self.cellHeight - 20,52, CGFLOAT_MAX);
            [self addStorage:lookMoreStorage];
            self.cellHeight +=10;
        }
        self.cellMarginsRect = frame(0, self.cellHeight - 10, APPWIDTH, 10);
        
    }
    return self;

}
@end
