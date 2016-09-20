




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
@end

@implementation TableViewCell

#pragma mark - Init

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.asyncDisplayView];
        [self.contentView addSubview:self.avatarImage];
        [self.contentView addSubview:self.likeLb];
        [self.contentView addSubview:self.comentButton];
        [self.contentView addSubview:self.likeButton];
        
        [self.contentView addSubview:self.moreImage];
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.cellline];
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
        if (self.cellLayout.statusModel.isfollow) {
            sheet = [[UIActionSheet alloc]initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"取消关注",@"举报",@"分享", nil];
            sheet.tag =888;
            [sheet showInView:self];
        }
        else
        {
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"关注",@"举报",@"分享", nil];
            sheet.tag =8888;
            [sheet showInView:self];
        }
        
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
        if (buttonIndex<3) {
            
            if (buttonIndex==2)
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
            
            [self.delegate tableViewCell:self didClickedLikeButtonWithIsSelf:self.cellLayout.statusModel.me andDynamicID:[NSString stringWithFormat:@"%ld",self.cellLayout.statusModel.ID] atIndexPath:_indexPath andIndex:buttonIndex];
        }
        
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
    self.asyncDisplayView.frame = CGRectMake(0,0,SCREEN_WIDTH,self.cellLayout.cellHeight);
    self.likeButton.frame = self.cellLayout.prisePosition;
    self.comentButton.frame = self.cellLayout.commentPosition;
    self.line.frame = self.cellLayout.lineRect;
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
    self.cellline.frame = self.cellLayout.cellMarginsRect;
    self.moreImage.frame = frame(APPWIDTH -30, 10, 16, 16);
    self.moreImage.hidden = !_cellLayout.isShowMore;
    _avatarImage.frame = _cellLayout.avatarPosition;
    [_avatarImage setRound];
    [[ToolManager shareInstance] imageView:_avatarImage setImageWithURL:_cellLayout.statusModel.imgurl placeholderType:PlaceholderTypeUserHead];
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
@end
