//
//  UIImage+Extend.m
//  CDHN
//
//  Created by muxi on 14-10-14.
//  Copyright (c) 2014年 muxi. All rights reserved.
//

#import "UIImage+Extend.h"
#import "CoreConst.h"
#import <objc/runtime.h>

static const void *CompleteBlockKey = &CompleteBlockKey;
static const void *FailBlockKey = &FailBlockKey;

@interface UIImage ()

@property (nonatomic,copy)  void(^CompleteBlock)();

@property (nonatomic,copy)  void(^FailBlock)();

@end


@implementation UIImage (Extend)


/**
 *  获取启动图片
 */
+(UIImage *)launchImage{
    
    NSString *imageName=@"LaunchImage-700";
    
    if(iphone5x_4_0) imageName=@"LaunchImage-700-568h";
    
    return [UIImage imageNamed:imageName];
}


/**
 *  根据不同的iphone屏幕大小自动加载对应的图片名
 *  加载规则：
 *  iPhone4:             默认图片名，无后缀
 *  iPhone5系列:          _ip5
 *  iPhone6:             _ip6
 *  iPhone6 Plus:     _ip6p,注意屏幕旋转显示不同的图片不是这个方法能决定的，需要使用UIImage的sizeClass特性决定
 */
+(UIImage *)deviceImageNamed:(NSString *)name{

    NSString *imageName=[name copy];

    //iphone5
    if(iphone5x_4_0) imageName=[NSString stringWithFormat:@"%@%@",imageName,@"_ip5"];
    
    //iphone6
    if(iphone6_4_7) imageName=[NSString stringWithFormat:@"%@%@",imageName,@"_ip6"];
    
    //iphone6 Plus
    if(iphone6Plus_5_5) imageName=[NSString stringWithFormat:@"%@%@",imageName,@"_ip6p"];

    UIImage *originalImage=[UIImage imageNamed:name];
    
    UIImage *deviceImage=[UIImage imageNamed:imageName];
    
    if(deviceImage==nil) deviceImage=originalImage;

    return deviceImage;
}


/**
 *  网络请求
 */
+ (UIImage *)imageWithUrl:(NSString *)urlstr
{
    
    
    NSURL *url = [NSURL URLWithString:urlstr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSError *error;
    NSData *data  = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error ==nil) {
        
        return [UIImage imageWithData:data];
    }
    else
    {
        return nil;
    }
}

/**
 *  拉伸图片
 */
#pragma mark  拉伸图片:自定义比例
+(UIImage *)resizeWithImageName:(NSString *)name leftCap:(CGFloat)leftCap topCap:(CGFloat)topCap{
    UIImage *image = [self imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * leftCap topCapHeight:image.size.height * topCap];
}




#pragma mark  拉伸图片
+(UIImage *)resizeWithImageName:(NSString *)name{
    
    return [self resizeWithImageName:name leftCap:.5f topCap:.5f];

}

+ (UIImage *)resizeImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    CGFloat imageW = image.size.width * 0.5;
    CGFloat imageH = image.size.height * 0.5;
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(imageH, imageW, imageH, imageW) resizingMode:UIImageResizingModeTile];
}




/**
 *  保存相册
 *
 *  @param completeBlock 成功回调
 *  @param completeBlock 出错回调
 */
-(void)savedPhotosAlbum:(void(^)())completeBlock failBlock:(void(^)())failBlock{
    
    UIImageWriteToSavedPhotosAlbum(self, self, @selector(image:didFinishSavingWithError:contextInfo:),NULL);
    
    self.CompleteBlock = completeBlock;
    self.FailBlock = failBlock;
}




- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if(error == nil){
        if(self.CompleteBlock != nil) self.CompleteBlock();
    }else{
        if(self.FailBlock !=nil) self.FailBlock();
    }

}

//图片压缩到指定大小
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    if ([[UIScreen mainScreen] scale] ==2) {
        
        UIGraphicsBeginImageContextWithOptions(targetSize, NO, 2.0);
    }
    else if ([[UIScreen mainScreen] scale] ==3)
    {
         UIGraphicsBeginImageContextWithOptions(targetSize, NO, 3.0);
    }
    else
    {
        UIGraphicsBeginImageContext(targetSize);
    }
    [self drawInRect:frame(0, 0, targetSize.width, targetSize.height)];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}

/*
 *  模拟成员变量
 */
-(void (^)())FailBlock{
    return objc_getAssociatedObject(self, FailBlockKey);
}
-(void)setFailBlock:(void (^)())FailBlock{
    objc_setAssociatedObject(self, FailBlockKey, FailBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(void (^)())CompleteBlock{
    return objc_getAssociatedObject(self, CompleteBlockKey);
}

-(void)setCompleteBlock:(void (^)())CompleteBlock{
    objc_setAssociatedObject(self, CompleteBlockKey, CompleteBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
