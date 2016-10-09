//
//  MyContentsCell.h
//  Lebao
//
//  Created by David on 15/12/16.
//  Copyright © 2015年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myCollectionModal.h"
#import "MyContentModal.h"
#import "BaseButton.h"

typedef NS_ENUM(NSUInteger,EditType) {
    EditDeleType =0,
    EditShareType
};
typedef void (^EditBlock)(MyContentDataModal *modal,EditType type);
@interface MyContentsArticleCell : UITableViewCell
@property(nonatomic,strong) UIImageView *icon;
@property(nonatomic,strong) BaseButton *shareBtn;
@property(nonatomic,copy) EditBlock editBlock;
@property(nonatomic,strong) MyContentDataModal *model;

 - (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth;

- (void)dataModal:(MyContentDataModal *)modal editBlock:(EditBlock)block pathBlock:(void(^)(MyContentDataModal *modal))pathBlock myfluence:(void(^)(MyContentDataModal *modal))myfluence;
@end


@interface MyContentsCollectionCell : UITableViewCell
@property(nonatomic,strong) UIImageView *icon;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth;
- (void)dataModal:(myCollectionDataModal *)modal;
@end