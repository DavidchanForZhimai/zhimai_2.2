




/********************* 有任何问题欢迎反馈给我 liuweiself@126.com ****************************************/
/***************  https://github.com/waynezxcv/Gallop 持续更新 ***************************/
/******************** 正在不断完善中，谢谢~  Enjoy ******************************************************/




#import "TableViewCell.h"
#import "LWImageStorage.h"
#import "BaseButton.h"
#import "UILabel+Extend.h"
#import "NSString+Extend.h"
#import "WetChatShareManager.h"
@interface TableViewCell ()<LWAsyncDisplayViewDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) LWAsyncDisplayView* asyncDisplayView;
@property (nonatomic,strong) BaseButton* comentButton;
@property (nonatomic,strong) BaseButton* avatarImage;
@property (nonatomic,strong) BaseButton* likeButton;
@property (nonatomic,strong) UIImageView* moreImage;
@property (nonatomic,strong) UILabel* likeLb;
@property (nonatomic,strong) UIView* line;
@property (nonatomic,strong) UIView* cellline;
@property(nonatomic,strong)  BaseButton* webSiteBtn;
//线索
@property(nonatomic,strong)  BaseButton* clueTitle;
@property(nonatomic,strong)  UILabel* clueCount;
@property(nonatomic,strong)  BaseButton* cooperation_benefit;
//合作利益

@end

@implementation TableViewCell

#pragma mark - Init

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.asyncDisplayView];
        [self.contentView addSubview:self.clueTitle];
        [self.contentView addSubview:self.avatarImage];
        [self.contentView addSubview:self.likeLb];
        [self.contentView addSubview:self.comentButton];
        [self.contentView addSubview:self.likeButton];
        
        [self.contentView addSubview:self.moreImage];
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.cellline];
        [self.contentView addSubview:self.webSiteBtn];//网站文章
        
        [self.contentView addSubview:self.cooperation_benefit];
    }
    return self;
}


#pragma mark - Actions

/***  点击图片  ***/
- (void)lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView
   didCilickedImageStorage:(LWImageStorage *)imageStorage
                     touch:(UITouch *)touch{
    //    NSLog(@"tag:%ld",imageStorage.tag);//这里可以通过判断Tag来执行相应的回调。
    //查看动态详情
    if (imageStorage.tag ==20) {
        if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickedLikeButtonWithDTID:atIndexPath:)] &&
            [self.delegate conformsToProtocol:@protocol(TableViewCellDelegate)]) {
            [self.delegate tableViewCell:self didClickedLikeButtonWithDTID:[NSString stringWithFormat:@"%ld",_cellLayout.statusModel.ID] atIndexPath:_indexPath];
        }
        return;
    }
    
    //点击更多
    else if (imageStorage.tag ==30) {
        [self didClickedMenuButton:imageStorage];
        return;
    }
    
    CGPoint point = [touch locationInView:self];
    
    for (NSInteger i = 0; i < self.cellLayout.imagePostionArray.count; i ++) {
        CGRect imagePosition = CGRectFromString(self.cellLayout.imagePostionArray[i]);
        if (CGRectContainsPoint(imagePosition, point)) {
            if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickedImageWithCellLayout:atIndex:)] &&
                [self.delegate conformsToProtocol:@protocol(TableViewCellDelegate)]) {
                [self.delegate tableViewCell:self didClickedImageWithCellLayout:self.cellLayout atIndex:i];
            }
        }
    }
    
    if (imageStorage.tag>=10) {
        for (NSInteger i = 0; i < self.cellLayout.prisePostionArray.count; i ++) {
            CGRect prisePosition = CGRectFromString(self.cellLayout.prisePostionArray[i]);
            if (CGRectContainsPoint(prisePosition, point)) {
                if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickedLikeButtonWithJJRId:)] &&
                    [self.delegate conformsToProtocol:@protocol(TableViewCellDelegate)]) {
                    
                    StatusLike *like = self.cellLayout .statusModel.like[i];
                    [self.delegate tableViewCell:self didClickedLikeButtonWithJJRId:[NSString stringWithFormat:@"%ld",like.brokerid]];
                }
            }
        }
        
    }
}

