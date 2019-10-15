//
//  UIView+FDAdd.m
//  FDCategories <https://github.com/toolazytoname/FDCategories>
//
//  Created by ibireme on 13/4/3.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "UIView+FDAdd.h"
#import <QuartzCore/QuartzCore.h>
#import "FDCategoriesMacro.h"
#import "NSArray+FDAdd.h"
#import "UIBezierPath+FDAdd.h"

FDSYNTH_DUMMY_CLASS(UIView_FDAdd)


@implementation UIView (FDAdd)

- (UIImage *)fd_snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (UIImage *)fd_snapshotImageAfterScreenUpdates:(BOOL)afterUpdates {
    if (![self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        return [self fd_snapshotImage];
    }
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdates];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (NSData *)fd_snapshotPDF {
    CGRect bounds = self.bounds;
    NSMutableData* data = [NSMutableData data];
    CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)data);
    CGContextRef context = CGPDFContextCreate(consumer, &bounds, NULL);
    CGDataConsumerRelease(consumer);
    if (!context) return nil;
    CGPDFContextBeginPage(context, NULL);
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    [self.layer renderInContext:context];
    CGPDFContextEndPage(context);
    CGPDFContextClose(context);
    CGContextRelease(context);
    return data;
}

- (void)fd_setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = 1;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)fd_removeAllSubviews {
    //[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}


- (UIViewController *)fd_viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (CGFloat)fd_visibleAlpha {
    if ([self isKindOfClass:[UIWindow class]]) {
        if (self.hidden) return 0;
        return self.alpha;
    }
    if (!self.window) return 0;
    CGFloat alpha = 1;
    UIView *v = self;
    while (v) {
        if (v.hidden) {
            alpha = 0;
            break;
        }
        alpha *= v.alpha;
        v = v.superview;
    }
    return alpha;
}

- (NSString *)fd_siblingTextFieldValue {
    __block NSString *textValue;
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [self.superview.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:UITextField.class]) {
            textValue = ((UITextField *)obj).text;
//            dispatch_semaphore_signal(semaphore);
        }
    }];
//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return textValue;
}

- (void)fd_siblingViewsHidden {
    [self.superview.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:UIView.class] && obj != self) {
            obj.hidden = YES;
        }
    }];
}

- (void)fd_addRoundedCornersAbsoulute:(UIRectCorner)corners
                            radii:(CGSize)radii {
    [self fd_addRoundedCornersRelative:corners radii:radii viewRect:self.bounds];
}

- (void)fd_addRoundedCornersRelative:(UIRectCorner)corners
                               radii:(CGSize)radii
                             viewRect:(CGRect)rect {
//一般都用使用Monsary布局,所以使用这个方法,因为当你进行相对布局的时候系统是不确定你的rect的,所以需要从外部传入
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    self.layer.mask = shape;
}

- (void)fd_addRoundedCornersWithRadii:(float)radii {
    [self fd_addRoundedCornersRelativeWithRadii:radii viewRect:self.bounds];
}

- (void)fd_addRoundedCornersRelativeWithRadii:(float)radii
                                     viewRect:(CGRect)rect {
//一般都用使用Monsary布局,所以使用这个方法,因为当你进行相对布局的时候系统是不确定你的rect的,所以需要从外部传入
    [self fd_addRoundedCornersRelativeWithRoundedRect:rect
                                  topLeftCornerRadius:radii
                                 topRightCornerRadius:radii
                               bottomLeftCornerRadius:radii
                              bottomRightCornerRadius:radii
                                      backgroundColor:self.backgroundColor
                                          borderWidth:0
                                          borderColor:nil
     ];
}

- (void)fd_addRoundedCornersRelativeWithRoundedRect:(CGRect)rect
                                topLeftCornerRadius:(CGFloat)topLeftCornerRadius
                               topRightCornerRadius:(CGFloat)topRightCornerRadius
                             bottomLeftCornerRadius:(CGFloat)bottomLeftCornerRadius
                            bottomRightCornerRadius:(CGFloat)bottomRightCornerRadius
                                    backgroundColor:(nullable UIColor *)backgroundColor
                                        borderWidth:(CGFloat)borderWidth
                                        borderColor:(nullable UIColor *)borderColor {
    //后台线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGSize size = rect.size;
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
        CGContextRef cxt = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(cxt, backgroundColor.CGColor);
        CGContextSetStrokeColorWithColor(cxt, borderColor.CGColor);
        CGContextSetLineWidth(cxt, borderWidth);
        
        CGFloat halfBorderWidth = borderWidth / 2.0;
        CGFloat width = size.width;
        CGFloat height = size.height;

        //右下角
        CGContextMoveToPoint(cxt, width - halfBorderWidth, height - bottomRightCornerRadius - halfBorderWidth);
        CGContextAddArcToPoint(cxt, width - halfBorderWidth, height - halfBorderWidth, height - bottomRightCornerRadius - halfBorderWidth, height - halfBorderWidth, bottomRightCornerRadius);//右下角
        CGContextAddArcToPoint(cxt, 0 + halfBorderWidth, height - halfBorderWidth, 0 + halfBorderWidth, height-bottomLeftCornerRadius - halfBorderWidth, bottomLeftCornerRadius);//左下角
        CGContextAddArcToPoint(cxt, 0 + halfBorderWidth, 0 + halfBorderWidth, topLeftCornerRadius + halfBorderWidth, 0 + halfBorderWidth, topLeftCornerRadius);//左上角
        CGContextAddArcToPoint(cxt, width - halfBorderWidth , 0 + halfBorderWidth, width - halfBorderWidth, 0 + topRightCornerRadius + halfBorderWidth, topRightCornerRadius);//右上角
        CGContextClosePath(cxt);
        CGContextDrawPath(cxt, kCGPathFillStroke);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, height, height)];
            [imageView setImage:image];
            [self insertSubview:imageView atIndex:0];
            self.backgroundColor = self.superview.backgroundColor;
        });
    }) ;
    
}


