//
//  MyVideo.h
//  libav2
//
//  Created by  stc on 13-5-2.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MyVideo : NSObject {
    uint8_t *frameData;
    AVAssetWriter *assetWriter;
    int width;
    int height;
    AVAssetWriterInput *assetWriterVideoInput;
    AVAssetWriterInputPixelBufferAdaptor *assetWriterPixelBufferInput;
    NSDate *startTime;
    
    int ct;
   
    GLuint movieFrameBuffer;
    CVOpenGLESTextureCacheRef coreVideoTextureCache;
    EAGLContext *context;
    CVPixelBufferRef renderTarget;
    CVOpenGLESTextureRef renderTexture;
}
+(MyVideo *)myVideo;
-(id) init;
-(const char *) getFileName;
-(void) saveToCamera;
-(void) initWriter;
-(void) startWork: (int) width  height: (int) height;
-(void) compressFrame;
-(void) stopWork;
-(void) createDataFBO;
-(void) destroyDataFBO;
-(void) finishSaveFile : (NSString *)videoPath error:(NSError *)error context:(void*)context;
@end
