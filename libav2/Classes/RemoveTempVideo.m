//
//  RemoveTempVideo.m
//  libav2
//
//  Created by  stc on 13-5-2.
//
//

#import "RemoveTempVideo.h"

@implementation RemoveTempVideo
-(void) finishCopy:(NSString *)videoPath error:(NSError *)error context:(void *)context {
    [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
}
@end