- (void)fd_addShadow:(nullable UIColor*)shadowColor
        shadowOffset:(CGSize)shadowOffset
        shadowRadius:(CGFloat)shadowRadius
      roundedCorners:(UIRectCorner)corners
         cornerRadii:(float)cornerRadii
          cornerRect:(CGRect)cornerRect {
//如果在同一个layer上实现两个效果，把masksToBounds开了，阴影无法显示，关了的话其上的View又会遮住圆角。解决的方式只能是再加一层layer。
    cornerRect = CGRectIsEmpty(cornerRect)?self.bounds:cornerRect;
    [self fd_addRoundedCornersRelative:corners radii:CGSizeMake(cornerRadii, cornerRadii) viewRect:cornerRect];
    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.frame = self.layer.frame;
    
    shadowLayer.shadowColor = shadowColor.CGColor;
    shadowLayer.shadowOffset = shadowOffset;
    shadowLayer.shadowRadius = shadowRadius;
    shadowLayer.shadowOpacity = 1;
    shadowLayer.shouldRasterize = YES;
    shadowLayer.rasterizationScale = [UIScreen mainScreen].scale;
    shadowLayer.masksToBounds = NO;
    
    [self.layer.superlayer insertSublayer:shadowLayer below:self.layer];
}


- (CGPoint)fd_convertPoint:(CGPoint)point toViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertPoint:point toWindow:nil];
        } else {
            return [self convertPoint:point toView:nil];
        }
    }
    
    UIWindow *from = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    UIWindow *to = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    if ((!from || !to) || (from == to)) return [self convertPoint:point toView:view];
    point = [self convertPoint:point toView:from];
    point = [to convertPoint:point fromWindow:from];
    point = [view convertPoint:point fromView:to];
    return point;
}

- (CGPoint)fd_convertPoint:(CGPoint)point fromViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertPoint:point fromWindow:nil];
        } else {
            return [self convertPoint:point fromView:nil];
        }
    }
    
    UIWindow *from = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    UIWindow *to = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    if ((!from || !to) || (from == to)) return [self convertPoint:point fromView:view];
    point = [from convertPoint:point fromView:view];
    point = [to convertPoint:point fromWindow:from];
    point = [self convertPoint:point fromView:to];
    return point;
}

- (CGRect)fd_convertRect:(CGRect)rect toViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertRect:rect toWindow:nil];
        } else {
            return [self convertRect:rect toView:nil];
        }
    }
    
    UIWindow *from = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    UIWindow *to = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    if (!from || !to) return [self convertRect:rect toView:view];
    if (from == to) return [self convertRect:rect toView:view];
    rect = [self convertRect:rect toView:from];
    rect = [to convertRect:rect fromWindow:from];
    rect = [view convertRect:rect fromView:to];
    return rect;
}

- (CGRect)fd_convertRect:(CGRect)rect fromViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertRect:rect fromWindow:nil];
        } else {
            return [self convertRect:rect fromView:nil];
        }
    }
    
    UIWindow *from = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    UIWindow *to = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    if ((!from || !to) || (from == to)) return [self convertRect:rect fromView:view];
    rect = [from convertRect:rect fromView:view];
    rect = [to convertRect:rect fromWindow:from];
    rect = [self convertRect:rect fromView:to];
    return rect;
}

- (CGFloat)fd_left {
    return self.frame.origin.x;
}

- (void)setFd_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)fd_top {
    return self.frame.origin.y;
}

- (void)setFd_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)fd_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setFd_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)fd_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setFd_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)fd_width {
    return self.frame.size.width;
}

- (void)setFd_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)fd_height {
    return self.frame.size.height;
}

- (void)setFd_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)fd_centerX {
    return self.center.x;
}

- (void)setFd_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)fd_centerY {
    return self.center.y;
}

- (void)setFd_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)fd_origin {
    return self.frame.origin;
}

- (void)setFd_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)fd_size {
    return self.frame.size;
}

- (void)setFd_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)fd_layerCornerRadius {
    return self.layer.cornerRadius;
}

- (void)setFd_layerCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (BOOL)fd_layerMaskToBounds {
    return self.layer.masksToBounds;
}

- (void)setFd_layerMaskToBounds:(BOOL)layerMaskToBounds {
    self.layer.masksToBounds = layerMaskToBounds;
}
@end
