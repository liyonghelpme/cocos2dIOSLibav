//
//  TestOpenAL.m
//  libav2
//
//  Created by  stc on 13-5-2.
//
//

#import "TestOpenAL.h"
#import "Util.h"
#import "CDOpenALSupport.h"

@implementation TestOpenAL
+(TestOpenAL *)testOpenAL {
    TestOpenAL *t = [[TestOpenAL alloc] init];
    return t;
}

-(void) dealloc{
    [bufferStorage release];
    [super dealloc];
}
/*

*/
-(void)initOpenAL {
    mDevice = alcOpenDevice(NULL);
    printf("mDevices %x\n", mDevice);
    if (mDevice) {
        mContext= alcCreateContext(mDevice, NULL);
        printf("mContext %x\n", mContext);
        
        alcMakeContextCurrent(mContext);
        
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"out" ofType:@"caf"];
        /*
        AudioFileID fileID = [self openAudioFile:fileName];
        UInt32 fileSize = [self audioFileSize:fileID];
        unsigned char *data = malloc(fileSize);
        checkStatus(AudioFileReadBytes(fileID, false, 0, &fileSize, data), @"Read Byte");
        AudioFileClose(fileID);
        */
        
        ALsizei size;
        ALenum format;
        ALsizei sample;
        void *data = CDloadCafAudioData((CFURLRef)[NSURL fileURLWithPath:fileName], &size, &format, &sample);
        
        
        
        NSLog(@"fileName %@", fileName);
        printf("read file %d\n", size);
        NSLog(@"format sample %d %d %d", format, AL_FORMAT_STEREO16, sample);
        
        NSUInteger buffer;
        alGenBuffers(1, &buffer);
        if(alGetError() != AL_NO_ERROR) {
            NSLog(@"gen buffer error");
        }
        alBufferData(buffer, format, data, size, sample);
        if(alGetError() != AL_NO_ERROR) {
            NSLog(@"buffer data  error");
        }
        [bufferStorage addObject:[NSNumber numberWithUnsignedInt:buffer]];
        
        NSUInteger source;
        alGenSources(1, &source);
        sourceID = source;
        
        alSourcei(source, AL_BUFFER, buffer);
        alSourcef(source, AL_PITCH, 1.0f);
        alSourcef(source, AL_GAIN, 1.0f);
        alSourcei(source, AL_LOOPING, AL_TRUE);
        if(alGetError() != AL_NO_ERROR) {
            NSLog(@"source error");
        }
        
        free(data);
        data = NULL;
        
    }
}
-(id) init {
    bufferStorage = [[NSMutableArray alloc] init];
    [self initOpenAL];
    return self;
}
-(void)playSound {
    NSLog(@"playSound %d", sourceID);
    alSourcePlay(sourceID);
}
-(void)stopSound {
    NSLog(@"stop Sound");
    NSLog(@"sourceId %d", sourceID);
    alSourceStop(sourceID);
}
-(AudioFileID) openAudioFile : (NSString *)filePath{
    AudioFileID outAFD;
    NSURL *url = [NSURL fileURLWithPath:filePath];
    OSStatus status = AudioFileOpenURL((CFURLRef)url, kAudioFileReadPermission, 0, &outAFD);
    checkStatus(status, @"not open file");
    return outAFD;
}
-(UInt32) audioFileSize : (AudioFileID) fileID {
    UInt64 outSize = 0;
    UInt32 thePropSize = sizeof(UInt64);
    checkStatus(AudioFileGetProperty(fileID, kAudioFilePropertyAudioDataByteCount, &thePropSize, &outSize), @"not find file size");
    return outSize;
}

@end
