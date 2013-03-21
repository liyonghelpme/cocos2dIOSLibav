#ifndef __HELLOWORLD_SCENE_H__
#define __HELLOWORLD_SCENE_H__

#include "cocos2d.h"
#include "VideoController.h"
#include "CameraFile.h"
#include "Bomb.h"
#include "Background.h"
#include "Cannon.h"

using namespace std;

using namespace cocos2d;
class HelloWorld : public cocos2d::CCLayer
{
public:
    // Method 'init' in cocos2d-x returns bool, instead of 'id' in cocos2d-iphone (an object pointer)
    virtual bool init();

    // there's no 'id' in cpp, so we recommend to return the class instance pointer
    static cocos2d::CCScene* scene();
    
    // a selector callback
    void menuCloseCallback(CCObject* pSender);

    // preprocessor macro for "static create()" constructor ( node() deprecated )
    CREATE_FUNC(HelloWorld);
    ~HelloWorld();
private:
    VideoController *video;
    void onStart(CCObject *);
    void onStop(CCObject *);
    CameraFile *camera;
    string savedFile;
};

#endif // __HELLOWORLD_SCENE_H__
