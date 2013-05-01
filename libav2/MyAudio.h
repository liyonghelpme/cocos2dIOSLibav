//
//  MyAudio.h
//  libav2
//
//  Created by  stc on 13-5-1.
//
//
#ifndef MYAUDIO_H
#define MYAUDIO_H

#import <AVFoundation/AVFoundation.h>

@interface MyAudio : NSObject <AVAudioRecorderDelegate>
{
    AVAudioRecorder *audioRecorder;
    int currentTime;
    AVAudioSession *audioSession;
}
+(MyAudio *) myAudio;
-(void) startRecord;
-(void) stopRecord;
-(NSString *) getFileName;
-(id) init;
@end

#endif
