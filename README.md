使用ios 自己的库来建立framebuffer 绘制到这个framebuffer中压缩视频


首先编译IOS 版本的 libffmpeg.a 静态链接库

一个已经编译好的静态库放在工程 libs 目录下面

调整Application.mm 代码 保留EAGLView 的backBuffer

调用UISaveVideoAtPathToSavedPhotosAlbum 将应用中保存的视频 保存到 Camera Roll里面方便查看o


获取IOS上面的路径传给C++代码处理


RecordScene 包含两个子对象
====

ShowScene  用于展示
=======
设定背景图像 setBackground
-------
设定recordScene  
-------

HelloWorld  用于场景
======
onStart 开始录制视频 组装RecordScene
------
stopRecord 停止录制视频 时调用的清理操作
------
update  可以设定开始 和 最后视频frame 以及中间的战斗过程 
------
recordScene 设定recordScene 用于和另外场景通信
------



