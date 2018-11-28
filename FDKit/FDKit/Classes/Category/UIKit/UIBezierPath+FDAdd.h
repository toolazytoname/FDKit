//
//  UIBezierPath+FDAdd.h
//  FDCategories <https://github.com/toolazytoname/FDCategories>
//
//  Created by ibireme on 14/10/30.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provides extensions for `UIBezierPath`.
 */
@interface UIBezierPath (FDAdd)

/**
 Creates and returns a new UIBezierPath object initialized with the text glyphs
 generated from the specified font.
 
 @discussion It doesnot support apple emoji. If you want get emoji image, try
 [UIImage imageWithEmoji:size:] in `UIImage(FDAdd)`.
 
 @param text The text to generate glyph path.
 @param font The font to generate glyph path.
 
 @return A new path object with the text and font, or nil if an error occurs.
 */
+ (nullable UIBezierPath *)fd_bezierPathWithText:(NSString *)text font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
