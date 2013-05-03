#ifndef __VIDEO_CONTROLLER_H__
#define __VIDEO_CONTROLLER_H__
#include "cocos2d.h"
#include "stdlib.h"
#include "CameraFile.h"

using namespace std;

using namespace cocos2d;
class VideoController : public CCNode{
public:
    static VideoController *create();
    virtual bool init();
    void startWork(int winW, int winH, int w, int h, const char *fn, float fr);
    void stopWork();
    virtual void update(float dt);
    ~VideoController();
    void compressCurrentFrame();
    bool getStart();
    void setCamera(CameraFile *);
    virtual void onEnter();
    virtual void onExit();
    
private:
    string fileN;
    float MaxRecordTime; // 最大视频时间
    float frameRate;  //帧率

    int outbuf_size;  
    uint8_t *outbuf;  //输出数据缓存
    uint8_t *pixelBuffer; //显卡中的RGBA 数据

    float passTime; //每帧记录的时间
    bool startYet;  //是否开始记录

    float totalTime; //当前总共记录的时间
    //用于像素 缓冲分配
    int winWidth;//屏幕大小
    int winHeight; //屏幕大小
    //用于视频缓冲分配
    int width; //视频的 宽度
    int height; //视频的高度
    void *tempCache;
    int frameCount;

    float testTime;

    double video_pts;
    
    CameraFile *camera;

};
#endif
