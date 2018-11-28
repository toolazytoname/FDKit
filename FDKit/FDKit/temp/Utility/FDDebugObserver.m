//
//  FDDebugObserver.m
//  iPhoneVideo
//
//  Created by weichao on 16/7/27.
//  Copyright © 2016年 FG. All rights reserved.
//

#import "FDDebugObserver.h"

@interface FDDebugObserver()

/**
 *  @{@"observed keyPath": observered Objects}
 *  The keys are observed keyPaths
 *  The values are observed Objects
 */
@property (nonatomic, strong) NSMutableDictionary *observedDictionary;
@end

@implementation FDDebugObserver

+ (FDDebugObserver *)fd_sharedDebugObserver {
    static dispatch_once_t onceToken;
    static FDDebugObserver *debugObserver;
    dispatch_once(&onceToken, ^{
        debugObserver = [[FDDebugObserver alloc] init];
    });
    return debugObserver;
}

- (void)fd_addObservedObject:(NSObject *)observedObject observedKeyPath:(NSString *)observedKeyPath {
    if (!observedKeyPath || !(observedKeyPath.length > 0) || !observedObject) {
        NSLog(@"The keyPath or observer is invalid.");
        return;
    }
    [observedObject addObserver:self forKeyPath:observedKeyPath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionNew context:nil];
    [self.observedDictionary setObject:observedObject forKey:observedKeyPath];
}

- (void)fd_removeObservedObject:(NSObject *)observedObject observedKeyPath:(NSString *)observedKeyPath {
    if (!observedKeyPath || !(observedKeyPath.length > 0) || !observedObject) {
        NSLog(@"The keyPath or observer is invalid.");
        return;
    }
    [observedObject removeObserver:self forKeyPath:observedKeyPath];
    [self.observedDictionary removeObjectForKey:observedKeyPath];
}

- (void)fd_logCurrentobserverDictionary {
    NSLog(@"observedDictionary:%@",self.observedDictionary);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    NSArray *keys = [self.observedDictionary allKeys];
    if ([keys containsObject:keyPath]) {
        NSLog(@"[FDDebugObserver] Who Moved %@'s %@ ? callStackSymbols:%@",object,keyPath,[NSThread callStackSymbols]);
    }
}

#pragma mark lazyLoader
- (NSMutableDictionary *)observedDictionary {
    if (!_observedDictionary) {
        _observedDictionary = [[NSMutableDictionary alloc] init];
    }
    return _observedDictionary;
}
@end
