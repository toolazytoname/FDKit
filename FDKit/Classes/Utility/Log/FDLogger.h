//
//  FDLogger.h
//  BPStatistics
//
//  Created by Lazy on 2019/2/26.
//

#import <Foundation/Foundation.h>
#define LOG_LEVEL_DEF ddLogLevel
#import <CocoaLumberjack/CocoaLumberjack.h>
static const DDLogLevel ddLogLevel = DDLogLevelDebug;



NS_ASSUME_NONNULL_BEGIN

@interface FDLogger : NSObject
+ (instancetype)sharedLogger;
- (void)log:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
