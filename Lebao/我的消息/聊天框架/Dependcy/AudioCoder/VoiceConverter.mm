//
//  VoiceConverter.m
//  Jeans
//
//  Created by Jeans Huang on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VoiceConverter.h"
#import "wav.h"
#import "interf_dec.h"
#import "dec_if.h"
#import "interf_enc.h"
#import "amrFileCodec.h"
#import "ExtAudioConverter.h"
@implementation VoiceConverter

+ (int)otherFormatToWav:(NSString*)path wavSavePath:(NSString*)_savePath
{

    NSData *data = [NSData dataWithContentsOfFile:path];
    return [data writeToFile:_savePath atomically:YES];
    
}

+ (int)wavToOtherFormat:(NSString*)path otherFormatSavePath:(NSString*)_savePath
{
    ExtAudioConverter* converter = [[ExtAudioConverter alloc] init];
    converter.inputFile =  path;
    converter.outputFile = _savePath;
    converter.outputFormatID = kAudioFormatMPEGLayer3;
    converter.outputFileType = kAudioFileMP3Type;
    if ([converter convert]) {
        return 1;
    }
    
     return 0;
}
+ (int) changeStu
{
   return changeState();
}

    
@end