/***  点击文本链接 ***/
- (void)lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView didCilickedTextStorage:(LWTextStorage *)textStorage linkdata:(id)data {
    //    NSLog(@"tag:%ld",textStorage.tag);//这里可以通过判断Tag来执行相应的回调。
    if ([self.delegate respondsToSelector:@selector(tableViewCell:cellLayout: atIndexPath: didClickedLinkWithData:)] &&
        [self.delegate conformsToProtocol:@protocol(TableViewCellDelegate)]) {
        [self.delegate tableViewCell:self cellLayout:self.cellLayout  atIndexPath:_indexPath didClickedLinkWithData:data];
    }
}

/***  点击菜单按钮  ***/
- (void)didClickedMenuButton:(LWImageStorage *)imageStorage {
    UIActionSheet *sheet;
    if (self.cellLayout.statusModel.me) {
        
        sheet = [[UIActionSheet alloc]initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除",@"分享", nil];
        sheet.tag =88;
        [sheet showInView:self];
        
    }
    else
    {
        
        sheet = [[UIActionSheet alloc]initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"举报",@"分享", nil];
        sheet.tag =888;
        [sheet showInView:self];
        
    }
    
    sheet.actionSheetStyle= UIActionSheetStyleBlackOpaque;
    
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==88) {
        if (buttonIndex==0) {
            if ([self.delegate respondsToSelector:@selector(tableViewCell: didClickedLikeButtonWithIsSelf:andDynamicID: atIndexPath: andIndex:)] &&
                [self.delegate conformsToProtocol:@protocol(TableViewCellDelegate)]) {
                [self.delegate tableViewCell:self didClickedLikeButtonWithIsSelf:self.cellLayout.statusModel.me andDynamicID:[NSString stringWithFormat:@"%ld",self.cellLayout.statusModel.ID] atIndexPath:_indexPath andIndex:buttonIndex];
            }
            
        }
        else if (buttonIndex==1)
        {
            //分享
            //获取最后一张图片的模型
            UIImage *image = [UIImage imageNamed:@"wx-logo.jpg"];
            if (_cellLayout.imageStorageArray.count>0) {
                LWImageStorage* lastImageStorage = (LWImageStorage *)[_cellLayout.imageStorageArray firstObject];
                image= lastImageStorage.imageStorage;
            }
            else
            {
                if (![_cellLayout.statusModel.imgurl isEqualToString:ImageURLS]) {
                    image = _avatarImage.imageView.image;
                }
                
            }
            
            [[WetChatShareManager shareInstance] dynamicShareTo:_cellLayout.statusModel.sharetitle desc:_cellLayout.statusModel.content image:image shareurl:_cellLayout.statusModel.shareurl ];
            
        }
        
    }
    else
    {
        if (buttonIndex==1)
        {
            //分享
            //获取最后一张图片的模型
            UIImage *image = [UIImage imageNamed:@"wx-logo.jpg"];
            if (_cellLayout.imageStorageArray.count>0) {
                LWImageStorage* lastImageStorage = (LWImageStorage *)[_cellLayout.imageStorageArray firstObject];
                image= lastImageStorage.imageStorage;
            }
            else
            {
                if (![_cellLayout.statusModel.imgurl isEqualToString:ImageURLS]) {
                    image = _avatarImage.imageView.image;
                }
                
            }
            
            [[WetChatShareManager shareInstance] dynamicShareTo:_cellLayout.statusModel.sharetitle desc:_cellLayout.statusModel.content image:image shareurl:_cellLayout.statusModel.shareurl ];
            
            return;
        }
        else if(buttonIndex==0)
        {
            [[ToolManager shareInstance] showAlertMessage:@"举报成功"];
        }
        
        //            [self.delegate tableViewCell:self didClickedLikeButtonWithIsSelf:self.cellLayout.statusModel.me andDynamicID:[NSString stringWithFormat:@"%ld",self.cellLayout.statusModel.ID] atIndexPath:_indexPath andIndex:buttonIndex];
    }
    
    
    
}

