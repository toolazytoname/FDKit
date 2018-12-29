//
//  BPEThreadSafeMutableArray.h
//  BPBaseLib
//
//  Created by Lazy on 2018/12/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDThreadSafeMutableArray : NSObject
- (id)popFirstObject;
- (void)addObject:(id)anObject;
- (void)removeAllObjects;
- (id)objectAtIndex:(NSUInteger)index;
- (NSUInteger)count;
@end

NS_ASSUME_NONNULL_END
