//
//  FDWebImagePrefetcher.m
//  BitAutoPlus
//
//  Created by Lazy on 2018/11/15.
//  Copyright © 2018 weichao. All rights reserved.
//

#import "FDWebImagePrefetcher.h"
#import "NSArray+FDAdd.h"

static const NSInteger kDefaultCacheMaxCacheAge = 60 * 60 * 24 * 7; // 1 week
static const NSInteger kDefaultCacheMaxCacheSize = 5 * 1024 * 1024;

@interface FDWebImagePrefetcher()
@property (nonatomic, strong) SDWebImagePrefetcher *webImagePrefetcher;
@property (nonatomic, strong) SDWebImageManager *webImageManager;
@property (nonatomic, strong) SDImageCache *imageCache;
@property (nonatomic, copy) NSString *cacheDirectory;
@end

@implementation FDWebImagePrefetcher

#pragma mark - init
- (instancetype)init{
    self = [super init];
    if (self) {
        NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _cacheDirectory = [paths[0] stringByAppendingPathComponent:NSStringFromClass(self.class)];
        _cacheAge = kDefaultCacheMaxCacheAge;
        _cacheSize = kDefaultCacheMaxCacheSize;
    }
    return self;
}

- (instancetype)initWithCacheDirectory:(NSString *)cacheDirectory {
    self = [self init];
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
        if (self.cacheKeyFilter) {
            NSString *key = self.cacheKeyFilter([urls fd_objectOrNilAtIndex:i]);
            if (![self.imageCache imageFromCacheForKey:key]) {
                return allCached;
            }
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
        [images fd_appendObject:[self imageForKey:obj]];
    }];
    return images;
}

- (void)setCacheAge:(NSInteger)cacheAge {
    if (_cacheAge != cacheAge) {
        _cacheAge = cacheAge;
        _imageCache.config.maxCacheAge = _cacheAge;
    }
}

- (void)setCacheSize:(NSInteger)cacheSize {
    if (_cacheSize != cacheSize) {
        _cacheSize = cacheSize;
        _imageCache.config.maxCacheSize = _cacheSize;
    }
}

- (void)setCacheKeyFilter:(SDWebImageCacheKeyFilterBlock)cacheKeyFilter {
    if (_cacheKeyFilter != cacheKeyFilter) {
        _cacheKeyFilter = cacheKeyFilter;
        self.webImageManager.cacheKeyFilter = ^NSString * _Nullable(NSURL * _Nullable url) {
            if (cacheKeyFilter) {
                return  cacheKeyFilter(url);
            }
            return nil;
        };
    }
}

#pragma mark - lazy load
- (SDWebImagePrefetcher *)webImagePrefetcher {
    if (!_webImagePrefetcher) {
        _webImagePrefetcher = [[SDWebImagePrefetcher alloc] initWithImageManager:self.webImageManager];
        _webImagePrefetcher.prefetcherQueue = dispatch_queue_create("FDWebImagePrefetcher.fatdragon.application", DISPATCH_QUEUE_SERIAL);
        _webImagePrefetcher.options = SDWebImageRetryFailed | SDWebImageRefreshCached;
    }
    return _webImagePrefetcher;
}

- (SDWebImageManager *)webImageManager {
    if (!_webImageManager) {
        SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
        _webImageManager = [[SDWebImageManager alloc] initWithCache:self.imageCache downloader:downloader];
        __weak typeof(self) weakSelf = self;
        _webImageManager.cacheKeyFilter = ^NSString * _Nullable(NSURL * _Nullable url) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.cacheKeyFilter) {
                return  strongSelf.cacheKeyFilter(url);
            }
            return nil;
        };
    }
    return _webImageManager;
}

- (SDImageCache *)imageCache {
    if (!_imageCache) {
        _imageCache = [[SDImageCache alloc] initWithNamespace:NSStringFromClass(self.class) diskCacheDirectory:self.cacheDirectory];
        _imageCache.config.maxCacheAge = self.cacheAge;
        _imageCache.config.maxCacheSize = self.cacheSize;
    }
    return _imageCache;
}
@end
