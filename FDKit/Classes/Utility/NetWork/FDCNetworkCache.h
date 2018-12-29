//
//  FDCNetworkCache.h
//  FatDragonCartoon
//
//  Created by weichao on 18/01/2018.
//  Copyright © 2018 FatDragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDCNetworkCache : NSObject
+ (instancetype)sharedCache;

- (void)setHttpCache:(id)httpData URL:(NSString *)URL parameters:(id)parameters;


- (id)httpCacheForURL:(NSString *)URL parameters:(id)parameters;

/// 获取网络缓存的总大小 bytes(字节)
- (NSInteger)getAllHttpCacheSize;


/// 删除所有网络缓存
- (void)removeAllHttpCache;

@end
