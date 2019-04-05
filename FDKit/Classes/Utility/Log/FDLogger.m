//
//  FDLogger.m
//  BPStatistics
//
//  Created by Lazy on 2019/2/26.
//

#import "FDLogger.h"

@implementation FDLogger
+ (instancetype)sharedLogger {
    static id sharedLogger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLogger = [[[self class] alloc] init];
        [sharedLogger initialLog];
    });
    return sharedLogger;
}


#pragma mark - initial logger
- (void)initialLog {

    // 添加DDASLLogger，你的日志语句将被发送到Xcode控制台
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // 添加DDTTYLogger，你的日志语句将被发送到Console.app
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    
    NSString * applicationDocumentsDirectory = [[[[NSFileManager defaultManager]
                                                  URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] path];
    DDLogFileManagerDefault *documentsFileManager = [[DDLogFileManagerDefault alloc]
                                                     initWithLogsDirectory:applicationDocumentsDirectory];
    DDFileLogger *fileLogger = [[DDFileLogger alloc]
                                initWithLogFileManager:documentsFileManager];

    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    
    [DDLog addLogger:fileLogger];

}

- (void)log:(NSString *)message {
    DDLogDebug(@"%@",message);
}

@end
