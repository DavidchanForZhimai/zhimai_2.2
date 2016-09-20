//
//  TabbarItem.h
//  1233Shop
//
//  Created by 陈江彬 on 14/12/26.
//  Copyright (c) 2014年 CJB. All rights reserved.
//

typedef void (^ItemSelectBlock)(int index);
@interface TabbarDataType : NSObject

@property (nonatomic, strong) NSString *itemSelectImage;
@property (nonatomic, strong) NSString *itemImage;
@property (nonatomic, strong) NSString *itemTitle;
@property (nonatomic, assign) int       itemIndex;
@property (nonatomic, assign) BOOL      itemIsSelected;
@property (nonatomic, assign) int       baged;
@end


@interface TabbarItem : UIView

@property (nonatomic, copy) ItemSelectBlock itemSelectBlock;
- (id)initWithFrame:(CGRect)frame itemData:(TabbarDataType *)type;
@end