//
//  NSObject+FDAddForARC.m
//  FDCategories <https://github.com/toolazytoname/FDCategories>
//
//  Created by ibireme on 13/12/15.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "NSObject+FDAddForARC.h"

@interface NSObject_FDAddForARC : NSObject @end
@implementation NSObject_FDAddForARC @end

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Specify the -fno-objc-arc flag to this file.
#endif


@implementation NSObject (FDAddForARC)

- (instancetype)fd_arcDebugRetain {
    return [self retain];
}

- (oneway void)fd_arcDebugRelease {
    [self release];
}

- (instancetype)fd_arcDebugAutorelease {
    return [self autorelease];
}

- (NSUInteger)fd_arcDebugRetainCount {
    return [self retainCount];
}

@end
