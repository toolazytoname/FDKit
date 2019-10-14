//
//  FDTabBar.h
//  FDKit
//
//  Created by Lazy on 2018/12/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDTabBar : UITabBar
@property(nonatomic,copy) void (^selectedIndexChanged) (NSUInteger currentIndex);

@end

NS_ASSUME_NONNULL_END
