//
//  NSKeyedUnarchiver+FDAdd.m
//  FDCategories <https://github.com/toolazytoname/FDCategories>
//
//  Created by ibireme on 13/8/4.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "NSKeyedUnarchiver+FDAdd.h"
#import "FDCategoriesMacro.h"

FDSYNTH_DUMMY_CLASS(NSKeyedUnarchiver_FDAdd)


@implementation NSKeyedUnarchiver (FDAdd)

+ (id)fd_unarchiveObjectWithData:(NSData *)data exception:(__autoreleasing NSException **)exception {
    id object = nil;
    @try {
        object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *e)
    {
        if (exception) *exception = e;
    }
    @finally
    {
    }
    return object;
}

+ (id)fd_unarchiveObjectWithFile:(NSString *)path exception:(__autoreleasing NSException **)exception {
    id object = nil;
    
    @try {
        object = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    @catch (NSException *e)
    {
        if (exception) *exception = e;
    }
    @finally
    {
    }
    return object;
}

@end
