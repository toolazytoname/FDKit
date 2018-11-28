//
//  UIFont+FDAdd.h
//  FDCategories <https://github.com/toolazytoname/FDCategories>
//
//  Created by ibireme on 14/5/11.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreText/CoreText.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provides extensions for `UIFont`.
 */
@interface UIFont (FDAdd) <NSCoding>

#pragma mark - Font Traits
///=============================================================================
/// @name Font Traits
///=============================================================================

@property (nonatomic, readonly) BOOL fd_isBold NS_AVAILABLE_IOS(7_0); ///< Whether the font is bold.
@property (nonatomic, readonly) BOOL fd_isItalic NS_AVAILABLE_IOS(7_0); ///< Whether the font is italic.
@property (nonatomic, readonly) BOOL fd_isMonoSpace NS_AVAILABLE_IOS(7_0); ///< Whether the font is mono space.
@property (nonatomic, readonly) BOOL fd_isColorGlyphs NS_AVAILABLE_IOS(7_0); ///< Whether the font is color glyphs (such as Emoji).
@property (nonatomic, readonly) CGFloat fd_fontWeight NS_AVAILABLE_IOS(7_0); ///< Font weight from -1.0 to 1.0. Regular weight is 0.0.

/**
 Create a bold font from receiver.
 @return A bold font, or nil if failed.
 */
- (nullable UIFont *)fd_fontWithBold NS_AVAILABLE_IOS(7_0);

/**
 Create a italic font from receiver.
 @return A italic font, or nil if failed.
 */
- (nullable UIFont *)fd_fontWithItalic NS_AVAILABLE_IOS(7_0);

/**
 Create a bold and italic font from receiver.
 @return A bold and italic font, or nil if failed.
 */
- (nullable UIFont *)fd_fontWithBoldItalic NS_AVAILABLE_IOS(7_0);

/**
 Create a normal (no bold/italic/...) font from receiver.
 @return A normal font, or nil if failed.
 */
- (nullable UIFont *)fd_fontWithNormal NS_AVAILABLE_IOS(7_0);

#pragma mark - Create font
///=============================================================================
/// @name Create font
///=============================================================================

/**
 Creates and returns a font object for the specified CTFontRef.
 
 @param CTFont  CoreText font.
 */
+ (nullable UIFont *)fd_fontWithCTFont:(CTFontRef)CTFont;

/**
 Creates and returns a font object for the specified CGFontRef and size.
 
 @param CGFont  CoreGraphic font.
 @param size    Font size.
 */
+ (nullable UIFont *)fd_fontWithCGFont:(CGFontRef)CGFont size:(CGFloat)size;

/**
 Creates and returns the CTFontRef object. (need call CFRelease() after used)
 */
- (nullable CTFontRef)fd_CTFontRef CF_RETURNS_RETAINED;

/**
 Creates and returns the CGFontRef object. (need call CFRelease() after used)
 */
- (nullable CGFontRef)fd_CGFontRef CF_RETURNS_RETAINED;


#pragma mark - Load and unload font
///=============================================================================
/// @name Load and unload font
///=============================================================================

/**
 Load the font from file path. Support format:TTF,OTF.
 If return YES, font can be load use it PostScript Name: [UIFont fontWithName:...]
 
 @param path    font file's full path
 */
+ (BOOL)fd_loadFontFromPath:(NSString *)path;

/**
 Unload font from file path.
 
 @param path    font file's full path
 */
+ (void)fd_unloadFontFromPath:(NSString *)path;

/**
 Load the font from data. Support format:TTF,OTF.
 
 @param data  Font data.
 
 @return UIFont object if load succeed, otherwise nil.
 */
+ (nullable UIFont *)fd_loadFontFromData:(NSData *)data;

/**
 Unload font which is loaded by loadFontFromData: function.
 
 @param font the font loaded by loadFontFromData: function
 
 @return YES if succeed, otherwise NO.
 */
+ (BOOL)fd_unloadFontFromData:(UIFont *)font;


#pragma mark - Dump font data
///=============================================================================
/// @name Dump font data
///=============================================================================

/**
 Serialize and return the font data.
 
 @param font The font.
 
 @return data in TTF, or nil if an error occurs.
 */
+ (nullable NSData *)dataFromFont:(UIFont *)font;

/**
 Serialize and return the font data.
 
 @param cgFont The font.
 
 @return data in TTF, or nil if an error occurs.
 */
+ (nullable NSData *)dataFromCGFont:(CGFontRef)cgFont;

@end

NS_ASSUME_NONNULL_END
