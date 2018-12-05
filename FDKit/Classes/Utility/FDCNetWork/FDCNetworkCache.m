//
//  FDCNetworkCache.m
//  FatDragonCartoon
//
//  Created by weichao on 18/01/2018.
//  Copyright © 2018 FatDragon. All rights reserved.
//

#import "FDCNetworkCache.h"
#import "YYCache.h"
static NSString *const kFDCNetworkResponseCache = @"kFDCNetworkResponseCache";

@interface FDCNetworkCache()
@property(nonatomic, strong) YYCache *dataCache;
@end

@implementation FDCNetworkCache


+ (instancetype)sharedCache {
    static FDCNetworkCache *networkCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkCache = [self new];
        networkCache.dataCache = [YYCache cacheWithName:kFDCNetworkResponseCache];
    });
    return networkCache;
}

- (void)setHttpCache:(id)httpData URL:(NSString *)URL parameters:(id)parameters {
    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:parameters];
    [self.dataCache setObject:httpData forKey:cacheKey withBlock:nil];
}


- (id)httpCacheForURL:(NSString *)URL parameters:(id)parameters {
    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:parameters];
    return [self.dataCache objectForKey:cacheKey];
}

/// 获取网络缓存的总大小 bytes(字节)
- (NSInteger)getAllHttpCacheSize {
    return [self.dataCache.diskCache totalCost];
}


/// 删除所有网络缓存
- (void)removeAllHttpCache {
    [self.dataCache.diskCache removeAllObjects];
}

- (NSString *)cacheKeyWithURL:(NSString *)URL parameters:(NSDictionary *)parameters {
    if(!parameters || parameters.count == 0){return URL;};
    // 将参数字典转换成字符串
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *paraString = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:@"%@%@",URL,paraString];
}

@end
