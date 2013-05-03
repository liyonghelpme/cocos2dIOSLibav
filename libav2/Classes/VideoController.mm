#include "VideoController.h"
#include "string.h"
/*
video = VideoController::create();
addChild(video);
video->startWork();
video->stopWork();
*/


VideoController *VideoController::create()
{
    CCLog("create VideoController");
    VideoController *pRet = new VideoController();
    pRet->init();
    pRet->autorelease();
    return pRet;
}

//时间2s钟
//每秒10帧
bool VideoController::init()
{
    CCLog("init VideoController");
    MaxRecordTime = 1000;
    frameRate = 1./25;  //0.1s 1帧
    startYet = false;
    testTime = 10;
    camera = new CameraFile();

    //scheduleUpdate();
    
    return true;
}
void VideoController::onEnter() {
    CCNode::onEnter();
    scheduleUpdate();
}
void VideoController::onExit() {
    unscheduleUpdate();
    CCNode::onExit();
}
void VideoController::startWork(int winW, int winH, int w, int h, const char *fn, float fr) {
    startYet = true;
    camera->startWork(winW, winH);
    CCLog("VideoController startWork");
}
void VideoController::stopWork() {
    startYet = false;
    camera->stopWork();
}

bool VideoController::getStart() {
    return startYet;
}
void VideoController::setCamera(CameraFile *c) {
    camera = c;
}
void VideoController::compressCurrentFrame() {
    CCLog("compressFrame in VideoController");
    camera->compressFrame();
}

/*
pts 帧率的问题
http://stackoverflow.com/questions/6603979/ffmpegavcodec-encode-video-setting-pts-h264
*/
void VideoController::update(float dt)
{
    //CCLog("update %d %f", startYet, dt);
    if(startYet ) {

        if(totalTime < MaxRecordTime) {//测试时间10s
            totalTime += dt;
            passTime += dt;
            if(passTime >= frameRate) {
                CCLog("update %f %f %f %f", totalTime, MaxRecordTime, passTime, frameRate);
                passTime -=  frameRate;
                compressCurrentFrame();
                frameCount += 1;
            }
        } else {
            stopWork();
        }
    }
}

VideoController::~VideoController()
{
    delete camera;
}


