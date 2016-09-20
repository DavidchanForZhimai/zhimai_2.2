//
//  UpLoadImageManager.h
//  Lebao
//
//  Created by David on 16/3/3.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>

//上传图片的接口
#define UploadImagesURL [NSString stringWithFormat:@"%@upload/index",HttpURL]
//文章图片 release
#define UploadImagesTypeRelease  @"release"
//背景图片 background
#define UploadImagesTypeBackground  @"background"
//头像图片 head
#define UploadImagesTypeHead  @"head"
//房产图片 property
#define UploadImagesTypeProperty  @"property"
//封面图片 cover
#define UploadImagesTypeCover  @"cover"
//车行
#define UploadImagesTypeCar  @"car"

@interface UpLoadImageModal : NSObject
@property(nonatomic,strong)NSString *abbr_imgurl;
@property(nonatomic,strong)NSString *imgurl;
@property(nonatomic,assign)int rtcode;
@property(nonatomic,strong)NSString *rtmsg;
@end

typedef void (^ImageBlock)(UpLoadImageModal * upLoadImageModal);

@interface UpLoadImageManager : NSObject
//单例
+ (instancetype)shareInstance;

//上传图片
- (void)upLoadImageType:(NSString *)type image:(UIImage *)image imageBlock:(ImageBlock)imageBlock;
@end



