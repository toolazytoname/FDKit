//
//  FDCrash.m
//  BPCrash
//
//  Created by Lazy on 2019/3/5.
//

#import "FDCrashManager.h"
#import <KSCrash/KSCrash.h>
#import "FDCrashInstallationCustom.h"

@interface FDCrashManager()
@property (strong, nonatomic) KSCrashInstallation* crashInstallation;
@end

@implementation FDCrashManager

+ (instancetype)sharedInstance {
    static FDCrashManager *crashCaughter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        crashCaughter = [[FDCrashManager alloc] init];
    });
    return crashCaughter;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self installCrashHandler];
    }
    return self;
}

- (void)installCrashHandler {
    [self configureAdvancedSettings];
    self.crashInstallation = [FDCrashInstallationCustom sharedInstance];
    [self.crashInstallation install];
}

- (void)configureAdvancedSettings {
    KSCrash* handler = [KSCrash sharedInstance];
    handler.deleteBehaviorAfterSendAll = KSCDeleteOnSucess;
    handler.userInfo = @{@"someKey": @"someValue"};
    handler.monitoring = KSCrashMonitorTypeProductionSafe;
}

- (void)checkLocalCrashLogs {
    [self checkLocalCrashLogsWithCompletion:^(NSArray* reports, BOOL completed, NSError* error) {
         if(completed) {
             NSLog(@"Sent %d reports", (int)[reports count]);
         }
         else {
             NSLog(@"Failed to send reports: %@", error);
         }
     }];
}

- (void)checkLocalCrashLogsWithCompletion:(KSCrashReportFilterCompletion)block {
    [self.crashInstallation sendAllReportsWithCompletion:block];
}
@end
