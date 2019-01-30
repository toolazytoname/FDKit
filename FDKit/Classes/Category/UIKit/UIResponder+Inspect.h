//
//  UIResponder+Inspect.h
//  FDKit
//
//  Created by Lazy on 2019/1/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (Inspect)
+ (NSString *)responderChainWithResponder:(UIResponder *)firstResponder;
@end

NS_ASSUME_NONNULL_END
