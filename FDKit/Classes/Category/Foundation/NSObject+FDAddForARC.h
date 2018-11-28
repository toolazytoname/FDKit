//
//  NSObject+FDAddForARC.h
//  FDCategories <https://github.com/toolazytoname/FDCategories>
//
//  Created by ibireme on 13/12/15.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

/**
 Debug method for NSObject when using ARC.
 */
@interface NSObject (FDAddForARC)

/// Same as `retain`
- (instancetype)fd_arcDebugRetain;

/// Same as `release`
- (oneway void)fd_arcDebugRelease;

/// Same as `autorelease`
- (instancetype)fd_arcDebugAutorelease;

/// Same as `retainCount`
- (NSUInteger)fd_arcDebugRetainCount;

@end
