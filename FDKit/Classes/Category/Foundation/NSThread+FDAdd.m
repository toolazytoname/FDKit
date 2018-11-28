//
//  NSThread+FDAdd.h
//  FDCategories <https://github.com/toolazytoname/FDCategories>
//
//  Created by ibireme on 15/7/3.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "NSThread+FDAdd.h"
#import <CoreFoundation/CoreFoundation.h>

@interface NSThread_FDAdd : NSObject @end
@implementation NSThread_FDAdd @end

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Specify the -fno-objc-arc flag to this file.
#endif

static NSString *const FDNSThreadAutoleasePoolKey = @"FDNSThreadAutoleasePoolKey";
static NSString *const FDNSThreadAutoleasePoolStackKey = @"FDNSThreadAutoleasePoolStackKey";

static const void *PoolStackRetainCallBack(CFAllocatorRef allocator, const void *value) {
    return value;
}

static void PoolStackReleaseCallBack(CFAllocatorRef allocator, const void *value) {
    CFRelease((CFTypeRef)value);
}


static inline void YYAutoreleasePoolPush() {
    NSMutableDictionary *dic =  [NSThread currentThread].threadDictionary;
    NSMutableArray *poolStack = dic[FDNSThreadAutoleasePoolStackKey];
    
    if (!poolStack) {
        /*
         do not retain pool on push,
         but release on pop to avoid memory analyze warning
         */
        CFArrayCallBacks callbacks = {0};
        callbacks.retain = PoolStackRetainCallBack;
        callbacks.release = PoolStackReleaseCallBack;
        poolStack = (id)CFArrayCreateMutable(CFAllocatorGetDefault(), 0, &callbacks);
        dic[FDNSThreadAutoleasePoolStackKey] = poolStack;
        CFRelease(poolStack);
    }
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; // create
    [poolStack addObject:pool]; // push
}

static inline void YYAutoreleasePoolPop() {
    NSMutableDictionary *dic =  [NSThread currentThread].threadDictionary;
    NSMutableArray *poolStack = dic[FDNSThreadAutoleasePoolStackKey];
    [poolStack removeLastObject]; // pop
}

static void YYRunLoopAutoreleasePoolObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        case kCFRunLoopEntry: {
            YYAutoreleasePoolPush();
        } break;
        case kCFRunLoopBeforeWaiting: {
            YYAutoreleasePoolPop();
            YYAutoreleasePoolPush();
        } break;
        case kCFRunLoopExit: {
            YYAutoreleasePoolPop();
        } break;
        default: break;
    }
}

static void FDRunloopAutoreleasePoolSetup() {
    CFRunLoopRef runloop = CFRunLoopGetCurrent();

    CFRunLoopObserverRef pushObserver;
    pushObserver = CFRunLoopObserverCreate(CFAllocatorGetDefault(), kCFRunLoopEntry,
                                           true,         // repeat
                                           -0x7FFFFFFF,  // before other observers
                                           YYRunLoopAutoreleasePoolObserverCallBack, NULL);
    CFRunLoopAddObserver(runloop, pushObserver, kCFRunLoopCommonModes);
    CFRelease(pushObserver);
    
    CFRunLoopObserverRef popObserver;
    popObserver = CFRunLoopObserverCreate(CFAllocatorGetDefault(), kCFRunLoopBeforeWaiting | kCFRunLoopExit,
                                          true,        // repeat
                                          0x7FFFFFFF,  // after other observers
                                          YYRunLoopAutoreleasePoolObserverCallBack, NULL);
    CFRunLoopAddObserver(runloop, popObserver, kCFRunLoopCommonModes);
    CFRelease(popObserver);
}

@implementation NSThread (FDAdd)

+ (void)fd_addAutoreleasePoolToCurrentRunloop {
    if ([NSThread isMainThread]) return; // The main thread already has autorelease pool.
    NSThread *thread = [self currentThread];
    if (!thread) return;
    if (thread.threadDictionary[FDNSThreadAutoleasePoolKey]) return; // already added
    FDRunloopAutoreleasePoolSetup();
    thread.threadDictionary[FDNSThreadAutoleasePoolKey] = FDNSThreadAutoleasePoolKey; // mark the state
}

@end
