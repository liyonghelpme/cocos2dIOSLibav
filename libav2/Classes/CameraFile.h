//
//  CameraFile.h
//  newLibav
//
//  Created by  stc on 13-3-20.
//
//
#ifndef __CAMERA_H__
#define __CAMERA_H__
class CameraFile {
public:
    CameraFile();
    const char *getFileName();
    void savedToCamera(const char*);

};
#endif
