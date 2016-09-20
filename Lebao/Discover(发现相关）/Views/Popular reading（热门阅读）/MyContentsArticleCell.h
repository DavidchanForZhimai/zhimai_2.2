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
@interface MyContentsArticleCell : UITableViewCell
@property(nonatomic,strong) UIImageView *icon;
@property(nonatomic,strong) BaseButton *shareBtn;
 - (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth;

- (void)dataModal:(MyContentDataModal *)modal deleBlock:(void(^)(MyContentDataModal *modal))deleBlock pathBlock:(void(^)(MyContentDataModal *modal))pathBlock myfluence:(void(^)(MyContentDataModal *modal))myfluence;
@end


@interface MyContentsCollectionCell : UITableViewCell
@property(nonatomic,strong) UIImageView *icon;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth;
- (void)dataModal:(myCollectionDataModal *)modal;
@end