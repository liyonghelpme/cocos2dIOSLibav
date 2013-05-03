//
//  ShowScene.cpp
//  libav2
//
//  Created by  stc on 13-5-3.
//
//

#include "ShowScene.h"
bool ShowScene::init(){
    CCLayer::init();
    
    setTouchEnabled(true);
    backgroundPic = CCLayerColor::create(ccc4BFromccc4F(ccc4f(1, 1, 1, 1)));
    addChild(backgroundPic, -1);
    
    
    CCLabelTTF *label = CCLabelTTF::create("This is a Show Scene", "Arial", 30);
    label->setColor(ccc3(255, 0, 0));
    addChild(label);
    label->setPosition(ccp(450, 320));
    
    CCMenuItemFont *font = CCMenuItemFont::create("Stop Record Now", this, menu_selector(ShowScene::onStop));
    font->setColor(ccc3(0, 255, 0));
    CCMenu *menu = CCMenu::create(font, NULL);
    addChild(menu);
    font->setPosition(ccp(50, 100));
    return true;
}
//阻塞所有到renderLayer 的touch事件
void ShowScene::registerWithTouchDispatcher(){
    CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(this, 0, true);
}
bool ShowScene::ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent)
{
    return true;
}
void ShowScene::setRecordScene(RecordScene * r) {
    recordScene = r;
}
void ShowScene::onStop() {
    recordScene->stopRecord();
    /*
    //renderLayer->retain();
    renderLayer->removeFromParent();
    CCScene *scene = CCScene::create();
    scene->addChild(renderLayer);
    //renderLayer->release();
    
    CCDirector::sharedDirector()->replaceScene(scene);
    videoController->stopWork();
    */
}
void ShowScene::setBackground(CCNode *s) {
    backgroundPic->removeFromParent();
    backgroundPic = s;
    addChild(s, -1);
}
void ShowScene::setRenderLayer(CCNode *n) {
    renderLayer = n;
    //addChild(n, -2);
}
CCScene *ShowScene::scene() {
    CCScene *sc = CCScene::create();
    ShowScene *show = ShowScene::create();
    sc->addChild(show);
    return sc;
}
void ShowScene::setVideoController(VideoController *video) {
    CCLog("video in %x", video);
    videoController = video;
}

void ShowScene::startRecord() {
    
}
void ShowScene::stopRecord() {
    
}
