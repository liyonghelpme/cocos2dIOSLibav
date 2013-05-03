//
//  CameraFile.m
//  newLibav
//
//  Created by  stc on 13-3-20.
//
//

#include "CameraFile.h"
#include "cocos2d.h"
#include "AppController.h"
#include "RootViewController.h"
#include "EAGLView.h"
using namespace cocos2d;
//视频的保存时间作为名字放置重叠
CameraFile::CameraFile() {
    NSDate *curTime = [NSDate date];
    ct = int([curTime timeIntervalSince1970]);
    removeTempVideo = [[RemoveTempVideo alloc] init];
    movieFrameBuffer = 0;
}
const char *CameraFile::getFileName() {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = [path objectAtIndex:0];
    
    NSString *s = [NSString stringWithFormat:@"%d-test.mov", ct];
    NSString *appFile = [document stringByAppendingPathComponent: s ];
    
    NSLog(@"appfile is %@", appFile);
    
    NSArray *testPath = NSSearchPathForDirectoriesInDomains(NSPicturesDirectory, NSUserDomainMask, YES);
    for (int i = 0; i < [testPath count]; i++) {
         NSLog(@"testPath %@", [testPath objectAtIndex:i]);
    }
    
    
   
    return [appFile UTF8String];
}
void CameraFile::destroyDataFBO() {
    if (movieFrameBuffer) {
        glDeleteFramebuffers(1, &movieFrameBuffer);
        movieFrameBuffer = 0;
    }
    if (coreVideoTextureCache) {
        CFRelease(coreVideoTextureCache);
    }
    if (renderTexture) {
        CFRelease(renderTexture);
    }
    if (renderTarget) {
        CVPixelBufferRelease(renderTarget);
    }
    
}
//生成TextureCache 管理器
//pixelBuffer renderTarget  内存中  依赖 writePixelBuffer 管理器
//texture    renderTexture  显卡中
void CameraFile::createDataFBO() {
    NSLog(@"createDataFBO");
    context = [[EAGLView sharedEGLView] context];
    GLint oldFBO;
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &oldFBO);
    
    glGenFramebuffers(1, &movieFrameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, movieFrameBuffer);
    CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, context, NULL, &coreVideoTextureCache);
    if(err) {
        NSLog(@"create FBO fail");
        exit(1);
    }
    CVPixelBufferPoolCreatePixelBuffer(NULL, [assetWriterPixelBufferInput pixelBufferPool], &renderTarget);
    CVOpenGLESTextureCacheCreateTextureFromImage (kCFAllocatorDefault, coreVideoTextureCache, renderTarget,
                                              NULL, // texture attributes
                                              GL_TEXTURE_2D,
                                              GL_RGBA, // opengl format
                                              (int)width,
                                              (int)height,
                                              GL_BGRA, // native iOS format
                                              GL_UNSIGNED_BYTE,
                                              0,
                                              &renderTexture);

    glBindTexture(CVOpenGLESTextureGetTarget(renderTexture), CVOpenGLESTextureGetName(renderTexture));
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, CVOpenGLESTextureGetName(renderTexture), 0);

    glBindFramebuffer(GL_FRAMEBUFFER, oldFBO);
    CCDirector::sharedDirector()->startRecording();
}
void CameraFile::savedToCamera() {
    
    NSLog(@"savedToCamera");
    //mergeAudio();
    
    const char *fileName = getFileName();
    NSLog(@"savedToCamera File %s", fileName);
    
    //NSString *videoPath = [NSString stringWithFormat:@"%s", fileName];
    /*
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"IMG_0697" ofType:@"mov"];
    NSURL *videoURL = [NSURL URLWithString:videoPath];
    AVURLAsset *videoasset = [[AVURLAsset alloc] initWithURL:videoURL options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES] , AVURLAssetPreferPreciseDurationAndTimingKey, nil]];
    AVKeyValueStatus d = [videoasset statusOfValueForKey:@"duration" error:nil];
    NSLog(@"duration ready %d", d);
    [videoasset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObjects:@"duration", @"isComposable", nil] completionHandler:^{
        NSLog(@"videoasset real duration %f", CMTimeGetSeconds(videoasset.duration));
        AVKeyValueStatus d = [videoasset statusOfValueForKey:@"duration" error:nil];
        NSLog(@"duration ready 222 %d", d);
    }];
    
    NSLog(@"videoasset descript %@", videoasset.description);
    NSLog(@"debug %@", videoasset.debugDescription);
    NSLog(@"videoasset %d", videoasset.providesPreciseDurationAndTiming);
    NSLog(@"video duration %lld", videoasset.duration.value);
    NSLog(@"video saved? %d", videoasset.isCompatibleWithSavedPhotosAlbum);
    NSLog(@"composible %d", videoasset.isComposable);
    */
    
    UISaveVideoAtPathToSavedPhotosAlbum([NSString stringWithFormat:@"%s",  fileName], removeTempVideo, @selector(finishCopy:error:context:), nil);
}
void CameraFile::startWork(int width, int height) {
    this->width = width;
    this->height = height;
    frameData = (uint8_t*)malloc(width*4);
    const char *fileName = this->getFileName();
    //fn = [NSString stringWithFormat:@"%s", fileName];
    NSError *error = nil;
    NSURL *url = [[NSURL alloc] initFileURLWithPath:[NSString stringWithFormat:@"%s", fileName] isDirectory:false];
    [url autorelease];
    
    assetWriter = [[AVAssetWriter alloc] initWithURL:url fileType:AVFileTypeQuickTimeMovie error:&error];
    if(error != nil) {
        NSLog(@"assetWriter Error %@", error);
        NSLog(@"url %@ %s", url, fileName);
        exit(1);
    }
    NSLog(@"CameraFile startWork %@", url);
    
    NSMutableDictionary *outputSettings = [[NSMutableDictionary alloc] init];
    [outputSettings autorelease];
    
    [outputSettings setObject:AVVideoCodecH264 forKey:AVVideoCodecKey];
    [outputSettings setObject:[NSNumber numberWithInt:width] forKey:AVVideoWidthKey];
    [outputSettings setObject:[NSNumber numberWithInt:height] forKey:AVVideoHeightKey];
    
    assetWriterVideoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:outputSettings];
    [assetWriterVideoInput retain];
    
    assetWriterVideoInput.expectsMediaDataInRealTime = true;
    
    
    NSDictionary *sourcePixelBufferAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA], kCVPixelBufferPixelFormatTypeKey,
                                                           [NSNumber numberWithInt:width], kCVPixelBufferWidthKey,
                                                           [NSNumber numberWithInt:height], kCVPixelBufferHeightKey,
                                                           nil];
    assetWriterPixelBufferInput = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:assetWriterVideoInput sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
    [assetWriterPixelBufferInput retain];
    
    
    [assetWriter addInput:assetWriterVideoInput];
    startTime = [NSDate date];
    [startTime retain];
    
    
    [assetWriter startWriting];
    [assetWriter startSessionAtSourceTime:kCMTimeZero];
    NSLog(@"startWork");
    
    //必须要等待 startWriting 才能 分配renderTarget
    this->createDataFBO();
}
void CameraFile::compressFrame() {
    if (!assetWriterVideoInput.readyForMoreMediaData)
    {
        NSLog(@"Had to drop a video frame");
        return;
    }
    //结束绘制 导出数据
    //glFinish();
    NSLog(@"compressFrame in Camera");
    //NSLog(@"lock pixel_buffer %@", renderTarget);
    CVPixelBufferRef pixel_buffer = NULL;
   
    pixel_buffer = renderTarget;
    
    //直接读取Framebuffer 中的数据
    CVPixelBufferLockBaseAddress(pixel_buffer, 0);
        
    GLint oldFBO;
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &oldFBO);
    glBindFramebuffer(GL_FRAMEBUFFER, movieFrameBuffer);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    //需要调整ScaleY 用于显示
    //测试播放动画
    CCDirector::sharedDirector()->getRecordSprite()->setScaleY(1);
    CCDirector::sharedDirector()->getRecordSprite()->visit();
    CCDirector::sharedDirector()->getRecordSprite()->setScaleY(-1);
    glFlush();
   
    glBindFramebuffer(GL_FRAMEBUFFER, oldFBO);
       
    CMTime currentTime = CMTimeMakeWithSeconds([[NSDate date] timeIntervalSinceDate:startTime], 120);
    if (![assetWriterPixelBufferInput appendPixelBuffer:pixel_buffer withPresentationTime:currentTime]) {
        NSLog(@"Problem appending pixel buffer at time: %lld", currentTime.value);
    } else {
        
    }
    CVPixelBufferUnlockBaseAddress(pixel_buffer, 0);
    //不能释放 pixel_buffer
    //CVPixelBufferRelease(pixel_buffer);
    
}
void CameraFile::mergeAudio() {
    
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"love" ofType:@"mp3"];
    NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
    AVURLAsset *audioasset = [[AVURLAsset alloc] initWithURL:audioUrl options:nil];
    
    const char *fileName = this->getFileName();
    NSLog(@"saveFileName %s", fileName);
    NSString *videoPath = [NSString stringWithFormat:@"%s", fileName];
    NSURL *videoURL = [NSURL URLWithString:videoPath];
    AVURLAsset *videoasset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    NSLog(@"audio duration %lld", audioasset.duration.value);
    NSLog(@"video duration %lld", videoasset.duration.value);
    
    //movie  audio video
    AVMutableComposition *mixComposition = [AVMutableComposition composition];
    NSString *moviepath = [NSString stringWithFormat:@"merge-%s", fileName];
    NSURL *movieurl = [NSURL URLWithString:moviepath];
    NSLog(@"movie path %@", moviepath);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:moviepath]) {
        [[NSFileManager defaultManager] removeItemAtPath:moviepath error:nil];
    }
    NSError *error;
    
    AVMutableCompositionTrack *compositionA = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *clipAudio = [[audioasset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    [compositionA insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioasset.duration) ofTrack:clipAudio atTime:kCMTimeZero error:&error];
    if (error) {
        NSLog(@"error composite audio %@", [error localizedDescription]);
    }
    
    
    AVMutableCompositionTrack *compositionB = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *clipVideo = [[videoasset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    [compositionB insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoasset.duration) ofTrack:clipVideo atTime:kCMTimeZero error:&error];
    if (error) {
        NSLog(@"error compositionVideo  %@", [error localizedDescription]);
    }
    
    
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.outputURL = movieurl;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        switch ([exporter status]) {
            case AVAssetExportSessionStatusFailed:
                NSLog(@"Export Failed %@", [[exporter error] localizedDescription]);
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"Export cancel ");
                break;
            case AVAssetExportSessionStatusCompleted:
                NSLog(@"Export Successful ");
            default:
                break;
        }
        //remove video remove movie
        [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
        UISaveVideoAtPathToSavedPhotosAlbum(moviepath, removeTempVideo, @selector(finishCopy:error:context:), nil);
        [audioasset release];
        [videoasset release];
        [exporter release];
    }];
}
void CameraFile::releaseAsset(){
    [assetWriter release];
    [assetWriterVideoInput release];
    [assetWriterPixelBufferInput release];
    [startTime release];
    free(frameData);
    destroyDataFBO();
}
void CameraFile::stopWork() {
    CCDirector::sharedDirector()->stopRecording();
    
    [assetWriterVideoInput markAsFinished];
    [assetWriter finishWritingWithCompletionHandler:^(){savedToCamera();}];
    /*
    BOOL finish = [assetWriter finishWriting];
    NSLog(@"finish");
    if(finish) {
        savedToCamera();
    }
    */
    
    releaseAsset();
    NSLog(@"stopWork");
}
CameraFile::~CameraFile() {
    [removeTempVideo release];
}
