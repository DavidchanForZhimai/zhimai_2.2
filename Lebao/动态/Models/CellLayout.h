




/********************* 有任何问题欢迎反馈给我 liuweiself@126.com ****************************************/
/***************  https://github.com/waynezxcv/Gallop 持续更新 ***************************/
/******************** 正在不断完善中，谢谢~  Enjoy ******************************************************/








#import "LWLayout.h"
#import "StatusModel.h"

/**
 *  要添加一些其他属性，可以继承自LWLayout
 */

@interface CellLayout : LWLayout
@property (nonatomic,copy) NSArray* imageStorageArray;
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,assign) CGRect lineRect;
@property (nonatomic,assign) CGRect cellMarginsRect;
@property (nonatomic,assign) CGRect commentBgPosition;
@property (nonatomic,assign) CGRect commentPosition;
@property (nonatomic,assign) CGRect prisePosition;
@property (nonatomic,copy) NSArray* imagePostionArray;
@property (nonatomic,copy) NSArray* prisePostionArray;
@property (nonatomic,assign) CGRect avatarPosition;
@property (nonatomic,strong) StatusDatas* statusModel;
@property (nonatomic,assign) BOOL isShowMore;
@property (nonatomic,assign) CGRect websiteRect;

//文字过长时，折叠状态的布局模型
- (id)initWithStatusModel:(StatusDatas *)statusModel
                    index:(NSInteger)index isDetail:(BOOL)isDetail;


//文字过长时，打开状态的布局模型
- (id)initContentOpendLayoutWithStatusModel:(StatusDatas *)statusModel
                                      index:(NSInteger)index isDetail:(BOOL)isDetail;

@end
