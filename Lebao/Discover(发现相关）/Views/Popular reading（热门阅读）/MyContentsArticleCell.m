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
@interface MyContentsArticleCell()<UIActionSheetDelegate>
@end
@implementation MyContentsArticleCell
{
 
    DWLable *_descrip;
    UILabel *_time;

    BaseButton *_browse;
    BaseButton *_pathBtn;
    BaseButton *_editBtn;
    BaseButton *_read;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth isRedAdd:(BOOL)isRedAdd
{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor =[UIColor clearColor];
        
        UIView *cell = allocAndInitWithFrame(UIView, frame(0, 0, cellWidth, cellHeight));
        cell.backgroundColor = WhiteColor;
        [self addSubview:cell];
        
        _icon = allocAndInitWithFrame(UIImageView, frame(10, 10, 76, 56));
        _icon.contentMode =ViewContentMode;
        [cell addSubview:_icon];
        
        
        _descrip = [DWLable createLabelWithFrame:frame(CGRectGetMaxX(_icon.frame) + 6, frameY(_icon), cellWidth - (CGRectGetMaxX(_icon.frame) + 18), 56.0*SpacedFonts+10) text:@"" fontSize:28.0*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
        _descrip.numberOfLines = 0;
        _descrip.verticalAlignment = VerticalAlignmentTop;
        
        
        _time = [UILabel createLabelWithFrame:frame(frameX(_descrip), CGRectGetMaxY(_icon.frame) - 20*SpacedFonts , 150*SpacedFonts, 22*SpacedFonts) text:@"2015- 11- 19" fontSize:22*SpacedFonts textColor:hexColor(c9c9c9) textAlignment:NSTextAlignmentLeft inView:cell];
        CGSize sizeTime = [_time sizeWithContent:_time.text font:[UIFont systemFontOfSize:22*SpacedFonts]];
        _time.frame = frame(frameX(_time), frameY(_time), sizeTime.width, frameHeight(_time));
        
        
        //line
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 74.5, cellWidth, 0.5)];
        line.backgroundColor = AppViewBGColor;
        [cell addSubview:line];
        
        if (!isRedAdd) {
            UIImage *_collectionImage =[UIImage imageNamed:@"exhibition_home_zhuanfa"];
            
            _browse = [[BaseButton alloc]initWithFrame:frame(_descrip.x, CGRectGetMaxY(_icon.frame) - _collectionImage.size.height, (cellWidth - CGRectGetMaxX(_icon.frame))/3.0, _collectionImage.size.height)  setTitle:@"22" titleSize:22*SpacedFonts titleColor:hexColor(c9c9c9) backgroundImage:nil iconImage:_collectionImage highlightImage:nil setTitleOrgin:CGPointMake(0,5) setImageOrgin:CGPointMake(0,0)  inView:self];
            _browse.shouldAnmial = NO;
            
        
            UIImage *_readIamge =[UIImage imageNamed:@"exhibition_home_yuedu"];
            
            _read = [[BaseButton alloc]initWithFrame:frame(CGRectGetMaxX(_browse.frame) , frameY(_browse), _browse.width, _collectionImage.size.height)  setTitle:@"22" titleSize:22*SpacedFonts titleColor:hexColor(c9c9c9) backgroundImage:nil iconImage:_readIamge highlightImage:nil setTitleOrgin:CGPointMake(0,5) setImageOrgin:CGPointMake(0,0)  inView:self];
            _read.shouldAnmial = NO;
            
             _time.frame = frame(cellWidth -sizeTime.width - 10 , frameY(_time), sizeTime.width, frameHeight(_time));
            _time.textAlignment = NSTextAlignmentRight;
        
            UIImage *_path = [UIImage imageNamed:@"icon_exhibition_mycontent_path_normal"];
            UIImage *_edit = [UIImage imageNamed:@"icon_exhibition_mycontent_shezhi"];
            
            //路径
            
            _pathBtn = [[BaseButton alloc]initWithFrame:frame(0, 75, cellWidth/2.0, cellHeight - 75) setTitle:@"路径分析" titleSize:14 titleColor:hexColor(838383) backgroundImage:nil iconImage:_path highlightImage:_path setTitleOrgin:CGPointMake(0,8) setImageOrgin:CGPointMake(0,0) inView:self];
            _pathBtn.exclusiveTouch = YES;
            
            UILabel *line1 =allocAndInitWithFrame(UILabel, frame(APPWIDTH/2.0, frameY(_pathBtn) + 3, 0.5,frameHeight(_pathBtn) -6 ));
            line1.backgroundColor = AppViewBGColor;
            [cell addSubview:line1];
            
            //编辑
            
            _editBtn = [[BaseButton alloc]initWithFrame:frame(APPWIDTH/2.0, frameY(_pathBtn),frameWidth(_pathBtn), frameHeight(_pathBtn)) setTitle:@"设置" titleSize:14 titleColor:hexColor(838383) backgroundImage:nil iconImage:_edit highlightImage:_edit setTitleOrgin:CGPointMake(0,8) setImageOrgin:CGPointMake(0,0) inView:self];
            _editBtn.exclusiveTouch = YES;
            [_pathBtn textAndImageCenter];
            [_editBtn textAndImageCenter];
        }
        
       
        
    }
    
    return self;
}

- (void)dataModal:(MyContentDataModal *)modal editBlock:(EditBlock)block  pathBlock:(void(^)(MyContentDataModal *modal))pathBlock myfluence:(void(^)(MyContentDataModal *modal))myfluence;
{
    _editBlock = block;
    _model = modal;
    
    [[ToolManager shareInstance] imageView:_icon setImageWithURL:modal.imgurl placeholderType:PlaceholderTypeOther];
    _descrip.text = modal.title;
    _time.text = [modal.createdate timeformatString:@"yyyy-MM-dd"];
    [_browse setTitle:[NSString stringWithFormat:@"%@人",modal.forwardcount] forState:UIControlStateNormal];
    [_read setTitle:[NSString stringWithFormat:@"%@人",modal.readcount] forState:UIControlStateNormal];
//    [_browse textAndImageCenter];
//    [_read textAndImageCenter];
    
    __weak typeof(self) weakSelf = self;
    _editBtn.didClickBtnBlock = ^
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选项" delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除",@"分享到我的动态", nil];
        [actionSheet showInView:weakSelf];
      
    };

    _pathBtn.didClickBtnBlock = ^
    {
        pathBlock(modal);
    };

   
    
}
#pragma mark
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex<2) {
        
        _editBlock(_model,(EditType)buttonIndex);
    }
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
