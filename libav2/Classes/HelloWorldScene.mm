#include "HelloWorldScene.h"
#include "SimpleAudioEngine.h"
#include "RecordScene.h"


using namespace cocos2d;
using namespace CocosDenshion;

CCScene* HelloWorld::scene()
{
    // 'scene' is an autorelease object
    CCScene *scene = CCScene::create();
    
    // 'layer' is an autorelease object
    HelloWorld *layer = HelloWorld::create();

    // add layer as a child to scene
    scene->addChild(layer);

    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
bool HelloWorld::init()
{
    //////////////////////////////
    // 1. super init first
    if ( !CCLayer::init() )
    {
        return false;
    }
    //开始录制视频
    inRecord = false;
    currentFrame = 0;
    
    menuLayer = CCNode::create();
    addChild(menuLayer);
    gameLayer = CCNode::create();
    addChild(gameLayer);
    /////////////////////////////
    // 2. add a menu item with "X" image, which is clicked to quit the program
    //    you may modify it.

    // add a "close" icon to exit the progress. it's an autorelease object
    CCMenuItemImage *pCloseItem = CCMenuItemImage::create(
                                        "CloseNormal.png",
                                        "CloseSelected.png",
                                        this,
                                        menu_selector(HelloWorld::menuCloseCallback) );
    pCloseItem->setPosition( ccp(CCDirector::sharedDirector()->getWinSize().width - 20, 20) );

    // create menu, it's an autorelease object
    CCMenu* pMenu = CCMenu::create(pCloseItem, NULL);
    pMenu->setPosition( CCPointZero );
    menuLayer->addChild(pMenu, 1);

    /////////////////////////////
    // 3. add your codes below...

    // add a label shows "Hello World"
    // create and initialize a label
  
    
    CCMenuItemFont *item1 = CCMenuItemFont::create("start", this, menu_selector(HelloWorld::onStart));
    CCMenuItemFont *item2 = CCMenuItemFont::create("stop", this, menu_selector(HelloWorld::onStop));
    CCMenu *menu = CCMenu::create(item1, item2, NULL);
    addChild(menu);
    //camera = new CameraFile();
    
    video = VideoController::create();
    addChild(video);
    
    //video->setCamera(camera);
    
    item1->setScale(2);
    item2->setScale(2);
    item1->setPosition(ccp(0, 200));
    item2->setPosition(ccp(0, -200));
    
    Background *bk = Background::create();
    gameLayer->addChild(bk);
    Cannon *cannon = Cannon::create();
    gameLayer->addChild(cannon);
    cannon->setPosition(ccp(480, 320));
    
    //SimpleAudioEngine::sharedEngine()->playBackgroundMusic("love.mp3", true);
    //SimpleAudioEngine::sharedEngine()->playEffect("out.caf", true);
    
    
    item1 = CCMenuItemFont::create("startAudio", this, menu_selector(HelloWorld::onRecord));
    item2 = CCMenuItemFont::create("stopAudio", this, menu_selector(HelloWorld::stopR));
    menu = CCMenu::create(item1, item2, NULL);
    addChild(menu);
    item1->setPosition(ccp(200, 200));
    item2->setPosition(ccp(200, -200));
    
    openAL = [[TestOpenAL alloc] init];
    item1 = CCMenuItemFont::create("startOpenAL", this, menu_selector(HelloWorld::onOpenAL));
    item2 = CCMenuItemFont::create("stopOpenAL", this, menu_selector(HelloWorld::stopOpenAL));
    menu = CCMenu::create(item1, item2, NULL);
    addChild(menu);
    item1->setPosition(ccp(400, 200));
    item2->setPosition(ccp(400, -200));
    
    return true;
    
    
}
void HelloWorld::onOpenAL() {
    [openAL playSound];
}
void HelloWorld::stopOpenAL() {
    [openAL stopSound];
}

void HelloWorld::onRecord() {
    myAudio = [MyAudio myAudio];
    [myAudio startRecord];
}
void HelloWorld::stopR() {
    [myAudio stopRecord];
    [myAudio release];
}
void HelloWorld::onEnter() {
    CCLayer::onEnter();
    scheduleUpdate();
}
void HelloWorld::onExit() {
    unscheduleUpdate();
    CCLayer::onExit();
}
void HelloWorld::update(float dt) {
    if(inRecord) {
        
        if(currentFrame == 0) {
            tempScreen = CCNode::create();
            tempScreen->addChild(CCLayerColor::create(ccc4(255, 255, 255, 255)));
            word = CCLabelTTF::create("第一frame", "Arial", 30);
            word->setColor(ccc3(255, 0, 0));
            tempScreen->addChild(word);
            word->setPosition(ccp(400, 300));
            
            addChild(tempScreen);
            currentFrame = 1;
            passTime = 0;
        }
        else if(currentFrame == 1) {
            if(passTime >= 2) {
                word->setString("第二frame");
                currentFrame = 2;
                passTime = 0;
            }
        } else if(currentFrame == 2) {
            if(passTime >= 2) {
                word->setString("第三frame");
                currentFrame = 3;
                passTime = 0;
            }
        } else if(currentFrame == 3) {
            if(passTime >= 2) {
                tempScreen->setVisible(false);
                currentFrame = 4;
                passTime = 0;
            }
        } else if(currentFrame == 4) {
            if(passTime >= 4) {
                tempScreen->setVisible(true);
                word->setString("Bye Bye");
                currentFrame = 5;
                passTime = 0;
            }
        } else if(currentFrame == 5) {
            //currentFrame = 1;
            //passTime = 0;
        }
        passTime += dt;
    }
}
CCSprite *HelloWorld::makeBackScreen() {
    CCDirector *director = CCDirector::sharedDirector();
    CCRenderTexture *render = CCRenderTexture::create(director->getWinSizeInPixels().width, director->getWinSizeInPixels().height, kTexture2DPixelFormat_RGBA8888);
    render->beginWithClear(0, 0, 0, 0, 0);
    gameLayer->visit();
    render->end();
    
    CCSprite *ns = CCSprite::createWithTexture(render->getSprite()->getTexture());
    return ns;
}

void HelloWorld::onStart(CCObject *send){
    if(inRecord)
        return;
    
    startRecord();
}
void HelloWorld::startRecord() {
    passTime = 0;
    inRecord = true;
    //const char *fileName = camera->getFileName();
    //CCLOG("fileName %s", fileName);
    //savedFile = string(fileName);
    RecordScene *recordScene = RecordScene::create();
    CCSprite *ns = makeBackScreen();
    
    //显示的场景
    show = ShowScene::create();
    CCLog("video is %x", video);
    show->setRenderLayer(this);
    show->setVideoController(video);
    show->setBackground(ns);
    ns->setFlipY(true);
    CCDirector *director = CCDirector::sharedDirector();
    ns->setPosition(ccp(director->getWinSize().width/2, director->getWinSize().height/2));
    
    //this 绘制的场景
    
    this->retain();
    removeFromParent();
    recordScene->setRenderLayer(this);
    this->release();
    
    recordScene->setShowLayer(show);
    //本场景只用于 update 和 draw 不用touch 处理
    
    CCDirector::sharedDirector()->replaceScene(recordScene);
    recordScene->startRecord();
    video->startWork(960, 640, 960, 640, "", 1./30);
}
HelloWorld::~HelloWorld() {
    delete camera;
}
void HelloWorld::stopRecord() {
    inRecord = false;
    video->stopWork();
    currentFrame = 0;
    passTime = 0;
    tempScreen->removeFromParent();
    tempScreen = NULL;
}
void HelloWorld::onStop(CCObject *send) {
    if (!inRecord) {
        return;
    }
    stopRecord();
    
}
void HelloWorld::menuCloseCallback(CCObject* pSender)
{
    CCDirector::sharedDirector()->end();

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    exit(0);
#endif
}
