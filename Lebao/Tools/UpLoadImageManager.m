//
//  UpLoadImageManager.m
//  Lebao
//
//  Created by David on 16/3/3.
//  Copyright © 2016年 David. All rights reserved.
//

#import "UpLoadImageManager.h"
#import "XLNetworkRequest.h"
#import "MJExtension.h"
#import "ToolManager.h"
#import "UIImage+Extend.h"
static UpLoadImageManager *upLoadImageManager = nil;
static dispatch_once_t once;
@implementation UpLoadImageManager
+ (instancetype)shareInstance
{
    if (!upLoadImageManager) {
        dispatch_once(&once, ^{
            
            upLoadImageManager = allocAndInit(UpLoadImageManager);
           
        });
    }
    
    return upLoadImageManager;
    
}

- (void)upLoadImageType:(NSString *)type image:(UIImage *)image imageBlock:(ImageBlock)imageBlock
{
    
    XLFileConfig *fileConfig = allocAndInit(XLFileConfig);
    
    BOOL isWB = YES;
    float bili=1.0;
    if (image.size.width<image.size.height) {
        isWB = NO;
    }
    
    if ([type isEqualToString:@"head"]||[type isEqualToString:@"property"]) {
        
        if (isWB&&image.size.width>2000) {
            bili = 2000/image.size.width;
        }
        if (!isWB&&image.size.height>2000) {
            bili = 2000/image.size.height;
        }
    }
    else if ([type isEqualToString:@"authen"]) {
        
        if (isWB&&image.size.width>480) {
            bili = 480/image.size.width;
        }
        if (!isWB&&image.size.height>480) {
            bili = 480/image.size.height;
        }

    }
    else
    {
        if (isWB&&image.size.width>1000) {
            bili = 1000/image.size.width;
        }
        if (!isWB&&image.size.height>1000) {
            bili = 1000/image.size.height;
        }

    }
    

    UIImage *newImage = [image imageByScalingAndCroppingForSize:CGSizeMake(bili*image.size.width, bili*image.size.height)];
//    NSLog(@"image.size =%@",NSStringFromCGSize(newImage.size));
    NSData *imageData = UIImageJPEGRepresentation(newImage,0.3);
    if (imageData) {
        fileConfig.fileData = imageData;
        fileConfig.name = @"imageFile";
        fileConfig.fileName =@"test.jpg";
        fileConfig.mimeType =@"image/jpg";
        NSMutableDictionary *parameter = [Parameter parameterWithSessicon];
        [parameter setObject:type forKey:Type];
        [parameter setObject:@"imageFile" forKey:@"name"];
        [[ToolManager shareInstance] showWithStatus:@"上传中..."];
        [XLNetworkRequest updateRequest:UploadImagesURL params:parameter fileConfig:fileConfig success:^(id responseObj) {
            if (responseObj) {
                UpLoadImageModal *upLoadImageModal = [UpLoadImageModal mj_objectWithKeyValues:responseObj];
                if (upLoadImageModal.rtcode ==1) {
                    [[ToolManager shareInstance] showSuccessWithStatus:@"上传成功"];
                    imageBlock(upLoadImageModal);
                    
                }
                else
                {
                    [[ToolManager shareInstance] showInfoWithStatus:upLoadImageModal.rtmsg];
                }
                
            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus];
            }
            
            
        } failure:^(NSError *error) {
            
            [[ToolManager shareInstance] showInfoWithStatus];
        }];

    }
    else
    {
        [[ToolManager shareInstance] showAlertMessage:@"无效的图片，重试！"];
    }
    }
@end

@implementation UpLoadImageModal


@end
