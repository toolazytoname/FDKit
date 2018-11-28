//
//  UIScrollView+FDAdd.h
//  FDCategories <https://github.com/toolazytoname/FDCategories>
//
//  Created by ibireme on 13/4/5.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provides extensions for `UIScrollView`.
 */
@interface UIScrollView (FDAdd)

/**
 pagingEnabled scrollview index
 */
@property (nonatomic, assign, readonly) NSUInteger fd_currentIndex;

/**
 Scroll content to top with animation.
 */
- (void)fd_scrollToTop;

/**
 Scroll content to bottom with animation.
 */
- (void)fd_scrollToBottom;

/**
 Scroll content to left with animation.
 */
- (void)fd_scrollToLeft;

/**
 Scroll content to right with animation.
 */
- (void)fd_scrollToRight;

/**
 Scroll content to top.
 
 @param animated  Use animation.
 */
- (void)fd_scrollToTopAnimated:(BOOL)animated;

/**
 Scroll content to bottom.
 
 @param animated  Use animation.
 */
- (void)fd_scrollToBottomAnimated:(BOOL)animated;

/**
 Scroll content to left.
 
 @param animated  Use animation.
 */
- (void)fd_scrollToLeftAnimated:(BOOL)animated;

/**
 Scroll content to right.
 
 @param animated  Use animation.
 */
- (void)fd_scrollToRightAnimated:(BOOL)animated;




/**
 Scroll content to specified index of a pagingEnabled scrollview

 @param index The specified index of a pagingEnabled scrollview
 @param animated Use animation.
 */
- (void)fd_scrollToIndex:(NSUInteger)index animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
