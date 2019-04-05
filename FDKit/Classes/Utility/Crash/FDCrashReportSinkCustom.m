//
//  BPCrashReportSinkCustom.m
//  BPCrash
//
//  Created by Lazy on 2019/3/6.
//

#import "FDCrashReportSinkCustom.h"
#import "KSCrashReportFilterAppleFmt.h"
#import "KSCrashReportFilterBasic.h"
#import "FDLogger.h"

@implementation BPCrashReportSinkCustom
- (id <KSCrashReportFilter>) defaultCrashReportFilterSet {
    //这个方法很重要，KSAppleReportStyleSymbolicated这种格式的才能返回可读的crash log
    return [KSCrashReportFilterPipeline filterWithFilters:
            [KSCrashReportFilterAppleFmt filterWithReportStyle:KSAppleReportStyleSymbolicated],self,nil];
}

- (void)filterReports:(NSArray*)reports
         onCompletion:(KSCrashReportFilterCompletion)onCompletion {
    NSString *crashString = [NSString stringWithFormat:@"[BPCrash] reports:%@",reports];
    [[FDLogger sharedLogger] log:crashString];
    kscrash_callCompletion(onCompletion, reports, YES, nil);
}

@end