- (BOOL)canBecomeFirstResponder{
    
    return YES;
    
}

#pragma mark - Draw and setup
- (void)setCellLayout:(CellLayout *)cellLayout {
    if (_cellLayout == cellLayout) {
        return;
    }
    _cellLayout = cellLayout;
    self.asyncDisplayView.layout = self.cellLayout;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.clueTitle.frame = CGRectMake(10,10,SCREEN_WIDTH-20,self.cellLayout.cellHeight-30);
    [self.clueTitle setTitle:self.cellLayout.statusModel.typeinfo.title forState:UIControlStateNormal];
    
    self.clueCount.frame = CGRectMake(20,self.cellLayout.cellHeight-60,SCREEN_WIDTH-50,30);
    self.clueCount.text = [NSString stringWithFormat:@"%@人领取",self.cellLayout.statusModel.typeinfo.count];
    self.asyncDisplayView.frame = CGRectMake(0,0,SCREEN_WIDTH,self.cellLayout.cellHeight);
    self.asyncDisplayView.backgroundColor = [UIColor clearColor];
    if (self.cellLayout.statusModel.type ==DTDataTypeClue )
    {
        self.avatarImage.hidden = YES;
        self.likeLb.hidden = YES;
        self.comentButton.hidden = YES;
        self.moreImage.hidden = YES;
        self.likeButton.hidden = YES;
        self.line.hidden = YES;
        self.webSiteBtn.hidden = YES;
        self.clueTitle.hidden = NO;
        self.clueCount.hidden = NO;
        self.cooperation_benefit.hidden = YES;
    }
    else
    {
        self.clueTitle.hidden = YES;
        self.avatarImage.hidden = NO;
        self.likeLb.hidden = NO;
        self.comentButton.hidden = NO;
        self.moreImage.hidden = NO;
        self.likeButton.hidden = NO;
        self.line.hidden = NO;
        self.webSiteBtn.hidden = NO;
        self.clueCount.hidden = YES;
        
        if (self.cellLayout.statusModel.cooperation_benefit &&![self.cellLayout.statusModel.cooperation_benefit isEqualToString:@""]) {
            self.cooperation_benefit.hidden = NO;
            if (_cellLayout.isShowMore) {
                self.cooperation_benefit.frame = CGRectMake(APPWIDTH - 90, 7, 55, 23);
            }
            else
            {
                self.cooperation_benefit.frame = CGRectMake(APPWIDTH - 65, 7, 55, 23);
            }
            
            __weak typeof(self) weakSelf =self;
            _cooperation_benefit.didClickBtnBlock = ^
            {
                UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"合作利益描述" message:weakSelf.cellLayout.statusModel.cooperation_benefit delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alert.tintColor = AppMainColor;
                [alert show];
            };
            
        }
        else
        {
            self.cooperation_benefit.hidden = YES;
        }
        
        NSString *pinlun =[NSString stringWithFormat:@"%ld评论",self.cellLayout.statusModel.comment.count];
        if (_cellLayout.statusModel.comment.count ==0) {
            pinlun = @"评论";
        }
        [self.comentButton setTitle:pinlun forState:UIControlStateNormal];
        UIImage *nomral;
        UIImage *selected;
        if (_cellLayout.statusModel.islike) {
            
            nomral =[UIImage imageNamed:@"dongtai_dianzan_pressed"];
            selected= [UIImage imageNamed:@"dongtai_dianzan_normal"];
        }
        else
        {
            nomral =[UIImage imageNamed:@"dongtai_dianzan_normal"];
            selected= [UIImage imageNamed:@"dongtai_dianzan_pressed"];
        }
        self.likeButton.imagePoint = CGPointMake(0 , 0);
        self.likeButton.titlePoint = CGPointMake(0 , 3);
        [self.likeButton setImage:nomral forState:UIControlStateNormal];
        [self.likeButton setImage:selected forState:UIControlStateHighlighted];
        _likeButton.anmialScal = 1.5;
        _likeButton.shouldAnmial = !_cellLayout.statusModel.islike;
        _likeButton.anmialTime = 0.5;
        
        NSString *priseStr = [NSString stringWithFormat:@"%ld赞",_cellLayout.statusModel.like.count];
        if (_cellLayout.statusModel.like.count ==0) {
            priseStr = @"赞";
        }
        CGSize prisesize = [priseStr sizeWithFont:Size(22) maxSize:CGSizeMake(100, 22*SpacedFonts)];
        self.likeLb.frame = frame(self.cellLayout.prisePosition.origin.x +nomral.size.width + 15, self.cellLayout.prisePosition.origin.y + 2, prisesize.width, 22*SpacedFonts);
        self.likeLb.text = priseStr;
        self.line.frame = self.cellLayout.lineRect;
        self.moreImage.frame = frame(APPWIDTH -30, 10, 16, 16);
        self.moreImage.hidden = !_cellLayout.isShowMore;
        _avatarImage.frame = _cellLayout.avatarPosition;
        [_avatarImage setRound];
        [[ToolManager shareInstance] imageView:_avatarImage setImageWithURL:_cellLayout.statusModel.imgurl placeholderType:PlaceholderTypeUserHead];
        
        self.likeButton.frame = self.cellLayout.prisePosition;
        self.comentButton.frame = self.cellLayout.commentPosition;
        self.webSiteBtn.frame = self.cellLayout.websiteRect;
        self.webSiteBtn.titleEdgeInsets = UIEdgeInsetsMake(4,45, 4,10);
        
        if (self.cellLayout.statusModel.type == DTDataTypeArticle) {
            self.webSiteimg.frame = CGRectMake(5, 5, 37, 37);
            [[ToolManager shareInstance] imageView:self.webSiteimg setImageWithURL:self.cellLayout.statusModel.typeinfo.imgurl placeholderType:PlaceholderTypeOther];
        }
        else
        {
            self.webSiteimg.frame = CGRectZero;
        }
        

        if (self.cellLayout.statusModel.isshow_title) {
            [self.webSiteBtn setTitle:self.cellLayout.statusModel.ac_title forState:UIControlStateNormal];
        }
        
    }
    
    
    
    self.cellline.frame = self.cellLayout.cellMarginsRect;
    
    
}

