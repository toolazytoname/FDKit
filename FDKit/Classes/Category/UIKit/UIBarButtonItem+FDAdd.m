//
//  UIBarButtonItem+FDAdd.m
//  FDCategories <https://github.com/toolazytoname/FDCategories>
//
//  Created by ibireme on 13/10/15.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "UIBarButtonItem+FDAdd.h"
#import "FDCategoriesMacro.h"
#import <objc/runtime.h>

FDSYNTH_DUMMY_CLASS(UIBarButtonItem_FDAdd)


static const int block_key;

@interface _FDUIBarButtonItemBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id sender);

- (id)initWithBlock:(void (^)(id sender))block;
- (void)invoke:(id)sender;

@end

@implementation _FDUIBarButtonItemBlockTarget

- (id)initWithBlock:(void (^)(id sender))block{
    self = [super init];
    if (self) {
        _block = [block copy];
    }
    return self;
}

- (void)invoke:(id)sender {
    if (self.block) self.block(sender);
}

@end


@implementation UIBarButtonItem (FDAdd)

- (void)setFd_actionBlock:(void (^)(id sender))block {
    _FDUIBarButtonItemBlockTarget *target = [[_FDUIBarButtonItemBlockTarget alloc] initWithBlock:block];
    objc_setAssociatedObject(self, &block_key, target, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setTarget:target];
    [self setAction:@selector(invoke:)];
}

- (void (^)(id)) fd_actionBlock {
    _FDUIBarButtonItemBlockTarget *target = objc_getAssociatedObject(self, &block_key);
    return target.block;
}

@end
