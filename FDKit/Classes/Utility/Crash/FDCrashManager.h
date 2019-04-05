//
//  FDCrash.h
//  BPCrash
//
//  Created by Lazy on 2019/3/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDCrashManager : NSObject
+ (instancetype)sharedInstance;
- (void)checkLocalCrashLogs;
@end

NS_ASSUME_NONNULL_END
