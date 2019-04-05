//
//  BPCrashReportSinkCustom.h
//  BPCrash
//
//  Created by Lazy on 2019/3/6.
//

#import <Foundation/Foundation.h>
#import "KSCrashReportFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface BPCrashReportSinkCustom : NSObject<KSCrashReportFilter>
- (id <KSCrashReportFilter>) defaultCrashReportFilterSet;

@end

NS_ASSUME_NONNULL_END
