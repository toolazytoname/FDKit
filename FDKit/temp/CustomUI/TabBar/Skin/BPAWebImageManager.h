//
//  BPACustomImageManager.h
//  BitAutoPlus
//
//  Created by Lazy on 2018/11/15.
//  Copyright © 2018 weichao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDWebImagePrefetcher.h"

NS_ASSUME_NONNULL_BEGIN

//利用SDWebImage自定义一个图片下载工具，可以自定义下载路径，图片key，缓存策略等。
@interface BPAWebImageManager : NSObject

//设置缓存路径，如果不设置，内部会有一个默认路径
- (void)setCacheDirectory:(NSString *)cacheDirectory;

//子线程执行，不会阻塞主线程
- (void)prefetchURLs:(nullable NSArray<NSURL *> *)urls;

//因为需要同步返回，所以会阻塞主线程
- (BOOL)allURLsCached:(nullable NSArray<NSURL *> *)urls;

- (UIImage *)imageForKey:(NSString *)key;

- (NSArray *)imagesForKeys:(NSArray *)keys;

@end

NS_ASSUME_NONNULL_END
