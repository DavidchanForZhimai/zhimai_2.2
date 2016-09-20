//
//  DiscoverModel.h
//  Lebao
//
//  Created by David on 16/1/6.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModal.h"

@interface DiscoverModel : BaseModal
@property(nonatomic,strong) NSMutableArray *upimg;
@end


@interface DiscoverDataModel : NSObject

@property(nonatomic, strong)NSString *forwardcount;
@property(nonatomic, strong)NSString *createtime;
@property(nonatomic, strong)NSString *readcount;
@property(nonatomic, strong)NSString *ID;
@property(nonatomic, strong)NSString *imgurl;
@property(nonatomic, strong)NSString *title;
@end

@interface DiscoverImageDataModel : NSObject
@property(nonatomic, strong)NSString *ID;
@property(nonatomic, strong)NSString *imgurl;
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *upimgurl;
@end