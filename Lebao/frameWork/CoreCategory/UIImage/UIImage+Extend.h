//
//  UIImage+Extend.h
//  CDHN
//
//  Created by muxi on 14-10-14.
//  Copyright (c) 2014年 muxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extend)




/**
 *  网络请求
 */
+ (UIImage *)imageWithUrl:(NSString *)urlstr;

/**
 *  拉伸图片:自定义比例
 */
+(UIImage *)resizeWithImageName:(NSString *)name leftCap:(CGFloat)leftCap topCap:(CGFloat)topCap;



//图片压缩到指定大小
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

/**
 *  拉伸图片
 */
+(UIImage *)resizeWithImageName:(NSString *)name;
+ (UIImage *)resizeImage:(NSString *)imageName;


/**
 *  获取启动图片
 */
+(UIImage *)launchImage;




/**
 *  保存相册
 *
 *  @param completeBlock 成功回调
 *  @param completeBlock 出错回调
 */
-(void)savedPhotosAlbum:(void(^)())completeBlock failBlock:(void(^)())failBlock;



@end
