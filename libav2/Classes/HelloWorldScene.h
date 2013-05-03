#ifndef __HELLOWORLD_SCENE_H__
#define __HELLOWORLD_SCENE_H__

#include "cocos2d.h"
#include "VideoController.h"
#include "CameraFile.h"
#include "Bomb.h"
#include "Background.h"
#include "Cannon.h"
#include "MyAudio.h"
#import "TestOpenAL.h"
#include "ShowScene.h"
#include "RecordScene.h"

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
    virtual void update(float);
    bool inRecord;
    float passTime;
    int currentFrame;
    
    CCNode *tempScreen;
    CCLabelTTF *word;
    virtual void onEnter();
    virtual void onExit();
    virtual void stopRecord();
    virtual void startRecord();
    RecordScene *recordScene;
private:
    VideoController *video;
    void onStart(CCObject *);
    void onStop(CCObject *);
    CameraFile *camera;
    string savedFile;
    
    void onRecord();
    void stopR();
    MyAudio *myAudio;
    TestOpenAL *openAL;
    void onOpenAL();
    void stopOpenAL();
    ShowScene *show;
    CCNode *menuLayer;
    CCNode *gameLayer;
    
    CCSprite *makeBackScreen();
};

#endif // __HELLOWORLD_SCENE_H__
