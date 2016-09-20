//
//  DWOptionView.h
//  Lebao
//
//  Created by David on 16/2/18.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SureSeletedBlock) (BOOL isBoy);
typedef void (^SureSeletedItemBlock) (int item);
typedef void (^SureSeletedItemsBlock) (NSArray *items);
@interface DWOptionView : UIView
@property(nonatomic,strong)NSMutableArray *items;
//选择男女
- (id)initWithFrame:(CGRect)frame block:(SureSeletedBlock)sureBlock;

//选择行业

- (id)initWithFrame:(CGRect)frame options:(NSArray *)array block:(SureSeletedItemBlock)sureBlock;

//本地分享
- (id)initWithFrame:(CGRect)frame options:(NSArray *)array sureSeletedItemsBlock:(SureSeletedItemsBlock)sureBlock;
@end


