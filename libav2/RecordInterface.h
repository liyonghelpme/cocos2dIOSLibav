//
//  RecordInterface.h
//  libav2
//
//  Created by  stc on 13-5-3.
//
//

#ifndef libav2_RecordInterface_h
#define libav2_RecordInterface_h
#include "RecordScene.h"

class RecordInterface {
public:
    virtual void stopRecord() = 0;
    virtual void startRecord() = 0;
    RecordScene *recordScene;
    virtual void setRecordScene(RecordScene *r) {
        recordScene = r;
    }
};

#endif
