




/********************* 有任何问题欢迎反馈给我 liuweiself@126.com ****************************************/
/***************  https://github.com/waynezxcv/Gallop 持续更新 ***************************/
/******************** 正在不断完善中，谢谢~  Enjoy ******************************************************/






#import <UIKit/UIKit.h>
#import "CellLayout.h"
#import "Gallop.h"


@class TableViewCell;

@protocol TableViewCellDelegate <NSObject>
@optional
//点击图片
- (void)tableViewCell:(TableViewCell *)cell didClickedImageWithCellLayout:(CellLayout *)layout
              atIndex:(NSInteger)index;

//点击文本链接
- (void)tableViewCell:(TableViewCell *)cell  cellLayout:(CellLayout *)layout  atIndexPath:(NSIndexPath *)indexPath didClickedLinkWithData:(id)data;

//评论
- (void)tableViewCell:(TableViewCell *)cell didClickedCommentWithCellLayout:(CellLayout *)layout
              atIndexPath:(NSIndexPath *)indexPath;

//点赞
- (void)tableViewCell:(TableViewCell *)cell didClickedLikeWithCellLayout:(CellLayout *)layout atIndexPath:(NSIndexPath *)indexPath;


//点击点赞头像查看详情
- (void)tableViewCell:(TableViewCell *)cell didClickedLikeButtonWithJJRId:(NSString *)JJRId;

//点击进入动态详情
- (void)tableViewCell:(TableViewCell *)cell didClickedLikeButtonWithDTID:(NSString *)DTID atIndexPath:(NSIndexPath *)indexPath;


//更多按钮事件
- (void)tableViewCell:(TableViewCell *)cell didClickedLikeButtonWithIsSelf:(BOOL)isSelf andDynamicID:(NSString *)andDynamicID atIndexPath:(NSIndexPath *)indexPath andIndex:(NSInteger)index;

//点击进入文章详情
- (void)tableViewCell:(TableViewCell *)cell didClickedLikeButtonWithArticleID:(NSString *)articleID atIndexPath:(NSIndexPath *)indexPath;

//点击进入文章详情
- (void)tableViewCell:(TableViewCell *)cell didClickedLikeButtonWithClueID:(NSString *)clueID atIndexPath:(NSIndexPath *)indexPath;
@end

@interface TableViewCell : UITableViewCell

@property (nonatomic,weak) id <TableViewCellDelegate> delegate;
@property(nonatomic,strong)  UIImageView* webSiteimg;//文章分享的
@property (nonatomic,strong) CellLayout* cellLayout;
@property (nonatomic,strong) NSIndexPath* indexPath;

@end


