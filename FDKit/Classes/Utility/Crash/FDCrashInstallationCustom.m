//
//  FDCrashInstallation.m
//  BPCrash
//
//  Created by Lazy on 2019/3/6.
//

#import "FDCrashInstallationCustom.h"
#import "FDCrashReportSinkCustom.h"
//#import "KSCrashInstallation+Private.h"
//#import "KSCrashReportFilterBasic.h"
#import <KSCrash/KSCrashInstallation+Private.h>
#import <KSCrash/KSCrashReportFilterBasic.h>

@implementation FDCrashInstallationCustom
+ (instancetype)sharedInstance {
    static FDCrashInstallationCustom *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FDCrashInstallationCustom alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super initWithRequiredProperties:nil];
    if(self) {
    }
    return self;
}

- (id<KSCrashReportFilter>)sink {
    BPCrashReportSinkCustom* sink = [[BPCrashReportSinkCustom alloc] init];
    return [KSCrashReportFilterPipeline filterWithFilters:[sink defaultCrashReportFilterSet], nil];
}


@end
