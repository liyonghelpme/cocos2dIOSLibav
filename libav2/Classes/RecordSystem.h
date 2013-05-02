//
//  RecordSystem.h
//  libav2
//
//  Created by  stc on 13-5-2.
//
//

#import <Foundation/Foundation.h>
#import "MyAudio.h"
#import "VideoController.h"

@interface RecordSystem : NSObject {
    MyAudio *audio;
    VideoController *video;
    
}
-(id) init;
-(void) startRecord;
-(void) stopRecord;
-(void) setParent : (CCNode *) parent;
@end
