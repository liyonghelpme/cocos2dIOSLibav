//
//  MyAudio.m
//  libav2
//
//  Created by  stc on 13-5-1.
//
//

#import "MyAudio.h"

@implementation MyAudio
+(MyAudio *) myAudio {
    MyAudio *w = [[MyAudio alloc] init];
    return w;
}
-(id) init{
    NSDate *t = [NSDate date];
    currentTime = (int)[t timeIntervalSince1970];
    return self;
}
//filename from module start time
-(NSString *) getFileName {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = [path objectAtIndex:0];
    NSString *s = [NSString stringWithFormat:@"%d-test.caf", currentTime];
    NSString *appFile = [document stringByAppendingPathComponent: s ];
    NSLog(@"audio file is %@", appFile);
    return appFile;
}
-(void) startRecord {
    NSError *error = nil;
    audioSession = [[AVAudioSession sharedInstance] retain];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error) {
        NSLog(@"audioSession SetCategory : %@ %d %@", [error domain], [error code], [[error userInfo] description]);
    }
    UInt32 ASRoute = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(ASRoute), &ASRoute);
    
     if (error) {
     NSLog(@"audioSession SetProperty Error : %@ %d %@", [error domain], [error code], [[error userInfo] description]);
     }
    
    [audioSession setActive:YES error:&error];
    if (error) {
        NSLog(@"audioSession setActive : %@ %d %@", [error domain], [error code], [[error userInfo] description]);
    }

    
    
    NSURL *fileURL = [NSURL URLWithString:[self getFileName]];
    NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:AVAudioQualityMin], AVEncoderAudioQualityKey,
                                   [NSNumber numberWithInt:16], AVEncoderBitRateKey,
                                   [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                                   [NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                                   nil];
    
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:fileURL settings:recordSetting error:&error];
    audioRecorder.delegate = self;
    
    if(error) {
        NSLog(@"error: %@", [error localizedDescription]);
    } else {
        BOOL pre = [audioRecorder prepareToRecord];
        NSLog(@"prepare %d", pre);
        audioRecorder.meteringEnabled = YES;
        BOOL rec = [audioRecorder record];
        NSLog(@"record %d", rec);
        
    }
    NSLog(@"start Record");
}
-(void) stopRecord {
    NSLog(@"stopRecord");
    if (audioRecorder.recording) {
        NSLog(@"in stop Record");
        [audioRecorder stop];
        //[audioSession release];
        NSLog(@"release session");
        [audioSession release];
    }
}
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    NSLog(@"finish Record Audio");
    [audioRecorder release];
    //[audioSession release];
}
-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    NSLog(@"Encoder Error %@", [error localizedDescription]);
}
-(void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder {
    
}
-(void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags {
    
}
@end
