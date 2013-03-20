//
//  CameraFile.m
//  newLibav
//
//  Created by  stc on 13-3-20.
//
//

#include "CameraFile.h"
CameraFile::CameraFile() {
    
}
const char *CameraFile::getFileName() {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = [path objectAtIndex:0];
    NSString *appFile = [document stringByAppendingPathComponent:@"my.mp4"];
    NSLog(@"appfile is %@", appFile);
    
    NSArray *testPath = NSSearchPathForDirectoriesInDomains(NSPicturesDirectory, NSUserDomainMask, YES);
    for (int i = 0; i < [testPath count]; i++) {
         NSLog(@"testPath %@", [testPath objectAtIndex:i]);
    }
    
    
   
    return [appFile UTF8String];
}
void CameraFile::savedToCamera(const char *fileName) {
    UISaveVideoAtPathToSavedPhotosAlbum([NSString stringWithFormat:@"%s", fileName], nil, nil, nil);
    
    
}
