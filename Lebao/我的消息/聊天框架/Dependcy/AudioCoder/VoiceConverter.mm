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
#import <AVFoundation/AVFoundation.h>
#import "lame.h"
@implementation VoiceConverter

+ (int)amrToWav:(NSString*)_amrPath wavSavePath:(NSString*)_savePath{
    
    if (! DecodeAMRFileToWAVEFile([_amrPath cStringUsingEncoding:NSUTF8StringEncoding], [_savePath cStringUsingEncoding:NSUTF8StringEncoding]))
        return 0;
    
    return 1;
}

+ (int)wavToAmr:(NSString*)_wavPath amrSavePath:(NSString*)_savePath{
    
    if (EncodeWAVEFileToAMRFile([_wavPath cStringUsingEncoding:NSUTF8StringEncoding], [_savePath cStringUsingEncoding:NSUTF8StringEncoding], 1, 16))
        return 1;
    
    return 0;
}

+ (int)mp3ToWav:(NSString*)_mp3Path wavSavePath:(NSString*)_savePath
{
   NSData *mp3 = [NSData dataWithContentsOfFile:_mp3Path];
   return  [mp3 writeToFile:_savePath atomically:YES];
    return 0;
}

+ (int)wavToMp3:(NSString*)_wavPath mp3SavePath:(NSString*)_savePath
{
    @try {
        int read, write;
        
        FILE *pcm = fopen([_wavPath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([_savePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 8000);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        
        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
       
         return 0;
    }
    @finally {
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
    }
    
    
    return 1;

}
+ (int) changeStu
{
   return changeState();
}

    
@end