- (void)extraAsyncDisplayIncontext:(CGContextRef)context size:(CGSize)size isCancelled:(LWAsyncDisplayIsCanclledBlock)isCancelled {
    if (!isCancelled()) {
        //绘制分割线
        CGContextMoveToPoint(context, 0.0f, self.bounds.size.height);
        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
        CGContextSetLineWidth(context, 0.2f);
        CGContextSetStrokeColorWithColor(context,RGB(220.0f, 220.0f, 220.0f, 1).CGColor);
        CGContextStrokePath(context);
        
        //        if ([self.cellLayout.statusModel.type isEqualToString:@"website"]) {
        //            CGContextAddRect(context, self.cellLayout.websiteRect);
        //            CGContextSetFillColorWithColor(context, RGB(240, 240, 240, 1).CGColor);
        //            CGContextFillPath(context);
        //        }
    }
}

#pragma mark - Getter

- (LWAsyncDisplayView *)asyncDisplayView {
    if (!_asyncDisplayView) {
        _asyncDisplayView = [[LWAsyncDisplayView alloc] initWithFrame:CGRectZero];
        _asyncDisplayView.delegate = self;
    }
    return _asyncDisplayView;
}


- (UIView *)line {
    if (_line) {
        return _line;
    }
    _line = [[UIView alloc] initWithFrame:CGRectZero];
    _line.backgroundColor = RGB(220.0f, 220.0f, 220.0f, 1);
    return _line;
}

