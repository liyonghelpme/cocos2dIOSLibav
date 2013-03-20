#!/bin/bash
#PREFIX=./myAndroid
#NDK=~/android-ndk-r8
#PLATFORM=$NDK/mytool
#PREBUILD=$NDK/mytool

PREFIX=./myIOS

IOS=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr
#include and lib
IOSLIB=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk/usr
PREBUILD=$IOS

$PREBUILD/bin/ar d libavcodec/libavcodec.a inverse.o
cp libavcodec/libavcodec.a myIOS
cp libavformat/libavformat.a myIOS
cp libavutil/libavutil.a myIOS
cp libswscale/libswscale.a myIOS
cd myIOS

#ar -x libavcodec.a
#ar -x libavformat.a
#ar -x libavutil.a
#ar -x libswscale.a
#ar -r libffmpeg.a *.o
libtool -static -o libffmpeg.a libavcodec.a libavformat.a libavutil.a libswscale.a


#$PREBUILD/bin/ld -arch armv7 -Z -L/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk/usr/lib  -syslibroot $IOSLIB   -static  -o $PREFIX/libffmpeg.a libavcodec/libavcodec.a libavformat/libavformat.a libavutil/libavutil.a libswscale/libswscale.a  
