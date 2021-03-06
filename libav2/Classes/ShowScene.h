//
//  ShowScene.h
//  libav2
//
//  Created by  stc on 13-5-3.
//
//

#ifndef __libav2__ShowScene__
#define __libav2__ShowScene__

#include <iostream>
#include "cocos2d.h"
#include "VideoController.h"
#include "RecordScene.h"

using namespace cocos2d;
class ShowScene : public cocos2d::CCLayer{
public:
    CCNode *renderLayer;
    CCNode *backgroundPic;
    virtual bool init();
    CREATE_FUNC(ShowScene);
    
    void setBackground(CCNode *back);
    void setRenderLayer(CCNode *n);
    void setVideoController(VideoController *);
    static CCScene *scene();
    
    VideoController *videoController;
    virtual bool ccTouchBegan(CCTouch *, CCEvent *);
    
    virtual void startRecord();
    virtual void stopRecord();
    RecordScene *recordScene;
    void setRecordScene(RecordScene *);
private:
    void onStop();
};

#endif /* defined(__libav2__ShowScene__) */
