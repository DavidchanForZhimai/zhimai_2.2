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
    UIImage *newImage = [image imageByScalingAndCroppingForSize:CGSizeMake(image.size.width, image.size.height)];
    NSData *imageData = UIImageJPEGRepresentation(newImage,0.00001);
    fileConfig.fileData = imageData;
    fileConfig.name = @"imageFile";
    fileConfig.fileName =@"test.jpg";
    fileConfig.mimeType =@"image/jpg";
    NSMutableDictionary *parameter = [Parameter parameterWithSessicon];
    [parameter setObject:type forKey:Type];
    [parameter setObject:@"imageFile" forKey:@"name"];
    
    [XLNetworkRequest updateRequest:UploadImagesURL params:parameter fileConfig:fileConfig success:^(id responseObj) {
//        NSLog(@"responseObj =%@ parameter= %@",responseObj,parameter);
        if (responseObj) {
            UpLoadImageModal *upLoadImageModal = [UpLoadImageModal mj_objectWithKeyValues:responseObj];
            if (upLoadImageModal.rtcode ==1) {
                
                
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
@end

@implementation UpLoadImageModal


@end