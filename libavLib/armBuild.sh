#/bin/bash
PREFIX=./myIOS
#NDK=~/android-ndk-r8
#PLATFORM=$NDK/mytool
#PREBUILD=$NDK/mytool

IOS=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr
#include and lib
IOSLIB=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk

./configure --target-os=darwin \
    --enable-cross-compile \
    --extra-libs="-lgcc" \
    --prefix=$PREFIX  \
    --arch=arm \
    --cpu=cortex-a8 \
    --sysroot=$IOSLIB \
    --enable-version3 \
    --enable-gpl \
    --enable-shared \
    --disable-everything \
    --disable-ffmpeg \
    --disable-avplay \
    --disable-avprobe \
    --disable-avdevice \
    --disable-decoders \
    --disable-encoders \
    --enable-muxers \
    --enable-demuxers \
    --disable-parsers \
    --enable-encoder=mpeg4 \
    --disable-yasm \
    --disable-doc \
    --disable-avconv \
    --disable-ffmpeg \
    --disable-avserver \
    --disable-avfilter \
    --enable-swscale \
    --disable-devices \
    --disable-protocols \
    --enable-protocol=file \
    --disable-network \
    --cc=$IOS/bin/gcc \
    --cross-prefix=$IOS/bin/ \
    --nm=$IOS/bin/nm \
    --extra-cflags="-arch armv7s" \
    --disable-asm \
    --extra-ldflags="-arch armv7s -isysroot $IOSLIB "
    
#make -j4  

#支持x264 的 编译

#--enable-encoder=h263 \
#--enable-encoder=h264 \
#--enable-encoder=libx264 \
#--enable-muxer=mp4 \
#--enable-libx264 \

#$PREBUILD/bin/arm-linux-androideabi-ld -rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib  -soname libffmpeg.so -shared -nostdlib  -z,noexecstack -Bsymbolic --whole-archive --no-undefined -o $PREFIX/libffmpeg.so libavcodec/libavcodec.a libavformat/libavformat.a libavutil/libavutil.a  -lc -lm -lz -ldl -llog  --warn-once  --dynamic-linker=/system/bin/linker $PREBUILD/lib/gcc/arm-eabi/4.4.0/libgcc.a


#$PREBUILD/bin/arm-linux-androideabi-ar d libavcodec/libavcodec.a inverse.o
#
#$PREBUILD/bin/arm-linux-androideabi-ld -rpath-link=$PLATFORM/sysroot/usr/lib -L$PLATFORM/sysroot/usr/lib  -soname libffmpeg.so -shared -nostdlib  -z,noexecstack -Bsymbolic --whole-archive --no-undefined -o $PREFIX/libffmpeg.so libavcodec/libavcodec.a libavformat/libavformat.a libavutil/libavutil.a  -lc -lm -lz -ldl -llog  --warn-once  --dynamic-linker=/system/bin/linker $PREBUILD/lib/gcc/arm-linux-androideabi/4.4.3/libgcc.a
