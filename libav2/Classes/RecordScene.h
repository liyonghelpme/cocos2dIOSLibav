//
//  RecordScene.h
//  libav2
//
//  Created by  stc on 13-5-3.
//
//

#ifndef __libav2__RecordScene__
#define __libav2__RecordScene__
#include "cocos2d.h"
#include <iostream>
#include "VideoController.h"

using namespace cocos2d;
//showLayer renderLayer 需要实现RecordInterface 接口功能
class ShowScene;
class HelloWorld;
class RecordScene : public CCScene {
public:
    ShowScene *showLayer;   //用来显示的层
    HelloWorld *renderLayer; //用来录制的层  控制显示哪些frame 以及frame 出现的时间和次序
    
    void startRecord();
    void stopRecord();
    CREATE_FUNC(RecordScene);
    virtual bool init();
    
    void setShowLayer(ShowScene*);
    void setRenderLayer(HelloWorld*);
    
};

#endif /* defined(__libav2__RecordScene__) */
