//
//  RecordSystem.m
//  libav2
//
//  Created by  stc on 13-5-2.
//
//

#import "RecordSystem.h"

@implementation RecordSystem
-(void) setParent:(cocos2d::CCNode *)parent {
    parent->addChild(video);
}
-(id)init{
    audio = [[MyAudio alloc] init];
    video = VideoController::create();
    video->retain();
    
    return self;
}
-(void)startRecord {
    [audio startRecord];
    video->startWork(960, 640, 960, 640, "", 1/25.);
    
}
-(void)stopRecord {
    
}
-(void)dealloc {
    video->removeFromParent();
    [audio release];
    video->release();
    [super dealloc];
}
@end
