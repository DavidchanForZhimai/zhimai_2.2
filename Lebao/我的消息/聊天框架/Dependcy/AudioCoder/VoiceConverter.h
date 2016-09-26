//
//  VoiceConverter.h
//  Jeans
//
//  Created by Jeans Huang on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceConverter : NSObject

+ (int)amrToWav:(NSString*)_amrPath wavSavePath:(NSString*)_savePath;

+ (int)wavToAmr:(NSString*)_wavPath amrSavePath:(NSString*)_savePath;

+ (int)mp3ToWav:(NSString*)_mp3Path wavSavePath:(NSString*)_savePath;

+ (int)wavToMp3:(NSString*)_wavPath mp3SavePath:(NSString*)_savePath;

+ (int) changeStu;
@end
