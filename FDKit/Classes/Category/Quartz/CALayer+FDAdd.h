//
//  CALayer+FDAdd.h
//  FDCategories <https://github.com/toolazytoname/FDCategories>
//
//  Created by ibireme on 14/5/10.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provides extensions for `CALayer`.
 */
@interface CALayer (FDAdd)

/**
 Take snapshot without transform, image's size equals to bounds.
 */
- (nullable UIImage *)fd_snapshotImage;

/**
 Take snapshot without transform, PDF's page size equals to bounds.
 */
- (nullable NSData *)fd_snapshotPDF;

/**
 Shortcut to set the layer's shadow
 
 @param color  Shadow Color
 @param offset Shadow offset
 @param radius Shadow radius
 */
- (void)fd_setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius;

/**
 Remove all sublayers.
 */
- (void)fd_removeAllSublayers;

@property (nonatomic) CGFloat fd_left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat fd_top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat fd_right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat fd_bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat fd_width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat fd_height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGPoint fd_center;      ///< Shortcut for center.
@property (nonatomic) CGFloat fd_centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat fd_centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint fd_origin;      ///< Shortcut for frame.origin.
@property (nonatomic, getter=frameSize, setter=setFrameSize:) CGSize  fd_size; ///< Shortcut for frame.size.


@property (nonatomic) CGFloat fd_transformRotation;     ///< key path "tranform.rotation"
@property (nonatomic) CGFloat fd_transformRotationX;    ///< key path "tranform.rotation.x"
@property (nonatomic) CGFloat fd_transformRotationY;    ///< key path "tranform.rotation.y"
@property (nonatomic) CGFloat fd_transformRotationZ;    ///< key path "tranform.rotation.z"
@property (nonatomic) CGFloat fd_transformScale;        ///< key path "tranform.scale"
@property (nonatomic) CGFloat fd_transformScaleX;       ///< key path "tranform.scale.x"
@property (nonatomic) CGFloat fd_transformScaleY;       ///< key path "tranform.scale.y"
@property (nonatomic) CGFloat fd_transformScaleZ;       ///< key path "tranform.scale.z"
@property (nonatomic) CGFloat fd_transformTranslationX; ///< key path "tranform.translation.x"
@property (nonatomic) CGFloat fd_transformTranslationY; ///< key path "tranform.translation.y"
@property (nonatomic) CGFloat fd_transformTranslationZ; ///< key path "tranform.translation.z"

/**
 Shortcut for transform.m34, -1/1000 is a good value.
 It should be set before other transform shortcut.
 */
@property (nonatomic) CGFloat fd_transformDepth;

/**
 Wrapper for `contentsGravity` property.
 */
@property (nonatomic) UIViewContentMode fd_contentMode;

/**
 Add a fade animation to layer's contents when the contents is changed.
 
 @param duration Animation duration
 @param curve    Animation curve.
 */
- (void)fd_addFadeAnimationWithDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve;

/**
 Cancel fade animation which is added with "-addFadeAnimationWithDuration:curve:".
 */
- (void)fd_removePreviousFadeAnimation;


/**
 Add a roate animation to layer's contents.

 */
- (void)fd_addRoateAnimation;
@end

NS_ASSUME_NONNULL_END
