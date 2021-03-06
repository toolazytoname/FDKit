//
//  UIView+FDAdd.h
//  FDCategories <https://github.com/toolazytoname/FDCategories>
//
//  Created by ibireme on 13/4/3.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provides extensions for `UIView`.
 */
@interface UIView (FDAdd)

/**
 Create a snapshot image of the complete view hierarchy.
 */
- (nullable UIImage *)fd_snapshotImage;

/**
 Create a snapshot image of the complete view hierarchy.
 @discussion It's faster than "snapshotImage", but may cause screen updates.
 See -[UIView drawViewHierarchyInRect:afterScreenUpdates:] for more information.
 */
- (nullable UIImage *)fd_snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;

/**
 Create a snapshot PDF of the complete view hierarchy.
 */
- (nullable NSData *)fd_snapshotPDF;

/**
 Shortcut to set the view.layer's shadow
 
 @param color  Shadow Color
 @param offset Shadow offset
 @param radius Shadow radius
 */
- (void)fd_setLayerShadow:(nullable UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius;

/**
 Remove all subviews.
 
 @warning Never call this method inside your view's drawRect: method.
 */
- (void)fd_removeAllSubviews;

/**
 Returns the view's view controller (may be nil).
 */
@property (nullable, nonatomic, readonly) UIViewController *fd_viewController;

/**
 Returns the visible alpha on screen, taking into account superview and window.
 */
@property (nonatomic, readonly) CGFloat fd_visibleAlpha;

- (NSString *)fd_siblingTextFieldValue;

- (void)fd_siblingViewsHidden;

#pragma mark - 设置部分圆角
/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)fd_addRoundedCornersAbsoulute:(UIRectCorner)corners
                                radii:(CGSize)radii;
/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)fd_addRoundedCornersRelative:(UIRectCorner)corners
                               radii:(CGSize)radii
                            viewRect:(CGRect)rect;



/// 新写的API，CG画了一个切除圆角的的图形，add上，然后self 的背景色设置为与父视图一致。
/// @param radii 半径
- (void)fd_addRoundedCornersWithRadii:(float)radii;

- (void)fd_addRoundedCornersRelativeWithRadii:(float)radii
                                     viewRect:(CGRect)rect;

//UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(30, 30, 100, 120)];
//testView.backgroundColor = [UIColor purpleColor];
//[testView fd_addRoundedCornersRelativeWithRoundedRect:testView.bounds topLeftCornerRadius:10 topRightCornerRadius:20 bottomLeftCornerRadius:30 bottomRightCornerRadius:40 backgroundColor:testView.backgroundColor borderWidth:5   borderColor:[UIColor greenColor]];
- (void)fd_addRoundedCornersRelativeWithRoundedRect:(CGRect)rect
                                topLeftCornerRadius:(CGFloat)topLeftCornerRadius
                               topRightCornerRadius:(CGFloat)topRightCornerRadius
                             bottomLeftCornerRadius:(CGFloat)bottomLeftCornerRadius
                            bottomRightCornerRadius:(CGFloat)bottomRightCornerRadius
                                    backgroundColor:(nullable UIColor *)backgroundColor
                                        borderWidth:(CGFloat)borderWidth
                                        borderColor:(nullable UIColor *)borderColor;


/**
 同时设置圆角和阴影,地下会新增一个阴影layer

 @param shadowColor shadowColor description
 @param shadowOffset shadowOffset description
 @param shadowRadius shadowRadius description
 @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 @param cornerRadii 需要设置的圆角大小 
 @param cornerRect 需要设置的圆角view的rect
 */
- (void)fd_addShadow:(nullable UIColor*)shadowColor
        shadowOffset:(CGSize)shadowOffset
        shadowRadius:(CGFloat)shadowRadius
      roundedCorners:(UIRectCorner)corners
         cornerRadii:(float)cornerRadii
          cornerRect:(CGRect)cornerRect;
/**
 Converts a point from the receiver's coordinate system to that of the specified view or window.
 
 @param point A point specified in the local coordinate system (bounds) of the receiver.
 @param view  The view or window into whose coordinate system point is to be converted. 
    If view is nil, this method instead converts to window base coordinates.
 @return The point converted to the coordinate system of view.
 */
- (CGPoint)fd_convertPoint:(CGPoint)point toViewOrWindow:(nullable UIView *)view;

/**
 Converts a point from the coordinate system of a given view or window to that of the receiver.
 
 @param point A point specified in the local coordinate system (bounds) of view.
 @param view  The view or window with point in its coordinate system. 
    If view is nil, this method instead converts from window base coordinates.
 @return The point converted to the local coordinate system (bounds) of the receiver.
 */
- (CGPoint)fd_convertPoint:(CGPoint)point fromViewOrWindow:(nullable UIView *)view;

/**
 Converts a rectangle from the receiver's coordinate system to that of another view or window.
 
 @param rect A rectangle specified in the local coordinate system (bounds) of the receiver.
 @param view The view or window that is the target of the conversion operation. If view is nil, this method instead converts to window base coordinates.
 @return The converted rectangle.
 */
- (CGRect)fd_convertRect:(CGRect)rect toViewOrWindow:(nullable UIView *)view;

/**
 Converts a rectangle from the coordinate system of another view or window to that of the receiver.
 
 @param rect A rectangle specified in the local coordinate system (bounds) of view.
 @param view The view or window with rect in its coordinate system.
    If view is nil, this method instead converts from window base coordinates.
 @return The converted rectangle.
 */
- (CGRect)fd_convertRect:(CGRect)rect fromViewOrWindow:(nullable UIView *)view;


@property (nonatomic) CGFloat fd_left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat fd_top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat fd_right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat fd_bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat fd_width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat fd_height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat fd_centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat fd_centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint fd_origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  fd_size;        ///< Shortcut for frame.size.

@property (nonatomic) IBInspectable CGFloat fd_layerCornerRadius;         ///< Shortcut for layer.cornerRadius

@property (nonatomic) BOOL fd_layerMaskToBounds;///< Shortcut for  layer.masksToBounds

@end

NS_ASSUME_NONNULL_END
