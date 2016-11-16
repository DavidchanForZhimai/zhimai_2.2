//
//  XLNetworkRequest.m
//  XLNetwork
//
//  Created by Shelin on 15/11/10.
//  Copyright © 2015年 GreatGate. All rights reserved.
//

#import "XLNetworkRequest.h"
#import <AFNetworking.h>
#import "ToolManager.h"
@implementation XLNetworkRequest

+ (void)getRequest:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler {
    
    //网络不可用
    if (![self checkNetworkStatus]) {
        successHandler(nil);
        failureHandler(nil);
        [[ToolManager shareInstance] showErrorWithStatus];
        return;
    }

     AFHTTPSessionManager *manager = [self getRequstManager];
    [manager GET:url parameters:params progress:^(NSProgress *downloadProgress)
     {
         
         
     }success:^(NSURLSessionDataTask *task, id _Nullable responseObject) {
        
        successHandler(responseObject);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        XLLog(@"------请求失败-------%@",error);
        failureHandler(error);
    }];
}


+ (void)postRequest:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler {
    
    //网络不可用
    [self checkNetworkStatus];
    if (![self checkNetworkStatus]) {
        successHandler(nil);
        failureHandler(nil);
        [[ToolManager shareInstance] showErrorWithStatus];
        return;
    }

    AFHTTPSessionManager *manager = [self getRequstManager];
    [manager POST:url parameters:params progress:^(NSProgress *downloadProgress)
     {
         
         
     }success:^(NSURLSessionDataTask *task, id _Nullable responseObject) {
         
         successHandler(responseObject);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
         XLLog(@"------请求失败-------%@",error);
         failureHandler(error);
     }];
}

+ (void)putRequest:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler {
    
    if (![self checkNetworkStatus]) {
        successHandler(nil);
        failureHandler(nil);
         [[ToolManager shareInstance] showErrorWithStatus];
        return;
    }
    
    AFHTTPSessionManager *manager = [self getRequstManager];
    [manager PUT:url parameters:params success:^(NSURLSessionDataTask *task, id _Nullable responseObject) {
         
         successHandler(responseObject);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
         XLLog(@"------请求失败-------%@",error);
         failureHandler(error);
     }];
}

+ (void)deleteRequest:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler {
    
    if (![self checkNetworkStatus]) {
        successHandler(nil);
        failureHandler(nil);
         [[ToolManager shareInstance] showErrorWithStatus];
        return;
    }

    AFHTTPSessionManager *manager = [self getRequstManager];

    [manager DELETE:url parameters:params success:^(NSURLSessionDataTask *task, id _Nullable responseObject) {
        
        successHandler(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        XLLog(@"------请求失败-------%@",error);
        failureHandler(error);
    }];
}

/**
 下载文件，监听下载进度
 */
+ (void)downloadRequest:(NSString *)url  successAndProgress:(progressBlock)progressHandler complete:(responseBlock)completionHandler {
    
    if (![self checkNetworkStatus]) {
        progressHandler(0, 0, 0);
        completionHandler(nil, nil);
         [[ToolManager shareInstance] showErrorWithStatus];
        return;
    }
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
        
        NSLog(@"progress is %@", downloadProgress);
    
    }   destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSURL *documentUrl = [[NSFileManager defaultManager] URLForDirectory :NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
      
//        NSLog(@"[documentUrl URLByAppendingPathComponent:[response suggestedFilename]] =%@",[documentUrl URLByAppendingPathComponent:[response suggestedFilename]]);
        
        return [documentUrl URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error){
        if (error) {
            XLLog(@"------下载失败-------%@",error);
        }
        completionHandler(response, error);
    }];
    
   
    
    [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        
        progressHandler(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
        
    }];
    [downloadTask resume];
}



/**
 *  发送一个POST请求
 *  @param fileConfig 文件相关参数模型
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 *  无上传进度监听
 */
+ (void)updateRequest:(NSString *)url params:(NSDictionary *)params fileConfig:(XLFileConfig *)fileConfig success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler {
    
    if (![self checkNetworkStatus]) {
        successHandler(nil);
        failureHandler(nil);
         [[ToolManager shareInstance] showErrorWithStatus];
        return;
    }
    //增加这几行代码；
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
//
    AFHTTPSessionManager *manager = [self getRequstManager];
  
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:fileConfig.fileData name:fileConfig.name fileName:fileConfig.fileName mimeType:fileConfig.mimeType];
        
    }
     progress:^(NSProgress *downloadProgress)
     {
         
         
     }success:^(NSURLSessionDataTask *task, id _Nullable responseObject) {
         
         successHandler(responseObject);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
         XLLog(@"------请求失败-------%@",error);
         failureHandler(error);
     }];}


///**
// 上传文件，监听上传进度
// */
//+ (void)updateRequest:(NSString *)url params:(NSDictionary *)params fileConfig:(XLFileConfig *)fileConfig successAndProgress:(progressBlock)progressHandler complete:(responseBlock)completionHandler {
//
//    if (![self checkNetworkStatus]) {
//        progressHandler(0, 0, 0);
//        completionHandler(nil, nil);
//         [[ToolManager shareInstance] showErrorWithStatus];
//        return;
//    }
//    
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        
//        [formData appendPartWithFileData:fileConfig.fileData name:fileConfig.name fileName:fileConfig.fileName mimeType:fileConfig.mimeType];
//        
//    } error:nil];
//    
//    //获取上传进度
//    AFHTTPSessionManager *manager = [self getRequstManager];
//    
//    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//         progressHandler(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//         completionHandler(responseObject, nil);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        completionHandler(nil, error);
//        if (error) {
//            XLLog(@"------上传失败-------%@",error);
//        }
//    }];
//   
//}

+ (AFHTTPSessionManager *)getRequstManager {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 请求超时设定
    manager.requestSerializer.timeoutInterval = 10;
    //manager.securityPolicy.allowInvalidCertificates = YES;//SSL certificates
    return manager;
}


/**
 监控网络状态
 */
+ (BOOL)checkNetworkStatus {
    
    __block BOOL isNetworkUse = YES;
    
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusUnknown) {
            isNetworkUse = YES;
           
        } else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            isNetworkUse = YES;
        } else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            isNetworkUse = YES;
        } else if (status == AFNetworkReachabilityStatusNotReachable){
            // 网络异常操作
//            NSLog(@"网络异常操作");
            isNetworkUse = NO;
            [[ToolManager shareInstance] showErrorWithStatus];
        }
    }];
    [reachabilityManager startMonitoring];
    return isNetworkUse;
}

@end





/**
 *  用来封装上传文件数据的模型类
 */
@implementation XLFileConfig

+ (instancetype)fileConfigWithfileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType {
    return [[self alloc] initWithfileData:fileData name:name fileName:fileName mimeType:mimeType];
}

- (instancetype)initWithfileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType {
    if (self = [super init]) {
    
        _fileData = fileData;
        _name = name;
        _fileName = fileName;
        _mimeType = mimeType;
    }
    return self;
}

@end

