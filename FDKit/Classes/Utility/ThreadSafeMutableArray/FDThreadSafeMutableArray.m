//
//  BPEThreadSafeMutableArray.m
//  BPBaseLib
//
//  Created by Lazy on 2018/12/12.
//

#import "FDThreadSafeMutableArray.h"

//读写锁
#define read(...)\
    dispatch_sync(self.concurrent_queue, ^{ \
        __VA_ARGS__ \
    });\

#define write(...)\
    dispatch_barrier_async(self.concurrent_queue, ^{\
        __VA_ARGS__ \
    });\

@interface FDThreadSafeMutableArray()
@property (nonatomic, strong) dispatch_queue_t concurrent_queue;
@property(nonatomic, copy) NSMutableArray *subItems;
@end

@implementation FDThreadSafeMutableArray
- (instancetype)init {
    self = [super init];
    if (self) {
        _concurrent_queue = dispatch_queue_create("com.weichao.FDKit.FDThreadSafeMutableArray", DISPATCH_QUEUE_CONCURRENT);
        _subItems = [[NSMutableArray array] init];
    }
    return self;
}

- (id)popFirstObject {
    id obj = nil;
    if (self.count) {
        obj = [self objectAtIndex:0];
        if (self.count) {
            [self removeObjectAtIndex:0];
        }
    }
    return obj;
}

#pragma mark - 模仿系统方法
- (NSUInteger)count {
    __block NSUInteger count = 0;
    read(count = self.subItems.count;)
    return count;
}

- (id)objectAtIndex:(NSUInteger)index {
    __block id obj = nil;
    read(obj = index < self.subItems.count ? self.subItems[index] : nil;)
    return obj;
}

- (void)removeAllObjects {
    write([self.subItems removeAllObjects];);
}

- (void)addObject:(id)anObject {
    write(if (anObject) {
        [self.subItems addObject:anObject];
    });
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    write(if(self.subItems.count) {
        [self.subItems removeObjectAtIndex:index];
    });
}

@end
