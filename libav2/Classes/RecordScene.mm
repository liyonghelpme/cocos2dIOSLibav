//
//  RecordScene.cpp
//  libav2
//
//  Created by  stc on 13-5-3.
//
//
#include "ShowScene.h"
#include "HelloWorldScene.h"
#include "RecordScene.h"
bool RecordScene::init() {
    CCScene::init();
    return true;
}

void RecordScene::startRecord() {
}
void RecordScene::stopRecord() {
    renderLayer->removeFromParent();
    CCScene *scene = CCScene::create();
    scene->addChild(renderLayer);
    
    CCDirector::sharedDirector()->replaceScene(scene);
    renderLayer->stopRecord();
}
void RecordScene::setRenderLayer(HelloWorld *r) {
    renderLayer = r;
    renderLayer->recordScene = this;
    CCDirector::sharedDirector()->setRenderLayer(renderLayer);
    addChild(renderLayer);
}
void RecordScene::setShowLayer(ShowScene *s) {
    CCLog("setShowLayer %x", s);
    showLayer = s;
    showLayer->setRecordScene(this);
    CCDirector::sharedDirector()->setShowLayer(showLayer);
    addChild(showLayer);
}