- (UIView *)cellline {
    if (_cellline) {
        return _cellline;
    }
    _cellline = [[UIView alloc] initWithFrame:CGRectZero];
    _cellline.backgroundColor = AppViewBGColor;
    return _cellline;
}
- (BaseButton *)likeButton {
    if (_likeButton) {
        return _likeButton;
    }
    
    
    _likeButton = [[BaseButton alloc]initWithFrame:CGRectZero backgroundImage:nil iconImage:[UIImage imageNamed:@"dongtai_dianzan_pressed"] highlightImage:[UIImage imageNamed:@"dongtai_dianzan_pressed"] inView:self];
    __weak typeof(self) weakSelf = self;
    
    _likeButton.didClickBtnBlock = ^
    {
        
        if ([weakSelf.delegate respondsToSelector:@selector(tableViewCell:didClickedLikeWithCellLayout:atIndexPath:)]) {
            [weakSelf.delegate tableViewCell:weakSelf didClickedLikeWithCellLayout:weakSelf.cellLayout atIndexPath:weakSelf.indexPath];
        }
        
    };
    return _likeButton;
}
- (BaseButton *)comentButton
{
    if (_comentButton) {
        return _comentButton;
    }
    
    UIImage *commentImage = [UIImage imageNamed:@"dongtai_pinglun"];
    
    _comentButton = [[BaseButton alloc]initWithFrame:self.cellLayout.commentPosition setTitle:[NSString stringWithFormat:@"%ld评论",self.cellLayout.statusModel.comment.count] titleSize:22*SpacedFonts titleColor:[UIColor colorWithRed:0.8157 green:0.8157 blue:0.8275 alpha:1.0]backgroundImage:nil iconImage:commentImage highlightImage:commentImage setTitleOrgin:CGPointMake(0 , 3) setImageOrgin:CGPointMake(0, 0) inView:self];
    __weak typeof(self) weakSelf =self;
    _comentButton.didClickBtnBlock = ^{
        
        if ([weakSelf.delegate respondsToSelector:@selector(tableViewCell:didClickedCommentWithCellLayout:atIndexPath:)]) {
            [weakSelf.delegate tableViewCell:weakSelf didClickedCommentWithCellLayout:weakSelf.cellLayout atIndexPath:weakSelf.indexPath];
            
        }
        
    };
    return _comentButton;
}

- (UILabel *)likeLb
{
    if (_likeLb) {
        
        return _likeLb;
    }
    
    
    _likeLb = [UILabel createLabelWithFrame:CGRectZero text:@"" fontSize:22*SpacedFonts textColor:[UIColor colorWithRed:0.8157 green:0.8157 blue:0.8275 alpha:1.0] textAlignment:0 inView:self];
    
    return _likeLb;
}
- (UIImageView *)moreImage
{
    if (_moreImage) {
        return _moreImage;
    }
    _moreImage =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dongtai_gengduo"]];
    return _moreImage;
}
- (BaseButton *)avatarImage
{
    if (_avatarImage) {
        return _avatarImage;
    }
    _avatarImage = [[BaseButton alloc]initWithFrame:CGRectZero];
    __weak typeof(self) weakSelf =self;
    _avatarImage.didClickBtnBlock = ^{
        if ([weakSelf.delegate respondsToSelector:@selector(tableViewCell:didClickedLikeButtonWithJJRId:)] &&
            [weakSelf.delegate conformsToProtocol:@protocol(TableViewCellDelegate)]) {
            StatusDatas *like = weakSelf.cellLayout .statusModel;
            [weakSelf.delegate tableViewCell:weakSelf didClickedLikeButtonWithJJRId:[NSString stringWithFormat:@"%ld",like.brokerid]];
        }
        
    };
    return _avatarImage;
    
}

