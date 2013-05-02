//
//  MyAudioUnit.h
//  libav2
//
//  Created by  stc on 13-5-2.
//
//

#import <Foundation/Foundation.h>
#import "AVFoundation/AVFoundation.h"

@interface MyAudioUnit : NSObject {
    AudioComponentInstance audioUnit;
    AudioStreamBasicDescription audioFormat;
}
+(MyAudioUnit *)myAudioUnit;
-(id)init;

-(void) startRecord;
-(void) stopRecord;
@end
