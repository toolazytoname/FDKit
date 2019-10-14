//
//  FDCustomTabManager.m
//  BitAutoPlus
//
//  Created by Lazy on 2018/11/15.
//  Copyright © 2018 weichao. All rights reserved.
//

#import "FDSkinManager.h"
#import "FDWebImageManager.h"
#import "NSDictionary+FDAdd.h"
#import "NSArray+FDAdd.h"

#define CustomTabDirectoryName @"CustomTab"
#define FDCustomMoveAnimation @"1"
#define FDCustomScaleAnimation @"2"

@interface FDSkinManager()<BPBGlobalEventDelegate>
@property (nonatomic, strong) FDWebImageManager *imageManager;
@end

@implementation FDSkinManager

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}


#pragma mark - public method
+ (instancetype)sharedManager {
    static id sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[[self class] alloc] init];
    });
    return sharedManager;
}

+ (BOOL)shouldPerformScaleAnimation {
    return [[self _animationArray] containsObject:FDCustomScaleAnimation];
}

+ (BOOL)shouldPerformMoveAnimation {
    return [[self _animationArray] containsObject:FDCustomMoveAnimation];
}

- (BOOL)isCustomSkinReady {
    return [self.imageManager allURLsCached:[self.class _urlsToPrefetch]]
    && self.tabBackgroundImage
    && 5 == self.norImages.count
    && 5 == self.preImages.count;
}

- (void)refreshImages {
    [self.imageManager prefetchURLs:[self.class _urlsToPrefetch]];
}

- (UIImage *)tabBackgroundImage {
    return [self.imageManager imageForKey:[self.class _tabBg]];
}

- (NSArray *)norImages {
    return [self.imageManager imagesForKeys:[self.class _normalUrls]];
}

- (NSArray *)preImages {
    return [self.imageManager imagesForKeys:[self.class _preUrls]];
}

#pragma mark - private method
- (void)_refreshTabSkinInUserDefaults {
    NSDictionary *data = [BPTAppConfig sharedConfig].configData;
    NSDictionary *dicAppTabSkin = [[data BPT_dictionaryForKey:@"appTabSkin"] BPT_dictionaryForKey:@"iOSAppTabSkin"];
    if (IsDictionaryWithAnyKeyValue(dicAppTabSkin)) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:dicAppTabSkin forKey:@"iOSAppTabSkin"];
        [defaults synchronize];
    }
    else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"iOSAppTabSkin"];
        [defaults synchronize];
    }
}

+ (NSArray *)_urlsToPrefetch {
    NSMutableArray *urlsToPrefetch = [[NSMutableArray alloc] init];
    NSMutableArray *stringsToPrefetch = [[NSMutableArray alloc] init];
    [stringsToPrefetch fd_appendObject:[self _tabBg]];
    [stringsToPrefetch fd_appendObjects:[self _normalUrls]];
    [stringsToPrefetch fd_appendObjects:[self _preUrls]];
    [stringsToPrefetch enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURL *url= [[NSURL alloc] initWithString:obj];
        [urlsToPrefetch BPT_addObj:url];
    }];
    return urlsToPrefetch;
}

+ (NSArray *)_animationArray {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *iOSAppTabSkin = [defaults dictionaryForKey:@"iOSAppTabSkin"];
    NSString *animationType = [iOSAppTabSkin BPT_stringForKey:@"tabAnim"];
    return [animationType componentsSeparatedByString:@","];
}

+ (NSString *)_tabBg {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *iOSAppTabSkin = [defaults dictionaryForKey:@"iOSAppTabSkin"];
    NSString *tabBg = [iOSAppTabSkin BPT_stringForKey:@"tabBg"];
    return tabBg;
}

+ (NSArray *)_normalUrls {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *iOSAppTabSkin = [defaults dictionaryForKey:@"iOSAppTabSkin"];
    NSArray *tabItem = [iOSAppTabSkin BPT_arrayForKey:@"tabItem"];
    NSArray *normalUrls = [tabItem valueForKey:@"nor"];
    return normalUrls;
}

+ (NSArray *)_preUrls {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *iOSAppTabSkin = [defaults dictionaryForKey:@"iOSAppTabSkin"];
    NSArray *tabItem = [iOSAppTabSkin BPT_arrayForKey:@"tabItem"];
    NSArray *preUrls = [tabItem valueForKey:@"pre"];
    return preUrls;
}

#pragma mark - lazy load
- (FDWebImageManager *)imageManager {
    if (!_imageManager) {
        _imageManager = [[FDWebImageManager alloc] init];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        [_imageManager setCacheDirectory:[paths[0] stringByAppendingPathComponent:CustomTabDirectoryName]];
    }
    return _imageManager;
}
@end
