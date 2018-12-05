//
//  FDCNetWork.h
//  FatDragonCartoon
//
//  Created by weichao on 16/5/17.
//  Copyright © 2016年 FatDragon. All rights reserved.
//
//
/*
 自己简单封装了一下AFNetworking，
 整体思路是让使Controller层外部调用尽量简单，
 把一些请求的具体细节都放在FDCRequest的子类里面，通过继承 FDCRequest 类来实现一些网络请求的细节，例如参数，处理逻辑。
 具体的请求逻辑，通过FDCRequest字类带进来的参数，在FDCSessionManager 类里面处理，他是AFHTTPSessionManager的字类，请求，建了个单例的目的是，看过某篇文章，据说，这样能够请求TCP连接请求开始的三次握手时间。
 再说文档也让我这么干，我就这么干了。
 Developers targeting iOS 7 or Mac OS X 10.9 or later that deal extensively with a web service are encouraged to subclass `AFHTTPSessionManager`, providing a class method that returns a shared singleton object on which authentication and other configuration can be shared across the application.
 
 
 */

#ifndef FDCNetWork_h
#define FDCNetWork_h

#import "FDCSessionManager.h"
#import "FDCCustomRequest.h"

#endif /* FDCNetWork_h */
