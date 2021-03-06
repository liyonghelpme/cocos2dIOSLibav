//
//  CameraFile.h
//  newLibav
//
//  Created by  stc on 13-3-20.
//
//
#import <AVFoundation/AVFoundation.h>
#import "RemoveTempVideo.h"

#ifndef __CAMERA_H__
#define __CAMERA_H__
class CameraFile {
public:
    CameraFile();
    const char *getFileName();
    void savedToCamera();
    void initWriter();
    void startWork(int width, int height);
    void compressFrame();
    void stopWork();
    ~CameraFile();
private:
    uint8_t *frameData;
    AVAssetWriter *assetWriter;
    int width;
    int height;
    AVAssetWriterInput *assetWriterVideoInput;
    AVAssetWriterInputPixelBufferAdaptor *assetWriterPixelBufferInput;
    NSDate *startTime;
    
    //NSString *fn;
    int ct;
    void createDataFBO();
    void destroyDataFBO();
    
    GLuint movieFrameBuffer;
    CVOpenGLESTextureCacheRef coreVideoTextureCache;
    EAGLContext *context;
    CVPixelBufferRef renderTarget;
    CVOpenGLESTextureRef renderTexture;
    RemoveTempVideo *removeTempVideo;
    void mergeAudio();
    void releaseAsset();
};
#endif
