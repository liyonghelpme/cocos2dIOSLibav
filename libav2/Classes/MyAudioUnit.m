//
//  MyAudioUnit.m
//  libav2
//
//  Created by  stc on 13-5-2.
//
//

#import "MyAudioUnit.h"

#define kOutputBus 0
#define kInputBus 1
@implementation MyAudioUnit
+(MyAudioUnit *)myAudioUnit {
    MyAudioUnit *ret = [[MyAudioUnit alloc] init];
    return ret;
}
//record audio send to hardward
//compress IO Data
static OSStatus playbackCallback(void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData) {
    
    MyAudioUnit *myAudioUnit = (MyAudioUnit *)inRefCon;
    OSStatus err = AudioUnitRender(myAudioUnit->audioUnit, ioActionFlags, inTimeStamp, 1, inNumberFrames, ioData);
    checkStatus(err, @"playback callback");
    return noErr;
}

-(id)init {
    OSStatus status;
    AudioComponentDescription desc;
    desc.componentType = kAudioUnitType_Output;
    desc.componentSubType = kAudioUnitSubType_RemoteIO;
    desc.componentFlags = 0;
    desc.componentFlagsMask = 0;
    desc.componentManufacturer = kAudioUnitManufacturer_Apple;
    
    AudioComponent inputComponent = AudioComponentFindNext(NULL, &desc);
    status = AudioComponentInstanceNew(inputComponent, &audioUnit);
    checkStatus(status, @"Instance New");
    
    //UInt32 flag = 1;
    //status = AudioUnitSetProperty(audioUnit, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Input, kInputBus, &flag, sizeof(flag));
    //checkStatus(status);
    
    UInt32 flag = 1;
    status = AudioUnitSetProperty(audioUnit, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Output, kOutputBus, &flag, sizeof(flag));
    checkStatus(status, @"EnableIO Output");
    
    
    //AudioStreamBasicDescription audioFormat;
    audioFormat.mSampleRate = 44100.0;
    audioFormat.mFormatID = kAudioFormatLinearPCM;
    audioFormat.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    audioFormat.mFramesPerPacket = 1;
    audioFormat.mChannelsPerFrame = 1;
    audioFormat.mBitsPerChannel = 16;
    audioFormat.mBytesPerPacket = 2;
    audioFormat.mBytesPerFrame = 2;
    
    //input audio format
    status = AudioUnitSetProperty(audioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, kOutputBus, &audioFormat, sizeof(audioFormat));
    checkStatus(status, @"set  input client stream format");
    
    status = AudioUnitSetProperty(audioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, kInputBus, &audioFormat, sizeof(audioFormat));
    checkStatus(status, @"set  output client stream format");

    //when app output audio call callback
    AURenderCallbackStruct callbackStruct;
    
    callbackStruct.inputProc = playbackCallback;
    callbackStruct.inputProcRefCon = self;
    
    status = AudioUnitSetProperty(audioUnit, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Global, kOutputBus, &callbackStruct, sizeof(callbackStruct));
    checkStatus(status, @"set callback func");
    
    
    
    //use System buffer
    //flag = 0;
    //status = AudioUnitSetProperty(audioUnit, kAudioUnitProperty_ShouldAllocateBuffer, kAudioUnitScope_Output, kInputBus, flag, sizeof(flag));
    //checkStatus(status);
    
    status = AudioUnitInitialize(audioUnit);
    checkStatus(status, @"initial output");
    
    
    return self;
}

-(void)startRecord {
    OSStatus status = AudioOutputUnitStart(audioUnit);
    checkStatus(status, @"Start Record");
}
-(void)stopRecord {
    OSStatus status = AudioOutputUnitStop(audioUnit);
    checkStatus(status, @"End Record");
}
-(void)dealloc {
    AudioComponentInstanceDispose(audioUnit);
    [super dealloc];
}
@end
