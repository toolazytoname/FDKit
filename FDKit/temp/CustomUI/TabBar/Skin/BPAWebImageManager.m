//
//  BPACustomImageManager.m
//  BitAutoPlus
//
//  Created by Lazy on 2018/11/15.
//  Copyright © 2018 weichao. All rights reserved.
//

#import "BPAWebImageManager.h"
#import "NSArray+FDAdd.h"

#define BPACustomImageManagerMaxCacheAge NSIntegerMax
#define BPACustomImageManagerMaxCacheSize 5 * 1024 * 1024

@interface BPAWebImageManager()
@property (nonatomic, strong) SDWebImagePrefetcher *webImagePrefetcher;
@property (nonatomic, strong) SDWebImageManager *webImageManager;
@property (nonatomic, strong) SDImageCache *imageCache;
@property (nonatomic, copy) NSString *cacheDirectory;
@end

@implementation BPAWebImageManager

- (instancetype)initWithCacheDirectory:(NSString *)cacheDirectory {
    self = [super init];
    if (self && cacheDirectory) {
        _cacheDirectory = cacheDirectory;
    }
    return self;
}

#pragma mark - public
- (void)prefetchURLs:(NSArray *)urls{
    [self.webImagePrefetcher prefetchURLs:urls];
}

- (BOOL)allURLsCached:(nullable NSArray<NSURL *> *)urls {
    BOOL allCached = NO;
    for (int i=0; i<urls.count; i++) {
        NSString *key = [[urls fd_objectOrNilAtIndex:i] absoluteString];
        if (![self.imageCache imageFromCacheForKey:key]) {
            return allCached;
        }
    }
    allCached = YES;
    return allCached;
}

- (UIImage *)imageForKey:(NSString *)key {
    return [self.imageCache imageFromCacheForKey:key];
}

- (NSArray *)imagesForKeys:(NSArray *)keys {
    __block NSMutableArray *images = [[NSMutableArray alloc] init];
    [keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [images BPT_addObj:[self imageForKey:obj]];
    }];
    return images;
}

#pragma mark - lazy load
- (SDWebImagePrefetcher *)webImagePrefetcher {
    if (!_webImagePrefetcher) {
        _webImagePrefetcher = [[SDWebImagePrefetcher alloc] initWithImageManager:self.webImageManager];
        _webImagePrefetcher.prefetcherQueue = dispatch_queue_create("BPACustomImageManager.bitauto.application", DISPATCH_QUEUE_SERIAL);
        _webImagePrefetcher.options = SDWebImageRetryFailed | SDWebImageRefreshCached;
    }
    return _webImagePrefetcher;
}

- (SDWebImageManager *)webImageManager {
    if (!_webImageManager) {
        SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
        _webImageManager = [[SDWebImageManager alloc] initWithCache:self.imageCache downloader:downloader];
    }
    return _webImageManager;
}

- (SDImageCache *)imageCache {
    if (!_imageCache) {
        _imageCache = [[SDImageCache alloc] initWithNamespace:NSStringFromClass(self.class) diskCacheDirectory:self.cacheDirectory];
        _imageCache.config.maxCacheAge = BPACustomImageManagerMaxCacheAge;
        _imageCache.config.maxCacheSize = BPACustomImageManagerMaxCacheSize;
    }
    return _imageCache;
}

- (NSString *)cacheDirectory {
    if (!_cacheDirectory) {
        ///如果外部没有传入缓存路径，那么就会用默认值
        NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _cacheDirectory = [paths[0] stringByAppendingPathComponent:NSStringFromClass(self.class)];
    }
    return _cacheDirectory;
}
@end
