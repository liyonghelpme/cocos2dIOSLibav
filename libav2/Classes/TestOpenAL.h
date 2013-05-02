//
//  TestOpenAL.h
//  libav2
//
//  Created by  stc on 13-5-2.
//
//

#import <Foundation/Foundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <AudioToolbox/AudioFile.h>
@interface TestOpenAL : NSObject{
    ALCcontext *mContext;
    ALCdevice *mDevice;
    NSMutableArray *bufferStorage;
    NSUInteger sourceID;
}
+(TestOpenAL *)testOpenAL;
-(id)init;
-(void)initOpenAL;
-(AudioFileID) openAudioFile : (NSString *)filePath;
-(void)playSound;
-(void)stopSound;
@end
