//
//  BPACustomTabManager.h
//  BitAutoPlus
//
//  Created by Lazy on 2018/11/15.
//  Copyright © 2018 weichao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BPASkinManager : NSObject
@property (nonatomic, strong, readonly) UIImage *tabBackgroundImage;
@property (nonatomic, strong, readonly) NSArray *norImages;
@property (nonatomic, strong, readonly) NSArray *preImages;
+ (instancetype)sharedManager;
+ (BOOL)shouldPerformScaleAnimation;
+ (BOOL)shouldPerformMoveAnimation;
- (BOOL)isCustomSkinReady;
- (void)refreshImages;
@end

NS_ASSUME_NONNULL_END
