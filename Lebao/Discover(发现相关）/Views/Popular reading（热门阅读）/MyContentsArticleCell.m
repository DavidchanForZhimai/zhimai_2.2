//
//  MyContentsCell.m
//  Lebao
//
//  Created by David on 15/12/16.
//  Copyright © 2015年 David. All rights reserved.
//

#import "MyContentsArticleCell.h"
#import "XLDataService.h"
#import "ToolManager.h"
#import "UILabel+Extend.h"
#import "NSString+Extend.h"
@interface MyContentsArticleCell()
@end
@implementation MyContentsArticleCell
{
 
    DWLable *_descrip;
    UILabel *_time;
    UILabel      *_clueNum;
    UILabel      *_readsNum;
    
    
    UIButton   *_shareImage;
    BaseButton *_pathBtn;
    BaseButton *_deleteBtn;
    BaseButton *_shareBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth
{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor =[UIColor clearColor];
        
        UIView *cell = allocAndInitWithFrame(UIView, frame(0, 0, cellWidth, cellHeight));
        cell.backgroundColor = WhiteColor;
        [self addSubview:cell];
        
        _icon = allocAndInitWithFrame(UIImageView, frame(10, (78 - 60)/2.0, 65, 60));
        _icon.contentMode =ViewContentMode;
        [_icon setRadius:5.0];
        [cell addSubview:_icon];
        
        
        _descrip = [DWLable createLabelWithFrame:frame(CGRectGetMaxX(_icon.frame) + 6, frameY(_icon), cellWidth - (CGRectGetMaxX(_icon.frame) + 18), 48.0*SpacedFonts+5) text:@"" fontSize:24.0*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
        _descrip.numberOfLines = 0;
        _descrip.verticalAlignment = VerticalAlignmentTop;
        
        
        _time = [UILabel createLabelWithFrame:frame(frameX(_descrip), cellHeight -66, 150*SpacedFonts, 20*SpacedFonts) text:@"2015- 11- 19" fontSize:20*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
        CGSize sizeTime = [_time sizeWithContent:_time.text font:[UIFont systemFontOfSize:20*SpacedFonts]];
        _time.frame = frame(frameX(_time), frameY(_time), sizeTime.width, frameHeight(_time));
        
        UIImage *readImage =[UIImage imageNamed:@"icon_exhibition_mycontent_read"];
        
        _readsNum =[UILabel createLabelWithFrame:CGRectZero text:@"158人" fontSize:18.0*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:self];
        CGSize size2 = [_readsNum sizeWithContent:_readsNum.text font:[UIFont systemFontOfSize:18.0*SpacedFonts]];
        _readsNum.frame =frame(cellWidth -size2.width - 10, frameY(_time), size2.width, 20.0*SpacedFonts);
        
        UIImageView *readImageView = allocAndInitWithFrame(UIImageView, frame(frameX(_readsNum) - 5 - 16, frameY(_readsNum) - (16 - frameHeight(_readsNum))/2.0, 16, 16));
        readImageView.image = readImage;
        [cell addSubview:readImageView];

        
        //line
        [UILabel CreateLineFrame:frame(0,78, cellWidth, 0) inView:cell];
        
        UIImage *_path = [UIImage imageNamed:@"icon_exhibition_mycontent_path_normal"];
        UIImage *_pathPress = [UIImage imageNamed:@"icon_exhibition_mycontent_path_press"];
        UIImage *_share = [UIImage imageNamed:@"discover_clue_normal"];
        UIImage *_sharePress = [UIImage imageNamed:@"discover_clue_selected"];
        UIImage *_delete = [UIImage imageNamed:@"icon_exhibition_mycontent_delete_nomal"];
        UIImage *_deletePress = [UIImage imageNamed:@"icon_exhibition_mycontent_delete_press"];

        //路径
        
        _pathBtn = [[BaseButton alloc]initWithFrame:frame(0, 78, cellWidth/3.0, cellHeight - 78)backgroundImage:nil iconImage:_path highlightImage:_pathPress inView:self];
        _pathBtn.exclusiveTouch = YES;
        
        UILabel *line1 =allocAndInitWithFrame(UILabel, frame(CGRectGetMaxX(_pathBtn.frame), frameY(_pathBtn) + 7, 0.5,frameHeight(_pathBtn) -14 ));
        line1.backgroundColor = LineBg;
        [cell addSubview:line1];
        
        //影响
        
        _shareBtn = [[BaseButton alloc]initWithFrame:frame(CGRectGetMaxX(_pathBtn.frame), frameY(_pathBtn), frameWidth(_pathBtn), frameHeight(_pathBtn))backgroundImage:nil iconImage:_share highlightImage:_sharePress inView:self];
        _shareBtn.exclusiveTouch = YES;
        
        UILabel *line2 =allocAndInitWithFrame(UILabel, frame(CGRectGetMaxX(_shareBtn.frame), frameY(_shareBtn) + 7, 0.5,frameHeight(_shareBtn) -14 ));
        line2.backgroundColor = LineBg;
        [cell addSubview:line2];
       
        //删除

       _deleteBtn = [[BaseButton alloc]initWithFrame:frame(CGRectGetMaxX(_shareBtn.frame), frameY(_pathBtn),frameWidth(_pathBtn), frameHeight(_pathBtn)) backgroundImage:nil iconImage:_delete highlightImage:_deletePress inView:self];
        _deleteBtn.exclusiveTouch = YES;
       
        
    }
    
    return self;
}

- (void)dataModal:(MyContentDataModal *)modal deleBlock:(void(^)(MyContentDataModal *modal))deleBlock pathBlock:(void(^)(MyContentDataModal *modal))pathBlock myfluence:(void(^)(MyContentDataModal *modal))myfluence;
{
   
    [[ToolManager shareInstance] imageView:_icon setImageWithURL:modal.imgurl placeholderType:PlaceholderTypeOther];
    _descrip.text = modal.title;
    _time.text = [modal.createdate timeformatString:@"yyyy-MM-dd"];
    _readsNum.text = modal.readcount;
    _clueNum.text = modal.readcover;
    _deleteBtn.didClickBtnBlock = ^
    {
        
        deleBlock(modal);
    };
    _pathBtn.didClickBtnBlock = ^
    {
        pathBlock(modal);
    };
//    __weak MyContentsArticleCell *weakSelf =self;
    _shareBtn.didClickBtnBlock = ^{
      
//        [[WetChatShareManager shareInstance] shareToWeixinApp:modal.title desc:@"" image:weakSelf.icon.image  shareID:modal.ID isWxShareSucceedShouldNotice:NO isAuthen:modal.isgetclue];
        myfluence(modal);
    };

    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@implementation  MyContentsCollectionCell
{
   
    DWLable *_descrip;
    UILabel *_time;
    UILabel *_source;
    UILabel *_share;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth
{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        
        _icon = allocAndInitWithFrame(UIImageView, frame(10, (cellHeight - 60)/2.0, 65, 60));
        _icon.contentMode =ViewContentMode;
        [self addSubview:_icon];
    
        _descrip = [DWLable createLabelWithFrame:frame(CGRectGetMaxX(_icon.frame) + 6, frameY(_icon), cellWidth - (CGRectGetMaxX(_icon.frame) + 18), 48.0*SpacedFonts+5) text:@"" fontSize:24.0*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:self];
        _descrip.numberOfLines = 0;
        _descrip.verticalAlignment = VerticalAlignmentTop;
        
        _time = [UILabel createLabelWithFrame:frame(frameX(_descrip), cellHeight -20, 150*SpacedFonts, 20*SpacedFonts) text:@"2010- 10- 12" fontSize:20*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:self];
        CGSize sizeTime = [_time sizeWithContent:_time.text font:[UIFont systemFontOfSize:20*SpacedFonts]];
        _time.frame = frame(frameX(_time), frameY(_time), sizeTime.width, frameHeight(_time));
        
       _source = [UILabel createLabelWithFrame:frame(CGRectGetMaxX(_time.frame) + 8, frameY(_time), 150*SpacedFonts, 20*SpacedFonts) text:@"来源：iPhone客户端" fontSize:20*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:self];
        CGSize sizeSource = [_time sizeWithContent:_source.text font:[UIFont systemFontOfSize:20*SpacedFonts]];
        _source.frame = frame(frameX(_source), frameY(_source), sizeSource.width, frameHeight(_time));
        
        _share= [UILabel createLabelWithFrame:frame(CGRectGetMaxX(_source.frame) + 8, frameY(_time), cellWidth - (CGRectGetMaxX(_source.frame) + 18), 20*SpacedFonts) text:@"" fontSize:20*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentRight inView:self];

        
        //line
         [UILabel CreateLineFrame:frame(0,cellHeight - 0.5, cellWidth, 0) inView:self];
    
        
    }
    
    return self;
}
- (void)dataModal:(myCollectionDataModal *)modal
{

      [[ToolManager shareInstance] imageView:_icon setImageWithURL:modal.imgurl placeholderType:PlaceholderTypeOther];
    _descrip.text = modal.title;
    _time.text = [modal.createtime timeformatString:@"yyyy-MM-dd"];
    if (modal.isshare) {
        _share.text = @"已分享";
    }
    else
    {
        _share.text = @"未分享";  
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