//文章
- (BaseButton *)webSiteBtn
{
    
    if (!_webSiteBtn) {
        _webSiteBtn = [[BaseButton alloc]initWithFrame:CGRectZero setTitle:@"" titleSize:12 titleColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft backgroundColor:rgba(0, 0, 0, 0.05) inView:nil];
        _webSiteBtn.titleLabel.numberOfLines = 2;
        _webSiteBtn.hidden = YES;
        [_webSiteBtn addSubview:self.webSiteimg];
        _webSiteBtn.shouldAnmial = NO;
        __weak typeof(self) weakSelf = self;
        _webSiteBtn.didClickBtnBlock = ^
        {
            if ([weakSelf.delegate respondsToSelector:@selector(tableViewCell:didClickedLikeButtonWithArticleID: atIndexPath:)] &&[weakSelf.delegate conformsToProtocol:@protocol(TableViewCellDelegate)]) {
                [weakSelf.delegate tableViewCell:weakSelf didClickedLikeButtonWithArticleID:weakSelf.cellLayout.statusModel.acid atIndexPath:weakSelf.indexPath];
            }
        };
    }
    
   
    return _webSiteBtn;
}
- (UIImageView *)webSiteimg
{
    if (!_webSiteimg) {
        _webSiteimg  = [[UIImageView alloc]initWithFrame:CGRectZero];
        
    }
    return _webSiteimg;
}
//线索背景
- (BaseButton *)clueTitle
{
    if (!_clueTitle) {
        _clueTitle = [[BaseButton alloc]initWithFrame:CGRectMake(10, 10, APPWIDTH - 20, 114) setTitle:@"" titleSize:30*SpacedFonts titleColor:WhiteColor textAlignment:NSTextAlignmentCenter backgroundColor:WhiteColor inView:nil];
    }
    __weak typeof(self) weakSelf = self;
    [_clueTitle setTitleColor:WhiteColor forState:UIControlStateNormal];
    _clueTitle.backgroundColor = [UIColor colorWithRed:0.5843 green:0.7686 blue:1.0 alpha:1.0];
    _clueTitle.titleLabel.textAlignment = NSTextAlignmentCenter;
    _clueTitle.shouldAnmial = NO;
    _clueTitle.didClickBtnBlock = ^
    {
        if ([weakSelf.delegate respondsToSelector:@selector(tableViewCell:didClickedLikeButtonWithClueID: atIndexPath:)] &&[weakSelf.delegate conformsToProtocol:@protocol(TableViewCellDelegate)]) {
            [weakSelf.delegate tableViewCell:weakSelf didClickedLikeButtonWithClueID:weakSelf.cellLayout.statusModel.typeinfo.ID atIndexPath:weakSelf.indexPath];
        }
    };
    [_clueTitle addSubview:self.clueCount];
    UIImage *image = [UIImage imageNamed:@"icon_dongtai_biaoqian"];
    UIButton *clue = [[UIButton alloc]initWithFrame:CGRectMake(-3, 10, image.size.width, image.size.height)];
    [clue setBackgroundImage:image forState:UIControlStateNormal];
    [clue setTitleColor:WhiteColor forState:UIControlStateNormal];
    [clue setTitle:@"线索" forState:UIControlStateNormal];
    clue.titleLabel.font = Size(22);
    clue.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_clueTitle addSubview:clue];
    return _clueTitle;
}
- (UILabel *)clueCount
{
    if (!_clueCount) {
        _clueCount = [UILabel createLabelWithFrame:CGRectZero text:@"" fontSize:24*SpacedFonts textColor:WhiteColor textAlignment:NSTextAlignmentRight inView:nil];
    }
    return _clueCount;
}

//线索背景
- (BaseButton *)cooperation_benefit
{
    if (!_cooperation_benefit) {
        _cooperation_benefit = [[BaseButton alloc]initWithFrame:CGRectZero setTitle:@"合作利益" titleSize:24*SpacedFonts titleColor:WhiteColor textAlignment:NSTextAlignmentCenter backgroundColor:WhiteColor inView:nil];
    }
    [_cooperation_benefit setTitleColor:AppMainColor forState:UIControlStateNormal];
    [_cooperation_benefit setRadius:2.0];
    [_cooperation_benefit setBorder:LineBg width:0.5];
    _cooperation_benefit.titleLabel.textAlignment = NSTextAlignmentCenter;
    _cooperation_benefit.shouldAnmial = NO;
    
    return _cooperation_benefit;
}

@end
